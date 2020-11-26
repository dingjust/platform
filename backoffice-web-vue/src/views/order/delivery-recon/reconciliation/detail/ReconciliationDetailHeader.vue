<template>
  <el-row type="flex" class="detail-header">
    <el-col :xs="18" :sm="18">
      <el-row type="flex" justify="start" class="basic-container">
        <h6 class="basic-text">标题：{{order.title}}</h6>
      </el-row>
      <el-row type="flex" justify="start" class="basic-container">
        <h6 class="basic-text">合作商：{{order.receiveParty.uid === currentUserUid ? 
                  order.shipParty.name : order.receiveParty.name}}</h6>
      </el-row>
    </el-col>
    <el-col :xs="6" :sm="6">
      <div class="info-box">
        <h6>电子合同</h6>
      </div>
    </el-col>
  </el-row>
</template>

<script>
export default {
  name: 'ReconciliationDetailHeader',
  props: ['order'],
  data () {
    return {
      currentUserUid: this.$store.getters.currentUser.uid
    }
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
</style>