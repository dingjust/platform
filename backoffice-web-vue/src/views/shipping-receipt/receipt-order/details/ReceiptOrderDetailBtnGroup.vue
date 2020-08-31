<!-- 
 * @description: 收货单详情按钮组
 * @fileName: ReceiptOrderDetailBtnGroup.vue 
 * @author: yj 
 * @date: 2020-06-22 13:58:50
 * @version: V1.0.0 
!-->
<template>
  <div>
    <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50">
      <template>
        <el-col :span="4" v-if="isShipParty">
          <el-button class="material-btn">申请复议</el-button>
        </el-col>
      </template>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ReceiptOrderDetailBtnGroup',
    props: {
      slotData: {
        type: Object
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
      }
    },
    computed: {
      //是否为发货方
      isShipParty: function () {
        if (this.currentUser != null && this.formData.shipParty != null) {
          return this.currentUser.companyCode == this.formData.shipParty.uid;
        } else {
          return false;
        }
      }
      // //是否创建人
      // isCreator: function () {
      //   if (this.slotData.creator != null && this.currentUser != null) {
      //     return this.slotData.creator.uid == this.currentUser.uid;
      //   } else {
      //     return false;
      //   }
      // },
      // //是否审批人
      // isApprover: function () {
      //   //无审批人
      //   if (this.slotData.approvers == null || this.currentUser == null) {
      //     return false;
      //   }
      //   let index = this.slotData.approvers.findIndex(item => {
      //     if (item != null && item.uid != null) {
      //       return item.uid === this.currentUser.uid;
      //     } else {
      //       return false;
      //     }
      //   });
      //   return index != -1;
      // },
      // hasOrigin: function () {
      //   return this.slotData.originOrder != null && this.slotData.originOrder.code != null;
      // },
      // isSalesOrder: function () {
      //   return this.slotData.type == 'SALES_ORDER';
      // }
    },
    methods: {
      // onGoback() {
      //   this.$router.go(-1);
      // },
      // onWithdraw() {
      //   this.$emit('onWithdraw');
      // },
      // onSave() {
      //   this.$emit('onSave');
      // },
      // onSubmit() {
      //   this.$emit('onSubmit');
      // },
      // onRefuse() {
      //   this.$emit('onRefuse');
      // },
      // //跳转接单页面
      // onCommit() {
      //   this.$router.push({
      //     name: this.slotData.type == 'SALES_ORDER' ? '录入外接订单' : '录入企划订单',
      //     params: {
      //       order: this.slotData
      //     }
      //   });
      // },
      // //审批
      // onApproval(isPass) {
      //   if (isPass) {
      //     this.$confirm('是否确认审核通过?', '提示', {
      //       confirmButtonText: '确定',
      //       cancelButtonText: '取消',
      //       type: 'warning'
      //     }).then(() => {
      //       this._onApproval(isPass, '');
      //     });
      //   } else {
      //     this.$prompt('请输入不通过原因', '提示', {
      //       confirmButtonText: '确定',
      //       cancelButtonText: '取消',
      //     }).then(({
      //       value
      //     }) => {
      //       this._onApproval(isPass, value);
      //     }).catch(() => {
      //       //TODO:取消操作
      //     });
      //   }
      // },
      // async _onApproval(isPass, auditMsg) {
      //   let formData = {
      //     id: this.slotData.auditWorkOrder.id,
      //     auditMsg: auditMsg,
      //     state: isPass ? 'PASSED' : 'AUDITED_FAILED'
      //   };
      //   const url = this.apis().taskAudit();
      //   const result = await this.$http.post(url, formData);
      //   if (result.code == 0) {
      //     this.$message.error(result.msg);
      //     return
      //   }
      //   this.$message.success('审批成功');
      //   this.$emit('callback');
      // }
    }
  }

</script>

<style scoped>
  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 150px;
    height: 35px;
  }

  .material-btn_red {
    background-color: red;
    /* border-color: #FFD5CE; */
    color: white;
    width: 150px;
    height: 35px;
  }

</style>
