<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>发货列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <shipping-tasks-toolbar :queryFormData="queryFormData" 
                                @onAdvancedSearch="onAdvancedSearch" 
                                @onCreate="onCreate"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
            <shipping-tasks-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail"/>
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
    'ShippingTasksModule'
  );

  import ShippingTasksToolbar from '@/views/shipping/shipping-Task/toolbar/ShippingTasksToolbar'
  import ShippingTasksList from '@/views/shipping/shipping-Task/list/ShippingTasksList'

  export default {
    name: 'ShippingTasksPage',
    components: {
     ShippingTasksToolbar,
     ShippingTasksList 
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
      onCreate () {
        // TODO 创建发货单
      },
      onDetail (row) {
        this.$router.push('/shipping/tasks/' + row.id);
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
            code: 'PENDING_DELIVERY',
            name: '待发货'
          },
          {
            code: 'SHIPPED',
            name: '已发货'
          },
          {
            code: 'COMPLETED',
            name: '已完成'
          },
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
