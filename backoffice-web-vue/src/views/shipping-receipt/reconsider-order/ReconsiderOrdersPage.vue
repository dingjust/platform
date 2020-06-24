<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>差异复议</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <reconsider-orders-toolbar :queryFormData="queryFormData" :ableToApply="ableToApply" 
                                  @onAdvancedSearch="onAdvancedSearch" @onApply="onApply"/>
      <el-row type="flex" justify="start">
        <h6 style="color: #F56C6C">注明：待复议中的发货订单，申请复议时间为5天，如5天内没有申请复议，则视为放弃复议，此发货单将不再接受复议</h6>
      </el-row>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
            <reconsider-orders-list :page="page" :ableToApply="ableToApply" :searchType="searchType"
                                    @onDetail="onDetail" @onAdvancedSearch="onAdvancedSearch"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
  import ReconsiderOrdersToolbar from './toolbar/ReconsiderOrdersToolbar'
  import ReconsiderOrdersList from './list/ReconsiderOrdersList'
  export default {
    name: 'ReconsiderOrdersPage',
    props: ['mode'],
    components: {
      ReconsiderOrdersToolbar,
      ReconsiderOrdersList
    },
    computed: {
      ableToApply: function () {
        return this.activeName == 'first';
      }
    },
    methods: {
      handleClick (tab, event) {
        if (tab.name == 'first') {
          this.searchType = 'SHIPPING_ORDER';
          this.queryFormData.status = '待复议';
          this.searchUrl = this.apis().getProductionTaskList();
        } else if (tab.name == 'second') {
          this.searchType = 'RECONSIDER_ORDER';
          this.queryFormData.status = '复议中';
          this.searchUrl = this.apis().getProductionOrders();
        } else if (tab.name == 'third') {
          this.searchType = 'RECONSIDER_ORDER';
          this.queryFormData.status = '复议成功';
          this.searchUrl = this.apis().getProductionOrders();
        } else if (tab.name == 'fourth') {
          this.searchType = 'RECONSIDER_ORDER';
          this.queryFormData.status = '复议失败';
          this.searchUrl = this.apis().getProductionOrders();
        } else if (tab.name == 'fifth') {
          this.searchType = 'SHIPPING_ORDER';
          this.queryFormData.status = '已过期';
          this.searchUrl = this.apis().getProductionTaskList();
        } 
        this.onAdvancedSearch(0, 10);
      },
      async onAdvancedSearch (page, size) {
        const url = this.searchUrl;
        const query = this.queryFormData;
        const result = await this.$http.post(url, query, {
          page: page,
          size: size
        });
        this.page = result;
      },
      onApply () {

      },
      onDetail () {

      }
    },
    data() {
      return {
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        },
        activeName: 'first',
        searchType: '',
        searchUrl: '',
        statuses: [{
          code: 'first',
          name: '待复议'
        }, {
          code: 'second',
          name: '复议中'
        }, {
          code: 'third',
          name: '复议成功'
        }, {
          code: 'fourth',
          name: '复议失败'
        }, {
          code: 'fifth',
          name: '已过期'
        }],
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
      this.searchType = 'SHIPPING_ORDER';
      this.queryFormData.status = '待复议';
      this.searchUrl = this.apis().getProductionTaskList();
      this.onAdvancedSearch(0, 10);
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
