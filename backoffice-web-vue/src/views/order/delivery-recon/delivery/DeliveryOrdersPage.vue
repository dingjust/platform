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
    <div class="tag-container" :class="tagPosition ? 'tag-position' : ''">
      <el-row ref="tag" type="flex" justify="end" align="top">
        <el-button size="medium" @click="onCreate">创建出货单</el-button>
      </el-row>
    </div>
    <el-tabs ref="tabs" v-model="activeName" @tab-click="handleClick" v-if="!isSelection">
      <template v-for="item in statuses">
        <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code" />
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
        cooperatorName: '',
        states: 'PENDING_RECONCILED',
        createdDateFrom: '',
        createdDateTo: '',
        // partyType: "PARTYB"
      },
      stateCount: {},
      tagPosition: true,
      tagWidth: 0,
    }
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch (page, size, isTabChange) {
      const query = this.queryFormData;
      const url = this.apis().getDeliveryList();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });

      // 获取统计信息
      if (!isTabChange) {
        this.getDeliveryListCount();
      }
    },
    async getDeliveryListCount () {
      let query = Object.assign({}, this.queryFormData);
      query.states = '';

      const url = this.apis().getDeliveryListCount();
      const result = await this.$http.post(url, query);
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
    handleClick (tab, event) {
      this.queryFormData.states = tab.name;
      this.onAdvancedSearch(0, 10, true);
    },
    onSelect () {
      this.$emit('onSelect', this.$refs.list.currentRow);
    },
    onCreate () {
      this.$router.push('/order/delivery/create');
    },
    changeTagPosition () {
      let count = 20;
      this.statuses.forEach(item => {
        count += document.getElementById("tab-" + item.code).scrollWidth
      })
      if (this.tagWidth === 0) {
        this.tagWidth = this.$refs.tag.$el.scrollWidth
      }
      this.tagPosition = this.tagWidth + count < this.$refs.tabs.$el.scrollWidth;
    }
  },
  mounted() {
    window.addEventListener('resize', this.changeTagPosition);
  },
  created () {
    this.onAdvancedSearch(0, 10);
  },
  destroyed () {
    window.removeEventListener('resize', this.changeTagPosition);
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

  .tag-position {
    position: absolute;
  }

  .tag-container {
    right: 20px;
    margin-top: 2px;
    z-index: 999;
  }
</style>