<!--
* @Description: 平台端首页图表模板
* @Date 2021/07/02 20:31
* @Author L.G.Y
* 
* unit 枚举 0 = 日，1 = 年，2 = 月， （3 = 周不作为后端接口参数，为前端自行处理
-->
<template>
  <div class="tenant-echart">
    <div class="echart-header">
      <h6>{{chartData.name}}</h6>
      <el-select v-model="unit" placeholder="请选择" style="width: 60px" @change="handleType">
        <el-option label="日" :value="0" :key="0"/>
        <!-- <el-option label="年" :value="1" :key="1"/> -->
        <el-option label="周" :value="3" :key="3"/>
        <el-option label="月" :value="2" :key="2"/>
      </el-select>
      <el-date-picker
        v-model="chartData.time"
        @change="handleChange"
        value-format="yyyy/MM/dd 00:00:00"
        style="width: 270px"
        :type="unit === 2 ? 'monthrange' : 'daterange'"
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
      const start = new Date(this.chartData.time[0])
      const end = new Date(this.chartData.time[1])
      // 月->日
      if (this.oldUnit === 2 && value !== 2) {
        let startT = this.handleTime(new Date(`${start.getFullYear()}-${start.getMonth() + 1}-01`));

        const endDate = new Date(`${end.getFullYear()}-${end.getMonth() + 1}-01`);
        let endT = this.handleTime(endDate.setMonth(endDate.getMonth() + 1) - 24*60*60*1000)

        this.$set(this.chartData, 'time', [startT, endT])
      }
    
      this.oldUnit = this.unit
      this.handleChange(this.chartData.time)
    },
    handleChange (value) {
      let params = {
        start: value[0]
      }
      let endDate = new Date(value[1])
      if (this.unit == 2) {
        const endT = new Date(`${endDate.getFullYear()}-${endDate.getMonth() + 1}-01`);
        params['end'] = this.handleTime(endT.setMonth(endT.getMonth() + 1))
      } else {
        params['end'] = this.handleTime(endDate.setDate(endDate.getDate() + 1))
      }

      this.$emit('getEchartData', this.code, this.unit, params)
    },
    handleTime (time) {
      return formatDate(new Date(time), 'yyyy/MM/dd 00:00:00');
    },
    downloadDetail () {
      if (this.chartData.data.length <= 0) {
        return
      }
      let str = ''
      this.chartData.data.forEach(item => {
        str = str + item.currentDate + ':' + (this.code == 'salesAmount' ? (item.amount + '元') : item.total) + '\r\n'
      })
      // let echartData = this.chartData.data.map(item => item.currentDate + ': ' + (this.code == 'salesAmount' ? (item.amount + '元') : item.total))

      var urlObject = window.URL || window.webkitURL || window;
      // var export_blob = new Blob([echartData.toString().replaceAll(',', '\r\n')]);
      var export_blob = new Blob([str]);
      var save_link = document.createElementNS("http://www.w3.org/1999/xhtml", "a")
      save_link.href = urlObject.createObjectURL(export_blob);
      save_link.download = this.chartData.name + '.txt';

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
          name: this.chartData.name === '销售额' ? '单位 / 万元' : '',
          axisLabel: {
            formatter: (value, index) => {
              return this.chartData.name === '销售额' ? (value / 10000) : value
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
      unit: 0,
      oldUnit: 0,
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() > Date.now();
        },
        shortcuts: [
          {
            text: '最近一周',
            onClick(picker) {
              const start = new Date()
              const end = new Date()
              
              start.setDate(start.getDate() - start.getDay())
              end.setDate(end.getDate() + (7 - end.getDay() - 1))

              picker.$emit('pick', [start, end]);
            }
          }, 
          {
            text: '最近一个月',
            onClick(picker) {
              const start = new Date();
              const end = new Date();

              start.setDate(1);

              end.setDate(1)
              const targetEnd = new Date(end.setMonth(end.getMonth() + 1) - 24*60*60*1000)
              
              picker.$emit('pick', [start, targetEnd]);
            }
          }, 
          {
            text: '最近三个月',
            onClick(picker) {
              const start = new Date();
              const end = new Date();

              start.setDate(1);
              const targetStart = new Date(start.setMonth(start.getMonth() - 2))

              end.setDate(1)
              const targetEnd = new Date(end.setMonth(end.getMonth() + 1) - 24*60*60*1000)
              console.log(targetStart, targetEnd)
              picker.$emit('pick', [targetStart, targetEnd]);
            }
          }
        ]
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