<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="template-list-title">
          <h6>合同模板列表</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <contract-back-temp-toolbar :queryFormData="queryFormData" @onSearch="onSearch"/>
      <contract-back-temp-list :page="page" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
import {
  createNamespacedHelpers
} from 'vuex';
const {
  mapGetters,
  mapActions
} = createNamespacedHelpers(
  'ContractTemplateModule'
);

import ContractBackTempToolbar from './toolbar/ContractBackTempToolbar'
import ContractBackTempList from './list/ContractBackTempList'

export default {
  name: 'ContractBackTemp',
  computed: {
    ...mapGetters({
      page: 'page',
      queryFormData: 'queryFormData'
    })
  },
  components: {
    ContractBackTempToolbar,
    ContractBackTempList
  },
  methods: {
    ...mapActions({
      search: 'search'
    }),
    onSearch (page, size) {
      const query = this.queryFormData;

      const url = this.apis().searchContractTempOnPlatform();
      this.search({ url, query, page, size });
    }
  },
  created () {
    this.onSearch();
  }
}
</script>

<style scoped>
  .template-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>