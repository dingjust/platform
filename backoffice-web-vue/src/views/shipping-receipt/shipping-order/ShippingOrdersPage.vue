<template>
  <div class="animated fadeIn">
    <el-row>
      <el-col :span="4">
        <div class="title">
          <h6>发货单列表</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <shipping-orders-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" 
                             :dataQuery="dataQuery" @onResetQuery="onResetQuery"/>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="item in statuses">
        <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
          <shipping-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail" :mode="mode"/>
        </el-tab-pane>
      </template>
    </el-tabs>
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
    'ShippingOrdersModule'
  );

  import ShippingOrdersToolbar from './toolbar/ShippingOrdersToolbar'
  import ShippingOrdersList from './list/ShippingOrdersList'

  export default {
    name: 'ShippingOrdersPage',
    props: {
      mode: {
        type: String,
        default: 'import'
      }
    },
    components: {
      ShippingOrdersToolbar,
      ShippingOrdersList
    },
    computed: {
      ...mapGetters({
        keyword: 'keyword',
        page: 'page',
        formData: 'formData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().shippingOrderList();
        const mode = this.mode;
        const companyCode = this.currentUser.companyCode;
        this.search({
          url,
          keyword,
          page,
          size,
          mode,
          companyCode
        });
      },
      onAdvancedSearch(page, size, isTab) {
        if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
          this.onResetQuery();
        }
        const query = this.queryFormData;
        const url = this.apis().shippingOrderList();
        const mode = this.mode;
        const companyCode = this.currentUser.companyCode;
        this.searchAdvanced({
          url,
          query,
          page,
          size,
          mode,
          companyCode
        });
        if (!isTab) {
          this.shippingOrderStateCount();
        }
      },
      async shippingOrderStateCount() {
        let query = Object.assign({}, this.queryFormData);
        query.states = '';
        if (this.mode == 'import') {
          query['shipParty'] = this.$store.getters.currentUser.companyCode;
        } else {
          query['receiveParty'] = this.$store.getters.currentUser.companyCode;
        }

        const url = this.apis().shippingOrderStateCount();
        const result = await this.$http.post(url, query);
        if (result['errors']) {
          this.stateCount = {};
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.stateCount = {};
          this.$message.error(result.msg);
          return;
        }
        this.stateCount = result.data;
      },
      tabName(tab) {
        if (this.stateCount.hasOwnProperty(tab.code)) {
          return tab.name + '(' + this.stateCount[tab.code] + ')';
        }
        if (tab.code === '已完成') {
          let count = 0;
          if (!isNaN(this.stateCount['RECONCILED'])) {
            count += this.stateCount['RECONCILED'];
          }
          if (!isNaN(this.stateCount['COMPLETED'])) {
            count += this.stateCount['COMPLETED'];
          }
          return count > 0 ? tab.name + '(' + count + ')' : tab.name;
        }
        return tab.name;
      },
      handleClick(tab, event) {
        //已完成状态为 已对账和完成状态
        if (tab.name == '已完成') {
          this.queryFormData.states = ['RECONCILED', 'COMPLETED'];
        } else {
          this.queryFormData.states = tab.name;
        }
        this.onAdvancedSearch(0, 10, true);
      },
      onDetail(row) {
        this.$router.push('/shipping/orders/' + row.id);
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      }
    },
    data() {
      return {
        stateCount: {},
        currentUser: this.$store.getters.currentUser,
        activeName: 'PENDING_RECEIVED',
        statuses: [{
          code: 'PENDING_RECEIVED',
          name: '待收货'
        }, {
          code: 'PENDING_RETURNED',
          name: '待退货'
        }, {
          code: 'RETURNING',
          name: '退货中'
        }, {
          code: 'PENDING_RECONSIDER',
          name: '待复议'
        }, {
          code: 'IN_RECONSIDER',
          name: '复议中'
        }, {
          code: 'PENDING_RECONCILED',
          name: '待对账'
        }, {
          code: '已完成',
          name: '已完成'
        }],
        queryFormData: {
          keyword: '',
          cooperatorName: '',
          merchandiserName: '',
          createdDateFrom: '',
          createdDateTo: '',
          states: 'PENDING_RECEIVED'
        },
        dataQuery: {}
      }
    },
    created() {
      const pageSign = this.mode === 'import' ? 'SHIPPING_SHEET' : 'RECEIPT_SHEET';
      this.dataQuery = this.getDataPerQuery(pageSign);
      this.onResetQuery();
      this.onAdvancedSearch();
    },
    destroyed() {

    }
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
