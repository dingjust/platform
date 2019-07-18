<template>
  <div class="animated fadeIn content">
    <el-card>
      <wallet-amount :walletData="walletData"/>
      <div class="pt-2"></div>
      <wallet-toolbar @onSearch="onSearch" @onSearchAmountFlows="onSearchAmountFlows"/>
      <wallet-list :page="page" @onDetails="onDetails" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  import http from '@/common/js/http';

  const {mapGetters, mapActions, mapMutations} = createNamespacedHelpers('WalletModule');

  import WalletToolbar from './toolbar/WalletToolbar';
  import WalletList from './list/WalletList';
  import WalletAmount from './amount/WalletAmount';
  import BillDetailsPage from '../bill/details/BillDetailsPage';
  import AmountFlowPage from '../amountFlow/AmountFlowrPage';

  export default {
    name: 'WalletPage',
    components: {
      WalletToolbar,
      WalletList,
      WalletAmount,
      BillDetailsPage,
      AmountFlowPage
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        walletData: 'walletData',
        queryFormData: 'queryFormData',
        amountFlowPage: 'amountFlowPage',
      })
    },
    methods: {
      ...mapMutations({
        setWalletData: 'walletData'
      }),
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        searchAdvancedByAmountFlow: 'searchAdvancedByAmountFlow'
      }),
      async onGetWallet () {
        const url = this.apis().getWallet();
        const response = await http.get(url);
        if (!response['errors']) {
          this.setWalletData(response);
        }
      },
      onSearch (page, size) {
        const keyword = this.keyword;
        const url = this.apis().getBills();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch (page, size) {
        this.setIsAdvancedSearch(true);
        const query = this.queryFormData;
        const url = this.apis().getBills();
        this.searchAdvanced({url, query, page, size});
      },
      onSearchAmountFlows (page, size) {
        this.fn.openSlider('交易明细', AmountFlowPage);
      },
      async onDetails (item) {
        const url = this.apis().getBill(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
        }

        this.fn.openSlider('明细：' + item.code, BillDetailsPage, result);
      },
    },
    data () {
      return {
        amount: 0,
        cashOutView: false,
      };
    },
    created () {
      this.onGetWallet();
      this.onSearch();
    }
  };
</script>
