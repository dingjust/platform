<template>
  <div>
    <el-row type="flex" justify="center" align="middle">
      <h6>选择款项类型</h6>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-checkbox-group v-model="checkList" @change="handleChange">
        <template v-for="item in paymentRequestType">
          <el-checkbox :label="item.code" :key="item.code">{{item.name}}</el-checkbox>
        </template>
      </el-checkbox-group>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-button class="sumbit-btn" @click="onSumbit">确定</el-button>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'PaymentRequestTypeSelect',
  methods: {
    handleChange (val) {
      if (val.length > 1) {
        this.checkList = [val[val.length - 1]];
      }
    },
    onSumbit () {
      this.$router.push({
        name: '创建付款申请单',
        params: {
          type: this.checkList[0]
        }
      });
    }
  },
  data () {
    return {
      checkList: [],
      paymentRequestType: this.$store.state.EnumsModule.PaymentRequestType
    }
  }  
}
</script>

<style scoped>
  .sumbit-btn {
    width: 80px;
    height: 30px;
    line-height: 0px;
    color: #606266;
    background-color: #ffd60c;
  }

  /deep/ .el-checkbox {
    margin-right: 80px;
  }
</style>