<template>
  <div class="animated fadeIn content requirement">
    <el-card>
      <el-row  type="flex" justify="space-between" align="middle">
        <div class="factory-info-title rowClass">
          <h6 class="factory-info-title_text">需求订单列表</h6>
        </div>
        <el-tag style="padding: 14px 15px;margin-bottom:14px;line-height: 0px;background-color: #ffd60c;color: black;cursor: pointer"
          @click="onNew">
          <span style="font-size: 14px">+ </span>发布需求
        </el-tag>
      </el-row>

      <requirement-order-toolbar
                                 @onSimpleNew="onSimpleNew"
                                 @clearQueryFormData="clearQueryFormData"
                                 @onAdvancedSearch="onAdvancedSearch"/>
      <el-tabs v-model="activeName" @tab-click="handleTabClick">
        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
          <requirement-order-search-result-list :page="page"
                                                @onSearch="onSearch"
                                                @onAdvancedSearch="onAdvancedSearch">
            <template slot="operations" slot-scope="props">
              <el-button-group>
                <el-button type="text" style="color: black" @click="onDetails(props.item)">详情</el-button>
                <el-button v-if="props.item.status == 'PENDING_QUOTE'"  type="text" style="cursor: unset;color: black" disabled>|</el-button>
                <el-button v-if="props.item.status == 'PENDING_QUOTE'" type="text" style="color: black" @click="onCancelled(props.item)">关闭</el-button>
              </el-button-group>
            </template>
          </requirement-order-search-result-list>
        </el-tab-pane>
      </el-tabs>

    </el-card>

    <el-dialog :visible.sync="detailsDialogVisible" width="80%"  class="purchase-dialog">
      <requirement-order-details-page :slotData="slotData" @onSearchQuotes="onSearchQuotes" :readOnly="false">

      </requirement-order-details-page>
    </el-dialog>
    <el-dialog :visible.sync="formDialogVisible" width="80%"  class="requirement-form-dialog">
      <requirement-order-form v-if="formDialogVisible" :formData="formData" @onSave="onSave">

      </requirement-order-form>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions, mapMutations} = createNamespacedHelpers('RequirementOrdersModule');

  import RequirementOrderToolbar from './toolbar/RequirementOrderToolbar';
  import RequirementOrderSearchResultList from './list/RequirementOrderSearchResultList';
  import RequirementOrderDetailsPage from './details/RequirementOrderDetailsPage';
  import RequirementOrderSimpleForm from './form/RequirementOrderSimpleForm';
  import RequirementOrderForm from './form/RequirementOrderForm';

  export default {
    name: 'RequirementOrderPage',
    components: {
      RequirementOrderForm,
      RequirementOrderDetailsPage,
      RequirementOrderToolbar,
      RequirementOrderSearchResultList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData',
        quoteQueryFormData: 'quoteQueryFormData',
        formData: 'formData',
        categories: 'categories'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        searchQuotesAdvanced: 'searchQuotesAdvanced',
        clearFormData: 'clearFormData',
        clearQueryFormData: 'clearQueryFormData'
      }),
      ...mapMutations({
        setIsAdvancedSearch: 'isAdvancedSearch',
        isShowDetailPrice: 'isShowDetailPrice',
        setCategories: 'categories'
      }),
      onSearch (page, size) {
        this.setIsAdvancedSearch(false);
        const keyword = this.keyword;
        const statuses = this.statuses;

        const url = this.apis().getRequirementOrders();
        this.search({url, keyword, statuses, page, size});

        if (this.categories <= 0) {
          this.getMinorCategories();
        }
      },
      onAdvancedSearch (page, size) {
        this.setIsAdvancedSearch(true);

        const query = this.queryFormData;
        const url = this.apis().getRequirementOrders();
        this.searchAdvanced({url, query, page, size});

        if (this.categories <= 0) {
          this.getMinorCategories();
        }
      },
      async onDetails (item) {
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
      async onCancelled (item) {
        this.$confirm('是否确认关闭该订单', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(async () => {
          const url = this.apis().cancelledRequirementOrder(item.code);
          const result = await this.$http.delete(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.$message.success('需求关闭成功，订单编号： ' + result);
          this.onAdvancedSearch();
        });
      },
      onNew (formData) {
        this.formDialogVisible = !this.formDialogVisible;
      },
      onSimpleNew (formData) {
        this.fn.openSlider('急速发布需求', RequirementOrderSimpleForm, formData);
      },
      onSearchQuotes (page, size) {
        const url = this.apis().getQuotes();
        var queryFormData = Object.assign({}, this.quoteQueryFormData);
        queryFormData.requirementOrderRef = this.slotData.code;

        this.searchQuotesAdvanced({url, query: queryFormData, page, size});
      },
      async onSave (factories, phoneNumbers) {
        console.log(factories);
        var params = {};
        if (factories != null) {
          var text = '';
          for (let uid of factories) {
            text += uid;
            text += ',';
          }
          text = text.slice(0, text.length - 1);
        }
        console.log(text);
        params['factories'] = text;
        const url = this.apis().createRequirementOrder();
        const result = await this.$http.post(url, this.formData, params);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('需求订单创建成功，订单编号： ' + result);
        this.formDialogVisible = !this.formDialogVisible;
        this.onSearch();
      },
      async getMinorCategories () {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setCategories(result);
      },
      handleTabClick (tab) {
        if (tab.name !== 'ALL') {
          this.queryFormData.statuses = tab.name;
        } else {
          this.queryFormData.statuses = [];
        }

        this.onAdvancedSearch();
      }
    },
    data () {
      return {
        slotData: '',
        isAdvancedSearch: this.$store.state.RequirementOrdersModule.isAdvancedSearch,
        detailsDialogVisible: false,
        formDialogVisible: false,
        statuses: [
          {
            code: 'ALL',
            name: '全部'
          },
          {
            code: 'PENDING_QUOTE',
            name: '报价中'
          },
          {
            code: 'COMPLETED',
            name: '已完成'
          },
          {
            code: 'CANCELLED',
            name: '已关闭'
          }
        ],
        activeName: 'ALL'
      };
    },
    watch: {
      'formDialogVisible': function (n, o) {
        if (!n) {
          this.clearFormData();
          // this.clearFactoryQueryFormData();
        }
      },
      'detailsDialogVisible': function (n, o) {
        if (!n) {
          this.isShowDetailPrice(false);
        }
      }
    },
    created () {
      this.onAdvancedSearch();
    },
    destroyed() {
      this.clearQueryFormData();
    }
  };
</script>

<style>
  .requirement .factory-info-title {
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .requirement .factory-info-title_text {
    font-size: 12px;
    font-weight: bold;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .requirement .rowClass {
    margin-bottom: 20px;
  }

  .requirement .requirement-form-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .requirement .requirement-form-dialog-header {
    padding: 0px !important;
  }

  .requirement .requirement-form-dialog .el-dialog__header {
    padding: 0px !important;
  }
</style>
