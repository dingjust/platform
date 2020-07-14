<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="financial-list-title">
            <h6>应收账款</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <receivable-toolbar @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData" />
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
            <receivable-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
  import { createNamespacedHelpers } from 'vuex';
  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'ReceivableModule'
  );
  import ReceivableToolbar from './toolbar/ReceivableToolbar'
  import ReceivableList from './list/ReceivableList'

  export default {
    name: 'ReceivablePage',
    props: {

    },
    components: {
      ReceivableToolbar,
      ReceivableList
    },
    computed: {
      ...mapGetters({
        page: 'page',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch (page, size) {
        const keyword = this.keyword;
        const url = this.apis().shippingOrderList();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().shippingOrderList();
        this.searchAdvanced({url, query, page, size});
      },
      handleClick (tab, event) {
        this.queryFormData.states = tab.name;
        this.onAdvancedSearch(0, 10);
      },
      onDetail (row) {
        this.$router.push('/financial/receivable/' + row.id);
      }
    },
    data () {
      return {
        activeName: 'PENDING_PAYMENT',
        queryFormData: {
          keyword: '',
          merchandiserName: '',
          cooperatorName: '',
          createdDateFrom: '',
          createdDateTo: '',
          states: ''
        },
        statuses: [{
          code: 'PENDING_PAYMENT',
          name: '待付款'
        }, {
          code: 'PAYING',
          name: '付款中'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        }]
      }
    },
    created () {
      this.onAdvancedSearch(0, 10);
    },
    destroyed () {
      
    }
  }
</script>

<style scoped>
  .financial-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>