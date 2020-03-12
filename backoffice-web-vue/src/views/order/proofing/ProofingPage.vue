<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>打样订单列表</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <proofing-toolbar @onAdvancedSearch="onAdvancedSearch" @clearQueryFormData="clearQueryFormData"/>

      <el-tabs v-model="activeName" @tab-click="handleTabClick">
        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
          <proofing-search-result-list :page="page"
                                       @onSearch="onAdvancedSearch"
                                       @onDetails="onDetails"
                                       @onShowQuote="onShowQuote"
                                       @onShowRequirement="onShowRequirement">
            <template slot="operations" slot-scope="props">
              <el-row v-if="props.item.status == 'PENDING_PAYMENT'">
                <el-button type="text" class="list-button" @click="onDetails(props.item)">详情</el-button>
                <el-divider v-if="closeShow" direction="vertical"></el-divider>
                <el-button v-if="closeShow" type="text" class="list-button" @click="onCancel(props.item)">关闭</el-button>
              </el-row>
              <el-row v-else>
                <el-button type="text" class="list-button" @click="onDetails(props.item)">详情</el-button>
              </el-row>
            </template>
          </proofing-search-result-list>
        </el-tab-pane>
      </el-tabs>

    </el-card>

    <el-dialog :visible.sync="detailsDialogVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
      <proofing-details-page :slotData="slotData" @onRefresh="getProofing" @onAdvancedSearch="onAdvancedSearch">

      </proofing-details-page>
    </el-dialog>

    <el-dialog :visible.sync="quoteDetailsDialogVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
      <quote-details-page :slotData="quoteData">

      </quote-details-page>
    </el-dialog>

    <el-dialog :visible.sync="requirementDetailsDialogVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
      <requirement-order-details-page :slotData="requirementData">

      </requirement-order-details-page>
    </el-dialog>
    <el-dialog title="关闭" :visible.sync="proofingCloseVisible" width="30%" :close-on-click-modal="false">
      <proofing-close-dialog v-if="proofingCloseVisible"
                                      @onCancel="onCloseCancel" @onConfirm="onCloseConfirm"/>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('ProofingsModule');

  import ProofingToolbar from './toolbar/ProofingToolbar';
  import ProofingSearchResultList from './list/ProofingSearchResultList';

  import QuoteDetailsPage from '../quote/details/QuoteDetailsPage';
  import RequirementOrderDetailsPage from '../requirement/details/RequirementOrderDetailsPage';
  import ProofingDetailsPage from './details/ProofingDetailsPage';
  import ProofingCloseDialog from './form/ProofingCloseDialog';
  import {hasPermission} from '../../../auth/auth';

  export default {
    name: 'ProofingPage',
    components: {
      ProofingCloseDialog,
      ProofingDetailsPage,
      RequirementOrderDetailsPage,
      QuoteDetailsPage,
      ProofingToolbar,
      ProofingSearchResultList
    },
    computed: {
      ...mapGetters({
        queryFormData: 'queryFormData',
        categories: 'categories',
        page: 'page'
      }),
      closeShow: function () {
        return (this.isFactory() && hasPermission(this.permission.proofingOrderClose)) || this.isTenant()
      }
    },
    methods: {
      ...mapMutations({
        setCategories: 'categories',
        setIsAdvancedSearch: 'isAdvancedSearch'
      }),
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        clearQueryFormData: 'clearQueryFormData'
      }),
      onSearch (page, size) {
        // this.setIsAdvancedSearch(false);
        const keyword = this.keyword;
        const url = this.apis().getProofings();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch (page, size) {
        // this.setIsAdvancedSearch(true);
        const query = this.queryFormData;
        const url = this.apis().getProofings();
        this.searchAdvanced({url, query, page, size});

        if (this.categories <= 0) {
          this.getMinorCategories();
        }
      },
      async getProofing (code) {
        const url = this.apis().getProofing(code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        console.log(result);

        this.slotData = result;
      },
      async onDetails (row) {
        this.getProofing(row.code);
        this.detailsDialogVisible = !this.detailsDialogVisible;
      },
      async onCancel (item) {
        this.$confirm('是否关闭订单', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          if (this.isTenant()) {
            this.onCloseDialog(item);
          } else {
            this._onCancel(item);
          }
        });
      },
      onCloseDialog (item) {
        this.closeItem = Object.assign({}, item);
        this.proofingCloseVisible = true;
      },
      // 平台关闭打样订单
      async onCloseConfirm (msg) {
        let formData = {
          'msg': msg
        }
        const url = this.apis().platformCancellingOfProofing(this.closeItem.code);
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.closeItem = {};
        this.$message.success('打样订单关闭成功');
        this.proofingCloseVisible = false;

        this.onAdvancedSearch();
      },
      async _onCancel (item) {
        const url = this.apis().cancellingOfProofing(item.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('关闭订单成功');
        this.onAdvancedSearch();
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
      },
      handleTabClick (tab) {
        if (tab.name !== 'ALL') {
          this.queryFormData.statuses = tab.name;
        } else {
          this.queryFormData.statuses = [];
        }

        this.onAdvancedSearch();
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
      onCloseCancel () {
        this.proofingCloseVisible = false;
      }
    },
    data () {
      return {
        detailsDialogVisible: false,
        quoteDetailsDialogVisible: false,
        requirementDetailsDialogVisible: false,
        quoteData: '',
        requirementData: '',
        slotData: '',
        activeName: 'ALL',
        closeItem: '',
        proofingCloseVisible: false,
        statuses: [
          {
            code: 'ALL',
            name: '全部'
          },
          {
            code: 'PENDING_PAYMENT',
            name: '待付款'
          },
          {
            code: 'PENDING_DELIVERY',
            name: '待发货'
          },
          {
            code: 'SHIPPED',
            name: '已发货'
          },
          {
            code: 'COMPLETED',
            name: '已完成'
          },
          {
            code: 'CANCELLED',
            name: '已取消'
          }
        ]
      }
    },
    created () {
      this.onAdvancedSearch();
    },
    destroyed () {
      this.clearQueryFormData();
    }
  }
</script>
