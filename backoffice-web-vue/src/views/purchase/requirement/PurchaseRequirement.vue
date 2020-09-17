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
      <purchase-requirement-toolbar @onAdvancedSearch="onAdvancedSearch" 
                                    :queryFormData="queryFormData" :dataQuery="dataQuery"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="item in statuses">
          <el-tab-pane :label="item.name" :name="item.code" :key="item.code">
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
    onAdvancedSearch(page, size) {
      if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
        this.onResetQuery();
      }
      const query = this.queryFormData;
      const url = this.apis().getoutboundOrdersList();
      this.searchAdvanced({
        url,
        query,
        page,
        size
      });
    },
    handleClick (tab, event) {
      this.queryFormData.state = tab.name;
      this.onAdvancedSearch(0, 10);
    },
    onResetQuery () {
      this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
    }
  },
  data () {
    return {
      queryFormData: {
        keyword: '',
        operatorName: '',
        state: 'TO_BE_SUBMITTED'
      },
      dataQuery: {},
      activeName: 'TO_BE_SUBMITTED',
      statuses: [{
          code: 'TO_BE_SUBMITTED',
          name: '待提交'
        }, {
          code: 'AUDITING',
          name: '待审核'
        }, {
          code: 'AUDITED_FAILED',
          name: '审核驳回'
        }, {
          code: 'PURCHASING',
          name: '采购中'
        }, {
          code: 'COMPLETED',
          name: '采购完成'
        }, {
          code: '',
          name: '全部'
      }]
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