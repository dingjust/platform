<template>
  <div class="animated fadeIn content">
    <el-card>
      <requirement-order-toolbar :query-form-data="queryFormData"
                                 @onSearch="onSearch"
                                 @onNew="onNew"
                                 @onSimpleNew="onSimpleNew"
                                 @onAdvancedSearch="onAdvancedSearch"/>
      <requirement-order-search-result-list :page="page" @onDetails="onDetails"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandRequirementOrdersModule');

  import autoHeight from '@/mixins/autoHeight';

  import RequirementOrderToolbar from "./toolbar/RequirementOrderToolbar";
  import RequirementOrderSearchResultList from './list/RequirementOrderSearchResultList';
  import RequirementOrderDetailsPage from './details/RequirementOrderDetailsPage';
  import RequirementOrderSimpleForm from './form/RequirementOrderSimpleForm';

  export default {
    name: 'RequirementOrderPage',
    mixins: [autoHeight],
    computed: {
      ...mapGetters({
        page: 'page'
      })
    },
    components: {
      RequirementOrderToolbar,
      RequirementOrderSearchResultList
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch() {
        this._onSearch(0);
      },
      onAdvancedSearch() {
        this.advancedSearch = true;
        this._onAdvancedSearch(0)
      },
      _onSearch(page, size) {
        const keyword = this.text;
        const statuses = this.statuses;
        this.search({keyword, statuses, page, size});
      },
      _onAdvancedSearch(page, size) {
        const query = this.queryFormData;
        this.searchAdvanced({query, page, size});
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      async onDetails(item) {
        const result = await this.$http.get('/b2b/orders/requirement/' + item.code);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('需求订单：' + item.code, RequirementOrderDetailsPage, result);
      },
      onNew(formData) {
        this.fn.openSlider('发布需求', RequirementOrderDetailsPage, formData);
      },
      onSimpleNew(formData) {
        this.fn.openSlider('发布需求', RequirementOrderSimpleForm, formData);
      },
      onCurrentPageChanged(val) {
        if (this.advancedSearch) {
          this._onAdvancedSearch(val - 1);
        } else {
          this._onSearch(val - 1);
        }
      },
      onPageSizeChanged(val) {
        this.reset();
        if (this.advancedSearch) {
          this._onAdvancedSearch(0, val);
        } else {
          this._onSearch(0, val);
        }
      },
    },
    data() {
      return {
        text: this.$store.state.BrandRequirementOrdersModule.keyword,
        formData: this.$store.state.BrandRequirementOrdersModule.formData,
        queryFormData: this.$store.state.BrandRequirementOrdersModule.queryFormData,
        advancedSearch: false,
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
