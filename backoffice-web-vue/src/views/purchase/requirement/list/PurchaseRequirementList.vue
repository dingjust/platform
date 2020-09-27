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
    async onEdit(row) {
      const url = this.apis().getPurchaseTask(row.id);
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
      let workOrders = []; 
      let data = Object.assign({}, resultData);
      resultData.workOrders.forEach(row => {
        if (row.materials && row.materials.specList && row.materials.specList.length > 0) {
          workOrders = workOrders.concat(row.materials.specList.map(item => {
            return {
              id: row.id,
              materialsId: row.materials.id,
              specListId: item.id,
              name: row.materials.name,
              code: row.materials.code,
              unit: row.materials.unit,
              materialsType: row.materials.materialsType,
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
              cooperatorName: row.cooperatorName,
              price: item.price,
              totalPrice: item.totalPrice
            }
          }));
        }
      })
      data.workOrders = workOrders;
      if (!data.approvers) {
        data.approvers = [null];
        data.auditNeeded = false
      } else {
        data.auditNeeded = true;
      }
      this.$router.push({
        name: '创建采购需求',
        params: {
          formData: Object.assign({}, data)
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
