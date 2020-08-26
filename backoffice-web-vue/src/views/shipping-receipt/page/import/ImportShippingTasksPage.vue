<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>发货任务</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <shipping-tasks-page :page="page" :queryFormData="queryFormData" @onSearch="onSearch"
        @onAdvancedSearch="onAdvancedSearch" mode="import" :dataQuery="dataQuery" @onResetQuery="onResetQuery"/>
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
    'ImportShippingTasksModule'
  );

  import ShippingTasksPage from '../../shipping-task/ShippingTasksPage'
  export default {
    name: 'ImportShippingTasksPage',
    components: {
      ShippingTasksPage
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
        const url = this.apis().shippingTaskList();
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
        if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
          this.onResetQuery();
        }
        const query = this.queryFormData;
        const url = this.apis().shippingTaskList();
        const companyCode = this.currentUser.companyCode;
        this.searchAdvanced({
          url,
          query,
          page,
          size,
          companyCode
        });
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        queryFormData: {
          keyword: '',
          cooperatorName: '',
          merchandiserName: '',
          createdDateFrom: '',
          createdDateTo: '',
          states: 'PENDING_DELIVERY'
        },
        dataQuery: {}
      }
    },
    created() {
      this.dataQuery = this.getDataPerQuery('SHIPPING_SHEET');
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
