<!--
* @Description: 出货-对账页面
* @Date 2020/11/23 14:29
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="list-title">
          <h6>订单列表</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <delivery-reconciliation-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
      <div class="tag-container" :class="tagPosition ? 'tag-position' : ''">
        <el-row ref="tag" type="flex" justify="end" align="top">
          <el-button size="medium" @click="deliveryVisible = true">出货单</el-button>
          <el-button size="medium" @click="reconciliationVisible = true">对账单</el-button>
          <el-button size="medium" @click="itemVisible = true">对账项</el-button>
        </el-row>
      </div>
      <el-tabs ref="tabs" v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
           <delivery-reconciliation-list :orderType="orderType" :page="page" :activeName="activeName" @onAdvancedSearch="onAdvancedSearch"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
    <el-dialog :visible.sync="reconciliationVisible" width="80%" append-to-body class="purchase-dialog" :close-on-click-modal="false">
      <reconciliation-orders-page-v2 v-if="reconciliationVisible"/>
    </el-dialog>
    <el-dialog :visible.sync="deliveryVisible" width="80%" append-to-body class="purchase-dialog" :close-on-click-modal="false">
      <delivery-orders-page v-if="deliveryVisible"/>
    </el-dialog>
    <el-dialog :visible.sync="itemVisible" width="80%" append-to-body class="purchase-dialog" :close-on-click-modal="false">
      <reconciliation-item-page v-if="itemVisible"/>
    </el-dialog>
  </div>
</template>

<script>
import DeliveryReconciliationToolbar from './toolbar/DeliveryReconciliationToolbar'
import DeliveryReconciliationList from './list/DeliveryReconciliationList'
import ReconciliationOrdersPageV2 from './reconciliation/ReconciliationOrdersPageV2'
import DeliveryOrdersPage from './delivery/DeliveryOrdersPage'
import ReconciliationItemPage from './components/ReconciliationItemPage'

export default {
  name: 'DeliveryReconciliationPage',
  components: {
    DeliveryReconciliationToolbar,
    DeliveryReconciliationList,
    ReconciliationOrdersPageV2,
    DeliveryOrdersPage,
    ReconciliationItemPage
  },
  data () {
    return {
      page: {
        number: 0, // 当前页，从0开始
        size: 10, // 每页显示条数
        totalPages: 1, // 总页数
        totalElements: 0, // 总数目数
        content: [] // 当前页数据
      },
      orderType: 'RECONCILIATION', // 页面订单类型 DELIVERY(出货单) RECONCILIATION(对账单新)
      activeName: '全部',
      statuses: [
        // 对账单全部在前
         {
          code: '全部',
          name: '全部'
        },
        // 出货单状态
        {
          code: 'PENDING_RECONCILED',
          name: '待对账',
        },
        // 对账单状态
        {
          code: 'WAIT_ME_SIGN',
          name: '待我签署'
        }, {
          code: 'WAIT_PARTNER_SIGN',
          name: '待对方签署'
        }, {
          code: 'PENDING_APPROVAL',
          name: '待审批'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        }, {
          code: 'CANCELLED',
          name: '已取消'
        }
      ],
      queryFormData: {
        keyword: '',
        cooperatorName: '',
        states: '',
        // partyType: "PARTYB",
        createdDateFrom: '',
        createdDateTo: ''
      },
      deliveryVisible: false,
      reconciliationVisible: false,
      itemVisible: false,
      tagPosition: true,
      tagWidth: 0,
      stateCount: {}
    }
  },
  methods: {
    async searchDelivery (page, size) {
      // this.queryFormData.partyType = 'PARTYB';
      const query = Object.assign({}, this.queryFormData);

      if (query.cooperatorName === '') {
        this.$delete(query, 'cooperatorName')
      }

      const url = this.apis().getDeliveryList();
      const result = await this.$http.post(url, query, {
        page: page,
        size: size
      });

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.$set(this, 'page', result);
    },
    async searchReconciliation (page, size) {
      // this.queryFormData.partyType = 'PARTYA';
      const query = Object.assign({}, this.queryFormData);

      if (query.cooperatorName === '') {
        this.$delete(query, 'cooperatorName')
      }

      const url = this.apis().getReconciliationV2List();
      const result = await this.$http.post(url, query, {
        page: page,
        size: size
      });

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.$set(this, 'page', result);
    },
    handleClick (tab, event) {
      if (tab.name === 'WAIT_ME_SIGN' || tab.name === 'WAIT_PARTNER_SIGN') {
        this.queryFormData.states = '';
        this.queryFormData.signState = tab.name;
      } else {
        this.queryFormData.states = tab.name === '全部' ? '' : tab.name;
        this.queryFormData.signState = '';
      }

      if (tab.name === 'PENDING_RECONCILED') {
        this.orderType = 'DELIVERY';
      } else {
        this.orderType = 'RECONCILIATION';
      }

      this.onAdvancedSearch(0, 10, true);
    },
    onAdvancedSearch (page, size, isTabChange) {
      if (this.orderType === 'DELIVERY') {
        this.searchDelivery(page, size);
      } else if (this.orderType === 'RECONCILIATION') {
        this.searchReconciliation(page, size);
      }

      // 获取统计信息
      if (!isTabChange) {
        this.stateCount = {};
        this.getCount();
      }
    },
    async getCount () {
      await this.getDeliveryListCount();
      await this.getReconciliationV2ListCount();

      // 通过 this.$set 刷新组件显示
      this.$set(this.stateCount, 'loading', true);
    },
    async getDeliveryListCount () {
      let query = Object.assign({}, this.queryFormData);
      query.states = '';

      if (query.cooperatorName === '') {
        this.$delete(query, 'cooperatorName')
      }

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
      if (result.code === 1) {
        this.stateCount.PENDING_RECONCILED = result.data.PENDING_RECONCILED || 0;
      }
    },
    async getReconciliationV2ListCount () {
      let query = Object.assign({}, this.queryFormData);
      query.states = '';

      if (query.cooperatorName === '') {
        this.$delete(query, 'cooperatorName')
      }

      const url = this.apis().getReconciliationV2ListCount();
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
      if (result.code === 1) {
        this.stateCount.WAIT_ME_SIGN = result.data.WAIT_ME_SIGN || 0;
        this.stateCount.WAIT_PARTNER_SIGN = result.data.WAIT_PARTNER_SIGN || 0;
        this.stateCount.PENDING_APPROVAL = result.data.PENDING_APPROVAL || 0;
        this.stateCount.COMPLETED = result.data.COMPLETED || 0;
        this.stateCount.CANCELLED = result.data.CANCELLED || 0;
      }
    },
    tabName(tab) {
      if (this.stateCount.hasOwnProperty(tab.code)) {
        return tab.name + '(' + this.stateCount[tab.code] + ')';
      }
      return tab.name;
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

  .tag-position {
    position: absolute;
  }

  .tag-container {
    right: 20px;
    margin-top: 2px;
    z-index: 999;
  }

</style>