<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="dialogTableVisible" width="80%">
      <contract-details  :slotData="contractData" />
    </el-dialog>
    <el-dialog :visible.sync="pdfVisible" :show-close="true" class="purchase-dialog" append-to-body>
      <contract-preview-pdf :fileUrl="fileUrl" :slotData="thisContract" @closePdfVisible="pdfVisible=false"/>
    </el-dialog>
    <!--<div class="report">-->
      <!--<contract-report />-->
    <!--</div>-->
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="orders-list-title">
            <h6>合同列表</h6>
          </div>
        </el-col>
      </el-row>
      <contract-toolbar @openPreviewPdf="openPreviewPdf" :queryFormData="queryFormData" style="margin-bottom: 10px;" @onNew="onNew" @onSearch="onSearch"/>
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <template v-for="(item, index) in contractStatues">
          <el-tab-pane :name="item">
            <span slot="label">
              <tab-label-bubble :label="item" :num="index" />
            </span>
            <contract-search-result-list :page="page" @onDetails="onDetails" @onSearch="onSearch" @closePdfVisible="pdfVisible = false" @previewPdf="openPreviewPdf"/>
          </el-tab-pane>
        </template>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers(
    'ContractModule'
  );

  import ContractToolbar from './toolbar/ContractToolbar';
  import ContractSearchResultList from './list/ContractSearchResultList';
  import ContractReport from './components/ContractReport';
  import ContractDetails from './components/ContractDetails';
  import TabLabelBubble from './components/TabLabelBubble';
  import ContractPreviewPdf from "./components/ContractPreviewPdf";

  // import PurchaseOrderDetailsPage from "./details/PurchaseOrderDetailsPage";

  export default {
    name: 'ContractPage',
    components: {
        ContractPreviewPdf,
      ContractToolbar,
      ContractSearchResultList,
      ContractReport,
      TabLabelBubble,
      ContractDetails
    },
    provide: {
      onSearch: this.onSearch
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        orderCode: 'orderCode',
        dateTime: 'dateTime',
        queryFormData: 'queryFormData',
        type: 'type'
      })
    },
    methods: {
      ...mapActions({
        search: 'search'
      }),
      ...mapMutations({
      }),
      onSearch (page, size) {
        const query = this.queryFormData;
        const url = this.apis().getContractsList();
        this.search({
          url,
          query,
          page,
          size
        });
      },
      // onAdvancedSearch(page, size) {
      //   this.setIsAdvancedSearch(true);
      //   const query = this.queryFormData;
      //   const url = this.apis().getContracts();
      //   this.searchAdvanced({
      //     url,
      //     query,
      //     page,
      //     size
      //   });
      // },
      async onDetails (row) {
        const url = this.apis().getContractDetail(row.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        // this.fn.openSlider('生产订单：' + result.code, PurchaseOrderDetailsPage, result);
        this.contractData = result.data;
        this.dialogTableVisible = true;
      },
      onNew (formData) {
        // this.fn.openSlider('创建手工单', PurchaseOrderDetailsPage, formData);
      },
      handleClick (tab, event) {
        var state = this.getEnumCode(tab.name);
        if (tab.name === '全部') {
          this.queryFormData.state = '';
          this.onSearch();
        } else {
          this.queryFormData.state = state;
          this.onSearch();
        }
      },
      getEnumCode (name) {
        if (name === '待签署') {
          return 'SIGN'
        }
        if (name === '待我签署') {
          return 'WAIT_ME_SIGN'
        }
        if (name === '待他签署') {
          return 'WAIT_PARTNER_SIGN'
        }
        if (name === '已签署') {
          return 'COMPLETE'
        }
        if (name === '已作废') {
          return 'INVALID'
        }
      },
      async openPreviewPdf (val, code) {
        this.thisContract = val;
        console.log(this.thisContract);
        let queryCode = '';
        if (code != null && code != '') {
          queryCode = code;
        } else {
          queryCode = val.code;
        }
        const url = this.apis().downContract(queryCode);
        const result = await this.$http.get(url);

        const aa = '/b2b/user/agreement/download/' + result.data;

        // const aa = 'https://sc.nbyjy.net/b2b/user/agreement/download/' + result.data;
        //
        // const aa = 'https://ht.nbyjy.net/b2b/user/agreement/download/' + result.data;
        // window.open('/static/pdf/web/viewer.html?file=' + encodeURIComponent(aa))
        this.pdfVisible = true;
        this.fileUrl = encodeURIComponent(aa)
      }
    },
    data () {
      return {
        formData: this.$store.state.PurchaseOrdersModule.formData,
        activeName: '全部',
        contractStatues: ['全部', '待我签署', '待他签署', '已签署', '已作废'],
        dialogTableVisible: false,
        contractData: '',
        pdfVisible: false,
        fileUrl: '',
        thisContract: ''
      };
    },
    created () {
      this.onSearch('');
    }
  };
</script>
<style>
  .report {
    margin-bottom: 10px;
  }

  .el-tabs__active-bar {
    background-color: #ffd60c;
    color: #ffd60c;
  }

  .el-tabs__item.is-active {
    color: #ffd60c;
  }

  .el-tabs__item:hover {
    color: #ffd60c;
  }

  .orders-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
