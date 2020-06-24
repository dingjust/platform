<!-- 
 * @description: 补全退货单
 * @fileName: ReturnForm.vue 
 * @author: yj 
 * @date: 2020-06-24 11:41:05
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn receipt-order-container">
    <el-row type="flex" justify="space-between">
      <el-col :span="4">
        <div class="title">
          <h6>补退货单</h6>
        </div>
      </el-col>
    </el-row>
    <color-size-table :data="curData" />
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
    ColorSizeTable
  } from '@/components/'

  export default {
    name: 'ReturnForm',
    props: {
      colorSizeEntries: {
        type: Array,
        required: true
      },
      data: {
        type: Array
      }
    },
    components: {
      ColorSizeTable
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
        if (this.colorSizeEntries != null) {
          this.colorSizeEntries.forEach(entry => {
            this.curData.push({
              color: entry.color,
              size: entry.size,
              quantity: ''
            });
          });
        }
      }
    },
    destroyed() {

    }
  }

</script>

<style scoped src="../../css/reconsider-order.css"></style>
