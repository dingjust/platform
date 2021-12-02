<template>
  <div id="ordersChart" style="width: 100%;height:400px;"></div>
</template>

<script>
  import {
    formatDate
  } from '@/common/js/filters';

  export default {
    name: "OrdersChart",
    methods: {
      initChart() {
        let that = this;
        const myChart = echarts.init(document.getElementById("ordersChart"));

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
          toolbox: {
            feature: {
              dataView: {
                show: true,
                readOnly: false
              },
              magicType: {
                show: true,
                type: ['line', 'bar']
              },
              restore: {
                show: true
              },
              saveAsImage: {
                show: true
              }
            }
          },
          legend: {
            data: ['生产数量', '订单金额']
          },
          xAxis: [{
            type: 'category',
            data: [],
            axisPointer: {
              type: 'shadow'
            },
          }],
          yAxis: [{
              type: 'value',
              name: '生产数量',
              min: 0,
              axisLabel: {
                formatter: '{value} 件'
              }
            },
            {
              type: 'value',
              name: '订单金额',
              min: 0,
              axisLabel: {
                formatter: '{value} '
              }
            }
          ],
          series: [{
              name: '生产数量',
              type: 'bar',
              color: [
                '#aed581',
              ]
            },
            {
              name: '订单金额',
              type: 'line',
              yAxisIndex: 1,
            }
          ]
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
          let date = formatDate(new Date(order.creationtime), 'yyyy-MM-dd');
          if (dataMap[date]) {
            let {
              num,
              amount
            } = dataMap[date];
            dataMap[date] = {
              'num': num += order.totalQuantity,
              'amount': amount += order.totalAmount

            };
          } else {
            dataMap[date] = {
              'num': order.totalQuantity,
              'amount': order.totalAmount
            }
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
              name: '生产数量',
              type: 'bar',
              data: category.map(e => {
                if (dataMap[e]) {
                  return dataMap[e].num;
                } else {
                  return 0;
                }
              })
            },
            {
              name: '订单金额',
              type: 'line',
              yAxisIndex: 1,
              data: category.map(e => {
                if (dataMap[e]) {
                  return dataMap[e].amount;
                } else {
                  return 0;
                }
              })
            }
          ],
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

        const url = this.apis().searchPendOut();
        const result = await this.$http.post(url, {
          createdDateFrom: this.startDate,
          createdDateTo: this.endDate
        }, {
          size: 999
        });
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        //线上支付订单
        this.data = result.content.filter(e => e.payOnline);
        return this.data;
      },
    },
    data() {
      return {
        loading: false,
        chart: null,
        data: null,
        startDate: null,
        endDate: null
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
  #ordersChart {
    height: 400px;
    width: 100%;
  }

</style>
