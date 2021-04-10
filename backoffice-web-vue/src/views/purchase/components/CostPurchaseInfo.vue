<!--
* @Description: 成本单采购明细
* @Date 2021/04/06 17:13
* @Author L.G.Y
-->
<template>
  <el-table ref="resultTable" :data="formData.workOrders" stripe :height="autoHeight">
    <el-table-column label="物料名称" prop="name" fixed="left"></el-table-column>
    <el-table-column label="物料类别" prop="materialsType">
      <template slot-scope="scope">
        <span>{{getEnum('MaterialsType', scope.row.materialsType)}}</span>
      </template>
    </el-table-column>
    <el-table-column label="物料编号" prop="code"></el-table-column>
    <el-table-column label="物料单位" prop="unit"></el-table-column>
    <el-table-column label="供应商" v-if="!isFromCost" prop="cooperatorName"></el-table-column>
    <el-table-column label="幅宽/型号" prop="modelName"></el-table-column>
    <el-table-column label="克重/规格" prop="specName"></el-table-column>
    <el-table-column label="物料颜色" prop="colorName"></el-table-column>
    <!-- 表单显示内容 -->
    <el-table-column label="单位用量" prop="unitQuantity"></el-table-column>
    <el-table-column label="预计损耗" prop="estimatedLoss">
      <template slot-scope="scope">
        <span>{{(scope.row.estimatedLoss * 100).toFixed(2)}}%</span>
      </template>
    </el-table-column>
    <el-table-column label="预计用量" prop="estimatedUsage" ></el-table-column>
    <el-table-column label="订单数" prop="orderCount"></el-table-column>
    <el-table-column label="空差" prop="emptySent">
      <template slot-scope="scope">
        <span>{{(scope.row.emptySent * 100).toFixed(2)}}%</span>
      </template>
    </el-table-column>
    <el-table-column label="需求数量" prop="requiredAmount" min-width="100px">
      <template slot="header">
        <span v-popover:popover>需求数量</span>
        <el-popover ref="popover" placement="top-start" width="270" trigger="hover"
          :content="title">
        </el-popover>
      </template>
      <template slot-scope="scope">
        <span v-popover:popover>{{scope.row.requiredAmount}}</span>
        <el-popover ref="popover" placement="top-start" width="270" trigger="hover"
          :content="title">
        </el-popover>
      </template>
    </el-table-column>
    <el-table-column label="物料单价" prop="price"></el-table-column>
    <el-table-column label="总金额" prop="totalPrice"></el-table-column>
    <el-table-column label="操作" min-width="100px" v-if="!readOnly" fixed="right">
      <template slot-scope="scope">
        <el-button type="text" @click="onModify(scope.row, scope.$index)">修改</el-button>
        <el-button type="text" @click="onDelete(scope.row, scope.$index)">删除</el-button>
      </template>
    </el-table-column>
  </el-table>
</template>

<script>
export default {
  name: 'CostPurchaseInfo',
  props: ['formData', 'readOnly', 'isFromCost', 'readCostOnly'],
  data () {
    return {
      title: '需求数量 = 预计用量 * 订单数 / 空差'
    }
  },
  methods: {
    onModify (row, index) {
      this.$emit('onModify', row, index);
    },
    onDelete (row, index) {
      this.$emit('onDelete', row, index);
    }
  }
}
</script>

<style scoped>

</style>