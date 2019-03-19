<template>
  <div class="animated fadeIn content">
    <el-card>
      <requirement-order-toolbar @onNew="onNew"
                                 @onSimpleNew="onSimpleNew"
                                 @onSearch="onSearch"
                                 @onAdvancedSearch="onAdvancedSearch"/>
      <requirement-order-search-result-list :page="page"
                                            @onSearch="onSearch"
                                            @onAdvancedSearch="onAdvancedSearch">
        <template slot="operations" slot-scope="props">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(props.item)">明细</el-button>
        </template>
      </requirement-order-search-result-list>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('RequirementOrdersModule');

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
        const url = this.apis().getRequirementOrders();
        this.search({url, keyword, statuses, page, size});
      },
      onAdvancedSearch(page, size) {
        this.isAdvancedSearch = true;

        const query = this.queryFormData;
        const url = this.apis().getRequirementOrders();
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
      onNew(formData) {
        this.fn.openSlider('发布需求', RequirementOrderDetailsPage, formData);
      },
      onSimpleNew(formData) {
        this.fn.openSlider('急速发布需求', RequirementOrderSimpleForm, formData);
      },
    },
    data() {
      return {
        keyword: this.$store.state.RequirementOrdersModule.keyword,
        formData: this.$store.state.RequirementOrdersModule.formData,
        queryFormData: this.$store.state.RequirementOrdersModule.queryFormData,
        isAdvancedSearch: this.$store.state.RequirementOrdersModule.isAdvancedSearch,
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
