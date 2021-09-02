<!--
* @Description: 平台端首页图表模板
* @Date 2021/07/02 20:31
* @Author L.G.Y
-->
<template>
  <div class="tenant-echart">
    <div class="echart-header">
      <h6>{{chartData.name}}</h6>
      <el-select v-model="unit" placeholder="请选择" style="width: 60px" @change="handleType">
        <el-option label="日" :value="0" :key="0"/>
        <el-option label="月" :value="2" :key="2"/>
      </el-select>
      <el-date-picker
        v-model="time"
        @change="handleChange"
        value-format="yyyy/MM/dd 00:00:00"
        style="width: 270px"
        :type="unit === 0 ? 'daterange' : 'monthrange'"
        unlink-panels
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        :picker-options="pickerOptions">
      </el-date-picker>
      <el-button type="text" @click="downloadDetail">下载明细</el-button>
    </div>
    <div v-loading="chartData.loading">
      <div :id="main" :style="'width: 500px;height:300px'"></div>
    </div>
  </div>
</template>

<script>
import { formatDate } from '@/common/js/filters';

export default {
  props: ['chartData', 'code', 'defaultTime'],
  methods: {
    handleType (value) {
      if (value === 2 && (new Date(this.time[0]).getMonth() === new Date(this.time[1]).getMonth())) {

        let params = {
          start: this.time[0]
        }
        let endDate = new Date(this.time[1])
        params['end'] = this.handleTime(endDate.setMonth(endDate.getMonth()))
  
        this.$emit('getEchartData', this.code, this.unit, params)
      } else {
        this.handleChange(this.time)
      }
    },
    handleChange (value) {
      let params = {
        start: value[0]
      }
      let endDate = new Date(value[1])
      if (this.unit == 2) {
        params['end'] = this.handleTime(endDate.setMonth(endDate.getMonth() + 1))
      } else {
        params['end'] = this.handleTime(endDate.setDate(endDate.getDate() + 1))
      }

      this.$emit('getEchartData', this.code, this.unit, params)
    },
    handleTime (time) {
      return formatDate(new Date(time), 'yyyy/MM/dd hh:mm:ss');
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
      time: [],
      unit: 0,
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() > Date.now();
        }
      },
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

    let endDate = new Date(this.defaultTime.end)

    this.time[0] = this.defaultTime.start
    this.time[1] = this.handleTime(endDate.setDate(endDate.getDate() - 1))
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