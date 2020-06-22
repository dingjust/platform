<template>
  <div class="animated fadeIn">
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>收货单列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <return-orders-toolbar :queryFormData="queryFormData" 
                                @onAdvancedSearch="onAdvancedSearch"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
            <return-orders-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail"/>
          </el-tab-pane>
        </template>
      </el-tabs>
  </div>
</template>

<script>
  import { createNamespacedHelpers } from 'vuex';
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
    components: {
     ReturnOrdersToolbar,
     ReturnOrdersList 
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
      onSearch (page, size) {
        const keyword = this.keyword;
        const url = this.apis().getProductionTaskList();
        this.search({
          url,
          keyword,
          page,
          size
        });
      },
      onAdvancedSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().getProductionTaskList();
        this.searchAdvanced({url, query, page, size});
      },
      handleClick (tab, event) {
        this.queryFormData.status = tab.name;
        this.onAdvancedSearch(0, 10);
      },
      onDetail (row) {
        // TODO 发货单详情
        // this.$router.push('/receipt/orders/' + row.id);
      },
    },
    data() {
      return {
        activeName: '',
        statuses: [
          {
            code: '',
            name: '全部'
          },
          {
            code: '1',
            name: '待发货'
          },
          {
            code: '2',
            name: '已收货'
          },
          {
            code: '3',
            name: '待退货'
          },
          {
            code: '4',
            name: '退货待收'
          },
          {
            code: '5',
            name: '退货已收'
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
