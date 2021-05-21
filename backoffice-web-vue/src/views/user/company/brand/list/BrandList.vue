<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="商家编号" prop="uid" min-width="110"></el-table-column>
      <el-table-column label="商家名称" prop="name" min-width="200"></el-table-column>
      <el-table-column label="登录账号" prop="contactUid" min-width="110"></el-table-column>
      <el-table-column label="联系人" prop="contactPerson" min-width="110"></el-table-column>
      <el-table-column label="积分" prop="points"></el-table-column>
      <el-table-column label="注册时间" prop="creationTime" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.creationTime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="标签" prop="labels" min-width="150">
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
      <el-table-column label="操作" min-width="200">
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
    name: 'BrandList',
    props: ['page'],
    computed: {},
    methods: {
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
      return {}
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
