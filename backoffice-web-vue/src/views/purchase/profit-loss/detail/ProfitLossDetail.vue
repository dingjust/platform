<!--
* @Description: 盈亏分析详情
* @Date 2021/03/25 13:54
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="cost-order-title">
          <h6>盈亏分析详情</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <profit-loss-detail-subject :id="id" :isFromDetail="true"/>
    </el-card> 
  </div>
</template>

<script>
import ProfitLossDetailSubject from './ProfitLossDetailSubject'
export default {
  name: 'ProfitLossDetail',
  props: ['id'],
  components: {
    ProfitLossDetailSubject
  }
}
</script>

<style scoped>
  .cost-order-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>