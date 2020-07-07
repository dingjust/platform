<template>
  <div>
    <shipping-tasks-toolbar :queryFormData="queryFormData" 
                              @onAdvancedSearch="onAdvancedSearch"/>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="item in statuses">
        <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
          <shipping-tasks-list :page="page" @onAdvancedSearch="onAdvancedSearch" @onDetail="onDetail"/>
        </el-tab-pane>
      </template>
    </el-tabs>
  </div>
</template>

<script>
  /**
   * @param {Object} [page]     - 列表数据，必传
   * @param {Object} [queryFormData]     - 查询表单对象，必传
   */
  import ShippingTasksToolbar from './toolbar/ShippingTasksToolbar'
  import ShippingTasksList from './list/ShippingTasksList'

  export default {
    name: 'ShippingTasksPage',
    props: {
      page: {
        type: Object,
        required: true
      },
      queryFormData: {
        type: Object,
        required: true
      }
    },
    components: {
     ShippingTasksToolbar,
     ShippingTasksList 
    },
    computed: {
      
    },
    methods: {
      onSearch (page, size) {
        this.$emit('onSearch');
      },
      onAdvancedSearch (page, size) {
        this.$emit('onAdvancedSearch');
      },
      handleClick (tab, event) {
        this.queryFormData.status = tab.name;
        this.$emit('onAdvancedSearch');
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
        ]
      }
    },
    created() {
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
