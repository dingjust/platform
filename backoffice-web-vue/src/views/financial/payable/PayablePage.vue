<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="financial-list-title">
            <h6>应付账款</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <payable-toolbar @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData" 
                       :dataQuery="dataQuery" @onResetQuery="onResetQuery"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
            <payable-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail"/>
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
    'PayableModule'
  );
  import PayableToolbar from './toolbar/PayableToolbar'
  import PayableList from './list/PayableList'

  export default {
    name: 'PayablePage',
    props: {

    },
    components: {
      PayableToolbar,
      PayableList
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
        const url = this.apis().getPaymentList();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch (page, size, isTab) {
        if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
          this.onResetQuery();
        }
        const query = this.queryFormData;
        const url = this.apis().getPaymentList();
        this.searchAdvanced({url, query, page, size});

        if (!isTab) {
          this.getPaymentCount();
        }
      },
      handleClick (tab, event) {
        this.queryFormData.state = tab.name;
        this.onAdvancedSearch(0, 10, true);
      },
      async getPaymentCount() {
        const url = this.apis().getPaymentCount();
        const result = await this.$http.post(url, this.queryFormData);
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
        return tab.name;
      },
      onDetail (row) {
        this.$router.push('/financial/payable/' + row.id);
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      }
    },
    data () {
      return {
        stateCount: {},
        activeName: 'WAIT_TO_PAY',
        queryFormData: {
          keyword: '',
          merchandiserName: '',
          payableName: '',
          createdDateFrom: '',
          createdDateTo: '',
          state: 'WAIT_TO_PAY'
        },
        statuses: this.$store.state.EnumsModule.financialState,
        dataQuery: {}
      }
    },
    created () {
      this.dataQuery = this.getDataPerQuery('PAYMENT_BILL');
      this.onResetQuery();
      this.onAdvancedSearch(0, 10);
    },
    mounted () {
      this.statuses.push({
        code: '',
        name: '全部'
      })
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