<template>
  <div class="animated fadeIn content">
    <el-card>
      <quote-toolbar @onSearch="onSearch" @onAdvancedSearch="onAdvancedSearch"/>
      <quote-search-result-list :page="page"
                                @onSearch="onSearch"
                                @onAdvancedSearch="onAdvancedSearch">
        <template slot="operations" slot-scope="props">
          <el-button type="text" icon="el-icon-edit"
                     @click="onDetails(props.item)">
            明细
          </el-button>
          <el-button v-if="isFactory()&&props.item.state=='BUYER_APPROVED'" type="text" icon="el-icon-edit"
                     @click="onCreatePurchaseOrder(props.item)">
            生产
          </el-button>
          <el-button v-if="isFactory()&&props.item.state=='BUYER_APPROVED'" type="text" icon="el-icon-edit"
                     @click="onCreateProofing(props.item)">
            打样
          </el-button>
          <el-button v-if="isFactory()&&props.item.state=='BUYER_REJECTED'&&props.item.requirementOrder.status=='PENDING_QUOTE'" type="text" icon="el-icon-edit"
                     @click="onReQuote(props.item)">
            重新报价
          </el-button>

        </template>
      </quote-search-result-list>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('QuotesModule');

  import QuoteToolbar from './toolbar/QuoteToolbar';
  import QuoteSearchResultList from './list/QuoteSearchResultList';
  import QuoteDetailsPage from "./details/QuoteDetailsPage";
  import PurchaseOrderDetailsPage from "../purchase/details/PurchaseOrderDetailsPage";
  import ProofingDetailsPage from "../proofing/details/ProofingDetailsPage";

  export default {
    name: 'QuotePage',
    components: {
      QuoteToolbar,
      QuoteSearchResultList
    },
    computed: {
      ...mapGetters({
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;

        const url = this.apis().getQuotes();
        this.search({url, keyword, statuses, page, size});
      },
      onAdvancedSearch(page, size) {
        this.isAdvancedSearch = true;

        const query = this.queryFormData;
        const url = this.apis().getQuotes();
        this.searchAdvanced({url, query, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getQuote(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('报价单明细，单号：' + item.code, QuoteDetailsPage, result);
      },
      onCreatePurchaseOrder(item) {
        let formData = {};
        Object.assign(formData, this.purchaseOrderFormData);
        formData.quoteRef = item.code;

        this.fn.openSlider('创建生产订单，报价单号：' + item.code, PurchaseOrderDetailsPage, formData);
      },
      onCreateProofing(item) {
        let formData = {};
        Object.assign(formData, this.proofingFormData);
        formData.quoteRef = item.code;

        this.fn.openSlider('创建打样订单，报价单号：' + item.code, ProofingDetailsPage, formData);
      },
      onReQuote(item) {
        let formData = {};
        Object.assign(formData, item);
        // formData.quoteRef = item.code;
        formData.id = null;

        this.fn.openSlider('重新报价，需求单号：' + item.requirementOrder.details.code, QuoteDetailsPage, formData);
      }
    },
    data() {
      return {
        keyword: this.$store.state.QuotesModule.keyword,
        formData: this.$store.state.QuotesModule.formData,
        queryFormData: this.$store.state.QuotesModule.queryFormData,
        purchaseOrderFormData: this.$store.state.PurchaseOrdersModule.formData,
        proofingFormData: this.$store.state.ProofingsModule.formData,
        isAdvancedSearch: this.$store.state.QuotesModule.isAdvancedSearch,
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
