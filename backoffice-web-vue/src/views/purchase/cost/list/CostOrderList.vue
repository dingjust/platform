<template>
  <div>
    <el-table ref="resultTable" stripe="" :data="page.content" :height="autoHeight">
      <el-table-column label="单号" prop="code"></el-table-column>
      <el-table-column label="关联工单" prop="productionOrder.code"></el-table-column>
      <el-table-column label="创建人" prop="creator.name"></el-table-column>
      <el-table-column label="创建时间" min-width="80">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="100" min-width="100">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
          <el-button type="text" @click="onEdit(scope.row)" v-if="scope.row.status === 'PENDING_ACCOUNT'">编辑</el-button>
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
  name: 'CostOrderList',
  props: ['page'],
  methods: {
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
    onDetail (row) {
      this.$router.push('/purchase/cost/' + row.id);
    },
    async onEdit (row) {
      const url = this.apis().getCostOrder(row.id);
      const result = await this.$http.get(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.initData(result.data);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      }
    },
    initData (resultData) {
      let data = Object.assign({}, resultData);
      let purchaseMaterials = [];
      if (resultData.purchaseMaterials && resultData.purchaseMaterials.length > 0) {
        resultData.purchaseMaterials.forEach(row => {
          if (row.specList && row.specList.length > 0) {
            purchaseMaterials = purchaseMaterials.concat(row.specList.map(item => {
              return {
                // id: row.id,
                materialsId: row.id,
                specListId: item.id,
                name: row.name,
                code: row.code,
                unit: row.unit,
                materialsType: row.materialsType,
                unitQuantity: item.unitQuantity,
                specName: item.specName,
                colorName: item.colorName,
                modelName: item.modelName,
                emptySent: item.emptySent,
                requiredAmount: item.requiredAmount,
                estimatedLoss: item.estimatedLoss,
                estimatedUsage: item.estimatedUsage,
                orderCount: item.orderCount,
                auditColor: item.auditColor,
                estimatedRecTime: item.estimatedRecTime,
                // cooperatorName: row.cooperatorName,
                price: item.price,
                totalPrice: item.totalPrice
              }
            }))
          }
        })
      }

      let customRows = [];
      if (resultData.customRows) {
        resultData.customRows.forEach(row => {
          if (row.specList && row.specList.length > 0) {
            customRows = customRows.concat(row.specList.map(item => {
              return {
                materialsId: row.id,
                specListId: item.id,
                  name: row.name,
                  unit: row.unit,
                  customCategoryName: row.customCategoryName,
                  price: item.price,
              }
            }))
          }
        })
      }

      data.workOrders = purchaseMaterials;
      data.customRows = customRows;
      data.productionOrder.product = {
        skuID: data.productionOrder.productSkuID
      }

      this.$router.push({
        name: '创建成本单',
        params: {
          formData: Object.assign({}, data)
        }
      });
    }
  }
}
</script>

<style scoped>

</style>