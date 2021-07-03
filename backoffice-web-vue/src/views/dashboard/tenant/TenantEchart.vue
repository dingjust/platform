<!--
* @Description: 平台端首页图表模板
* @Date 2021/07/02 20:31
* @Author L.G.Y
-->
<template>
  <div>
    <div :id="main" :style="'width: 500px;height:300px'"></div>
  </div>
</template>

<script>
export default {
  props: ['chartData', 'title'],
  methods: {
    init() {
      let chartDom = document.getElementById(this.main);
      let myChart = echarts.init(chartDom);

      const bottom = this.chartData.data.map(item => {
        var date =  new Date(item.time)
        return (date.getMonth() + 1) + '-' + date.getDate()
      })
      const values = this.chartData.data.map(item => item.value)

      let option = {
        title: {
          show: true,
          text: this.title
        },
        xAxis: {
            type: 'category',
            data: bottom
        },
        yAxis: {
            type: 'value'
        },
        series: [{
            data: values,
            type: 'line'
        }]
      };
      option && myChart.setOption(option);
    }
  },
  data () {
    return {
      main: null
    }
  },
  mounted () {
    this.$nextTick(()=>{
      this.init()
    })
  },
  created () {
    this.$set(this, 'main', this.chartData.name)
  }
}
</script>

<style>

</style>