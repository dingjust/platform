<!--
* @Description: 对账单对账产品项列表页
* @Date 2020/12/07 16:53
* @Author L.G.Y
-->
<template>
  <div>
    <!-- <el-card> -->
      <el-row>
        <div class="list-title">
          <h6>对账项列表</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <reconciliation-item-toolbar @onAdvancedSearch="onAdvancedSearch" :queryFormData="queryFormData"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
            <reconciliation-item-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    <!-- </el-card> -->
  </div>
</template>

<script>
import ReconciliationItemToolbar from './ReconciliationItemToolbar'
import ReconciliationItemList from './ReconciliationItemList'
export default {
  name: 'ReconciliationItemPage',
  components: {
    ReconciliationItemToolbar,
    ReconciliationItemList
  },
  data () {
    return {
      activeName: '',
      statuses: [
        {
          code: '',
          name: '全部'
        }, {
          code: 'IN_RECONCILED',
          name: '对账中'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        }, {
          code: 'CANCELLED',
          name: '已取消'
        }
      ],
      page: {
        number: 0,
        size: 10,
        totalPages: 1,
        totalElements: 0,
        content: []
      },
      queryFormData: {
        keyword: '',
        cooperatorName: '',
        partyType: 'PARTYA',
        deliveryDateFrom: '',
        deliveryDateTo: '',
        contractDateFrom: '',
        contractDateTo: ''
      },
      stateCount: {}
    }
  },
  methods: {
    async onAdvancedSearch (page, size, isTabChange) {
      const query = Object.assign({}, this.queryFormData);

      const url = this.apis().getReconciliationItems();
      const result = await this.$http.post(url, query, {
        page: page,
        size: size
      })

      this.$set(this, 'page', result);

      // 获取统计信息
      if (!isTabChange) {
        this.stateCount = {};
        this.getReconciliationItemsCount();
      }
    },
    async getReconciliationItemsCount () {
      const query = Object.assign({}, this.queryFormData);

      const url =  this.apis().getReconciliationItemsCount();
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

      this.$set(this, 'stateCount', result.data);
    },
    tabName(tab) {
      let tabName = tab.name + '(0)';
      if (tab.code === '') {
        tabName = tab.name + '(' + this.getCount() + ')';
      } else if (tab.code === 'IN_RECONCILED') {
        let arr = ['COMPLETED', 'CANCELLED'];
        tabName = tab.name + '(' + this.getCount(arr) + ')';
      } else if (this.stateCount.hasOwnProperty(tab.code)) {
        tabName = tab.name + '(' + this.stateCount[tab.code] + ')';
      }
      return tabName;
    },
    getCount (arr) {
      let count = 0;
      for (const key in this.stateCount) {
        // stateCount存在，参数 arr 为过滤项数组
        if (this.stateCount.hasOwnProperty(key) && !(arr && arr.indexOf(key) > -1)) {
          const element = this.stateCount[key];
          count += element;
        }
      }
      return count;
    },
    handleClick (tab, event) {
      if (tab.name === 'IN_RECONCILED') {
        this.queryFormData.states = ['PENDING_B_SIGN', 'PENDING_APPROVAL', 'PENDING_A_SIGN']
      } else {
        this.queryFormData.states = tab.name;
      }
      this.onAdvancedSearch(0, 10, true);
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
</style>