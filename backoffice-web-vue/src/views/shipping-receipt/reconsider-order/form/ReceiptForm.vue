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
    <color-size-box-change-table :vdata="curData" :oldData="receiptOrder.packageSheets" style="width:100%"
      :colorSizeEntries="receiptOrder.packageSheets[0].colorSizeEntries" />
    <!-- <color-size-change-table :oldData="receiptOrder.colorSizeEntries" :data="curData[0]" /> -->
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
  import {
    ColorSizeBoxChangeTable,
    ColorSizeChangeTable,
  } from '@/components/'

  export default {
    name: 'ReceiptForm',
    props: {
      receiptOrder: {
        type: Object
      },
      data: {
        type: Array
      }
    },
    components: {
      ColorSizeBoxChangeTable,
      ColorSizeChangeTable
    },
    computed: {

    },
    methods: {
      onSubmit() {
        this.$emit('onSave', this.curData);
      },
    },
    data() {
      return {
        curData: []
      }
    },
    created() {
      if (this.data != null && this.data.length > 0) {
        this.curData = JSON.parse(JSON.stringify(this.data));
      } else {
        this.curData = JSON.parse(JSON.stringify(this.receiptOrder.packageSheets));
        //清空数据 quantity为0
        this.curData.forEach(entry=>{
          entry.colorSizeEntries.forEach(element=>{
            element.quantity=0;
          });
        });
      }
    },
    destroyed() {

    }
  }

</script>

<style scoped src="../../css/reconsider-order.css"></style>
