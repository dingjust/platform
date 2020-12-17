<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="orders-list-title">
          <h6>报价订单列表</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <quote-toolbar @clearQueryFormData="clearQueryFormData" @onAdvancedSearch="onAdvancedSearch"/>

      <el-tabs v-model="activeName" @tab-click="handleTabClick">
        <el-tab-pane v-for="status of statuses" :key="status.code" :label="status.name" :name="status.code">
          <quote-search-result-list :page="page"
                                    @onSearch="onSearch"
                                    @onAdvancedSearch="onAdvancedSearch">
            <template slot="operations" slot-scope="props">
              <el-row v-if="props.item.state == 'SELLER_SUBMITTED'">
                <el-button type="text" class="list-button" @click="onDetails(props.item)">详情</el-button>
<!--                <el-divider direction="vertical"></el-divider>-->
<!--                <el-button type="text" class="list-button" @click="onDetails(props.item)" v-if="!isTenant()">修改</el-button>-->
                <el-divider direction="vertical" v-if="!isTenant()"></el-divider>
                <el-button type="text" class="list-button" @click="onCannel(props.item)">关闭</el-button>
              </el-row>
              <el-row v-else>
                <el-button type="text" class="list-button" @click="onDetails(props.item)">详情</el-button>
              </el-row>
            </template>
          </quote-search-result-list>
        </el-tab-pane>
      </el-tabs>


    </el-card>

    <el-dialog :visible.sync="detailsDialogVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
      <quote-details-page :slotData="slotData" :readOnly="false">

      </quote-details-page>
    </el-dialog>
    <el-dialog title="关闭" :visible.sync="quoteCannelVisible" width="30%" :close-on-click-modal="false">
      <quote-cannel-visible v-if="quoteCannelVisible"
                                      @onCancel="onCloseCancel" @onConfirm="onCloseConfirm"/>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('QuotesModule');

  import QuoteToolbar from './toolbar/QuoteToolbar';
  import QuoteSearchResultList from './list/QuoteSearchResultList';
  import QuoteDetailsPage from './details/QuoteDetailsPage';
  import PurchaseOrderDetailsPage from '../purchase/details/PurchaseOrderDetailsPage';
  import ProofingDetailsPage from '../proofing/details/ProofingDetailsPage';
  import QuoteCannelVisible from './form/QuoteCancelVisible';

  export default {
    name: 'QuotePage',
    components: {
      QuoteCannelVisible,
      QuoteDetailsPage,
      QuoteToolbar,
      QuoteSearchResultList
    },
    computed: {
      ...mapGetters({
        keyword: 'keyword',
        page: 'page',
        queryFormData: 'queryFormData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        clearQueryFormData: 'clearQueryFormData'
      }),
      onSearch (page, size) {
        const keyword = this.keyword;
        const statuses = this.statuses;

        const url = this.apis().getQuotes();
        this.search({url, keyword, statuses, page, size});
      },
      onAdvancedSearch (page, size) {
        this.isAdvancedSearch = true;

        const query = this.queryFormData;
        const url = this.apis().getQuotes();
        this.searchAdvanced({url, query, page, size});
      },
      async onDetails (item) {
        const url = this.apis().getQuote(item.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.slotData = result;
        this.detailsDialogVisible = !this.detailsDialogVisible;
      },
      onCreatePurchaseOrder (item) {
        let formData = {};
        Object.assign(formData, this.purchaseOrderFormData);
        formData.quoteRef = item.code;

        this.fn.openSlider('创建生产订单，报价单号：' + item.code, PurchaseOrderDetailsPage, formData);
      },
      onCreateProofing (item) {
        let formData = {};
        Object.assign(formData, this.proofingFormData);
        formData.quoteRef = item.code;

        this.fn.openSlider('创建打样订单，报价单号：' + item.code, ProofingDetailsPage, formData);
      },
      onReQuote (item) {
        let formData = {};
        Object.assign(formData, item);
        // formData.quoteRef = item.code;
        formData.id = null;

        this.fn.openSlider('重新报价，需求单号：' + item.requirementOrder.details.code, QuoteDetailsPage, formData);
      },
      handleTabClick (tab) {
        if (tab.name !== 'ALL') {
          this.queryFormData.states = tab.name;
        } else {
          this.queryFormData.states = [];
        }

        this.onAdvancedSearch();
      },
      onCannel (item) {
        this.$confirm('是否确认关闭该报价订单', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          if (this.isTenant()) {
            this.onCloseDialog(item);
          } else {
            this._onCancell(item);
          }
        });
      },
      onCloseDialog (item) {
        this.closeItem = Object.assign({}, item);
        this.quoteCannelVisible = true;
      },
      // 平台关闭报价订单
      async onCloseConfirm () {
        const url = this.apis().platformCancelQuote(this.closeItem.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.closeItem = {};
        this.quoteCannelVisible = false;

        this.$message.success('取消报价订单成功');
        this.onAdvancedSearch(this.page.number);
      },
      async _onCancell (item) {
        const url = this.apis().cancelQuote(item.code);
        const result = await this.$http.put(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('取消报价订单成功');
        this.onAdvancedSearch(this.page.number);
      },
      onCloseCancel () {
        this.quoteCannelVisible = false;
      }
    },
    data () {
      return {
        formData: this.$store.state.QuotesModule.formData,
        purchaseOrderFormData: this.$store.state.PurchaseOrdersModule.formData,
        proofingFormData: this.$store.state.ProofingsModule.formData,
        isAdvancedSearch: this.$store.state.QuotesModule.isAdvancedSearch,
        detailsDialogVisible: false,
        quoteCannelVisible: false,
        closeItem: {},
        slotData: '',
        statuses: [
          {
            code: 'ALL',
            name: '全部'
          },
          {
            code: 'SELLER_SUBMITTED',
            name: '待处理'
          },
          {
            code: 'BUYER_APPROVED',
            name: '通过'
          },
          {
            code: 'BUYER_REJECTED',
            name: '拒绝'
          },
          {
            code: 'CANCELLED',
            name: '已取消'
          }
        ],
        activeName: 'ALL'
      };
    },
    created () {
      this.onSearch();
    },
    destroyed () {
      this.clearQueryFormData();
    }
  };
</script>
