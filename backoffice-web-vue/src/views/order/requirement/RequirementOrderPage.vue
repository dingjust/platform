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
          <el-button type="text" v-if="isBrand()&&props.item.status=='PENDING_QUOTE'" icon="el-icon-delete" @click="onCancelled(props.item)">关闭</el-button>
        </template>
      </requirement-order-search-result-list>
    </el-card>

    <el-dialog :visible.sync="detailsDialogVisible" width="80%"  class="purchase-dialog">
      <requirement-order-details-page :slotData="slotData" @onSearchQuotes="onSearchQuotes" :readOnly="false">

      </requirement-order-details-page>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions,mapMutations} = createNamespacedHelpers('RequirementOrdersModule');

  import RequirementOrderToolbar from "./toolbar/RequirementOrderToolbar";
  import RequirementOrderSearchResultList from './list/RequirementOrderSearchResultList';
  import RequirementOrderDetailsPage from './details/RequirementOrderDetailsPage';
  import RequirementOrderSimpleForm from './form/RequirementOrderSimpleForm';

  export default {
    name: 'RequirementOrderPage',
    components: {
      RequirementOrderDetailsPage,
      RequirementOrderToolbar,
      RequirementOrderSearchResultList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData',
        quoteQueryFormData: 'quoteQueryFormData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        searchQuotesAdvanced: 'searchQuotesAdvanced'
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch'
      }),
      onSearch(page, size) {
        this.setIsAdvancedSearch(false);
        const keyword = this.keyword;
        const statuses = this.statuses;

        const url = this.apis().getRequirementOrders();
        this.search({url, keyword, statuses, page, size});
      },
      onAdvancedSearch(page, size) {
        this.setIsAdvancedSearch(true);

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

        this.slotData = result;
        this.detailsDialogVisible = !this.detailsDialogVisible;
        this.onSearchQuotes(0, 8);
      },
      async onCancelled(item) {
        const url = this.apis().cancelledRequirementOrder(item.code);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('需求关闭成功，订单编号： ' + result);
        this.onSearch();
      },
      onNew(formData) {
        this.fn.openSlider('发布需求', RequirementOrderDetailsPage, formData);
      },
      onSimpleNew(formData) {
        this.fn.openSlider('急速发布需求', RequirementOrderSimpleForm, formData);
      },
      onSearchQuotes (page, size) {
        const url = this.apis().getQuotes();
        var queryFormData = Object.assign({}, this.quoteQueryFormData);
        queryFormData.requirementOrderRef = this.slotData.code;

        this.searchQuotesAdvanced({url, query: queryFormData, page, size});
      },
    },
    data() {
      return {
        slotData: '',
        isAdvancedSearch: this.$store.state.RequirementOrdersModule.isAdvancedSearch,
        detailsDialogVisible: false
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
