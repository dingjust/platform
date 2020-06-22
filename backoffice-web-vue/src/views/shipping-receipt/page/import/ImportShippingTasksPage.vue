<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>收发任务</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <shipping-tasks-page :page="page" :queryFormData="queryFormData" 
                            @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"/>
    </el-card>
  </div>
</template>

<script>
  import { createNamespacedHelpers } from 'vuex';
  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'ShippingTasksModule'
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
      onSearch (page, size) {
        // TODO 查询自身的收发任务
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
        // TODO 查询自身的收发任务
        const query = this.queryFormData;
        const url = this.apis().getProductionTaskList();
        this.searchAdvanced({url, query, page, size});
      }
    },
    data() {
      return {
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
