<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between" align="middle">
        <div class="sales-plan-form-title">
          <h6 class="title-info">销售计划详情</h6>
        </div>
        <h6 class="title-info">订单号：{{formData.code}}</h6>
        <h6 class="title-info">创建时间：{{formData.creationtime | timestampToTime}}</h6>
        <div>
          <el-row type="flex">
            <h6 class="title-info">标签/状态：{{getEnum('SalesProductionOrderState', formData.state)}}</h6>
            <audit-tag :state="formData.auditState" class="audit-tag" />
          </el-row>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" :inline="true" :model="formData">
        <sales-order-detail-form :form="formData" :modifyType="modifyType" @callback="getDetails" />
      </el-form>
      <div style="margin-top: 10px">
        <sales-production-tabs :canChangeProduct="false" :form="formData" @getDetails="getDetails" :canUpdate="false"
          @appendProduct="appendProduct" />
      </div>
      <template
        v-if="formData.auditWorkOrder &&formData.auditWorkOrder.processes&& formData.auditWorkOrder.processes.length > 0">
        <order-audit-detail :processes="formData.auditWorkOrder.processes" />
      </template>
      <div class="sales-border-container" style="margin-top: 10px" v-if="formData.auditState=='AUDITED_FAILED'">
        <el-row type="flex" justify="start" class="basic-form-row">
          <h5 style="font-weight: bold">拒绝原因</h5>
        </el-row>
        <el-row class="basic-form-row" type="flex" justify="center">
          <el-col :span="22">
            <h6 class="reject_reason">{{formData.msg}}</h6>
          </el-col>
        </el-row>
      </div>
      <sales-plan-detail-btn-group :slotData="formData" @onReturn="onReturn" @onSave="onSave(false)"
        @onWithdraw="onWithdraw" @callback="onRefresh" @onSubmit="onSave(true)" @onCancel="onDelete"
        @onCancelProdcution="canelingProductionDialogVisible=true" />
    </el-card>
    <el-dialog :visible.sync="salesProductAppendVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sales-plan-append-product-form v-if="salesProductAppendVisible" @onSave="onAppendProduct"
        :needMaterialsSpec="needMaterialsSpec" :defaultAddress="formData.address" :isUpdate="false"
        :productionLeader="formData.productionLeader" />
    </el-dialog>
    <el-dialog :visible.sync="canelingProductionDialogVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sale-order-production-cancel-form v-if="canelingProductionDialogVisible" :order="formData"
        @callback="callback" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'SalesProductionOrdersModule'
  );

  import {
    accMul
  } from '@/common/js/number';
  import SalesProductionTabs from '../components/SalesProductionTabs';
  import SalesOrderDetailForm from '../form/SalesOrderDetailForm';
  import SalesPlanDetailBtnGroup from '../components/SalesPlanDetailBtnGroup';
  import SalesPlanAppendProductForm from '../form/SalesPlanAppendProductForm';
  import SaleOrderProductionCancelForm from '../form/SaleOrderProductionCancelForm';

  import {
    OrderAuditDetail
  } from '@/views/order/salesProduction/components'

  export default {
    name: 'SalesPlanDetail',
    props: ['id'],
    components: {
      SalesOrderDetailForm,
      SalesProductionTabs,
      SalesPlanDetailBtnGroup,
      SalesPlanAppendProductForm,
      OrderAuditDetail,
      SaleOrderProductionCancelForm
    },
    computed: {
      // ...mapGetters({
      //   formData: 'formData'
      // }),
      //根据订单类型，加工类型判断是否需要物料清单等
      needMaterialsSpec: function () {
        //销售计划
        switch (this.formData.cooperationMode) {
          case 'LABOR_AND_MATERIAL':
            return false;
          case 'LIGHT_PROCESSING':
            return true;
          default:
            return false;
        }
      },
      getTriangleColor: function () {
        switch (this.formData.auditState) {
          case 'AUDITING':
            return 'border-right: 70px solid #114EE8;';
          case 'PASSED':
            return 'border-right: 70px solid #4DE811;';
          case 'AUDITED_FAILED':
            return 'border-right: 70px solid #D91A17;';
          case 'NONE':
            return 'border-right: 70px solid #BBBBBB;';
          default:
            return 'border-right: 70px solid #BBBBBB;';
        }
      },
      modifyType: function () {
        if (this.formData.auditState == null) {
          return false;
        }
        switch (this.formData.auditState) {
          case 'NONE':
            return true;
          case 'AUDITED_FAILED':
            return true;
          default:
            return false;
        }
      }
    },
    methods: {
      callback() {
        this.canelingProductionDialogVisible = false;
        this.getDetails();
      },
      async getDetails() {
        const url = this.apis().getSalesProductionOrderDetails(this.id);
        const result = await this.$http.get(url);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.formData = Object.assign({
          approvers: [null]
        }, result.data);
      },
      onWithdraw() {
        this.$confirm('确认撤回?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onWithdraw();
        });
      },
      async _onWithdraw() {
        const url = this.apis().salesPlanWithdraw(this.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == '0') {
          this.$message.error(result.msg);
          return;
        } else if (result.code == '1') {
          this.$message.success('撤回成功');
          this.getDetails();
        }
      },
      appendProduct() {
        this.salesProductAppendVisible = true;
      },
      onAppendProduct(products) {
        products.forEach(element => {
          let index = this.formData.entries.findIndex(entry => entry.product.code == element.product.code);
          if (index == -1) {
            if (element.materialsSpecEntries != null) {
              //移除原有Id;
              element.materialsSpecEntries.forEach(item => {
                this.$delete(item, 'id');
                item.materialsColorEntries.forEach(colorEntry => {
                  this.$delete(colorEntry, 'id');
                });
              });
            }
            this.formData.entries.push(element);
          }
        });
        this.salesProductAppendVisible = false;
      },
      async onSave(submitAudit) {
        this.$refs['form'].validate((valid) => {
          if (valid) {
            this._onSave(submitAudit);
          } else {
            this.$message.error('请完善信息');
          }
        });
      },
      async _onSave(submitAudit) {
        const url = this.apis().salesPlanSave(submitAudit);
        const result = await this.$http.post(url, this.formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == '0') {
          this.$message.error('保存失败:' + result.msg != null ? result.msg : '');
          return;
        } else if (result.code == '1') {
          this.$message.success('更新成功');
          this.$router.go(0);
          this.getDetails();
        }
      },
      onReturn() {

      },
      onReturnPage() {
        this.$router.push({
          name: '销售计划'
        })
      },
      onRefresh() {
        const loading = this.$loading({
          lock: true,
          text: 'Loading',
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.7)'
        });
        setTimeout(() => {
          loading.close();
          this.getDetails();
        }, 1000);
      },
      //作废订单
      onDelete() {
        this.$confirm('此操作将永久作废订单, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onDelete();
        });
      },
      async _onDelete() {
        const url = this.apis().outboundOrderDelete(this.formData.id);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('作废订单成功');
        await this.$router.go(-1);
      },
    },
    data() {
      return {
        salesProductAppendVisible: false,
        canelingProductionDialogVisible: false,
        originalData: '',
        machiningTypes: this.$store.state.EnumsModule.cooperationModes,
        formData: {
          code: '',
          taskOrderEntries: [],
          deliveryAddress: {},
          id: '',
          status: '',
          user: {},
          quality: '',
          seller: {},
          creator: {},
          approvers: [null],
          productionLeader: null,
          auditWorkOrder: {
            processes: []
          }
        },
      }
    },
    created() {
      this.getDetails();
    },
    mounted() {

    }
  };

</script>

<style scoped>
  .sales-plan-form-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .sales-plan-box {
    display: table;
    margin: 0 auto;
    width: 100%;
  }

  .sales-plan-one {
    width: 75%;
    display: table-cell;
  }

  .sales-plan-three {
    width: 1%;
    display: table-cell;
  }

  .sales-plan-two {
    width: 24%;
    display: table-cell;
    z-index: 100;
  }

  .sales-border-container {
    border: 1px solid #DCDFE6;
    border-radius: 5px;
    padding-top: 10px;
  }

  .basic-form-row {
    padding-left: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .sales-plan-h6 {
    padding-top: 8px;
  }

  /deep/ .el-input__inner {
    height: 24px;
    line-height: 24px;
    border-radius: 2px;
    padding: 0px;
  }

  .sales-radio {
    margin-top: 8px
  }

  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 30px;
    margin-top: 2px;
  }

  /deep/ .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 5px;
  }

  .reject_reason {
    color: #606266;
    padding-bottom: 10px;
  }

  .audit-tag {
    margin-left: 10px;
  }

  .title-info {
    margin-top: 5px;
  }

</style>
