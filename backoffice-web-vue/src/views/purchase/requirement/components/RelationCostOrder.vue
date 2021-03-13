<!--
* @Description: 采购需求详情 -> 关联成本单
* @Date 2021/03/12 14:24
* @Author L.G.Y
-->
<template>
  <div>
    <el-tabs type="border-card">
      <el-tab-pane label="关联成本单">
        <cost-order-detail :id="costOrderId"/>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import CostOrderDetail from '@/views/purchase/cost/details/CostOrderDetail'

export default {
  name: 'RelationCostOrder',
  props: ['costOrderId'],
  components: {
    CostOrderDetail
  }
}
</script>

<style scoped>

</style>