<template>
  <div class="pp-order-top">
    <el-row type="flex" justify="space-between" align="middle">
      <el-col :span="4">
        <h6 style="margin-bottom: 0px;margin-top: 2px;">生产进度工单</h6>
      </el-col>
      <el-col :span="2">
        <el-button class="pp-edit-btn" @click="onEdit">编辑</el-button>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" class="pp-basic-row">
      <el-col :span="23">
        <el-card>
          <production-progress-node :slotData="slotData" @refreshData="refreshData"/>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import ProductionProgressNode from './ProductionProgressNode';
  export default {
    name: 'ProductionProgressOrderInfo',
    components: {ProductionProgressNode},
    props: ['slotData'],
    methods: {
      onEdit () {
        // this.$router.push('/sales/progressOrder/' + this.slotData.code);
        this.$router.push('/sales/progressOrder/' + this.slotData.code + '/edit');
      },
      refreshData () {
        this.$emit('refreshData');
      }
    }
  }
</script>

<style scoped>
  .pp-order-top {
    margin-top: 20px;
  }

  .pp-edit-btn {
    width: 90px;
  }

  .pp-basic-row {
    margin-top: 20px;
  }
</style>
