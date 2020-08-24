<!-- 
 * @description: 销售计划/订单详情按钮组
 * @fileName: SalesPlanDetailBtnGroup.vue 
 * @author: yj 
 * @date: 2020-06-10 14:55:33
 * @version: V1.0.0 
!-->
<template>
  <div>
    <el-row type="flex" justify="space-around" style="margin-top: 20px" :gutter="50">
      <!-- 创建人员控制按钮 -->
      <template v-if="isCreator">
        <el-col :span="3" v-if="slotData.auditState=='AUDITING'">
          <el-button class="material-btn" @click="onWithdraw">撤回</el-button>
        </el-col>
      </template>
      <!-- 审核人员按钮 -->
      <template v-if="isApprover && slotData.auditWorkOrder && slotData.auditWorkOrder.currentUserAuditState === 'AUDITING'">
        <el-col :span="3">
          <authorized :permission="['DO_AUDIT']">
            <el-button class="material-btn_red" @click="onApproval(false)">审核拒绝</el-button>
          </authorized>
        </el-col>
        <el-col :span="3">
          <authorized :permission="['DO_AUDIT']">
            <el-button class="material-btn" @click="onApproval(true)">审核通过</el-button>
          </authorized>
        </el-col>
      </template>
      <!-- 制定交接人或创建者按钮 -->
      <template v-if="slotData.state != 'CANCELED'">
        <!-- 销售订单按钮 -->
        <template v-if="isSalesOrder&&(slotData.auditState=='NONE'||slotData.auditState=='AUDITED_FAILED')&&hasOrigin">
          <el-col :span="3">
            <authorized :permission="['ACCEPT_REJECT_ORDER']">
              <el-button class="material-btn_red" @click="onRefuse">拒单</el-button>
            </authorized>
          </el-col>
          <el-col :span="3">
            <authorized :permission="['ACCEPT_REJECT_ORDER']">
              <el-button class="material-btn" @click="onCommit">接单</el-button>
            </authorized>
          </el-col>
        </template>
        <!-- 销售计划 -->
        <template v-else-if="slotData.auditState=='NONE' || (slotData.auditState=='AUDITED_FAILED' && isCreator)">
          <el-col :span="3">
            <el-button class="material-btn" @click="onCommit">提交</el-button>
          </el-col>
        </template>
      </template>
      <!-- <el-col :span="3">
        <el-button class="material-btn" @click="onGoback">返回</el-button>
      </el-col> -->
      <!-- <el-col :span="3" v-if="slotData.auditState=='NONE'||slotData.auditState=='AUDITED_FAILED'">
        <el-button class="material-btn" @click="onSave">保存</el-button>
      </el-col>
      <el-col :span="3" v-if="slotData.auditState=='NONE'||slotData.auditState=='AUDITED_FAILED'">
        <el-button class="material-btn" @click="onSubmit">提交审核</el-button>
      </el-col> -->
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'SalesPlanDetailBtnGroup',
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
      //是否创建人
      isCreator: function () {
        if (this.slotData.creator != null && this.currentUser != null) {
          return this.slotData.creator.uid == this.currentUser.uid;
        } else {
          return false;
        }
      },
      //是否审批人
      isApprover: function () {
        //无审批人
        if (this.slotData.approvers == null || this.currentUser == null) {
          return false;
        }
        let index = this.slotData.approvers.findIndex(item => {
          if (item != null && item.uid != null) {
            return item.uid === this.currentUser.uid;
          } else {
            return false;
          }
        });
        return index != -1;
      },
      hasOrigin: function () {
        //来源公司
        return this.slotData.originCompany != null && this.slotData.originCompany != '';
      },
      isSalesOrder: function () {
        return this.slotData.type == 'SALES_ORDER';
      }
    },
    methods: {
      onGoback() {
        this.$router.go(-1);
      },
      onWithdraw() {
        this.$emit('onWithdraw');
      },
      onSave() {
        this.$emit('onSave');
      },
      onSubmit() {
        this.$emit('onSubmit');
      },
      onRefuse() {
        this.$emit('onRefuse');
      },
      //跳转接单页面
      onCommit() {
        this.$router.push({
          name: this.slotData.type == 'SALES_ORDER' ? '录入业务订单' : '录入企划订单',
          params: {
            order: this.slotData
          }
        });
      },
      //审批
      onApproval(isPass) {
        if (this.slotData.auditWorkOrder.auditingUser.uid === this.$store.getters.currentUser.uid && 
            this.slotData.auditWorkOrder.currentUserAuditState === 'AUDITING') {
          if (isPass) {
            this.$confirm('是否确认审核通过?', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              this._onApproval(isPass, '');
            });
          } else {
            this.$prompt('请输入不通过原因', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
            }).then(({
              value
            }) => {
              this._onApproval(isPass, value);
            }).catch(() => {
              //TODO:取消操作
            });
          }
        } else if (this.slotData.auditWorkOrder.currentUserAuditState === 'AUDITING' && 
                    this.slotData.auditWorkOrder.auditingUser.uid !== this.$store.getters.currentUser.uid) {
          this.$message.warning('此订单暂未轮到您进行审批。')
        } else if (this.slotData.auditWorkOrder.currentUserAuditState === 'PASSED') {
          this.$message.warning('您已对此订单进行了审批。');
        }
      },
      async _onApproval(isPass, auditMsg) {
        let formData = {
          id: this.slotData.auditWorkOrder.id,
          auditMsg: auditMsg,
          state: isPass ? 'PASSED' : 'AUDITED_FAILED'
        };
        const url = this.apis().taskAudit();
        const result = await this.$http.post(url, formData);
        if (result.code == 0) {
          this.$message.error(result.msg);
          return
        }
        this.$message.success('审批成功');
        this.$emit('callback');
      }
    }
  }

</script>

<style scoped>
  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .material-btn_red {
    background-color: red;
    /* border-color: #FFD5CE; */
    color: white;
    width: 90px;
    height: 35px;
  }

</style>
