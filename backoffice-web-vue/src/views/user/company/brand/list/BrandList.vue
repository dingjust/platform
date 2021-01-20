<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="商家编号" prop="uid" min-width="110"></el-table-column>
      <el-table-column label="商家名称" prop="name" min-width="200"></el-table-column>
      <el-table-column label="登录账号" prop="contactUid" min-width="110"></el-table-column>
      <el-table-column label="联系人" prop="contactPerson" min-width="110"></el-table-column>
      <el-table-column label="注册时间" prop="creationTime" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.creationTime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="标签" prop="labels" min-width="150">
        <template slot-scope="scope">
          <el-tag size="mini" class="disableTagClass" :disable-transitions="true" v-if="scope.row.loginDisabled">
            已禁用
          </el-tag>
          <el-tag v-for="(item, index) of showLabels(scope.row.labels, scope.row.approvalStatus)"
                  size="mini" class="elTagClass" :disable-transitions="true" :key="index">
            {{item}}
          </el-tag>
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
      showLabels (arr, approvalStatus) {
        let arr1 = [];
        if (approvalStatus != undefined && approvalStatus == 'approved') {
          arr1[0] = '已认证';
        } else {
          arr1[0] = '未认证';
        }
        for (let i = 0; i < arr.length; i++) {
          arr1[i + 1] = arr[i].name;
        }
        return arr1;
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
  .disableTagClass{
    color: #0b0e0f;
    margin-right: 10px;
    margin-bottom: 10px;
    cursor:pointer;
    background-color: #F2F6FC;
  }
  .elTagClass{
    color: #0b0e0f;
    margin-right: 10px;
    margin-bottom: 10px;
    cursor:pointer;
    background-color: #FFD60C;
  }
  .el-tag {
    border-color: #FFD60C;
  }
</style>
