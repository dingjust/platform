<template>
  <div class="animated fadeIn content">
    <el-card>
      <proofing-toolbar @onSearch="onSearch"/>
      <proofing-search-result-list :page="page"
                                   @onSearch="onSearch"
                                   @onDetails="onDetails"
                                   @onShowQuote="onShowQuote"
                                   @onShowRequirement="onShowRequirement"/>
    </el-card>

    <el-dialog :visible.sync="detailsDialogVisible" width="80%"  class="purchase-dialog">
      <proofing-details-page :slotData="slotData">

      </proofing-details-page>
    </el-dialog>

    <el-dialog :visible.sync="quoteDetailsDialogVisible" width="80%"  class="purchase-dialog">
      <quote-details-page :slotData="quoteData">

      </quote-details-page>
    </el-dialog>

    <el-dialog :visible.sync="requirementDetailsDialogVisible" width="80%"  class="purchase-dialog">
      <requirement-order-details-page :slotData="requirementData">

      </requirement-order-details-page>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('ProofingsModule');

  import ProofingToolbar from './toolbar/ProofingToolbar';
  import ProofingSearchResultList from './list/ProofingSearchResultList';

  import QuoteDetailsPage from '../quote/details/QuoteDetailsPage';
  import RequirementOrderDetailsPage from '../requirement/details/RequirementOrderDetailsPage';
  import ProofingDetailsPage from './details/ProofingDetailsPage';

  export default {
    name: 'ProofingPage',
    components: {
      ProofingDetailsPage,
      RequirementOrderDetailsPage,
      QuoteDetailsPage,
      ProofingToolbar,
      ProofingSearchResultList
    },
    computed: {
      ...mapGetters({
        keyword: 'keyword',
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch (page, size) {
        const keyword = this.keyword;

        const url = this.apis().getProofings();
        this.search({url, keyword, page, size});
      },
      async onDetails (row) {
        const url = this.apis().getProofing(row.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        console.log(result);

        this.slotData = result;
        this.detailsDialogVisible = !this.detailsDialogVisible;
      },
      async onShowQuote (row) {
        const url = this.apis().getQuote(row.quoteRef);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.quoteData = result;
        this.quoteDetailsDialogVisible = !this.quoteDetailsDialogVisible;
      },
      async onShowRequirement (row) {
        const url = this.apis().getRequirementOrder(row.requirementOrderRef);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.requirementData = result;
        this.requirementDetailsDialogVisible = !this.requirementDetailsDialogVisible;
      }
    },
    data () {
      return {
        detailsDialogVisible: false,
        quoteDetailsDialogVisible: false,
        requirementDetailsDialogVisible: false,
        quoteData: '',
        requirementData: '',
        slotData: ''
      }
    },
    created () {
      this.onSearch();
    }
  }
</script>
