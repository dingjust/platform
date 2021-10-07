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
      <inventory-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
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

export default {
  name: 'InventoryPage',
  components: { InventoryList, InventoryToolbar },
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

      const url = this.apis().searchInventory();
      this.searchAdvanced({url, query, page, size});
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>
</style>