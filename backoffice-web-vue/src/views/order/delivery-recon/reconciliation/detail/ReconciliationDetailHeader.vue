<template>
  <el-row type="flex" class="detail-header">
    <el-col :xs="18" :sm="18">
      <el-row type="flex" justify="start" class="basic-container">
        <h6 class="basic-text">标题：{{order.title}}</h6>
      </el-row>
      <el-row type="flex" justify="start" class="basic-container">
        <h6 class="basic-text">合作商：{{order.cooperator.type === 'ONLINE' ? order.cooperator.partner.name : order.cooperator.name}}</h6>
      </el-row>
    </el-col>
    <el-col :xs="6" :sm="6" v-if="order.docSignatures">
      <div class="info-box">
        <el-row type="flex" justify="start" class="reconcilication-order-title">
          <h6 style="margin: 0px">电子对账单</h6>
        </el-row>
        <el-row>
          <template v-for="item in order.docSignatures">
            <el-col :span="6" :key="item.code" @click.native="showPDF(item)" class="contract-item" style="width: 60px">
              <el-row type="flex" justify="center" align="middle">
                <div>
                  <img style="width: 100%" src="static/img/word.png"/>
                </div>
              </el-row>
              <!-- <el-row type="flex" justify="center" align="middle">
                <h6 class="state-title">{{signed ? '已签署' : '未签署'}}</h6>
              </el-row> -->
            </el-col>
          </template>
        </el-row>
      </div>
    </el-col>
  </el-row>
</template>

<script>
export default {
  name: 'ReconciliationDetailHeader',
  props: ['order'],
  computed: {
    signed: function () {
      let flag = false;

      const companyCode = this.$store.getters.currentUser.companyCode;
      const doc = this.order.docSignatures[0];
      // 合同为线下合同，合同已签
      if (doc.signMethod === 'OFFLINE_SIGN') {
        flag = true;
      } else {
        if (doc.partyA.uid === companyCode && doc.partyASignTime) {
          flag = true;
        } else if (doc.partyB.uid === companyCode && doc.partyBSignTime) {
          flag = true;
        }
      }
      return flag;
    }
  },
  data () {
    return {
      currentUserUid: this.$store.getters.currentUser.uid,
      fileUrl: '',
      pdfVisible: false,
      pdfItem: ''
    }
  },
  methods: {
    showPDF (item) {
      this.$emit('showPDF', item);
    },
  }
}
</script>

<style scoped>
  .detail-header {
    margin: 10px 0;
  }

  .basic-container {
    margin: 0 0 20px 12px;
  }

  .basic-text {
    font-size: 16px;
    color: #303133;
    margin: 0px;
  }

  .info-box {
    width: 100%;
    height: 100%;
    border: 1px solid #dcdfe6;
    border-radius: 10px;
    padding: 5px 0px 0px 5px;
  }

  .contract-item {
    padding: 5px;
    border-radius: 5px;
  }

  .contract-item:hover {
    background-color: #ffd60c;
  }

  .reconcilication-order-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .state-title {
    display: contents;
    font-size: 12px;
    width: 100%;
    margin-bottom: 0px;
    color: #606266;
  }
</style>