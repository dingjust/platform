<template>
  <div class="echart-cell">
    <template v-for="(value, key) in echartArr">
      <tenant-echart :key="key" :code="key" :chartData="value" :defaultTime="defaultTime" @getEchartData="getEchartData" @handleTime="handleTime"/>
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

      this.$set(this, 'defaultTime', {
        start: this.handleTime(start), 
        end: this.handleTime(end)
      })

      for (const key in this.echartArr) {
        if (Object.hasOwnProperty.call(this.echartArr, key)) {
          const element = this.echartArr[key];
          this.getEchartData(key, 0, {
            start: this.handleTime(start), 
            end: this.handleTime(end)
          })
        }
      }
    },
    async getEchartData (type, unit, params) {
      this.echartArr[type].loading = true 
      const url = this.apis().getEchartData(type, unit);
      const result = await this.$http.post(url, {}, params, true)

      if (result.code === 1) {
        this.echartArr[type].loading = false
        this.echartArr[type].data = result.data
      }
    },
  },
  data () {
    return {
      defaultTime: null,
      echartArr: {
        agreement: {
          name: '签约数',
          loading: false,
          data: []
        },
        quote: {
          name: '报价数',
          loading: false,
          data: []
        },
        requirement: {
          name: '需求数',
          loading: false,
          data: []
        },
        sales: {
          name: '销售订单',
          loading: false,
          data: []
        },
        salesAmount: {
          name: '销售额',
          loading: false,
          data: []
        },
        salesQuantity: {
          name: '生产量',
          loading: false,
          data: []
        },
        register: {
          name: '注册用户数',
          loading: false,
          data: []
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