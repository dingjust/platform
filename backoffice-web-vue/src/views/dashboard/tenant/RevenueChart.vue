<template>
  <div id="revenueChart" style="width: 100%;height:400px;"></div>
</template>

<script>
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
            type: 'value'
          },
          series: [{
            data: [150, 230, 224, 218, 135, 147, 260],
            type: 'line'
          }]
        };

        myChart.setOption(option);
        this.chart = myChart;
        window.addEventListener("resize", function () {
          that.$nextTick(() => {
            myChart.resize();
          });
        });
      },

    },
    data() {
      return {
        loading: false,
        chart: null
      };
    },
    watch: {},
    created() {

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
