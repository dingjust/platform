<template>
  <div class="info-detail-staff-body">
    <el-dialog :visible.sync="dialogVisible" width="80%" height="50%" class="purchase-dialog" append-to-body>
      <purchase-contract-type @closeContractT="onCloseDialog" :slotData="slotData" v-if="hackSet"
                              @onSaveContractForm="onSaveContractForm"
                              @onSaveContractFormPdf="onSaveContractFormPdf"
                              @onSaveContractPurchaseForm="onSaveContractPurchaseForm"
                              @onSaveContractPurchaseFormPdf="onSaveContractPurchaseFormPdf"
                              @onSaveContractFrameForm="onSaveContractFrameForm"
                              @onSaveContractFrameFormPdf="onSaveContractFrameFormPdf"/>
    </el-dialog>
<!--    <el-dialog :visible.sync="dialogContractVisible" width="85%" :show-close="true" class="purchase-dialog"-->
<!--      append-to-body :modal="true">-->
<!--      <contract-form @closeContractFormDialog="closeContractFormDialog" :slotData="slotData" v-if="hackSet"></contract-form>-->
<!--    </el-dialog>-->
    <el-dialog :visible.sync="pdfVisible" :show-close="true" width="85%" class="purchase-dialog" append-to-body
      :modal="true">
      <purchase-contract-preview-pdf :fileUrl="fileUrl" :slotData="thisContract" @getContractsList="getContractsList" @showContract="showContract"/>
    </el-dialog>
    <el-dialog :visible.sync="dialogSealVisible" :show-close="false">
      <contract-seal-list :page="sealPage" :onSearchSeal="onSearchSeal" @onSealSelectChange="onSealSelectChange" />
    </el-dialog>
    <el-row type="flex" justify="space-between" align="middle" class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">合同（{{contracts==null || contracts == '' || contracts.length <= 0?'未签署':'已有合同'}}）
        </h6>
      </div>
      <el-button
        v-if="(contracts ==null || contracts == '')&& slotData.status != 'PENDING_CONFIRM' && slotData.status != 'CANCELLED'"
        type="text" class="info-detail-logistics_info-btn2" @click="onCreate">签署合同
      </el-button>
      <!--<el-button v-if="contract !=null && contract.state != 'INVALID'" type="text" class="info-detail-logistics_info-btn2" @click="openContract">查看合同-->
      <!--</el-button>-->
    </el-row>
    <div>
      <el-row>
        <el-col v-if="contracts!=null && contracts!= []" :span="4" v-for="(item, index) in contracts" :key="index"
          :offset="0">
          <div class="template-file" v-if="item.title!=null && item.title!=''" @click="showContract(item)" :title="item.title">
            <el-row type="flex" justify="center">
              <img src="static/img/word.png" class="info-img-word" alt="" :title="item.title"/>
            </el-row>
            <el-row type="flex" justify="center">
              <el-col :span="16">
                <h6 class="info-template-name" >{{ item.title }}</h6>
              </el-col>
            </el-row>
          </div>
        </el-col>
      </el-row>
    </div>

  </div>
</template>

