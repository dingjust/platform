<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>创建对账单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form :inline="true" ref="form">
        <el-row type="flex" style="padding-left: 10px">
          <el-col :span="24">
            <reconciliation-orders-form-head :formData="formData" @onOrderSelect="onOrderSelect"
              :disabled="selectDisabled" />
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-left: 10px">
          <el-col :span="24">
            <reconciliation-shipping-orders-list :formData="formData" />
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-left: 10px;margin-top: 20px">
          <el-col :span="24">
            <reconciliation-orders-form-foot :formData="formData" ref="footComp" />
          </el-col>
        </el-row>
        <el-row type="flex" justify="end" style="padding-left: 10px;margin-top: 20px">
          <el-col :span="6">
            <h5>应付金额：{{payable}}元</h5>
          </el-col>
        </el-row>
        <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
          <el-col :span="4">
            <el-button class="create-btn" @click="onSubmit" :disabled="btnDisabled">确认创建</el-button>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import ReconciliationOrdersFormHead from './ReconciliationOrdersFormHead'
  import ReconciliationOrdersFormFoot from './ReconciliationOrdersFormFoot'
  import ReconciliationShippingOrdersList from '../list/ReconciliationShippingOrdersList'
  export default {
    name: 'ReconciliationOrdersForm',
    props: {
      //对账任务id
      taskId: {

      },
      //对应生产工单
      productionTaskOrder: {
        type: Object
      },
      //对应发货单id
      receiveDispatchTaskId: {

      },
      //生产工单id
      productionTaskOrderId: {

      },
      selectShipOrder: {
        type: Array,
        default: () => {
          return [];
        }
      }
    },
    components: {
      ReconciliationOrdersFormHead,
      ReconciliationOrdersFormFoot,
      ReconciliationShippingOrdersList
    },
    computed: {
      btnDisabled: function () {
        if (this.reconciliationTaskId != null) {
          return false;
        } else {
          return true
        }
      },
      selectDisabled: function () {
        if (this.taskId != null && this.taskId != '') {
          return true;
        } else {
          return false;
        }
      },
      isCreator: function () {
        // TODO 判断是否为创建人
        return true;
      },
      payable: function () {
        let totalNum = 0;
        //选中发货单收货总额
        if (this.formData.shippingSheets != null) {
          this.formData.shippingSheets.forEach(sheet => {
            if (sheet.receiptSheets != null) {
              sheet.receiptSheets.forEach(entry => {
                let num = parseInt(entry.totalQuantity);
                if (!Number.isNaN(num)) {
                  totalNum += num;
                }
              });
            }
          });
        }
        let unitPrice = 0;
        if (this.formData.productionTaskOrder.unitPrice != null) {
          unitPrice = this.formData.productionTaskOrder.unitPrice;
        }

        //扣款项
        let deduction = 0;
        if (this.formData.deductions) {
          this.formData.deductions.forEach(element => {
            let num = parseFloat(element.amount);
            if (!Number.isNaN(num)) {
              deduction += num;
            }
          });
        }

        //增款项
        let increase = 0;
        if (this.formData.increases) {
          this.formData.increases.forEach(element => {
            let num = parseFloat(element.amount);
            if (!Number.isNaN(num)) {
              increase += num;
            }
          });
        }

        return (unitPrice * totalNum + increase - deduction).toFixed(2);
      }
    },
    methods: {
      onSubmit() {
        //校验选中发货单数量
        if (this.formData.shippingSheets.length < 1) {
          this.$message.error('请选择发货单');
          return false;
        }

        this.$refs.footComp.$refs.footForm.validate((valid) => {
          if (valid) {
            this._onSubmit();
          } else {

            return false;
          }
        });
      },
      async _onSubmit() {
        const form = {
          shippingSheets: this.formData.shippingSheets,
          increases: this.formData.increases.filter(item => item.amount != null || item.remarks != null).map(
            item => {
              return {
                amount: item.amount ? item.amount : 0,
                remarks: item.remarks ? item.remarks : ''
              };
            }),
          deductions: this.formData.deductions.filter(item => item.amount != null || item.remarks != null).map(
            item => {
              return {
                amount: item.amount ? item.amount : 0,
                remarks: item.remarks ? item.remarks : ''
              };
            }),
        };

        //是否需要审核
        if (this.formData.isApproval) {
          Object.assign(form, {
            isApproval: true,
            approvers: this.formData.approvers
          })
        }

        //TODO:对账任务id处理
        const url = this.apis().reconciliationCreate();
        const result = await this.$http.post(url, form, {
          taskId: this.reconciliationTaskId
        });



        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        } else if (result.code == '1') {
          this.$message.success(result.msg);
          this.$router.go(-1);
        }
      },
      onReturn() {
        this.$router.go(-1);
      },
      onCheck() {

      },
      onApply() {

      },
      onOrderSelect(rows) {
        if (rows != null && rows[0] != null) {
          this.$set(this.formData, 'productionTaskOrder', rows[0]);
          //查询对应发货任务
          if (rows[0].receiveDispatchTask && rows[0].receiveDispatchTask.id) {
            this.getShippingTaskDetai(rows[0].receiveDispatchTask.id);
          }
        }
      },
      async getProductionOrderDetail(id) {
        const url = this.apis().getProductionOrderDetail(id);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$set(this.formData, 'productionTaskOrder', Object.assign({}, result.data.taskOrderEntries[0]));
        //查询发货任务详情
        this.getShippingTaskDetai(this.formData.productionTaskOrder.receiveDispatchTask.id);
        //设置对应对账任务id
        this.reconciliationTaskId = this.formData.productionTaskOrder.reconciliationTask.id;
      },
      //查询发货任务详情
      async getShippingTaskDetai(id) {
        const url = this.apis().shippingTaskDetail(id);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$set(this.formData, 'shippingTask', result.data);
        this.reconciliationTaskId = result.data.reconciliationTask.id;
      }

    },
    data() {
      return {
        reconciliationTaskId: null,
        dispatchTaskId: null,
        formData: {
          isApproval: false,
          approvers: [null],
          shippingSheets: [

          ],
          increases: [{
            amount: null,
            remarks: null
          }],
          deductions: [{
            amount: null,
            remarks: null
          }],
          productionTaskOrder: {
            code: ''
          },
          shippingTask: {
            shippingSheets: []
          }
        }
      }
    },
    created() {
      //组件传参限定工单
      if (this.productionTaskOrder != null) {
        this.formData.productionTaskOrder = this.productionTaskOrder;
      }
      if (this.taskId != null) {
        this.reconciliationTaskId = this.taskId;
      }
      if (this.receiveDispatchTaskId != null) {
        this.dispatchTaskId = this.receiveDispatchTaskId;
      }
      //若发货单任务id不为空，则查询对应发货任务
      if (this.dispatchTaskId != null) {
        this.getShippingTaskDetai(this.dispatchTaskId);
      }

      if (this.productionTaskOrderId != null) {
        this.getProductionOrderDetail(this.productionTaskOrderId);
      }
      if (this.selectShipOrder.length > 0) {
        this.selectShipOrder.forEach(order => {
          this.formData.shippingSheets.push(order);
        });
      }
    }
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .create-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
    border-radius: 10px;
  }

</style>
