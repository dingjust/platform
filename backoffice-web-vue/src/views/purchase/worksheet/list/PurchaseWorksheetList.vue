<template>
  <div class="shipping-order-list-container">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" >
      <el-table-column label="采购工单号" prop="code" min-width="100px"></el-table-column>
      <el-table-column label="关联款号" prop="skuID"></el-table-column>
      <el-table-column label="物料名称" prop="materials.name"></el-table-column>
      <el-table-column label="物料类别" prop="materials.materialsType">
        <template slot-scope="scope">
          <span>{{getEnum('MaterialsType', scope.row.materials.materialsType)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="物料编号" prop="materials.code"></el-table-column>
      <el-table-column label="采购总量">
        <template slot-scope="scope">
          <span>{{requiredAmount(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="采购员" prop="cooperatorName"></el-table-column>
      <el-table-column label="单位" prop="materials.unit"></el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="回料时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{getEnum('PurchaseWorksheetState', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
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
  name: 'PurchaseWorksheetList',
  props: {
    page: {
      type: Object,
      required: true
    }
  },
  methods: {
    requiredAmount (row) {
      let count = 0;
      row.materials.specList.forEach(item => {
        if (typeof item.requiredAmount === 'number') {
          count += item.requiredAmount;
        }
      });
      return count === 0 ? '' : count;
    },
    onDetail(row) {
      this.$router.push('/purchase/worksheet/' + row.id);
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
