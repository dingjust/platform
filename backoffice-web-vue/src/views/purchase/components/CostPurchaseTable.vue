<!--
* @Description: 成本单采购报价 tab模块
* @Date 2021/04/06 17:14
* @Author L.G.Y
-->
<template>
  <div>
    <div class="over-tabs" v-if="!readOnly">
      <el-row type="flex">
        <el-button class="material-btn" @click="appendMateriel">添加物料</el-button>
      </el-row>
    </div>
    <el-tabs type="border-card">
      <el-tab-pane label="采购明细">
        <cost-purchase-info :formData="formData" :readOnly="readOnly"
                           @onModify="onModify" @onDelete="onDelete"/>
      </el-tab-pane>
      <el-tab-pane label="报价单" v-if="isFromCost && formData.id">
        <cost-quote-info :formData="formData" /> 
      </el-tab-pane>
    </el-tabs>
    <el-dialog :visible.sync="appendVisible" width="80%" append-to-body :close-on-click-modal="false">
      <material-append-table v-if="appendVisible" :formData="formData" 
                            @onSelect="onSelect" :entries="entries" :singleton="true"/>
    </el-dialog>
  </div>
</template>

<script>
import MaterialAppendTable from '@/views/purchase/requirement/components/MaterialAppendTable'
import CostPurchaseInfo from './CostPurchaseInfo';
import CostQuoteInfo from './CostQuoteInfo';

export default {
  name: 'CostPurchaseTable',
  props: {
    formData: {
      required: true
    },
    readOnly: {
      type: Boolean,
      default: false
    },
    isFromCost: {
      type: Boolean,
      detault: false
    }
  },
  components: {
    MaterialAppendTable,
    CostPurchaseInfo,
    CostQuoteInfo
  },
  methods: {
    appendMateriel () {
      this.isModify = false;
      this.appendVisible = true;
      this.resetItem();
    },
    onSelect (entries) {
      this.appendVisible = false;
      if (this.isModify) {
        this.formData.workOrders = entries;
        this.isModify = false;
      } else {
        this.formData.workOrders = this.arrangeData(this.formData.workOrders.concat(entries));
      }

      this.formData.workOrders.forEach(item => item.factoryName = item.cooperatorName);

      this.resetItem();
    },
    resetItem () {
      this.entries = {
        workOrders: [
          {
            name: '',
            code: '',
            unit: '',
            materialsType: '',
            unitQuantity: '',
            specName: '',
            colorName: '',
            modelName: '',
            emptySent: '',
            requiredAmount: '',
            estimatedLoss: '',
            estimatedUsage: '',
            orderCount: 1,
            auditColor: '',
            estimatedRecTime: '',
            cooperatorName: '',
            price: '',
            totalPrice: '',
            composition: '',
            purpose: '',
            quoteLossRate: '',
            quoteAmount: '',
            remarks: ''
          }
        ]
      }
    },
    arrangeData (materials) {
      let result = [];
      let stark = [];

      stark = stark.concat(materials);

      while (stark.length) {
        let temp = stark.shift();
        result.push(temp);
        result = result.concat(stark.filter(item => item.code === temp.code));
        stark = stark.filter(item => item.code !== temp.code);
      }
      return result;
    },
    onModify (row, index) {
      this.entries.workOrders = JSON.parse(JSON.stringify(this.formData.workOrders));
      this.entries.workOrders.forEach(item => {
        item.quoteLossRate = item.quoteLossRate * 100;
        item.estimatedLoss = item.estimatedLoss * 100;
        item.emptySent = item.emptySent * 100;
      })
      this.appendVisible = true;
      this.isModify = true;
    },
    onDelete (row, index) {
      this.formData.workOrders.splice(index, 1);
    }
  },
  data () {
    return {
      appendVisible: false,
      isModify: false,
      title: '需求数量 = 预计用量 * 订单数 / 空差',
      entries: {
        workOrders: [
          {
            name: '',
            code: '',
            unit: '',
            materialsType: '',
            unitQuantity: '',
            specName: '',
            colorName: '',
            modelName: '',
            emptySent: '',
            requiredAmount: '',
            estimatedLoss: '',
            estimatedUsage: '',
            orderCount: 1,
            auditColor: '',
            estimatedRecTime: '',
            cooperatorName: '',
            price: '',
            totalPrice: '',
            composition: '',
            purpose: '',
            quoteLossRate: '',
            quoteAmount: '',
            remarks: ''
          }
        ]
      }
    }
  }  
}
</script>

<style scoped>
  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 50px;
    margin-top: 2px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  /deep/ .el-dialog__header {
    padding: 0px;
  }
</style>
