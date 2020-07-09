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
            <h6>实裁数量</h6>
          </el-row>
          <color-size-table :data="cropColorSizeEntry" :readOnly="true" />
        </el-col>
      </el-row>
    </div>
    <el-row type="flex" justify="end" align="middle" style="margin-top: 20px">
      <el-col :span="3">
        <h6>订单数：{{orderTotalNum}}</h6>
      </el-col>
      <el-col :span="3">
        <h6>应发数：{{cropTotalNum}}</h6>
      </el-col>
      <el-col :span="3">
        <h6>已发数：{{totalShippingNum}}</h6>
      </el-col>
      <el-col :span="3">
        <h6>已退数：{{totalReturnNum}}</h6>
      </el-col>
      <el-col :span="3">
        <h6>实收数：{{totalReceiptNum}}</h6>
      </el-col>
      <el-col :span="3">
        <h6>差异数：{{totalDiffNum}}</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {
    ColorSizeTable
  } from '@/components/'
  export default {
    name: 'ShippingTasksQuantityTable',
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
      //订单数量
      orderTotalNum: function () {
        let result = 0;
        if (this.formData.colorSizeEntries != null) {
          this.formData.colorSizeEntries.forEach(entry => {
            let num = parseInt(entry.quantity);
            if (!Number.isNaN(num)) {
              result += num;
            }
          });
        }
        return result;
      },
      //应发数（实裁总数）
      cropTotalNum: function () {
        let result = 0;
        if (this.formData.actualCutEntries != null) {
          this.formData.actualCutEntries.forEach(entry => {
            let num = parseInt(entry.quantity);
            if (!Number.isNaN(num)) {
              result += num;
            }
          });
        }
        return result;
      },
      //统计发货总数
      totalShippingNum: function () {
        let result = 0;
        if (this.formData.shippingSheets != null) {
          this.formData.shippingSheets.forEach(element => {
            let num = parseInt(element.totalQuantity);
            if (!Number.isNaN(num)) {
              result += num;
            }
          });
        }
        return result;
      },
      //统计退货总数
      totalReturnNum: function () {
        let result = 0;
        if (this.formData.shippingSheets != null) {
          this.formData.shippingSheets.forEach(element => {
            //统计对应退货单数
            if (element.returnSheets != null) {
              element.returnSheets.forEach(sheet => {
                let num = parseInt(sheet.totalQuantity);
                if (!Number.isNaN(num)) {
                  result += num;
                }
              });
            }
          });
        }
        return result;
      },
      //统计收货总数
      totalReceiptNum: function () {
        let result = 0;
        if (this.formData.shippingSheets != null) {
          this.formData.shippingSheets.forEach(element => {
            //统计对应退货单数
            if (element.receiptSheets != null) {
              element.receiptSheets.forEach(sheet => {
                let num = parseInt(sheet.totalQuantity);
                if (!Number.isNaN(num)) {
                  result += num;
                }
              });
            }
          });
        }
        return result;
      },
      //统计差异总数
      totalDiffNum: function () {
        let result = 0;
        if (this.formData.shippingSheets != null) {
          this.formData.shippingSheets.forEach(element => {
            let num = parseInt(element.diffQuantity);
            if (!Number.isNaN(num)) {
              result += num;
            }
          });
        }
        return result;
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
