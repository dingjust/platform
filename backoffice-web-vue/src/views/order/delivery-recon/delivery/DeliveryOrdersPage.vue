<!--
* @Description: 出货单
* @Date 2020/11/23 17:55
* @Author L.G.Y
-->
<template>
  <div>
    <el-row>
      <div class="list-title">
        <h6>出货单列表</h6>
      </div>
    </el-row>
    <div class="pt-2"></div>
    <delivery-orders-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
    <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="item in statuses">
        <el-tab-pane :label="item.name" :name="item.code" :key="item.code" />
      </template>
    </el-tabs>
    <delivery-orders-list ref="list" :page="page" @onAdvancedSearch="onAdvancedSearch" 
                            :isSelection="isSelection" :selectedId="selectedId"/>
    <el-row type="flex" justify="center" v-if="isSelection">
      <el-button type="primary" size="medium" class="reconciliation-btn" @click="onSelect">确定</el-button>
    </el-row>
  </div>
</template>
 
<script>
import { createNamespacedHelpers } from 'vuex';

const {
  mapGetters,
  mapActions,
  mapMutations
} = createNamespacedHelpers(
  'DeliveryOrdersModule'
);

import DeliveryOrdersList from './list/DeliveryOrdersList'
import DeliveryOrdersToolbar from './toolbar/DeliveryOrdersToolbar'

export default {
  name: 'DeliveryOrdersPageV2',
  props: {
    // 是否为选择列表组件
    isSelection: {
      type: Boolean,
      default: false,
    },
    // 已选id，处理回显
    selectedId: {
      default: ''
    } 
  },
  components: {
    DeliveryOrdersList,
    DeliveryOrdersToolbar
  },
  computed: {
    ...mapGetters({
      page: 'page',
      keyword: 'keyword'
    })
  },
  data () {
    return {
      activeName: 'PENDING_RECONCILED',
      statuses: [
        {
          code: 'PENDING_RECONCILED',
          name: '待对账',
        },
        {
          code: 'IN_RECONCILED',
          name: '对账中',
        },
        {
          code: 'COMPLETED',
          name: '已完成',
        },
      ],
      queryFormData: {
        keyword: '',
        cooperator: '',
        states: '',
        expectedDeliveryDateFrom: '',
        expectedDeliveryDateTo: '',
        partyType: "PARTYA"
      }
    }
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch (page, size) {
      const query = this.queryFormData;
      const url = this.apis().getDeliveryList();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });
    },
    handleClick (tab, event) {
      this.queryFormData.states = tab.name;
      this.onAdvancedSearch(0, 10);
    },
    onSelect () {
      this.$emit('onSelect', this.$refs.list.currentRow);
    }
  },
  created () {
    this.onAdvancedSearch(0, 10);
  }
}
</script>

<style scoped>
  .list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .reconciliation-btn {
    background: #ffd60c;
    color: #303133;
    border-color: #ffd60c;
  }
</style>