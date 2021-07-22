<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="outbound-order-create-title">
          <h6>创建外发订单</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" label-width="80px" :rules="rules" :model="formData">
        <outbound-type-select :formData="formData" />
        <outbound-order-contact-com :formData="formData" :isAccepted="isAccepted"/>
        <order-pay-setting ref="paySetting" :formData="formData" from="OUTBOUND_ORDER" :readOnly="isAccepted"/>
        <el-divider />
        <outbound-order-entry ref="orderEntries" :formData="formData" :readOnly="isAccepted"/>
        <el-row>
          <h6 style="padding-left: 10px">生产详情</h6>
        </el-row>
        <div class="outbound-basic-row matvat-container">
          <MTAVAT :machiningTypes.sync="formData.cooperationMode" :needVoice.sync="formData.invoiceNeeded"
            :tax.sync="formData.invoiceTaxPoint" :layoutScale="[9,10,5]" :readOnly="isAccepted" />
          <el-form-item label="运费承担：" label-width="120" style="min-width: 240px">
            <el-radio v-model="formData.freightPayer" :label="'PARTYA'" :disabled="isAccepted">甲方</el-radio>
            <el-radio v-model="formData.freightPayer" :label="'PARTYB'" :disabled="isAccepted">乙方</el-radio>
          </el-form-item>
        </div>
        <pay-plan-form class="outbound-basic-row" :formData="formData.payPlan" :isUseForOrder="true" ref="payPlanCom" :readOnly="isAccepted"/>
        <outbound-order-audit-part :formData="formData" :isDisabled="isDisabled"/>
        <outbound-order-addition-info :formData="formData" />
      </el-form>
      <outbound-order-form-btn :formData="formData" :canDelete="canDelete" @onCreate="onCreate" @onDelete="onDelete"/>
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions
  } = createNamespacedHelpers(
    'OutboundOrderModule'
  );

  import {
    PayPlanForm,
    MTAVAT
  } from '@/components'
  import { checkAuditFree } from '@/auth/auth'

  import OutboundTypeSelect from '../components/OutboundTypeSelect'
  import OutboundOrderContactCom from './OutboundOrderContactCom'
  import OutboundOrderAuditPart from './OutboundOrderAuditPart'
  import OutboundOrderAdditionInfo from './OutboundOrderAdditionInfo'
  import OutboundOrderFormBtn from './OutboundOrderFormBtn'
  import OutboundOrderEntry from './OutboundOrderEntry'
  import OrderPaySetting from '@/views/order/salesProduction/components/OrderPaySetting'

  export default {
    name: 'OutboundOrderForm',
    components: {
      PayPlanForm,
      MTAVAT,
      OutboundTypeSelect,
      OutboundOrderContactCom,
      OutboundOrderAuditPart,
      OutboundOrderAdditionInfo,
      OutboundOrderFormBtn,
      OutboundOrderEntry,
      OrderPaySetting
    },
    computed: {
      canDelete: function () {
        if (this.formData.state != null && this.formData.state == 'TO_BE_SUBMITTED') {
          return true;
        } else {
          return false;
        }
      },
      isDisabled: function () {
        return !checkAuditFree('SEND_SALES_OUT_NO_AUDIT');
      },
      isAccepted: function () {
        return this.formData['NEW_ACCEPTED']
      }
    },
    methods: {
      ...mapActions({
        clearFormData: 'clearFormData'
      }),
      // 封装Promise对象
      getFormPromise(form) {
        return new Promise(resolve => {
          form.validate(res => {
            resolve(res);
          })
        })
      },
      async validateForms() {
        var formArr = [];
        formArr.push(this.$refs['form']);
        formArr.push(this.$refs['paySetting'].$refs['form']);
        this.$refs['orderEntries'].$refs['itemForm'].forEach(item => {
          formArr.push(item);
        })
        this.$refs['orderEntries'].$refs['addressForm'].forEach(item => {
          formArr.push(item.$refs['address']);
        })
        formArr.push(this.$refs['payPlanCom'].$refs['payPlanForm']);
        // 使用Promise.all 并行去校验结果
        let res = await Promise.all(formArr.map(this.getFormPromise));

        return res.every(item => !!item);
      },
      async onCreate(flag) {
        let validate = await this.validateForms();
        if (validate) {
          this._onCreate(flag);
        } else {
          this.$message.error('请完善表单信息');
        }
      },
      async _onCreate(flag) {
        let data = Object.assign({}, this.formData);
        // 人员设置数据处理
        if (!data.sendAuditNeeded) {
          data.sendApprovers = [];
        } else {
          // 处理级联选择数据
          data.sendApprovers = [];
          this.formData.sendApprovers.forEach(item => {
            if (item instanceof Array && item.length > 0) {
              data.sendApprovers.push({
                id: item[item.length - 1]
              });
            }
          })
        }
        if (!data.invoiceNeeded) {
          data.invoiceTaxPoint = null;
        }

        let url = this.apis().createOutboundOrder();
        if (this.formData['NEW_ACCEPTED']) {
          url = this.apis().receivingOrder()
        }

        const result = await this.$http.post(url, data, {
          // 特殊处理新的修改情况，submitAudit为false
          submitAudit: data['NEW_MODIFY'] ? false : flag
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }

        this.$message.success(flag ? '创建外发订单成功！' : '保存外发订单成功！');
        await this.$router.push({
          name: '外发订单列表'
        });
      },
      validateField(name) {
        this.$refs.form.validateField(name);
      },
      initData() {
        if (this.$route.params.formData != null) {
          this.formData = this.$route.params.formData;

          if (this.formData.sendApprovers == null) {
            this.formData.sendApprovers = [null];
          }
          if (this.formData.taskOrderEntries.length <= 0) {
            this.formData.taskOrderEntries.push({
              originOrder: {
                id: ''
              },
              deliveryDate: '',
              shippingAddress: {},
              product: {},
              progressPlan: {
                name: ''
              },
              colorSizeEntries: []
            })
          }
        } 
        //默认设置跟单员为当前账号
        this.$set(this.formData, 'merchandiser', this.currentUser);
      },
      //作废订单
      onDelete() {
        this.$confirm('此操作将永久取消订单, 是否继续?', '提示', {
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
        this.$message.success('取消订单成功');
        this.$router.go(-1);
      },
    },
    data() {
      var checkPartyAOperator = (rule, value, callback) => {
        if (value && value.id != '') {
          return callback();
        } else {
          return callback(new Error('请选择跟单员'));
        }
      };
      return {
        rules: {
          merchandiser: [{
            type: 'object',
            validator: checkPartyAOperator,
            trigger: 'change'
          }]
        },
        formData: Object.assign({}, this.$store.state.OutboundOrderModule.formData),
        currentUser: this.$store.getters.currentUser,
        taskDialogVisible: false,
        progressPlanVisible: false,
        editProgressPlanVisible: false,
        editProgress: '',
        operator: {},
        count: 0,
        isSingleSelect: true
      }
    },
    watch: {
      'formData.managementMode': function (nval, oval) {
        this.validateField('managementMode');
      },
      'formData.sendApprovers': function (nval, oval) {
        this.formData.sendApprovers.forEach((item, index) => {
          this.validateField('sendApprovers.' + index);
        })
      }
    },
    created() {
      if (checkAuditFree('SEND_SALES_OUT_NO_AUDIT')) {
        this.formData.sendAuditNeeded = false;
      } else {
        this.formData.sendAuditNeeded = true;
      }
      this.initData();
    },
    mounted() {
      this.$nextTick(() => {
        this.$refs['form'].clearValidate();
      })
    },
    destroyed() {
      this.clearFormData();
    }
  }

</script>

<style scoped>
  .outbound-order-create-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .outbound-basic-row {
    padding-left: 20px;
  }

  .outbound-btn {
    background: #FFD60C;
    color: rgba(0, 0, 0, 0.85);
    width: 70px;
  }

  .info-order-row {
    margin-bottom: 20px;
  }

  .order-purchase-table-btn_add {
    width: 100%;
    height: 50px;
    line-height: 50px;
    border: 0.5px dashed rgba(0, 0, 0, 0.15);
    text-align: center;
    align-content: center;
    color: rgba(0, 0, 0, 0.65);
    background: rgba(247, 247, 247, 1);
  }

  .order-purchase-table-btn_add:hover {
    background: #fff9c4;
    cursor: pointer;
  }

  /deep/ .el-divider--horizontal {
    margin: 16px 0;
  }

  /deep/ .el-input__suffix {
    right: 0px;
  }

  .price-row {
    display: flex;
    justify-content: start;
    flex-wrap: wrap;
  }

  .matvat-container {
    display: flex;
    justify-content: start;
    flex-wrap: wrap;
  }
</style>
