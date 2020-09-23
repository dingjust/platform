<template>
  <div class="shipping-order-list-container">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" >
      <el-table-column label="采购需求号" prop="code" />
      <el-table-column label="关联款号" prop="productionTask.product.skuID" />
      <el-table-column label="关联订单" prop="productionTask.code"/>
      <el-table-column label="采购人" prop="merchandiser.name"/>
      <el-table-column label="创建人" prop="creator.name" />
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{getEnum('PurchaseTaskState', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
          <el-divider direction="vertical" v-if="scope.row.state === 'NOT_COMMITED'"></el-divider>
          <el-button v-if="scope.row.state === 'NOT_COMMITED' || scope.row.state === 'AUDITED_FAIL'" 
                      type="text" @click="onEdit(scope.row)">编辑</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
export default {
  name: 'PurchaseRequirementList',
  props: {
    page: {
      type: Object,
      required: true
    }
  },
  methods: {
    onDetail(row) {
      this.$router.push('/purchase/requirement/' + row.id);
    },
    onEdit(row) {
      this.$router.push({
        name: '创建采购需求',
        params: {
          id: row.id
        }
      });
    },
    onPageSizeChanged(val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged(val) {
      this.$emit('onAdvancedSearch', val - 1);
      
      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
  },
  data() {
    return {
    }
  },
  create() {

  }
}
</script>

<style scoped>
  .shipping-order-list-container>>>.el-table th>.cell .el-checkbox {
    display: none;
  }

</style>
