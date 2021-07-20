<!--
* @Description: 账号注销审阅
* @Date 2021/07/20 14:47
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>账号注销审阅</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <account-logoff-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane v-for="item in statuses" :label="item.name" :name="item.code" :key="item.code">
          <account-logoff-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
        </el-tab-pane>
      </el-tabs>
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
  'AccountLogoffModule'
);

import AccountLogoffList from './list/AccountLogoffList'
import AccountLogoffToolbar from './toolbar/AccountLogoffToolbar'

export default {
  name: 'AccountLogoff',
  components: { AccountLogoffToolbar, AccountLogoffList },
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

      const url = this.apis().searchAccountLogoff();
      this.searchAdvanced({url, query, page, size});
    },
    handleClick(tab, event) {
      this.queryFormData.state = tab.name;
      this.onAdvancedSearch(0, this.page.size);
    },
  },
  data () {
    return {
      activeName: 'APPLIED',
      queryFormData: {
        keyword: '',
        state: 'APPLIED'
      },
      statuses: [
        {
          code: 'APPLIED',
          name: '申请中'
        },
        {
          code: 'AUDIT_PASSED',
          name: '申请通过'
        },
        {
          code: 'CLOSED',
          name: '已取消'
        },
        {
          code: '',
          name: '全部'
        }
      ]
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>
</style>