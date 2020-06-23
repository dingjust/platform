<!-- 
 * @description: 同意复议单表单
 * @fileName: AcceptForm.vue 
 * @author: yj 
 * @date: 2020-06-23 16:54:56
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn receipt-order-container">
    <el-row type="flex" justify="space-between">
      <el-col :span="4">
        <div class="title">
          <h6>修改收货单据</h6>
        </div>
      </el-col>
    </el-row>

    <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50">
      <template>
        <el-col :span="4">
          <el-button class="material-btn" @click="onSubmit">确定</el-button>
        </el-col>
      </template>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ReceiptForm ',
    props: {
      receiptOrder: {
        type: Object
      },
      data: {
        type:Array
      }
    },
    components: {
      
    },
    computed: {

    },
    methods: {
      onSubmit() {

      },
    },
    data() {
      return {
        curData: ''
      }
    },
    created() {

    },
    destroyed() {

    }
  }

</script>

<style scoped src="../../css/reconsider-order.css"></style>
