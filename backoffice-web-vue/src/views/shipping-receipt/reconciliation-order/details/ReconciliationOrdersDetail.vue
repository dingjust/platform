<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="4">
          <div class="title">
            <h6>对账单详情</h6>
          </div>
        </el-col>
        <el-col :span="4">
          <div>
            <h6>状态: {{getEnum('ReconciliationOrderState',formData.state)}}</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form :inline="true">
        <el-row type="flex" style="padding-left: 10px">
          <el-col :span="24">
            <reconciliation-orders-detail-head :formData="formData" />
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-left: 10px">
          <el-col :span="24">
            <shipping-orders-list :formData="formData" />
          </el-col>
        </el-row>
        <el-row type="flex" style="padding-left: 10px;margin-top: 20px">
          <el-col :span="24">
            <reconciliation-orders-form-foot :formData="formData" :readOnly="readOnly" />
          </el-col>
        </el-row>
        <el-row type="flex" justify="end" style="padding-left: 10px;margin-top: 20px">
          <el-col :span="6">
            <h5>应付金额：{{formData.amountDue?formData.amountDue.toFixed(2):0}}元</h5>
          </el-col>
        </el-row>
        <el-row type="flex" v-if="formData.state=='REJECTED'">
          <el-col :span="12">
            <h5 style="color:red">拒绝理由：<span style="color:black">{{formData.remarks}}</span></h5>
          </el-col>
        </el-row>
        <el-row type="flex" justify="center" align="middle" style="margin-top: 20px"
          v-if="isReceiptPart&&formData.state=='PENDING_CONFIRM'">
          <el-col :span="4">
            <el-button class="create-btn" @click="onReject">拒绝</el-button>
          </el-col>
          <el-col :span="4">
            <el-button class="create-btn" @click="onAccept">确认</el-button>
          </el-col>
        </el-row>
        <el-row type="flex" justify="center" align="middle" style="margin-top: 20px"
          v-if="isShipPart&&formData.state=='REJECTED'&&isCreator">
          <el-col :span="4" v-if="readOnly">
            <el-button class="create-btn" @click="onUpdate">修改</el-button>
          </el-col>
          <el-col :span="4" v-if="!readOnly">
            <el-button class="create-btn" @click="onSave">更新</el-button>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import ReconciliationOrdersDetailHead from './ReconciliationOrdersDetailHead'
  import ReconciliationOrdersFormFoot from '../form/ReconciliationOrdersFormFoot'
  import ShippingOrdersList from './ShippingOrdersList'
  export default {
    name: 'ReconciliationOrdersDetail',
    props: ['id'],
    components: {
      ReconciliationOrdersDetailHead,
      ReconciliationOrdersFormFoot,
      ShippingOrdersList
    },
    computed: {
      //发货方
      isShipPart: function () {
        if (this.formData.shipParty) {
          return this.currentUser.companyCode == this.formData.shipParty.uid;
        } else {
          return false;
        }
      },
      //收货方
      isReceiptPart: function () {
        if (this.formData.receiveParty) {
          return this.currentUser.companyCode == this.formData.receiveParty.uid;
        } else {
          return false;
        }
      },
      isCreator: function () {
        if (this.currentUser.uid == this.formData.creator.uid) {
          return true;
        } else {
          return false;
        }
      },
    },
    methods: {
      async getDetail() {
        //获取对账单详情
        const url = this.apis().reconciliationDetail(this.id);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.formData = result.data;
      },
      onCreate() {
        this.$router.go(-1);
      },
      onReturn() {
        this.$router.go(-1);
      },
      onReject() {
        this.$prompt('拒绝理由', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
        }).then(({
          value
        }) => {
          this._onReject(value);
        }).catch(() => {

        });
      },
      async _onReject(reason) {
        //获取对账单详情
        const url = this.apis().reconciliationReject(this.id);
        const result = await this.$http.put(url, {
          remarks: reason
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        } else if (result.code == '1') {
          this.$message.success(result.msg);
          this.getDetail();
        }
      },
      onAccept() {
        this.$confirm('提示：对账单一旦确认将不能进行修改，是否确定此操作', '提示', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this._onAccept();
        }).catch(() => {

        });
      },
      async _onAccept() {
        //获取对账单详情
        const url = this.apis().reconciliationAccept(this.id);
        const result = await this.$http.put(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        } else if (result.code == '1') {
          this.$message.success(result.msg);
          this.getDetail();
        }
      },
      onUpdate() {
        this.readOnly=false;
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        readOnly: true,
        formData: {
          code: '',
          productionTaskOrder: {
            code: '',
            unitPrice: 0
          }
        }
      }
    },
    created() {
      this.getDetail();
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
