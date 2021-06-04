<!--
* @Description: 外接订单选择列表
* @Date 2021/06/04 18:06
* @Author L.G.Y
-->
<template>
  <div class="pending-select-page">
    <pending-sales-select-toolbar 
      @onAdvancedSearch="onAdvancedSearch"
      @onResetQuery="onResetQuery"
      :queryFormData="queryFormData" 
      :dataQuery="dataQuery" 
    />
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <el-tab-pane v-for="item in statuses" :label="item.name" :name="item.code" :key="item.code">
        <pending-sales-select-list 
          :page="page" 
          :singleChoice="singleChoice"
          @onSelect="onSelect"
          @onAdvancedSearch="onAdvancedSearch"
        />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import {
  createNamespacedHelpers
} from 'vuex';

const {
  mapGetters,
  mapActions,
  mapMutations
} = createNamespacedHelpers(
  'PendingSalesProductionOrdersModule'
);

import PendingSalesSelectList from '../list/PendingSalesSelectList.vue'
import PendingSalesSelectToolbar from '../toolbar/PendingSalesSelectToolbar.vue'
export default {
  name: 'PendingSalesSelectPage',
  components: { PendingSalesSelectToolbar, PendingSalesSelectList },
  props: {
    // 是否单选
    singleChoice: {
      type: Boolean,
      default: false
    },
    // 需要现实的列表状态
    customStatuses: {
      type: Array
    },
    // 需要查询的queryFormData
    customQueryFormData: {
      type: Object
    }
  },
  computed: {
    ...mapGetters({
      page: 'page'
    })
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch(page, size) {
      if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
        this.onResetQuery();
      }
      const query = this.queryFormData;
      const url = this.apis().getPendingSalesOrderList();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });
    },
    handleClick (tab, event) {
      this.queryFormData.state = tab.name;
      this.onAdvancedSearch();
    },
    onSelect (selectionRow) {
      this.$emit('onSelect', selectionRow);
    },
    onResetQuery () {
      this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
    }
  },
  data () {
    return {
      activeName: 'AUDIT_PASSED',
      statuses: [
        {
          code: 'AUDIT_PASSED',
          name: '生产中'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        } 
      ],
      queryFormData: {
        keyword: '',
        planLeader: '',
        originCooperator: '',
        state: 'AUDIT_PASSED'
      },
      dataQuery: {}
    }
  },
  created() {
    if (this.customStatuses) {
      this.statuses = this.customStatuses
    }
    if (this.customQueryFormData) {
      this.queryFormData = this.customQueryFormData
    }

    this.dataQuery = this.getDataPerQuery('SALES_OUT_ORDER');
    this.onResetQuery();
    this.onAdvancedSearch();
  }
}
</script>

<style>

</style>