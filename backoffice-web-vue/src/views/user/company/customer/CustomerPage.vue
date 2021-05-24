<!--
* @Description: 所有用户列表（平台端页面
* @Date 2021/05/22 15:11
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>用户列表</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <customer-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
      <customer-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
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
  'CustomerModule'
);

import CustomerList from './list/CustomerList'
import CustomerToolbar from './toolbar/CustomerToolbar'

export default {
  name: 'CustomerPage',
  components: { CustomerList, CustomerToolbar },
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
      const query = this.queryFormData;

      const url = this.apis().searchCustomerList();
      this.searchAdvanced({url, query, page, size});
    }
  },
  data () {
    return {
      queryFormData: {
        keyword: ''
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