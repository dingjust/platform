<template>
  <div class="echart-cell">
    <template v-for="(value, key) in echartArr">
      <tenant-echart :key="key" :code="key" :chartData="value" @getEchartData="getEchartData" @handleTime="handleTime"/>
    </template>
  </div>
</template>

<script>
import { formatDate } from '@/common/js/filters';
import TenantEchart from './TenantEchart'

export default {
  name: 'TenantEchartTab',
  components: { TenantEchart },
  methods: {
    handleTime (time) {
      return formatDate(new Date(time), 'yyyy/MM/dd hh:mm:ss');
    },
    init() {
      const date = new Date();

      const end = new Date(`${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`).getTime() + 24*60*60*1000;
      const start = end - 7*24*60*60*1000

      for (const key in this.echartArr) {
        if (Object.hasOwnProperty.call(this.echartArr, key)) {
          this.getEchartData(key, 0, {
            start: this.handleTime(start), 
            end: this.handleTime(end)
          })
        }
      }
    },
    async getEchartData (type, unit, params) {
      this.echartArr[type].loading = true
      
      let week = false

      // 查询 周为单位时，需处理查询时间，保证start,end分别为 周日， 周六
      if (unit === 3) {
        let start = new Date(params.start)
        let end = new Date(params.end)

        start.setDate(start.getDate() - start.getDay())
        // 组件上处理end时间加了1天，所以这里判断是否为 0，不判断是否为 6
        end.getDay() === 0 || end.setDate(end.getDate() + (7 - end.getDay()))

        params.start = this.handleTime(start)
        params.end = this.handleTime(end)

        unit = 0
        week = true
      }

      const url = this.apis().getEchartData(type, unit);
      const result = await this.$http.post(url, {}, params, true)

      if (result.code === 1) {
        this.echartArr[type].loading = false
        this.echartArr[type].data = this.handleResult(result.data, type, week, params)

        this.echartArr[type].time = [params.start, this.handleTime(new Date(params.end).getTime() - 24*60*60*1000)]
      }
    },
    handleResult (data, type, week) {
      let result = []
      
      if (week) {
        this.handleWeek(data, type, 0, result)
      } else {
        result = data
      }

      return result
    },
    handleWeek (data, type, index, result) {
      let item = {
        currentDate: data[index].currentDate,
        total: 0,
        amount: 0
      }
      
      data.slice(index, index += 7).forEach(val => {
        if (type === 'salesAmount') {
          item.amount += val.amount
        } else {
          item.total += val.total
        }
      })

      result.push(item)

      if (index < data.length) {
        this.handleWeek(data, type, index, result)
      }
    }
  },
  data () {
    return {
      echartArr: {
        agreement: {
          name: '签约数',
          loading: false,
          data: [],
          time: []
        },
        quote: {
          name: '报价数',
          loading: false,
          data: [],
          time: []
        },
        requirement: {
          name: '需求数',
          loading: false,
          data: [],
          time: []
        },
        sales: {
          name: '销售订单',
          loading: false,
          data: [],
          time: []
        },
        salesAmount: {
          name: '销售额',
          loading: false,
          data: [],
          time: []
        },
        salesQuantity: {
          name: '生产量',
          loading: false,
          data: [],
          time: []
        },
        register: {
          name: '注册用户数',
          loading: false,
          data: [],
          time: []
        }
      }
    }
  },
  created () {
    this.init();
  }
}
</script>

<style scoped>
  .echart-cell {
    display: flex;
    flex-wrap: wrap;
  }
</style>