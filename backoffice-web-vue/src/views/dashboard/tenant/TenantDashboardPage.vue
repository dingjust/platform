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
        <h6 style="margin-top: 20px">线上订单</h6>
        <el-row type="flex" style="margin-top:20px">
          <el-col :span="12">
            <orders-chart />
          </el-col>
          <el-col :span="12">
            <revenue-chart />
          </el-col>
        </el-row>
      </el-tab-pane>
      <el-tab-pane label="数据看板" lazy>
        <tenant-echart-tab />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import TenantEchartTab from './components/TenantEchartTab.vue';
  import OrdersChart from './OrdersChart.vue';
  import RevenueChart from './RevenueChart.vue';

  export default {
    name: 'TenantDashboardPage',
    components: {
      TenantEchartTab,
      OrdersChart,
      RevenueChart
    },
    methods: {
      showLastStyle(tab1, key, index) {
        return (Object.getOwnPropertyNames(tab1).length - 2) === index
      },
      async init() {
        const date = new Date();
        // 获取当天0点时间戳
        const thisDay = new Date(`${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`).getTime();
        const result = await this.getTab1({
          start: thisDay,
          end: thisDay + 24 * 60 * 60 * 1000
        })
        this.$set(this, 'tab1', result.data)

        this.$set(this, 'tab2', await this.getTab2())
      },
      async getTab1(section) {
        const url1 = this.apis().getTenantReportsTab1()
        const tab1 = await this.$http.post(url1, {}, section)

        return {
          section: section,
          data: tab1
        };
      },
      async getTab2() {
        const url2 = this.apis().getTenantReportsTab2()
        const tab2 = await this.$http.post(url2)

        return tab2;
      }
    },
    data() {
      return {
        tab1: {},
        tab2: {},
        reportsTitle: {
          noAgreementOrder: '做单未签约',
          noQuoteRequirementOrder: '需求未报价',
          notAcceptRequirementOrder: '报价未确认',
          agreementTotal: '今日签约数',
          quoteTotal: '今日报价数',
          requirementTotal: '今日需求数',
          salesOrderTotal: '今日订单数',
          orderAmount: '今日成交额',
          registerTotal: '今日注册数'
        }
      }
    },
    created() {
      this.init();
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
    border: none !important;
    ;
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
    /* border-bottom: 1px solid #DCDFE6; */
  }

  .chart-cell {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-around;
  }

</style>
