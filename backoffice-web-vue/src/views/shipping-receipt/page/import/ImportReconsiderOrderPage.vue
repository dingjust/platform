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
      <reconsider-orders-page mode="import" :page="page" :queryFormData="queryFormData" @onSearch="onSearch"
        @onAdvancedSearch="onAdvancedSearch" @handleClick="onHandleClick" />
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
    'ImportReconsiderOrderModule'
  );

  import ReconsiderOrdersPage from '../../reconsider-order/ReconsiderOrdersPage'
  export default {
    name: 'ImportReconsiderOrderPage',
    components: {
      ReconsiderOrdersPage
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
      onHandleClick(val) {
        this.searchUrl = val.searchUrl;
        this.queryFormData.states = val.states;
        this.onAdvancedSearch(0, 10);
      },
      onSearch(page, size) {
        // TODO 查询自身的收发任务
        const keyword = this.keyword;
        const url = this.searchUrl;
        const companyCode = this.currentUser.companyCode;
        this.search({
          url,
          keyword,
          page,
          size,
          companyCode
        });
      },
      onAdvancedSearch(page, size) {
        // TODO 查询自身的收发任务
        const query = this.queryFormData;
        const url = this.searchUrl;
        const companyCode = this.currentUser.companyCode;
        this.searchAdvanced({
          url,
          query,
          page,
          size,
          companyCode
        });
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        searchUrl: this.apis().shippingOrderList(),
        queryFormData: {
          keyword: '',
          productionLeaderName: '',
          operatorName: '',
          creationtimeStart: '',
          creationtimeEnd: '',
          states: 'PENDING_RECONSIDER'
        },
      }
    },
    created() {
      this.onAdvancedSearch();
    },
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
