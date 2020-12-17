<template>
  <div class="animated fadeIn">
    <el-dialog :visible.sync="proofingDetailDialogVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
      <proofing-details-page :slotData="proofingDetailData" @onRefresh="getProofing">

      </proofing-details-page>
    </el-dialog>
    <el-dialog :visible.sync="quoteDetailDialogVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
      <quote-details-page :slotData="quoteDetailData" :readOnly="true">

      </quote-details-page>
    </el-dialog>
    <el-dialog :visible.sync="requirementDetailDialogVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
      <requirement-order-details-page :slotData="requirementDetailData"
                                      :readOnly="true">

      </requirement-order-details-page>
    </el-dialog>
    <el-dialog @open="getContract" @close="initContract" :visible.sync="purchaseDetailDialogVisible" width="85%"
               class="purchase-dialog" :close-on-click-modal="false">
      <purchase-order-details-page :contracts="contracts" :slotData="purchaseDetailData"
                                   @closeDialogDetailVisible="closePurchaseDialogDetailVisible"/>
    </el-dialog>
    <el-row>
      <el-button  class="toolbar-search_input" @click="onRead">标记已读</el-button>
      <!--<el-button  @click="onNotRead">标记未读</el-button>-->
      <el-button  @click="onDelete">删除消息</el-button>
    </el-row>
    <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :row-style="{cursor:'pointer'}"
              :height="autoHeight" @row-click="openOrderDialog" @selection-change="handleSelectionChange" :row-key="(row)=> row.code">
      <el-table-column
        :reserve-selection="true"
        type="selection"
        width="55">
      </el-table-column>
      <el-table-column label="内容" prop="body">
        <template slot-scope="scope">
          <span :style="{fontWeight: isRead(scope.row.read),}"> {{scope.row.body}}</span>
          <!--<a v-if='scope.row.groupCode == 1' :style="{fontWeight: isRead(scope.row.read),cursor:'pointer'}" @click="openOrderDialog(scope.row)">去看看>></a>-->
        </template>
      </el-table-column>f
      <el-table-column label="时间" prop="creationtime" width="350">
        <template slot-scope="scope">
          <span :style="{fontWeight: isRead(scope.row.read)}"> {{scope.row.creationtime | formatDateWithSecond}}</span>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged"
                   @current-change="onCurrentPageChanged"
                   :current-page="page.number + 1"
                   :page-size="page.size"
                   :page-count="page.totalPages"
                   :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import RequirementOrderRequestForm from '@/views/order/requirement/form/RequirementOrderRequestForm';
  import ProofingDetailsPage from '../../../order/proofing/details/ProofingDetailsPage';
  import RequirementOrderDetailsPage from '../../../order/requirement/details/RequirementOrderDetailsPage';
  import PurchaseOrderDetailsPage from '../../../order/purchase/details/PurchaseOrderDetailsPage';
  import QuoteDetailsPage from '../../../order/quote/details/QuoteDetailsPage';
  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'PurchaseOrdersModule'
  );

  export default {
    name: 'MessageList',
    props: ['page'],
    components: {
      QuoteDetailsPage,
      PurchaseOrderDetailsPage,
      RequirementOrderDetailsPage,
      ProofingDetailsPage,
      RequirementOrderRequestForm},
    computed: {
      ...mapGetters({
      })
    },
    methods: {
      ...mapActions({
        search: 'search'
      }),
      ...mapMutations({
      }),
      isRead (row) {
        if (!row) {
          return 'bold';
        }
        return 'unset';
      },
      onPageSizeChanged (val) {
        // this._reset();

        // if (this.isAdvancedSearch) {
        //   this.$emit('onAdvancedSearch', val);
        //   return;
        // }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        this.$emit('onSearch', val - 1);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      _reset () {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      clickRow (row) {
        // this.$refs.resultTable.toggleRowSelection(row);
      },
      handleSelectionChange (val) {
        this.selectItems = val;
      },
      async onRead () {
        if (this.selectItems.length <= 0) {
          this.$message.error('请选择消息');
          return;
        }
        var uid = this.$store.getters.currentUser.uid;
        // 标记已读
        const url = this.apis().readMsgs(uid);
        const data = this.selectItems.map((item) => item.code);
        const result = await this.$http.post(url, data);
        if (result['errors']) {
          this.$message.error('系统出错');
          return;
        }
        if (result != null && result.code === '0') {
          this.$message.error('标记失败');
          return;
        }
        this.$message.success('标记已读成功');
        this.$emit('refreshData');
        this.$refs.resultTable.clearSelection();
      },
      async onReadOne (item) {
        var uid = this.$store.getters.currentUser.uid;
        // 标记已读
        const url = this.apis().readMsgs(uid);
        const data = [item.code];
        const result = await this.$http.post(url, data);
        // if (result['errors']) {
        //   this.$message.error('系统出错');
        //   return;
        // }
        this.$emit('refreshData');
      },
      async onNotRead () {
        if (this.selectItems.length <= 0) {
          this.$message.error('请选择消息');
          return;
        }
        var uid = this.$store.getters.currentUser.uid;
        // 标记未读
        const url = this.apis().unReadMsgs(uid);
        const data = this.selectItems.map((item) => item.code);
        const result = await this.$http.post(url, data);
        if (result['errors']) {
          this.$message.error('系统出错');
          return;
        }
        if (result != null && result.code === '0') {
          this.$message.error('标记失败');
          return;
        }
        this.$message.success('标记未读成功');
        this.$emit('refreshData');
        this.$refs.resultTable.clearSelection();
      },
      async onDelete () {
        if (this.selectItems.length <= 0) {
          this.$message.error('请选择消息');
          return;
        }
        this.$confirm('此操作将永久删除该消息, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(async () => {
          var uid = this.$store.getters.currentUser.uid;
          // 删除消息
          const url = this.apis().deleteMsgs(uid);
          const data = this.selectItems.map((item) => item.code);
          const result = await this.$http.post(url, data);
          if (result['errors']) {
            this.$message.error('系统出错');
            return;
          }
          if (result != null && result.code === '0') {
            this.$message.error('删除消息失败');
            return;
          }
          this.$message.success('删除消息成功');
          this.$emit('refreshData');
          this.$refs.resultTable.clearSelection();
        })
      },
      openOrderDialog (row) {
        switch (row.moduleCode) {
          case 'newQuote':
          case 'refuseQuote':
          case 'adoptedQuote':
            this.getQuote(row.params);
            this.quoteDetailDialogVisible = !this.quoteDetailDialogVisible;
            if (!row.read) {
              this.onReadOne(row);
            }
            break;
          case 'proofingCreate':
          case 'proofingDeliver':
          case 'proofingReceived':
          case 'proofingPay':
            this.getProofing(row.params);
            this.proofingDetailDialogVisible = !this.proofingDetailDialogVisible;
            if (!row.read) {
              this.onReadOne(row);
            }
            break;
          case 'newPurchaseOrder':
          case 'purchaseDeliver':
          case 'purchaseReceived':
          case 'purchaseFactoryDelay':
          case 'purchaseBrandDelay':
          case 'payDeposit':
          case 'payTheRest':
          case 'progressUpdated':
            this.getPurchase(row.params);
            this.purchaseDetailDialogVisible = !this.purchaseDetailDialogVisible;
            if (!row.read) {
              this.onReadOne(row);
            }
            break;
          case 'recommendRequireOrder':
            this.getRequirement(row.params);
            this.requirementDetailDialogVisible = !this.requirementDetailDialogVisible;
            if (!row.read) {
              this.onReadOne(row);
            }
            break;
        }
      },
      async getProofing (code) {
        const url = this.apis().getProofing(code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.proofingDetailData = result;
      },
      async getQuote (code) {
        const url = this.apis().getQuote(code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.quoteDetailData = result;
      },
      async getRequirement (code) {
        const url = this.apis().getRequirementOrder(code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.requirementDetailData = result;
      },
      async getPurchase (code) {
        const url = this.apis().getPurchaseOrder(code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        // this.contentData = result;
        this.purchaseDetailData = result;
        // if (result.status != 'CANCELLED' && (result.creator != null || result.creator != undefined)) {
        //   if ((result.creator.uid != this.$store.getters.currentUser.companyCode) && result.cannelStatus == 'APPLYING') {
        //     this.cannelMsgVisible = true;
        //   }
        // }
      },
      async getContract () {
        const url = this.apis().getContractsList();
        const result = await this.$http.post(url, {
          orderCode: this.contentData.code
        }, {
          page: 0,
          size: 100
        });
        for (var i = 0; i < result.content.length; i++) {
          if (result.content[i].state !== 'INVALID') {
            this.contracts.push(result.content[i]);
          }
        };
      },
      initContract () {
        this.contracts = [];
        this.purchaseDetailDialogVisible = false;
      },
      closePurchaseDialogDetailVisible () {
        this.purchaseDetailDialogVisible = false;
      }
    },
    data () {
      return {
        selectItems: [],
        proofingDetailData: '',
        quoteDetailData: '',
        purchaseDetailData: null,
        requirementDetailData: '',
        contracts: [],
        proofingDetailDialogVisible: false,
        quoteDetailDialogVisible: false,
        requirementDetailDialogVisible: false,
        purchaseDetailDialogVisible: false
      }
    }
  }
</script>
