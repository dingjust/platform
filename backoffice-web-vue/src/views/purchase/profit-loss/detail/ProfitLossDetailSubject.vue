<!--
* @Description: 盈亏分析详情主体
* @Date 2021/03/25 13:54
* @Author L.G.Y
-->
<template>
  <div v-if="detail.id">
    <div v-show="false">
      <div id="print-page" >
        <profit-loss-print-page :detail="detail" :taskRow="detail.entries"/>
      </div>
    </div>
    <div id="profitloss-detail">
      <el-row>
          <div class="cost-order-title">
            <h6>盈亏分析详情</h6>
          </div>
        </el-row>
      <div class="pt-2"></div>
      <profit-loss-detail-top :detail="detail"/>
      <el-radio-group class="detail-container" v-model="showWhole">
        <el-radio :label="true">统一展示</el-radio>
        <el-radio :label="false">根据工单分类</el-radio>
      </el-radio-group>
      <div v-show="!showWhole">
        <profit-loss-detail-task-table v-for="taskRow in taskRows" :key="taskRow.id" :detail="detail" :taskRow="taskRow"/>
      </div>
      <profit-loss-detail-task-table :detail="detail" :taskRow="detail.entries" :showWhole="showWhole" v-show="showWhole"/>
      <profit-loss-echarts v-if="detail.id" :detail="detail"/>
      <profit-loss-detail-remarks :detail="detail" />
    </div>
    <profit-loss-detail-btn :detail="detail" @callback="callback"/>
    <el-row type="flex" justify="center" style="margin-top: 10px">
      <printer-button v-print="'#print-page'" />
    </el-row>
  </div>
</template>

<script>
import ProfitLossDetailTop from './ProfitLossDetailTop'
import ProfitLossDetailRemarks from './ProfitLossDetailRemarks'
import ProfitLossDetailTaskTable from './ProfitLossDetailTaskTable'
import ProfitLossEcharts from './ProfitLossEcharts'
import ProfitLossDetailBtn from './ProfitLossDetailBtn.vue'
import { PrinterButton } from '@/components/index.js'
import ProfitLossPrintPage from './ProfitLossPrintPage.vue'

export default {
  name: 'ProfitLossDetailSubject',
  props: ['id', 'isFromDetail'],
  components: {
    ProfitLossDetailTop,
    ProfitLossDetailRemarks,
    ProfitLossDetailTaskTable,
    ProfitLossEcharts,
    ProfitLossDetailBtn,
    PrinterButton,
    ProfitLossPrintPage
  },
  data () {
    return {
      detail: {
        entries: []
      },
      taskRows: [],
      showWhole: true
    }
  },
  methods: {
    async getDetail () {
      const id = this.id;

      const url = this.apis().getProfitLoss(id);
      const result = await this.$http.get(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.detail = result.data;

      this.handleData(result.data.entries);
    },
    handleData (entries) {
      const ids = new Set(entries.map(item => item.productionTaskOrderId));

      ids.forEach(item => {
        this.taskRows.push(entries.filter(val => val.productionTaskOrderId === item)); 
      })
    },
    callback () {
      if (this.isFromDetail) {
        this.getDetail();
      } else {
        this.$emit('callback');
      }
    }
  },
  created () {
    this.getDetail();
  }
}
</script>

<style scoped>
  .cost-order-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .detail-container {
    margin: 0px 0px 10px 20px;
  }

  @page {
    size: auto;
  }
</style>