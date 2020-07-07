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
    <shipping-orders-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" />
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="item in statuses">
        <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
          <shipping-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail" />
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
      onAdvancedSearch(page, size) {
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
      },
      handleClick(tab, event) {
        this.queryFormData.status = tab.name;
        this.onAdvancedSearch(0, 10);
      },
      onDetail(row) {
        this.$router.push('/shipping/orders/' + row.id);
      },
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        activeName: '',
        statuses: [{
            code: '',
            name: '全部'
          },
          {
            code: '1',
            name: '待收货'
          },
          {
            code: '2',
            name: '待退货'
          },
          {
            code: '3',
            name: '退货中'
          },
          {
            code: '4',
            name: '已完成'
          }
        ],
        queryFormData: {
          keyword: '',
          productionLeaderName: '',
          operatorName: '',
          creationtimeStart: '',
          creationtimeEnd: '',
          status: ''
        }
      }
    },
    created() {
      this.onSearch();
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
