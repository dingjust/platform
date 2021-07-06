<template>
  <div class="animated fadeIn">
    <el-tabs type="border-card">
      <el-tab-pane label="业务数据">
        <el-row class="table-row">
          <template v-for="(value,key,index) in tab1">
            <el-col :span="4" :title="reportsTitle[key]" :key="index">
              <div class="table-cell" :class="showLastStyle(tab1, key, index) ? 'table-cell_last' : ''">
                <h6 class="table-cell_title">{{reportsTitle[key]}}</h6>
                <h6 class="table-cell_value">{{value}}</h6>
              </div>
            </el-col>
          </template>
        </el-row>
        <div class="pt-3"></div>
        <h6 style="margin: 0px">生产流程预警</h6>
        <div class="pt-3"></div>
        <el-row class="table-row">
          <template v-for="(value,key,index) in tab2">
            <el-col :span="4" :title="reportsTitle[key]" :key="index">
              <div class="table-cell-center" :class="index > 5 ? 'table-cell_last' : ''">
                <h6 class="table-cell_value">{{value}}</h6>
                <h6 class="table-cell_title">{{reportsTitle[key]}}</h6>
              </div>
            </el-col>
          </template>
        </el-row>
      </el-tab-pane>
      <el-tab-pane label="数据看板">
        <template v-if="chartData">
          <div class="chart-cell">
            <template v-for="(item, index) in chartData">
              <tenant-echart :chartData="item" :key="index" :title="chartTitle[item.name]" style="margin-right:10px;margin-bottom: 10px"/>
            </template>
          </div>
        </template>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import TenantEchart from './TenantEchart.vue';
export default {
  components: { TenantEchart },
  name: 'TenantDashboardPage',
  methods: {
    showLastStyle (tab1, key, index) {
      return (Object.getOwnPropertyNames(tab1).length - 2) === index
    },
    async init () {
      const date = new Date();
      // 获取当天0点时间戳
      const thisDay = new Date(`${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`).getTime();
      const result = await this.getTab1({
        start: thisDay,
        end: thisDay + 24*60*60*1000
      })
      this.$set(this, 'tab1', result.data)

      this.$set(this, 'tab2', await this.getTab2())
    },
    async getTab1 (section) {
      const url1 = this.apis().getTenantReportsTab1()
      const tab1 = await this.$http.post(url1, {}, section)

      return {
        section: section,
        data: tab1
      };
    },
    async getTab2 () {
      const url2 = this.apis().getTenantReportsTab2()
      const tab2 = await this.$http.post(url2)

      return tab2;
    },
    getChartData () {
      const date = new Date();
      // 获取当天0点时间戳
      const thisDay = new Date(`${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`).getTime();
      // 获取前7天（包括今天）的 start，end对象
      let arr = [{
        number: 0,
        start: thisDay,
        end: thisDay + 24*60*60*1000
      }]
      for (let index = 1; index < 7; index++) {
        arr.push({
          number: index,
          start: arr[index - 1].start - 24*60*60*1000,
          end: arr[index - 1].start
        })
      }
      Promise.all(arr.map(this.getTab1)).then(res => {
        let chartData = [];
        res.sort((o1, o2) => o2.section.number - o1.section.number)
        res.forEach(item => {
          for (const key in item.data) {
            if (Object.hasOwnProperty.call(item.data, key)) {
              const element = item.data[key];
              var index = chartData.findIndex(v => v.name === key);
              if (index > -1) {
                chartData[index].data.push({
                  time: item.section.start,
                  value: element
                })
              } else {
                chartData.push({
                  name: key,
                  data: [{
                    time: item.section.start,
                    value: element
                  }]
                })
              }
            }
          }
        })
        this.$set(this, 'chartData', chartData)
      })
    } 
  },
  data () {
    return {
      tab1: {},
      tab2: {},
      reportsTitle: {
        noAgreementOrder: '做单未签约',
        noQuoteRequirementOrder: '需求未报价',
        notAcceptRequirementOrder: '报价未确认',
        agreementTotal: '今日签约数',
        orderAmount: '今日成交额',
        quoteTotal: '今日报价数',
        registerTotal: '今日注册数',
        requirementTotal: '今日需求数',
        salesOrderTotal: '今日订单数'
      },
      chartTitle: {
        agreementTotal: '签约数',
        orderAmount: '成交额',
        quoteTotal: '报价数',
        registerTotal: '注册数',
        requirementTotal: '需求数',
        salesOrderTotal: '订单数'
      },
      chartData: null
    }
  },
  created () {
    this.init();
    this.getChartData();
  }
}
</script>

<style scoped>
  .table-row {
    border: 1px solid #DCDFE6;
    padding: 4px;
  }

  .table-cell {
    min-height: 90px;
    max-height: 90px;
    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
    align-items: center;
    border-right: 1px solid #DCDFE6;
  }
  .table-cell_last {
    border: none !important;;
  }

  .table-cell_title {
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    width: 100%;
    text-align: center;
    margin: 0;
  }

  .table-cell_value {
    color: #409EFF;
    margin: 0;
  }

  .table-cell-center {
    min-height: 90px;
    max-height: 90px;
    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
    align-items: center;
    border-bottom: 1px solid #DCDFE6;
  }

  .chart-cell {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-around;
  }
</style>