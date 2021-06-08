<template>
  <div style="width: 100%">
    <el-dialog :visible.sync="detailVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <!-- <sales-plan-append-product-form v-if="salesProductAppendVisible" @onSave="onSave" :isUpdate="true"
        :fromOrigin="!canChangeProduct" :needMaterialsSpec="needMaterialsSpec" :updataEntry="updateEntry"
        :productionLeader="form.productionLeader" :readOnly="productFormReadOnly" /> -->
      <sales-plan-entry-detail v-if="detailVisible" :fromOrigin="!canChangeProduct"
        :needMaterialsSpec="needMaterialsSpec" :slotData="updateEntry" :belongOrder="form"
        :productionLeader="form.productionLeader" :readOnly="productFormReadOnly" />
    </el-dialog>
    <el-dialog :visible.sync="formVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sales-plan-entry-form v-if="formVisible" @onSave="onSave" :isUpdate="true" :fromOrigin="!canChangeProduct"
        :needMaterialsSpec="needMaterialsSpec" :slotData="updateEntry" :belongOrder="form"
        :productionLeader="form.productionLeader" :readOnly="productFormReadOnly" />
    </el-dialog>
    <div class="over-tabs">
      <el-row type="flex">
        <el-button v-if="canChangeProduct" class="material-btn" @click="appendProduct">添加商品</el-button>
        <el-button v-if="canCreateProfitLoss" class="material-btn" @click="createProfitLoss">创建盈亏分析</el-button>
      </el-row>
    </div>
    <el-tabs type="border-card">
      <el-tab-pane label="订单明细" v-if="form.auditState!='PASSED'" key="order">
        <sales-production-products-table :data="form.taskOrderEntries" :canDelete="canChangeProduct" @onDelete="onProductDelete"
          :canUpdate="canUpdate" @onModify="onProductModify" @onDetail="onProductDetail"/>
      </el-tab-pane>
      <el-tab-pane label="生产明细" v-if="form.auditState=='PASSED'" key="production">
        <sales-production-tasks-table :data="form.taskOrderEntries" :isSelfCreated="isSelfCreated" 
                                      @callback="callback" @onDetail="onTaskDetail"/>
      </el-tab-pane>
      <el-tab-pane label="盈亏分析" v-if="showProfitLoss" key="profitLoss" :lazy="true">
        <profit-loss-detail-subject v-if="form.profitLossAnalysis" 
                                    :id="form.profitLossAnalysis.id" @callback="callback"/>
        <el-row v-else type="flex" justify="center" align="middle" style="padding: 20px;">
          <h6 style="color: #909399">暂无数据</h6>
        </el-row>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import SalesPlanAppendProductForm from '../form/SalesPlanAppendProductForm';
  import SalesProductionProductsTable from './SalesProductionProductsTable';
  import SalesProductionTasksTable from './SalesProductionTasksTable';
  import SalesPlanEntryForm from '../form/SalesPlanEntryForm'
  import SalesPlanEntryDetail from '../form/SalesPlanEntryDetail'

  export default {
    name: 'SalesProductionTabs',
    components: {
      SalesPlanAppendProductForm,
      SalesProductionProductsTable,
      SalesProductionTasksTable,
      SalesPlanEntryForm,
      SalesPlanEntryDetail,
      ProfitLossDetailSubject: () => import('@/views/purchase/profit-loss/detail/ProfitLossDetailSubject')
    },
    props: {
      canUpdate: {
        type: Boolean,
        default: true
      },
      canChangeProduct: {
        type: Boolean,
        default: true
      },
      form: {
        type: Object
      },
      fromOut: {
        type: Boolean,
        default: false
      }
    },
    computed: {
      //根据订单类型，加工类型判断是否需要物料清单等
      needMaterialsSpec: function () {
        switch (this.form.cooperationMode) {
          case 'LABOR_AND_MATERIAL':
            return this.form.type == 'SALES_PLAN' ? false : true;
          case 'LIGHT_PROCESSING':
            return this.form.type == 'SALES_PLAN' ? true : false;
          default:
            return false;
        }
      },
      showProfitLoss: function () {
        // 状态为生产中或已完成
        return this.form.state === 'AUDIT_PASSED' || this.form.state === 'COMPLETED';
        // return this.form.sendBy && this.form.sendBy.id && (this.form.state === 'AUDIT_PASSED' || this.form.state === 'COMPLETED');
      },
      canCreateProfitLoss: function () {
        return !this.form.profitLossAnalysis && this.showProfitLoss && !this.fromOut;
      },
      isSelfCreated: function () {
        return !this.form.originCompany;
      }
    },
    methods: {
      appendProduct() {
        this.$emit('appendProduct');
      },
      handleCommand(command) {
        switch (command) {
          case 'delete':
            this.onDelete();
            break;
          case 'close':
            this.onClose();
            break;
          case 'modify':
            this.onModify();
            break;
        }
      },
      //产品删除
      onProductDelete(index) {
        this.$confirm('确认删除？')
          .then(_ => {
            this.form.taskOrderEntries.splice(index, 1);
            popVisible = false;
          })
          .catch(_ => {});
      },
      onClose() {
        this.$message('------close--------');
      },
      //详情
      onProductDetail(index) {
        this.updateIndex = index;
        this.updateEntry = this.form.taskOrderEntries[index];
        this.productFormReadOnly = true;
        this.detailVisible = true;
      },
      //产品修改
      onProductModify(index) {
        this.updateIndex = index;
        this.updateEntry = JSON.parse(JSON.stringify(this.form.taskOrderEntries[index]));;
        this.productFormReadOnly = false;
        this.formVisible = true;
      },
      //编辑回调
      onSave(rowData) {
        if (rowData.id) {
          this.$confirm('是否保存修改?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this.onSaveRow(rowData);
          });
        } else {
          this.form.taskOrderEntries[this.updateIndex] = rowData;
          this.formVisible = false;
        }
        // this.$emit('onSaveRow', entries);
        // var newEntry = Object.assign(this.updateEntry, entries[0]);
        // this.$set(this.form.taskOrderEntries, this.updateIndex, newEntry);
        // this.salesProductAppendVisible = false;
      },
      async onSaveRow (row) {
        const url = this.apis().updateSalesOrderRow();
        const result = await this.$http.post(url, row);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return; 
        }
        this.$emit('getDetails');
        this.formVisible = false;
      },
      onTaskDetail(index){
        
      },
      createProfitLoss () {
        this.$router.push({
          name: '创建盈亏分析',
          params: {
            formData: {
              id: this.form.id,
              code: this.form.code,
              taskOrderEntries: this.form.taskOrderEntries
            }
          }
        })
      },
      callback () {
        this.$emit('callback');
      }
    },
    data() {
      return {
        salesProductDetailsVisible: false,
        popVisible: false,
        updateEntry: null,
        updateIndex: null,
        salesProductAppendVisible: false,
        productFormReadOnly: false,
        detailVisible: false,
        formVisible: false
      }
    }
  }

</script>

<style scoped>
  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 100px;
    height: 40px;
    border-radius: 5px;
  }

  .border-container {
    border: 1px solid #DCDFE6;
    border-radius: 5px;
    background-color: #F5F5F5;
  }

  .sales-container-box {
    background-color: #D5D5DE;
    padding: 18px;
    border-radius: 3px;
  }

  .el-dropdown-link {
    cursor: pointer;
    color: #409EFF;
    font-size: 12px;
  }

  .el-icon-arrow-down {
    font-size: 12px;
  }

  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 50px;
    margin-top: 2px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    /* width: 90px; */
    height: 35px;
  }

</style>
