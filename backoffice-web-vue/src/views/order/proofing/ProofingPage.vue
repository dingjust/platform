<template>
  <div class="animated fadeIn content">
    <el-card>
      <proofing-toolbar @onSearch="onSearch"/>
      <proofing-search-result-list :page="page" @onDetails="onDetails" @onShowQuote="onShowQuote"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('ProofingsModule');

  import ProofingToolbar from './toolbar/ProofingToolbar';
  import ProofingSearchResultList from './list/ProofingSearchResultList';
  import ProofingDetailsPage from "./details/ProofingDetailsPage";

  import QuoteDetailsPage from "../quote/details/QuoteDetailsPage";

  export default {
    name: 'ProofingPage',
    components: {
      ProofingToolbar,
      ProofingSearchResultList
    },
    computed: {
      ...mapGetters({
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        this.search({keyword, page, size});
      },
      async onDetails(row) {
        const url = this.apis().getProofing(row.code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.fn.openSlider('打样订单:' + row.code, ProofingDetailsPage, row);
      },
      async onShowQuote(row) {
        const url = this.apis().getQuote(row.quoteRef);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.fn.openSlider('报价单:' + row.code, QuoteDetailsPage, result);
      }
    },
    data() {
      return {}
    },
    created() {
      this.search('');
    }
  }
</script>
