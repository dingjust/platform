<!--
* @Description: 报价单合计部分
* @Date 2021/03/30 16:01
* @Author L.G.Y
-->
<template>
  <div>
    <el-row type="flex" justify="start" style="margin: 10px 0px">
      <h6>成本总额：{{totalCost}}</h6>
    </el-row>
    <el-form ref="form" :inline="true" :model="formData" label-position="left" label-width="85px">
      <div class="profit-container">
        <el-form-item label="利润率：" prop="profitRate" >
          <el-input v-model="formData.profitRate" 
                    v-number-input.float="{ min: 0, max: 100, decimal:2 }" 
                    @blur="onBlur(formData, 'profitRate')">
            <span slot="suffix">%</span>
          </el-input>
        </el-form-item>
        <h6 style="margin-top: 8px;">{{totalProfit.toFixed(2)}}</h6>
      </div>
      <div class="profit-container">
        <el-form-item label="档口报价：" prop="stallQuote" >
          <el-input v-model="formData.stallQuote" 
                    v-number-input.float="{ min: 0, decimal:2 }" 
                    @blur="onBlur(formData, 'stallQuote')"/>
        </el-form-item>
      </div>
      <div class="profit-container">
        <el-form-item label="公司核价：" prop="companyPricing" 
            :rules="[{ validator: checkCompanyPricing, tigger: 'blur'}]">
          <el-input v-model="formData.companyPricing" 
                    v-number-input.float="{ min: 0, decimal:2 }" 
                    @blur="onBlur(formData, 'companyPricing')"/>
        </el-form-item>
      </div>
    </el-form>
    <el-row>
      <h6 class="row-title">其他备注：</h6>
    </el-row>
    <el-row>
      <el-input type="textarea" :rows="3" placeholder="请输入内容" v-model="formData.remarks" />
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'QuoteOrderTotalPart',
  props: ['formData'],
  computed: {
    totalCost: function () {
      let totalCost = 0;
      this.formData.costOrder.workOrders.forEach(item => {
        if (!Number.isNaN(Number.parseFloat(item.totalPrice))) {
          totalCost += Number.parseFloat(item.totalPrice);
        }
      })

      this.formData.costOrder.customRows.forEach(item => {
        if (!Number.isNaN(Number.parseFloat(item.price))) {
          totalCost += Number.parseFloat(item.price);
        }
      })

      return totalCost.toFixed(4);
    },
    totalProfit: function () {
      let profitRate = Number.isNaN(Number.parseFloat(this.formData.profitRate)) ? 
                        0 : Number.parseFloat(this.formData.profitRate);
      return this.totalCost * (1 + profitRate / 100);
    }
  },
  methods: {
    checkCompanyPricing (rule, value, callback) {
      if (!value || value == '') {
        callback(new Error('请填写'));
      } else {
        callback();
      }
    },
    onBlur(row, attribute) {
      var reg = /\.$/;
      if (reg.test(row[attribute])) {
        this.$set(row, attribute, parseFloat(row[attribute] + '0'));
      }
    }
  }
}
</script>

<style scoped>
  /deep/ .el-input__suffix {
    display: flex;
    align-items: center;
  }

  .profit-container {
    display: flex;
    justify-content: flex-start;
    align-items: flex-start;
  }

  .purchase-form {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: center;
  }

  .row-title {
    font-size: 14px;
    color: #606266;
  }
</style>