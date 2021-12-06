<template>
  <div id="revenueChart" style="width: 100%;height:400px;"></div>
</template>

<script>
  import {
    formatDate
  } from '@/common/js/filters';

  import {
    accAdd,
  } from '@/common/js/number';

  export default {
    name: "RevenueChart",
    methods: {
      initChart() {
        let that = this;
        const myChart = echarts.init(document.getElementById("revenueChart"));

        const option = {
          tooltip: {
            trigger: 'axis',
            axisPointer: {
              type: 'cross',
              crossStyle: {
                color: '#999'
              }
            }
          },
          xAxis: {
            type: 'category',
            data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
          },
          yAxis: {
            type: 'value',
            name: '线上金额',
          },
          series: [{
            data: [],
            type: 'line'
          }]
        };

        myChart.setOption(option);
        this.chart = myChart;
        this.updateChart(myChart);

        window.addEventListener("resize", function () {
          that.$nextTick(() => {
            myChart.resize();
          });
        });
      },
      //处理数据
      async updateChart(chart) {
        chart.showLoading();
        let orders = await this.getOrders();
        var dataMap = {};

        orders.forEach(order => {
          let date = formatDate(new Date(order.paySuccessTime), 'yyyy-MM-dd');
          this.testMap[date]
          if (dataMap[date]) {
            dataMap[date] = accAdd(dataMap[date], order.totalAmount);
          } else {
            dataMap[date] = order.totalAmount;
          }
        });

        let category = [];
        let iDate = this.startDate;
        while (iDate < this.endDate) {
          category.push(formatDate(new Date(iDate), 'yyyy-MM-dd'));
          iDate += 24 * 60 * 60 * 1000;
        }

        chart.setOption({
          series: [{
            name: '线上金额',
            type: 'line',
            data: category.map(e => dataMap[e] != null ? dataMap[e] : 0)
          }, ],
          xAxis: [{
            type: 'category',
            data: category,
            axisPointer: {
              type: 'shadow'
            },
          }],

        });

        chart.hideLoading();

      },
      async getOrders() {
        const url = this.apis().searchPaymentOrder();
        const result = await this.$http.post(url, {
          creationtimeFrom: formatDate(new Date(this.startDate), 'yyyy-MM-dd'),
          creationtimeTo: formatDate(new Date(this.endDate), 'yyyy-MM-dd'),
          state: 'PAID'
        }, {
          size: 999
        });
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.data = result.content
        return this.data;
      },
    },
    data() {
      return {
        loading: false,
        chart: null,
        data: null,
        startDate: null,
        endDate: null,
        testMap:{}
      };
    },
    watch: {},
    created() {
      //时间设为最近一周
      const date = new Date();
      // 获取当天0点时间戳
      const now = new Date(`${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`).getTime();
      this.startDate = now - 6 * 24 * 60 * 60 * 1000;
      this.endDate = now + 24 * 60 * 60 * 1000;
    },
    mounted() {
      this.$nextTick(() => {
        this.initChart();
      });
    },
  };

</script>

<style scoped>
  #revenueChart {
    height: 400px;
    width: 100%;
  }

</style>
