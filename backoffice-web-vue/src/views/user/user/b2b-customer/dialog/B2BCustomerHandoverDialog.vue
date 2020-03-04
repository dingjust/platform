<template>
  <div>
    <el-row>
      <div class="customer-list-title">
        <h6>工作交接</h6>
      </div>
    </el-row>
    <div class="pt-2"></div>
    <el-row type="flex" justify="center">

    </el-row>
    <el-row type="flex" justify="space-around">
      <el-button @click="onCannel" size="mini">取消</el-button>
      <el-button style="background-color: #FFD60C" @click="onConfirm" size="mini">确定</el-button>
    </el-row>
  </div>
</template>

<script>
    export default {
      name: 'B2BCustomerHandoverDialog',
      props: ['slotData'],
      data () {
        return {

        }
      },
      methods: {
        onCannel () {
          this.$emit('onHandoverCannel');
        },
        onConfirm () {
          this.$emit('onHandoverConfirm');
        }
      }
    }
</script>

<style scoped>
  .customer-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .formLabel {
    font-size: 12px;display: inline-block;
  }

  .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 65px;
    font-size: 14px;
  }
</style>
