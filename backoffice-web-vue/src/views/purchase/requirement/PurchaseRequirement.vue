<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="purchase-list-title">
            <h6>采购需求列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <purchase-requirement-toolbar @onAdvancedSearch="onAdvancedSearch" @onResetQuery="onResetQuery"
                                    :queryFormData="queryFormData" :dataQuery="dataQuery"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code">
            <purchase-requirement-list :page="page" @onAdvancedSearch="onAdvancedSearch"/>
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
  mapActions,
  mapMutations
} = createNamespacedHelpers(
  'PurchaseRequirementModule'
);

import PurchaseRequirementToolbar from './toolbar/PurchaseRequirementToolbar'
import PurchaseRequirementList from './list/PurchaseRequirementList'

export default {
  name: 'PurchaseRequirement',
  components: {
    PurchaseRequirementToolbar,
    PurchaseRequirementList
  },
  computed: {
    ...mapGetters({
      page: 'page',
    })
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch(page, size, isTab) {
      if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
        this.onResetQuery();
      }
      const query = this.queryFormData;
      const url = this.apis().getPurchaseTaskList();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });
      // 切换tab页不再重新查询统计接口
      if (!isTab) {
        this.getPurchaseRequirementCount();
      }
    },
    async getPurchaseRequirementCount() {
      const url = this.apis().getPurchaseRequirementCount();
      const result = await this.$http.post(url, this.queryFormData);
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
      this.queryFormData.state = tab.name;
      this.onAdvancedSearch(0, 10, true);
    },
    onResetQuery () {
      this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
    }
  },
  data () {
    return {
      queryFormData: {
        keyword: '',
        creator: '',
        createdDateFrom: '',
        createdDateTo: '',
        state: 'NOT_COMMITED'
      },
      dataQuery: {},
      activeName: 'NOT_COMMITED',
      statuses: [{
          code: 'NOT_COMMITED',
          name: '待提交'
        }, {
          code: 'AUDITING',
          name: '待审核'
        }, {
          code: 'AUDITED_FAIL',
          name: '审核驳回'
        }, {
          code: 'PURCHASING',
          name: '采购中'
        }, {
          code: 'PURCHASE_COMPLETE',
          name: '采购完成'
        }, {
          code: '',
          name: '全部'
      }],
      stateCount: {},
    }
  },
  created () {
    this.dataQuery = this.getDataPerQuery('PURCHASE_REQUIREMENT');
    this.onResetQuery();
    this.onAdvancedSearch(0, 10);
  }
}
</script>

<style scoped>
  .purchase-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>