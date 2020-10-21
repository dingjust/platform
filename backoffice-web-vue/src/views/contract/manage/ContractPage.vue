<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="dialogTableVisible" width="80%" :close-on-click-modal="false">
      <contract-details  :slotData="contractData" />
    </el-dialog>
    <el-dialog :visible.sync="pdfVisible" :show-close="true" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <contract-preview-pdf :fileUrl="fileUrl" :slotData="thisContract" @closePdfVisible="pdfVisible=false" @onSearch="onSearch"/>
    </el-dialog>
    <!--<div class="report">-->
      <!--<contract-report />-->
    <!--</div>-->
    <el-card>
      <el-row>
        <el-col>
          <div class="contract-list-title">
            <h6>合同列表</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <contract-toolbar @openPreviewPdf="openPreviewPdf" :queryFormData="queryFormData" 
                        style="margin-bottom: 10px;" @onNew="onNew" @onSearch="onSearch" @onAdvancedSearch="onSearch"
                        :dataQuery="dataQuery" @onResetQuery="onResetQuery"/>
      <div>
        <div class="tag-container" :class="tagPosition ? 'tag-position' : ''">
          <el-row ref="tag" type="flex" justify="end" align="top">
            <Authorized :permission="['AGREEMENT_CREATE']">
              <el-button class="pr-create-btn" @click="dialogVisible = true">创建合同</el-button>
            </Authorized>
          </el-row>
        </div>
        <el-tabs ref="tabs" v-model="activeName" @tab-click="handleClick">
          <template v-for="item in contractStatues">
            <el-tab-pane :name="item" :key="item" :label="item">
              <!-- <span slot="label">
                <tab-label-bubble :label="item" :num="index" />
              </span> -->
              <contract-search-result-list :page="page" @onDetails="onDetails" @onSearch="onSearch" @onAdvancedSearch="onSearch"
                                            @closePdfVisible="pdfVisible = false" @previewPdf="openPreviewPdf"/>
            </el-tab-pane>
          </template>
        </el-tabs>
      </div>
    </el-card>
    <el-dialog :visible.sync="dialogVisible" width="80%" class="purchase-dialog" :close-on-click-modal="false" append-to-body>
      <contract-type v-if="dialogVisible" @onSearch="onSearch" @onAdvancedSearch="onSearch"
                      @closeContractTypeDialog="dialogVisible = false" @openPreviewPdf="openPreviewPdf"/>
    </el-dialog>
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
  import ContractPreviewPdf from './components/ContractPreviewPdf';
  import ContractType from './components/ContractType'

  // import PurchaseOrderDetailsPage from "./details/PurchaseOrderDetailsPage";

  export default {
    name: 'ContractPage',
    components: {
      ContractPreviewPdf,
      ContractToolbar,
      ContractSearchResultList,
      ContractReport,
      TabLabelBubble,
      ContractDetails,
      ContractType
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
        if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
          this.onResetQuery();
        }
        const query = this.queryFormData;
        const url = this.apis().getContractsList();
        this.search({
          url,
          query,
          page,
          size
        });

        this.$nextTick(() => {
          this.changeTagPosition();
        })
      },
      changeTagPosition () {
        let count = 20;
        this.contractStatues.forEach(item => {
          count += document.getElementById("tab-" + item).scrollWidth
        })
        if (this.tagWidth === 0) {
          this.tagWidth = this.$refs.tag.$el.scrollWidth
        }
        this.tagPosition = this.tagWidth + count < this.$refs.tabs.$el.scrollWidth;
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
          this.onSearch(0, 10);
        } else {
          this.queryFormData.state = state;
          this.onSearch(0, 10);
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
      },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      },
    },
    data () {
      return {
        formData: this.$store.state.PurchaseOrdersModule.formData,
        activeName: '全部',
        contractStatues: ['待我签署', '待他签署', '已签署', '已作废', '全部'],
        dialogTableVisible: false,
        contractData: '',
        pdfVisible: false,
        fileUrl: '',
        thisContract: '',
        dialogVisible: false,
        queryFormData: {
          title: '',
          orderCode: '',
          creationtimeStart: '',
          creationtimeEnd: '',
          type: '',
          state: '',
          partner: ''
        },
        dataQuery: {},
        tagPosition: true,
        tagWidth: 0,
      };
    },
    mounted() {
      let that = this;
      window.addEventListener('resize', function () {
        that.$nextTick(() => {
          that.changeTagPosition();
        })
      })
    },
    created () {
      this.dataQuery = this.getDataPerQuery('COMPANY_AGREEMENT');
      this.onResetQuery();
      this.onSearch(0, 10);
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

  .contract-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }


  .tag-position {
    position: absolute;
  }

  .tag-container {
    right: 35px;
    margin-top: 4px;
    z-index: 999;
  }

  .pr-create-btn {
    background-color: #ffd60c;
    width: 110px;
  } 

  .pr-create-btn:focus {
    background: #ffd60c;
    color: #606266;
  }

  .pr-create-btn:hover {
    background: #ffd60c;
    color: #606266;
  }
</style>
