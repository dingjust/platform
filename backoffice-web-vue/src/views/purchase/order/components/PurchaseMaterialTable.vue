<template>
  <div class="purchase-material-table">
    <el-row type="flex" justify="end" v-if="!readOnly">
      <h6 style="margin-right: 20px">单位：{{'米'}}</h6>
    </el-row>
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
            <td>{{readOnly ? order.workOrder.materials.name : item.name}}</td>
            <td>{{readOnly ? item.spec.colorName : item.colorName}}</td>
            <td>{{readOnly ? item.spec.modelName : item.modelName}}</td>
            <td>{{readOnly ? item.spec.specName : item.specName}}</td>
            <td style="min-width: 100px">
              <span v-if="readOnly">{{item.orderQuantity}}</span>
              <el-input v-else v-model="item.orderQuantity" type="number" placeholder="请输入" v-number-input.float="{ min: 0, decimal: 2}" />
            </td>
            <td style="min-width: 100px">
              <span v-if="readOnly">{{item.price}}</span>
              <el-input v-else v-model="item.price" type="number" placeholder="请输入" v-number-input.float="{ min: 0, decimal: 2}" />
            </td>
            <td style="min-width: 100px">
              <span v-if="readOnly">{{item.totalPrice}}</span>
              <span v-else>{{totalPrice(item, index)}}</span>
            </td>
            <td>
              <span v-if="readOnly">{{item.estimatedRecTime | timestampToTime}}</span>
              <el-date-picker v-else v-model="item.estimatedRecTime" style="width: 130px" type="date" placeholder="选择日期" value-format="timestamp" />
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
        <td>{{countQuantity}}</td>
        <td></td>
        <td>{{countTotalPrice}}</td>
        <td></td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  name: 'PurchaseMaterialTable',
  props: {
    order: {
      required: true
    },
    readOnly: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    countQuantity: function () {
      let count = 0;
      this.order.entries.forEach(item => {
        if (!Number.isNaN(Number.parseFloat(item.orderQuantity))) {
          count += Number.parseFloat(item.orderQuantity);
        }
      })
      return count === 0 ? '' : count.toFixed(2);
    },
    countTotalPrice: function () {
      let count = 0;
      this.order.entries.forEach(item => {
        if (!Number.isNaN(Number.parseFloat(item.totalPrice))) {
          count += Number.parseFloat(item.totalPrice);
        }
      })
      return count === 0 ? '' : count.toFixed(2);
    }
  },
  methods: {
    totalPrice (item, index) {
      let orderQuantity = Number.isNaN(Number.parseFloat(item.orderQuantity)) ? 0 : Number.parseFloat(item.orderQuantity);
      let price = Number.isNaN(Number.parseFloat(item.price)) ? 0 : Number.parseFloat(item.price);
      item.totalPrice = (orderQuantity * price).toFixed(2);
      return (orderQuantity * price).toFixed(2);
    }
  },
  data () {
    return {
      titleRow: ['物料名称', '物料颜色', '幅宽/型号', '克重/规格', '下单数', '物料单价', '总金额', '到料时间'],
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