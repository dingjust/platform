<template>
  <div class="animated fadeIn content">
    <el-card>
      <requirement-order-toolbar @onSearch="onSearch"
                                 @onAdvancedSearch="onAdvancedSearch"/>
      <requirement-order-search-result-list :page="page"
                                            @onSearch="onSearch"
                                            @onAdvancedSearch="onAdvancedSearch">
        <template slot="operations" slot-scope="props">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(props.item)">明细</el-button>
          <el-button type="text" icon="el-icon-edit" :disabled="!isPendingQuote(props.item)"
                     @click="onQuoting(props.item)">
            报价
          </el-button>
        </template>
      </requirement-order-search-result-list>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('RequirementOrdersModule');

  import RequirementOrderToolbar from "@/views/order/requirement/toolbar/RequirementOrderToolbar";
  import RequirementOrderSearchResultList from '@/views/order/requirement/list/RequirementOrderSearchResultList';
  import RequirementOrderDetailsPage from '@/views/order/requirement/details/RequirementOrderDetailsPage';

  import QuoteDetailsPage from '@/views/order/quote/details/QuoteDetailsPage';

  export default {
    name: 'FactoryDashboardPage',
    components: {
      RequirementOrderToolbar,
      RequirementOrderSearchResultList
    },
    computed: {
      ...mapGetters({
        page: 'page'
      }),
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;
        const url = this.apis().getAllRequirementOrders();
        this.search({url, keyword, statuses, page, size});
      },
      onAdvancedSearch(page, size) {
        this.isAdvancedSearch = true;

        const query = this.queryFormData;
        const url = this.apis().getAllRequirementOrders();
        this.searchAdvanced({url, query, page, size});
      },
      async onDetails(item) {
        const url = this.apis().getRequirementOrder(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('需求订单：' + item.code, RequirementOrderDetailsPage, result);
      },
      onQuoting(item) {
        console.log('报价: ' + JSON.stringify(item));
        let quoteFormData = {};
        Object.assign(quoteFormData, this.quoteFormData);
        quoteFormData.requirementOrder = item;

        // 填写报价单
        this.fn.openSlider('填写报价单，需求编号：' + item.code, QuoteDetailsPage, quoteFormData);
      },
      isPendingQuote: function (row) {
        return row.status === 'PENDING_QUOTE';
      },
    },
    data() {
      return {
        keyword: this.$store.state.RequirementOrdersModule.keyword,
        queryFormData: this.$store.state.RequirementOrdersModule.queryFormData,
        quoteFormData: this.$store.state.RequirementOrdersModule.quoteFormData,
        isAdvancedSearch: this.$store.state.RequirementOrdersModule.isAdvancedSearch,
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