<script>
  import Bus from '@/common/js/bus.js';
  import http from '@/common/js/http';
  import ContractDetails from '../../../contract/manage/components/ContractDetails';
  import ContractPreviewPdf from '../../../contract/manage/components/ContractPreviewPdf'
  import ContractSealList from '../../../contract/manage/components/ContractSealList'
  import PurchaseContractType from './contract/PurchaseContractType';
  import PurchaseContractPreviewPdf from './contract/PurchaseContractPreviewPdf';

  export default {
    name: 'PurchaseOrderInfoContract',
    props: ['slotData', 'contracts'],
    components: {
      PurchaseContractPreviewPdf,
      PurchaseContractType,
      ContractSealList,
      ContractDetails,
      ContractPreviewPdf
    },
    mixins: [],
    computed: {

    },
    methods: {
      async onSaveContractForm (formData) {
        const url = this.apis().saveContract();
        const result = await http.post(url, formData);

        if (result.code == 1) {
          this.$message.success(result.msg);
        } else if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }

        if (result.data != null && result.data != '') {
          var url1 = this.apis().getContractDetail(result.data);
          const result1 = await http.get(url1);
          if (result1['errors']) {
            this.$message.error(result1['errors'][0].message);
            return;
          }
          this.thisContract = result1.data;

          this.showContract(this.thisContract);
        }
        this.getContractsList();
      },
      async onSaveContractFormPdf (formData) {
        const url = this.apis().saveContract();
        const result = await http.post(url, formData);

        if (result.code == 1) {
          this.$message.success(result.msg);
        } else if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }

        if (result.data != null && result.data != '') {
          var url1 = this.apis().getContractDetail(result.data);
          const result1 = await http.get(url1);
          if (result1['errors']) {
            this.$message.error(result1['errors'][0].message);
            return;
          }
          this.thisContract = result1.data;
          console.log(this.thisContract);

          this.showContract(this.thisContract);
        }

        this.getContractsList();
      },
      async onSaveContractPurchaseForm (formData) {
        const url = this.apis().saveContract();
        const result = await http.post(url, formData);

        if (result.code == 1) {
          this.$message.success(result.msg);
        } else if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }

        if (result.data != null && result.data != '') {
          var url1 = this.apis().getContractDetail(result.data);
          const result1 = await http.get(url1);
          if (result1['errors']) {
            this.$message.error(result1['errors'][0].message);
            return;
          }
          this.thisContract = result1.data;
          console.log(this.thisContract);

          this.showContract(this.thisContract);
        }

        this.getContractsList();
      },
      async onSaveContractPurchaseFormPdf (formData) {
        const url = this.apis().saveContract();
        const result = await http.post(url, formData);

        if (result.code == 1) {
          this.$message.success(result.msg);
        } else if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }

        if (result.data != null && result.data != '') {
          var url1 = this.apis().getContractDetail(result.data);
          const result1 = await http.get(url1);
          if (result1['errors']) {
            this.$message.error(result1['errors'][0].message);
            return;
          }
          this.thisContract = result1.data;
          console.log(this.thisContract);

          this.showContract(this.thisContract);
        }

        this.getContractsList();
      },
      async onSaveContractFrameForm (formData) {
        const url = this.apis().saveContract();
        const result = await http.post(url, formData);

        if (result.code == 1) {
          this.$message.success(result.msg);
        } else if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }

        if (result.data != null && result.data != '') {
          var url1 = this.apis().getContractDetail(result.data);
          const result1 = await http.get(url1);
          if (result1['errors']) {
            this.$message.error(result1['errors'][0].message);
            return;
          }
          this.thisContract = result1.data;
          console.log(this.thisContract);

          this.showContract(this.thisContract);
        }

        this.getContractsList();
      },
      async onSaveContractFrameFormPdf (formData) {
        const url = this.apis().saveContract();
        const result = await http.post(url, formData);

        if (result.code == 1) {
          this.$message.success(result.msg);
        } else if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }

        if (result.data != null && result.data != '') {
          var url1 = this.apis().getContractDetail(result.data);
          const result1 = await http.get(url1);
          if (result1['errors']) {
            this.$message.error(result1['errors'][0].message);
            return;
          }
          this.thisContract = result1.data;
          console.log(this.thisContract);

          this.showContract(this.thisContract);
        }

        this.getContractsList();
      },
      async onCreate () {
        const url = this.apis().getAuthenticationState();
        const result = await http.get(url);
        console.log(result);
        Bus.$emit('my-event');
        if (result.data.personalState == 'SUCCESS' || result.data.companyState == 'SUCCESS') {
          // this.fn.openSlider("创建", contractForm, this.slotData);
          this.dialogVisible = true;
        } else {
          this.$message.error('当前账号未通过认证');
        }
        console.log(this.slotData);
      },
      // async openContract(){
      //   const url = this.apis().getContractDetail(this.contract.code);
      //   const result = await this.$http.get(url);
      //   if (result["errors"]) {
      //     this.$message.error(result["errors"][0].message);
      //     return;
      //   }
      //   console.log(result);
      //
      //   if(result.data != null || result.data != ''){
      //     Bus.$emit('my-event');
      //     this.fn.openSlider("创建", ContractDetails,result.data);
      //   }
      //
      // },
      async showContract (item) {
        this.thisContract = item;

        const url = this.apis().downContract(item.code);
        const result = await http.get(url);
        console.log(result);

        const aa = '/b2b/user/agreement/download/' + result.data;

        // const aa = 'https://sc.nbyjy.net/b2b/user/agreement/download/' + result.data;

        // const aa = 'https://ht.nbyjy.net/b2b/user/agreement/download/' + result.data;

        //
        // window.open('/static/pdf/web/viewer.html?file=' + encodeURIComponent(aa))
        this.$set(this.thisContract, 'key', this.thisContractKey++);
        this.pdfVisible = true;
        this.fileUrl = encodeURIComponent(aa)
      },
      async onSearchSeal (vel, keyword, page, size) {
        if (vel != null) {
          this.contractCode = vel.code;
        }

        if (keyword == null) {
          keyword = '';
        }
        const url = this.apis().getSealsList();
        console.log(url)
        const result = await this.$http.post(url, {
          keyword: keyword
        }, {
          page: page,
          size: 10
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.sealPage = result;
        this.dialogSealVisible = true
      },
      async onSealSelectChange (data) {
        this.dialogSealVisible = false;
        const sealCode = data.code;

        const url = this.apis().flowContract(this.thisContract.code, sealCode);
        const result = await http.get(url);

        if (result.data != null) {
          window.open(result.data, '_blank');
        } else {
          this.$message.success(result.msg);
        }
      },
      async previewPdf (code) {
        this.thisContract = await this.getContractDetail(code);
        const url = this.apis().downContract(code);
        const result = await http.get(url);

        const aa = '/b2b/user/agreement/download/' + result.data;

        // const aa = 'https://sc.nbyjy.net/b2b/user/agreement/download/' + result.data;

        // const aa = 'https://ht.nbyjy.net/b2b/user/agreement/download/' + result.data;

        this.fileUrl = encodeURIComponent(aa)
        this.pdfVisible = true;
      },
      async getContractDetail (code) {
        const url = this.apis().getContractDetail(code);
        const result = await http.get(url);
        return result.data;
      },
      async closeContractFormDialog () {
        this.dialogContractVisible = false;
        this.getContractsList();
      },
      async closeContractPdfViewDialog () {
        this.pdfVisible = false;
        this.getContractsList();
      },
      async getContractsList () {
        const url = this.apis().getContractsList();
        const result = await http.post(url, {
          orderCode: this.slotData.code
        }, {
          page: 0,
          size: 100
        });
        this.contracts = [];
        for (var i = 0; i < result.content.length; i++) {
          if (result.content[i].state != 'INVALID') {
            this.contracts.push(result.content[i]);
          }
        }
      },
      onCloseDialog () {
        this.dialogVisible = false;
      }
    },
    data () {
      return {
        dialogVisible: false,
        dialogContractVisible: false,
        dialogTableVisible: false,
        contractData: '',
        pdfVisible: false,
        fileUrl: '',
        thisContract: '',
        dialogSealVisible: false,
        sealPage: false,
        thisContractKey: 1,
        hackSet: true
      }
    },
    created () {
      Bus.$on('openSeal', args => {
        this.onSearchSeal();
        this.pdfVisible = false;
        this.dialogSealVisible = true;
      });
      Bus.$on('openList', args => {
        this.dialogSealVisible = true;
      });
      Bus.$on('openContract', args => {
        this.dialogContractVisible = false;
        this.previewPdf(args);
      });
      Bus.$on('closePdfView', args => {
        this.pdfVisible = false;
        this.getContractsList();
      });
      Bus.$on('closeContractFrom', args => {
        console.log(2323)
        this.dialogContractVisible = false;
      });
    },
    watch: {
      dialogContractVisible (newValue, oldValue) {
        if (!newValue && oldValue) {
          this.hackSet = false;
          this.$nextTick(() => {
            this.hackSet = true;
          })
        }
      }
    }
  }
</script>
<style>
  .info-detail-staff-body {
    width: 100%;
    margin-top: 20px;
  }

  .info-row {
    margin-top: 5px;
  }

  .info-template-name {
    text-align: center;
    font-size: 12px;
    width: 35px;
    height: 15px;
    white-space:nowrap;
    text-overflow:ellipsis;
    overflow:hidden;
  }

  .info-img-word {
    width: 50px;
    height: 50px;
    margin-bottom: 5px;
  }

  .purchase-dialog .el-dialog__header {
    padding: 0px !important;
  }

  .purchase-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .purchase-dialog-header {
    padding: 0px !important;
  }

  .el-dialog {
    width: 80%;
  }

  .template-file {
    padding-top: 10px;
    margin-left: 10px;
    border-radius: 10px;
    flex-direction: column;
    display: flex;
    /* border: 1px solid #ffd60c; */
  }

  .template-file:hover {
    background-color: #ffd60c;
  }

  .template-file:active {
    background-color: #ffd60c;
  }

</style>
