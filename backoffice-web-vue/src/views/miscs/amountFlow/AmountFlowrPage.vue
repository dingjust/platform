<template>
  <div class="animated fadeIn content">
    <el-card>
      <amount-flow-tollbar @onSearch="onAdvancedSearch"/>
      <amount-flow-list :page="page" @onDetails="onDetails" @onSearch="onAdvancedSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions, mapMutations} = createNamespacedHelpers('WalletModule');

  import AmountFlowList from './list/AmountFlowList';
  import AmountFlowTollbar from './toolbar/AmountFlowToolbar';

  export default {
    name: 'cashOutManagerPage',
    components: {
      AmountFlowList,
      AmountFlowTollbar
    },
    computed: {
      ...mapGetters({
        page: 'amountFlowPage',
        keyword: 'keyword',
        cashOutDetailData: 'cashOutDetailData',
        queryFormData: 'queryFormData'
      })
    },
    methods: {
      ...mapMutations({
        setCashOutDetailData: 'cashOutDetailData'
      }),
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        searchAdvancedByAmountFlow: 'searchAdvancedByAmountFlow'
      }),
      onAdvancedSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().findAmountFlows();
        this.searchAdvancedByAmountFlow({url, query, page, size});
      },
      async onDetails (item) {
        const url = this.apis().getBill(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
        }
        this.setCashOutDetailData(result);
        this.fn.openSlider('明细：' + item.code, cashOutManagerDetailsPage);
      }
    },
    data () {
      return {};
    },
    created () {
      this.onAdvancedSearch();
    }
  };
</script>
