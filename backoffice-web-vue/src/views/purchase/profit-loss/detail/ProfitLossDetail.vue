<!--
* @Description: 盈亏分析详情
* @Date 2021/03/25 13:54
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
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
</style>