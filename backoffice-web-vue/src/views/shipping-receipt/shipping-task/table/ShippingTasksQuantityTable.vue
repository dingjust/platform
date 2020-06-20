<template>
  <div>
    <div class="container-border">
      <el-row type="flex" justify="space-between" :gutter="20">
        <el-col :span="12">
          <el-row type="flex" justify="start">
            <h6>下单数量</h6>
          </el-row>
          <color-size-table :data="orderQuantity" :readOnly="true"/>
        </el-col>
        <el-col :span="12">
          <el-row type="flex" justify="start">
            <h6>实裁数量</h6>
          </el-row>
          <color-size-table :data="cropQuantity" :readOnly="true"/>
        </el-col>
      </el-row>
    </div>
    <el-row type="flex" justify="end" align="middle" style="margin-top: 20px">
      <el-col :span="3">
        <h6>订单数：200000</h6>
      </el-col>
      <el-col :span="3">
        <h6>应发数：200000</h6>
      </el-col>
      <el-col :span="3">
        <h6>已发数：200000</h6>
      </el-col>
      <el-col :span="3">
        <h6>已退数：200000</h6>
      </el-col>
      <el-col :span="3">
        <h6>实收数：200000</h6>
      </el-col>
      <el-col :span="3">
        <h6>差异数：200000</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {ColorSizeTable} from '@/components/'
  export default {
    name: 'ShippingTasksQuantityTable',
    props: ['formData'],
    components: {
      ColorSizeTable
    },
    computed: {
      orderQuantity: function () {
        // TODO 处理下单数量数据
        return [];
      },
      cropQuantity: function () {
        // TODO 处理裁剪数量数据
        return [];
      }
    },
    methods: {
    },
    data() {
      return {
      }
    },
    created() {
    },
    destroyed() {

    }
  }
</script>

<style scoped>
  .container-border {
    border: 2px solid #E5E5E5;
    border-radius: 5px;
    padding: 20px 20px 0px 20px;
  }
</style>