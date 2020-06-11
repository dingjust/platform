<template>
  <div class="animated fadeIn content">
    <el-card>
      <div class="sales-plan-triangle_box">
        <div class="sales-plan-triangle" :style="getTriangleColor">
          <h6 class="sales-plan-triangle_text">{{getEnum('SalesProductionAuditStatus', formData.auditState)}}</h6>
        </div>
      </div>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="sales-plan-form-title">
            <h6>销售订单详情</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" :inline="true" :model="formData" hide-required-asterisk>
        <sales-order-detail-form :form="formData" :modifyType="modifyType" />
      </el-form>
      <div style="margin-top: 10px">
        <sales-production-tabs :canChangeProduct="canAddProduct" :canUpdate="false" :form="formData"
          @appendProduct="appendProduct" />
      </div>
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
        @onRefuse="onRefuse" @onSubmit="onSave(true)" @callback="onRefresh" />
    </el-card>
    <el-dialog :visible.sync="salesProductAppendVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sales-plan-append-product-form v-if="salesProductAppendVisible" @onSave="onAppendProduct" :isUpdate="false"
        :needMaterialsSpec="needMaterialsSpec" :productionLeader="formData.productionLeader" />
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

  export default {
    name: 'SalesOrderDetail',
    props: ['id'],
    components: {
      SalesOrderDetailForm,
      SalesProductionTabs,
      SalesPlanDetailBtnGroup,
      SalesPlanAppendProductForm
    },
    computed: {
      // ...mapGetters({
      //   formData: 'formData'
      // }),
      //根据订单类型，加工类型判断是否需要物料清单等
      needMaterialsSpec: function () {
        //销售订单
        switch (this.formData.cooperationMode) {
          case 'LABOR_AND_MATERIAL':
            return true;
          case 'LIGHT_PROCESSING':
            return false;
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
      },
      canAddProduct: function () {
        //外发订单来源不能添加
        if (this.formData.originOrder != null && this.formData.originOrder.code != '') {
          return false;
        } else {
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

    },
    methods: {
      appendProduct() {
        this.salesProductAppendVisible = true;
      },
      onAppendProduct(products) {
        products.forEach(element => {
          let index = this.formData.entries.findIndex(entry => entry.product.code == element.product.code);
          if (index == -1) {
            //移除原有Id;
            element.materialsSpecEntries.forEach(item => {
              this.$delete(item, 'id');
              item.materialsColorEntries.forEach(colorEntry => {
                this.$delete(colorEntry, 'id');
              });
            });
            this.formData.entries.push(element);
          }
        });
        this.salesProductAppendVisible = false;
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
      onReturn() {

      },
      async onSave(submitAudit) {
        let costingValidate = true;
        //校验是否有核算单
        this.formData.entries.forEach(element => {
          if (element.costOrder == null) {
            costingValidate = false;
          }
        });

        this.$refs['form'].validate((valid) => {
          if (valid && costingValidate) {
            this._onSave(submitAudit);
          } else {
            if (!costingValidate) {
              this.$message.error('请补充明细信息');
            } else {
              this.$message.error('请完善信息');
            }
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
          // this.$router.go(0);
          this.getDetails();
        }
      },
      onReturnPage() {
        this.$router.push({
          name: '销售计划'
        })
      },
      onRefuse() {
        this.$confirm('确认拒绝订单？')
          .then(_ => {
            this._onRefuse();
          })
          .catch(_ => {});
      },
      async _onRefuse() {
        const url = this.apis().refuseSalesOrder(this.formData.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == '0') {
          this.$message.error('拒单失败:' + result.msg != null ? result.msg : '');
          return;
        } else if (result.code == '1') {
          this.$message.success('拒单成功');
          this.$router.go(-1);
        }
      },
      onRefresh() {
        this.$router.go(0);
      },
      validate(callback) {
        this.$refs.form.validate(callback);
      }
    },
    data() {
      return {
        salesProductAppendVisible: false,
        originalData: '',
        machiningTypes: this.$store.state.EnumsModule.cooperationModes,
        formData: {
          code: '',
          entries: [],
          deliveryAddress: {},
          id: '',
          status: '',
          user: {},
          quality: '',
          seller: {},
          approvers: [null],
          productionLeader: null
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

  .sales-plan-triangle_box {
    margin-top: 1px;
    position: absolute;
    right: 0;
    top: 0;
  }

  .sales-plan-triangle {
    width: 0;
    height: 0;
    border-right: 70px solid white;
    border-bottom: 70px solid transparent;
    z-index: 0;
  }

  .sales-plan-triangle_text {
    width: 80px;
    padding-top: 10px;
    padding-left: 30px;
    transform: rotateZ(45deg);
    color: white;
    font-size: 12px;
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

</style>
