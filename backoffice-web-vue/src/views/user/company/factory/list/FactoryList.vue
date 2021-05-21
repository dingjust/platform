<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight" @sort-change="sortChange">
      <el-table-column label="商家编号" prop="uid" min-width="115"></el-table-column>
      <el-table-column label="商家名称" prop="name" min-width="200"></el-table-column>
      <el-table-column label="登录账号" prop="contactUid" min-width="95"></el-table-column>
      <el-table-column label="联系人" prop="contactPerson" min-width="100"></el-table-column>
      <el-table-column label="积分" prop="points" min-width="60"></el-table-column>
      <el-table-column label="代运营手机号" prop="agentOperationPhoneNumber" min-width="120"></el-table-column>
      <el-table-column label="渠道码" prop="channelCode" min-width="120" show-overflow-tooltip></el-table-column>
      <el-table-column label="注册时间" prop="creationTime" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.creationTime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="标签" prop="labels" min-width="160">
        <template slot-scope="scope">
          <div class="tag-container">
            <el-tag type="danger" class="tag-item" v-if="scope.row.loginDisabled">
              已禁用
            </el-tag>
            <el-tag :type="Certified(scope.row) ? 'success' : 'warning'" class="tag-item">
              {{Certified(scope.row) ? '已认证' : '未认证'}}
            </el-tag>
            <el-tag v-for="item of scope.row.labels" class="tag-item" type="primary" :key="item.id">
              {{item.name}}
            </el-tag>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="序列值" sortable="custom" prop="sequenceNo" min-width="80"></el-table-column>
      <el-table-column label="操作" min-width="70" fixed="right">
        <template slot-scope="scope">
          <slot name="operations" :item="scope.row"></slot>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right"
                   layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged"
                   @current-change="onCurrentPageChanged"
                   :current-page="page.number + 1"
                   :page-size="page.size"
                   :page-count="page.totalPages"
                   :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
export default {
  name: 'FactoryList',
  props: ['page', 'sequanceSort'],
  computed: {
  },
  methods: {
    sortChange ({ column, prop, order }) {
      // order descending顺序 / ascending倒序
      if (order === 'descending') {
        this.sequanceSort.value = 'sort=sequenceNo,desc&';
      } else if (order === 'ascending') {
        this.sequanceSort.value = 'sort=sequenceNo,asc&';
      } else {
        this.sequanceSort.value = '';
      }

      this.$emit('onAdvancedSearch');
    },
    Certified (row) {
      if (row.approvalStatus && row.approvalStatus === 'approved') {
        return true;
      }
      return false;
    },
    showLabels (arr) {
      return arr.map(item => item.name);
    },
    onPageSizeChanged (val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      })
    },
    onCurrentPageChanged (val) {
      this.$emit('onAdvancedSearch', val - 1, 10);
      
      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      })
    },
    _reset () {
      this.$refs.resultTable.clearSort();
      this.$refs.resultTable.clearFilter();
      this.$refs.resultTable.clearSelection();
    },
    onDetails (row) {
      this.$emit('onDetails', row);
    }
  },
  data () {
    return {
    }
  },
  created () {
  }
}
</script>

<style scoped>
  .tag-item {
    margin-right: 10px;
    margin-bottom: 10px;
  }

  .tag-container {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
  }
</style>
