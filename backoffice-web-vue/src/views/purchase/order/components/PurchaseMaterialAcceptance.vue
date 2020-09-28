<template>
  <div class="purchase-material-table">
    <table cellspacing="2" width="100%" class="order-table">
      <!-- 表头 -->
      <tr class="order-table_body-wrapper">
        <template v-for="item in titleRow">
          <th :key="item">{{item}}</th>
        </template>
      </tr>
      <template v-if="order && order.entries.length > 0">
        <template v-for="(item, index) in order.entries">
          <tr :key="index">
            <td>{{order.workOrder.materials.name}}</td>
            <td>{{item.spec.colorName}}</td>
            <td>{{item.spec.modelName}}</td>
            <td>{{item.spec.specName}}</td>
            <td>{{item.orderQuantity}}</td>
            <td style="width: 200px">
              <el-input v-if="isOnEdit" v-model="item.receiveQuantity" type="number" v-number-input.float="{ min: 0, decimal: 2}" />
              <span v-else>{{item.receiveQuantity}}</span>
            </td>
            <td>
              <span>{{lackMaterials(item)}}</span>
            </td>
            <td style="width: 200px">
              <el-input v-if="isOnEdit" v-model="item.remark" />
              <span v-else>{{item.remark}}</span>
            </td>
          </tr>
        </template>
      </template>
      <template v-else>
        <tr>
          <td :colspan="titleRow.length">暂无数据</td>
        </tr>
      </template>
      <tr>
        <td :colspan="4">总计</td>
        <td>{{countPlace}}</td>
        <td>{{countReceive}}</td>
        <td>{{countLack}}</td>
        <td></td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  name: 'PurchaseMaterialAcceptance',
  props: ['order', 'isOnEdit'],
  computed: {
    countPlace: function () {
      let count = 0;
      this.order.entries.forEach(item => {
        if (!Number.isNaN(Number.parseFloat(item.orderQuantity))) {
          count += Number.parseFloat(item.orderQuantity);
        }
      })
      return count.toFixed(2);
    },
    countReceive: function () {
      let count = 0;
      this.order.entries.forEach(item => {
        if (!Number.isNaN(Number.parseFloat(item.receiveQuantity))) {
          count += Number.parseFloat(item.receiveQuantity);
        }
      })
      return count.toFixed(2);
    },
    countLack: function () {
      let count = 0;
      this.order.entries.forEach(item => {
        count += Number.parseFloat(this.lackMaterials(item) !== '' ? this.lackMaterials(item) : 0);
      })
      return count.toFixed(2);
    }
  },
  methods: {
    lackMaterials (item) {
      let orderQuantity = Number.parseFloat(item.orderQuantity);
      let receiveQuantity = Number.parseFloat(item.receiveQuantity);
      if (!Number.isNaN(orderQuantity) && !Number.isNaN(receiveQuantity)) {
        return (orderQuantity - receiveQuantity).toFixed(2) > 0 ? (orderQuantity - receiveQuantity).toFixed(2) : 0;
      }
      return '';
    }
  },
  data () {
    return {
      titleRow: ['物料名称', '物料颜色', '幅宽/型号', '克重/规格', '下单数', '收料数', '缺料数', '备注'],
    }
  }  
}
</script>

<style scoped>
  .order-table {
    width: 100%;
    height: 100%; 
    border-collapse: collapse;
    margin-bottom: 20px;
    border: 2px solid #EBEEF5;;
  }

  .order-table tr td,
  .order-table tr th {
    text-align: center;
    height: 40px;
    font-size: 10px;
    border-right: 2px solid #EBEEF5;
    border-bottom: 2px solid #EBEEF5;
  }

  .purchase-material-table >>> .el-input__inner {
    text-align: center;
    border: 0px solid #DCDFE6;
  }
</style>