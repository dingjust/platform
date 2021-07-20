<!--
* @Description: 平台端首页图表模板
* @Date 2021/07/02 20:31
* @Author L.G.Y
-->
<template>
  <div class="tenant-echart">
    <div class="echart-header">
      <h6>{{chartData.name}}</h6>
      <el-date-picker
        v-model="time"
        @change="handleChange"
        value-format="yyyy/MM/dd 00:00:00"
        style="width: 270px"
        type="daterange"
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期">
      </el-date-picker>
      <el-button type="text" @click="downloadDetail">下载明细</el-button>
    </div>
    <div v-loading="chartData.loading">
      <div :id="main" :style="'width: 500px;height:300px'"></div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['chartData', 'code'],
  methods: {
    handleChange (value) {
      this.$emit('getEchartData', this.code, 0 , {
        start: value[0],
        end: value[1]
      })
    },
    downloadDetail () {
      if (this.chartData.data.length <= 0) {
        return
      }
      let echartData = this.chartData.data.map(item => item.currentDate + ': ' + (this.code == 'salesAmount' ? (item.amount + '元') : item.total))

      var urlObject = window.URL || window.webkitURL || window;
      var export_blob = new Blob([echartData.toString().replaceAll(',', '\r\n')]);
      var save_link = document.createElementNS("http://www.w3.org/1999/xhtml", "a")
      save_link.href = urlObject.createObjectURL(export_blob);
      save_link.download = this.chartData.name;

      var ev = document.createEvent("MouseEvents");
      ev.initMouseEvent("click", true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
      save_link.dispatchEvent(ev);
    },
    init() {
      let chartDom = document.getElementById(this.main);
      let myChart = echarts.init(chartDom);

      const bottom = this.chartData.data.map(item => item.currentDate)
      const values = this.chartData.data.map(item => this.code == 'salesAmount' ? item.amount : item.total)

      let option = {
        tooltip: {
          trigger: 'axis'
        },
        xAxis: {
          type: 'category',
          data: bottom
        },
        yAxis: {
          type: 'value',
          name: this.chartData.name === '销售额' ? '单位 / 千元' : '',
          axisLabel: {
            formatter: (value, index) => {
              return this.chartData.name === '销售额' ? (value / 1000) : value
            }
          }
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
      main: null,
      time: null
    }
  },
  watch: {
    'chartData.data': function (nval, oval) {
      if (nval.length > 0) {
        this.$nextTick(() => {
          this.init();
        })
      }
    }
  },
  created () {
    this.$set(this, 'main', this.code)
  }
}
</script>

<style scoped>
  .tenant-echart h6 {
    margin: 0px;
  }
  .tenant-echart >>> .el-date-editor .el-range-input {
    width: 100px;
  }
  .tenant-echart >>> .el-date-editor .el-range-separator {
    width: 18px;
  }
  .echart-header {
    padding: 0px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .download-cell {
    display: flex;
    align-items: center;
  }
</style>