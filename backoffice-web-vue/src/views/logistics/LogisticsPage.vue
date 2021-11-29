<!--
* @Description: 物流管理
* @Date 2021/11/25 14:01
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>物流单号管理</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <logistics-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" @onImport="onImport" />
      <logistics-list :page="page" @onAdvancedSearch="onAdvancedSearch" />
    </el-card>
  </div>
</template>

<script>
import {
  createNamespacedHelpers
} from 'vuex';

const {
  mapGetters,
  mapActions
} = createNamespacedHelpers(
  'LogisticsModule'
);

import LogisticsToolbar from './toolbar/LogisticsToolbar'
import LogisticsList from './list/LogisticsList'

import { formatDate } from '@/common/js/filters';
import { exportTable } from '@/common/js/export'

export default {
  name: 'LogisticsPage',
  components: { LogisticsToolbar, LogisticsList },
  computed: {
    ...mapGetters({
      page: 'page',
      queryFormData: 'queryFormData'
    })
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch (page, size) {
      const query = this.queryFormData;

      const url = this.apis().searchLogistics();
      this.searchAdvanced({url, query, page, size});
    },
    async onImport () {
      const totalElements = this.page.totalElements

      const exportData = await this.getExportData(totalElements)
      exportTable(exportData, '物流信息')
    },
    async getExportData (totalElements) {
      const query = this.queryFormData;

      const url = this.apis().searchLogistics();
      const result = await this.$http.post(url, query, {
        page: 0,
        size: totalElements
      })

      let exportData = []
      exportData = result.content.map(e => {
        return {
          快递编号: e.code,
          换货编号: e.relationCode,
          快递类型: this.getEnum('ExpressType', e.type),
          款号: e.skuID,
          产品名称: e.productName,
          颜色: e.colors.join(', '),
          尺码: e.sizes.join(', '),
          质量问题: e.defected ? '有' : '无',
          备注: e.remarks,
          创建时间: formatDate(new Date(e.creationtime), 'yyyy-MM-dd hh:mm')
        }
      })

      return exportData
    }
  },
  data () {
    return {

    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style>

</style>