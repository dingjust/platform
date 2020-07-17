<template>
  <div>
    <div class="container-border">
      <el-row type="flex" justify="space-between" :gutter="20">
        <el-col :span="12">
          <el-row type="flex" justify="start">
            <h6>下单数量</h6>
          </el-row>
          <color-size-table :data="formData.colorSizeEntries" :readOnly="true" />
        </el-col>
        <el-col :span="12">
          <el-row type="flex" justify="start">
            <h6>实收数量</h6>
          </el-row>
          <color-size-table :data="cropColorSizeEntry" :readOnly="true" />
        </el-col>
      </el-row>
    </div>
    <el-row type="flex" justify="end" align="middle" style="margin-top: 20px">
      <el-col :span="4">
        <h6>订单总额：{{orderTotalAmount}}</h6>
      </el-col>
      <el-col :span="4">
        <h6>实收总额：{{receiveTotalAmount}}</h6>
      </el-col>
      <el-col :span="4">
        <h6>累计扣款：{{reconciliationAmountObj.deAmount}}</h6>
      </el-col>
      <el-col :span="4">
        <h6>累计增款：{{reconciliationAmountObj.inAmount}}</h6>
      </el-col>
      <el-col :span="4">
        <h6>实付总额：{{reconciliationAmountObj.payAmount}}</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {
    ColorSizeTable
  } from '@/components/'
  export default {
    name: 'ReconciliationTasksQuantityTable',
    props: ['formData'],
    components: {
      ColorSizeTable
    },
    computed: {
      // 处理裁剪数量数据
      cropColorSizeEntry: function () {
        if (this.formData.colorSizeEntries != null) {
          let result = this.formData.colorSizeEntries.map(entry => {
            let quantity = this.getEntryFromActualNum(entry.color.name, entry.size.name);
            let color = Object.assign({}, entry.color);
            let size = Object.assign({}, entry.size);
            return {
              color: color,
              size: size,
              quantity: quantity
            };
          });
          return result;
        } else {
          return [];
        }
      },
      //订单总额
      orderTotalAmount: function () {
        let result = 0;
        if (this.formData.productionTaskOrder) {
          result = this.formData.productionTaskOrder.unitPrice * this.formData.productionTaskOrder.totalQuantity;
        }
        return result.toFixed(2);
      },
      //实收总额(收货数X单价)
      receiveTotalAmount: function () {
        let totalQuantity = 0;
        let unitPrice = 0;
        if (this.formData.productionTaskOrder) {
          unitPrice = this.formData.productionTaskOrder.unitPrice;
        }
        if (this.formData.shippingSheets) {
          this.formData.shippingSheets.forEach(sheet => {
            if (sheet.receiptSheets) {
              sheet.receiptSheets.forEach(element => {
                totalQuantity += element.totalQuantity;
              });
            }
          });
        }
        return (totalQuantity * unitPrice).toFixed(2);
      },
      //对账款项
      reconciliationAmountObj: function () {
        let deductResult = 0;
        let increaseResult = 0;
        let payResult = 0;

        if (this.formData.reconciliationSheets) {
          this.formData.reconciliationSheets.forEach(sheet => {
            if (sheet.deductionAmount) {
              deductResult += sheet.deductionAmount
            }

            if (sheet.increaseAmount) {
              increaseResult += sheet.increaseAmount;
            }
            if (sheet.amountDue) {
              payResult += sheet.amountDue;
            }
          });
        }
        return {
          deAmount: deductResult.toFixed(2),
          inAmount: increaseResult.toFixed(2),
          payAmount: payResult.toFixed(2)
        };
      }
    },
    methods: {
      //获取实裁数量entry（报单行color,size是Sring类型）
      getEntryFromActualNum(colorName, sizeName) {
        let num = 0;
        if (this.formData.actualCutEntries != null) {
          let index = this.formData.actualCutEntries.findIndex(entry => entry.color == colorName && entry.size ==
            sizeName);
          if (index != -1) {
            let entryQuantity = parseInt(this.formData.actualCutEntries[index].quantity);
            if (!Number.isNaN(entryQuantity)) {
              num += entryQuantity;
            }
          }
        }
        return num;
      }
    },
    data() {
      return {}
    },
    created() {},
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
