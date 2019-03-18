<template>
  <div class="animated fadeIn content">
    <el-card>
      <requirement-order-toolbar @onNew="onNew"
                                 @onSimpleNew="onSimpleNew"
                                 @onSearch="onSearch"
                                 @onAdvancedSearch="onAdvancedSearch"/>
      <requirement-order-search-result-list :page="page"
                                            @onDetails="onDetails"
                                            @onSearch="onSearch"
                                            @onAdvancedSearch="onAdvancedSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandRequirementOrdersModule');

  import RequirementOrderToolbar from "./toolbar/RequirementOrderToolbar";
  import RequirementOrderSearchResultList from './list/RequirementOrderSearchResultList';
  import RequirementOrderDetailsPage from './details/RequirementOrderDetailsPage';
  import RequirementOrderSimpleForm from './form/RequirementOrderSimpleForm';

  export default {
    name: 'RequirementOrderPage',
    components: {
      RequirementOrderToolbar,
      RequirementOrderSearchResultList
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
        this.search({keyword, statuses, page, size});
      },
      onAdvancedSearch(page, size) {
        this.isAdvancedSearch = true;

        const query = this.queryFormData;
        this.searchAdvanced({query, page, size});
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
        this.fn.openSlider('急速发布需求', RequirementOrderSimpleForm, formData);
      },
    },
    data() {
      return {
        keyword: this.$store.state.BrandRequirementOrdersModule.keyword,
        formData: this.$store.state.BrandRequirementOrdersModule.formData,
        queryFormData: this.$store.state.BrandRequirementOrdersModule.queryFormData,
        isAdvancedSearch: this.$store.state.BrandRequirementOrdersModule.isAdvancedSearch,
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
