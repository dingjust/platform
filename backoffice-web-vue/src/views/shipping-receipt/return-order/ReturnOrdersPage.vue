<template>
  <div class="animated fadeIn">
    <el-row>
      <el-col :span="4">
        <div class="title">
          <h6>退货单列表</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <return-orders-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" 
                            :dataQuery="dataQuery" @onResetQuery="onResetQuery"/>
    <div>
      <!-- <div class="good-btn">
        <el-button class="check-btn" v-if="canClick" @click="onReceiptReturn">收退货</el-button>
      </div> -->
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
            <return-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail" :mode="mode" />
          </el-tab-pane>
        </template>
      </el-tabs>
    </div>
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
    'ReturnOrdersModule'
  );

  import ReturnOrdersToolbar from './toolbar/ReturnOrdersToolbar'
  import ReturnOrdersList from './list/ReturnOrdersList'

  export default {
    name: 'ReturnOrdersPage',
    props: {
      mode: {
        type: String,
        default: 'import'
      }
    },
    components: {
      ReturnOrdersToolbar,
      ReturnOrdersList
    },
    computed: {
      ...mapGetters({
        keyword: 'keyword',
        page: 'page',
        formData: 'formData'
      }),
      canClick: function () {
        // TODO 判断
        return true;
      }
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().returnOrderList();
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
      onAdvancedSearch(page, size) {
        if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
          this.onResetQuery();
        }
        const query = this.queryFormData;
        const url = this.apis().returnOrderList();
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
      },
      handleClick(tab, event) {
        this.queryFormData.states = tab.name;
        this.onAdvancedSearch(0, 10);
      },
      onDetail(row) {
        // 退单详情
        this.$router.push('/returned/orders/' + row.id);
      },
      onReceiptReturn() {

      },
      // 查询退货单状态统计
      async returnOrderStateCount() {
        let query = Object.assign({}, this.queryFormData);
        query.states = '';
        if (this.mode == 'import') {
          // query['shipParty'] = this.$store.getters.currentUser.companyCode;
          query['partyType'] = 'PARTYB';
        } else {
          // query['receiveParty'] = this.$store.getters.currentUser.companyCode;
          query['partyType'] = 'PARTYA';
        }

        const url = this.apis().returnSheetStateCount();
        const result = await this.$http.post(url, query);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$set(this, 'stateCount', result.data);
      },
      tabName(map) {
        let tabName = this.getEnum('ShippingSheetState', map.code);
        if (!this.stateCount.hasOwnProperty(map.code)) {
          return tabName;
        }
        tabName = this.getEnum('ShippingSheetState', map.code) + '(' + this.stateCount[map.code] +
          ')';
        return tabName;
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      }
    },
    data() {
      return {
        activeName: 'RETURN_TO_BE_RECEIVED',
        currentUser: this.$store.getters.currentUser,
        statuses: [{
            code: 'RETURN_TO_BE_RECEIVED',
            name: '退货待收'
          },
          {
            code: 'RETURN_RECEIVED',
            name: '退货已收'
          },
        ],
        queryFormData: {
          keyword: '',
          cooperatorName: '',
          merchandiserName: '',
          createdDateFrom: '',
          createdDateTo: '',
          states: 'RETURN_TO_BE_RECEIVED'
        },
        stateCount: {

        },
        dataQuery: {}
      }
    },
    created() {
      const pageSign = this.mode === 'import' ? 'SHIPPING_SHEET' : 'RECEIPT_SHEET';
      this.dataQuery = this.getDataPerQuery(pageSign);
      this.onResetQuery();
      this.onAdvancedSearch();
      this.returnOrderStateCount();
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

  .good-btn {
    position: absolute;
    right: 20px;
    z-index: 999;
  }

  .check-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
  }

</style>
