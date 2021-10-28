<!--
* @Description: 库存管理
* @Date 2021/09/24 11:43
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>库存管理</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <inventory-toolbar @onAdvancedSearch="onAdvancedSearch" @onImport="onImport"/>
      <inventory-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
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
  'InventoryModule'
);

import InventoryList from './list/InventoryList'
import InventoryToolbar from './toolbar/InventoryToolbar'

import { exportTable } from '@/common/js/export'
import { formatDate } from '@/common/js/filters';

export default {
  name: 'InventoryPage',
  components: { InventoryList, InventoryToolbar },
  computed: {
    ...mapGetters({
      page: 'page'
    })
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch (page, size) {
      const query = {};

      const url = this.apis().searchInventory();
      this.searchAdvanced({url, query, page, size});
    },
    async onImport () {
      const totalElements = this.page.totalElements

      const exportData = await this.getExportData(totalElements)

      exportTable(exportData, '库存数据/' + formatDate(new Date(), 'yyyy-MM-dd hh:mm:ss'))
    },
    async getExportData (totalElements) {
      const url = this.apis().searchInventory(); 
      const result = await this.$http.post(url, {}, {
        page: 0,
        size: totalElements
      })

      return this.handleData(result.content)
    },
    handleData (content) {
      let arr = []

      content.forEach(inventory => {
        let item = Object.assign(Object.assign({}, this.defaultData), {
          品牌: inventory.brand,
          产品名称: inventory.name,
          款号: inventory.skuID,
          成本价: inventory.costPrice,
          吊牌价: inventory.tagPrice,
          出库价: inventory.checkoutPrice
        })
        
        inventory.variants.forEach(variant => {
          if (!variant.color || !variant.size) return

          let index = arr.findIndex(val => val['颜色'] === variant.color.name && val['款号'] === inventory.skuID && val['是否次品'] === '否')

          if (index < 0) {
            arr.push(Object.assign(Object.assign({}, item), {'颜色': variant.color.name}))
            index = arr.length - 1
          }

          let quality = (variant.quality ? variant.quality : 0) + (variant.tailQuality ? variant.tailQuality : 0)

          arr[index][variant.size.name] = quality
          arr[index]['合计'] += quality

          if (variant.defectiveQuality) {
            let defectiveIndex = arr.findIndex(val => val['颜色'] === variant.color.name && val['款号'] === inventory.skuID && val['是否次品'] === '是')

            if (defectiveIndex < 0) {
              arr.push(Object.assign(Object.assign({}, item), {'颜色': variant.color.name, '是否次品': '是'}))
              defectiveIndex = arr.length - 1
            }

            arr[defectiveIndex][variant.size.name] = variant.defectiveQuality
            arr[defectiveIndex]['合计'] += variant.defectiveQuality
          }
        })
      })

      return arr
    }
  },
  data () {
    return {
      defaultData: {
        ' ': '',
        品牌: '',
        产品名称: '',
        款号: '',
        是否次品: '否',
        入库时间: '',
        入库交接人: '',
        出库时间: '',
        出库跟进人: '',
        成本价: '',
        吊牌价: '',
        出库价: '',
        颜色: '',
        '99 ': 0,
        XS: 0,
        S: 0,
        M: 0,
        L: 0,
        XL: 0,
        XXL: 0,
        XXXL: 0,
        XXXXL: 0,
        XXXXXL: 0,
        XXXXXXL: 0,
        合计: 0
      }
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>
</style>