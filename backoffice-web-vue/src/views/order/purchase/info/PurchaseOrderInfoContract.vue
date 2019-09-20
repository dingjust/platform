<template>
  <div class="info-detail-staff-body">
    <el-dialog :visible.sync="dialogContractVisible" width="85%" :show-close="true" class="purchase-dialog"
      append-to-body :modal="true">
      <contract-form :slotData="slotData"></contract-form>
    </el-dialog>
    <el-dialog :visible.sync="pdfVisible" :show-close="true" width="85%" class="purchase-dialog" append-to-body
      :modal="true">
      <contract-preview-pdf :fileUrl="fileUrl" :slotData="thisContract"/>
    </el-dialog>
    <el-dialog :visible.sync="dialogSealVisible" :show-close="false">
      <contract-seal-list :page="sealPage" :onSearchSeal="onSearchSeal" @onSealSelectChange="onSealSelectChange" />
    </el-dialog>
    <el-row type="flex" justify="space-between" align="middle" class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">合同（{{contract==null?'未签署':getEnum('contractStates', contract.state)}}）</h6>
      </div>
      <el-button v-if="contract ==null || contract.state == 'INVALID'" type="text" class="info-detail-logistics_info-btn2" @click="onCreate">签署合同
      </el-button>
      <el-button v-if="contract !=null && contract.state != 'INVALID'" type="text" class="info-detail-logistics_info-btn2" @click="openContract">查看合同
      </el-button>
    </el-row>
    <el-row v-if="contract !=null && contract.state != 'INVALID'" type="flex" justify="center">
      <img @click="openContract" src="static/img/word.png" class="info-img-word" alt="" />
    </el-row>
    <el-row v-if="contract !=null && contract.state != 'INVALID'" type="flex" justify="center">
      <el-col :span="16">
        <h6 @click="openContract" class="info-template-name">{{contract.title}}</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import contractForm from '../../../contract/manage/ContractForm'
  // import contractPage from '../../../contract/manage/ContractPage'
  import Bus from '@/common/js/bus.js';
  import http from '@/common/js/http';
  import ContractDetails from "../../../contract/manage/components/ContractDetails";
  import ContractPreviewPdf from '../../../contract/manage/components/ContractPreviewPdf'
  import contractSealView from '../../../contract/manage/components/ContractSealList'

  export default {
    name: 'PurchaseOrderInfoContract',
    props: ['slotData', 'contract'],
    components: {
      contractForm,
      ContractDetails,
      ContractPreviewPdf,
    },
    mixins: [],
    computed: {

    },
    methods: {
      async onCreate() {
        const url = this.apis().getAuthenticationState();
        const result = await http.get(url);
        console.log(result);
        Bus.$emit('my-event');
        if (result.data.personalState == 'SUCCESS' || result.data.companyState == 'SUCCESS') {
          // this.fn.openSlider("创建", contractForm, this.slotData);
          this.dialogContractVisible = true;

        } else {
          this.$message.error('当前账号未通过认证');
        }

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
      async openContract() {
        this.thisContract = this.contract;

        const url = this.apis().downContract(this.contract.code);
        const result = await http.get(url);
        console.log(result);

        const aa = 'https://sc.nbyjy.net/b2b/user/agreement/download/' + result.data;
        //
        // window.open('/static/pdf/web/viewer.html?file=' + encodeURIComponent(aa))
        this.$set(this.thisContract,'key',this.thisContractKey++);
        this.pdfVisible = true;
        this.fileUrl = encodeURIComponent(aa)
      },
      async onSearchSeal(vel, keyword, page, size) {
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
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.sealPage = result;
        this.dialogSealVisible = true
      },
      async onSealSelectChange(data) {
        this.dialogSealVisible = false;
        const sealCode = data.code;

        const url = this.apis().flowContract(this.contractCode, sealCode);
        const result = await http.get(url);

        if (result.data != null) {
          window.open(result.data, '_blank');
        } else {
          this.$message.success(result.msg);
        }
      },
      async previewPdf(code) {
        this.thisContract = await this.getContractDetail(code);
        const url = this.apis().downContract(code);
        const result = await http.get(url);
        const aa = 'https://sc.nbyjy.net/b2b/user/agreement/download/' + result.data;
        this.fileUrl = encodeURIComponent(aa)
        this.pdfVisible = true;
      },
      async getContractDetail(code) {
        const url = this.apis().getContractDetail(code);
        const result = await http.get(url);
        return result.data;
      }
    },
    data() {
      return {
        dialogContractVisible: false,
        dialogTableVisible: false,
        contractData: '',
        pdfVisible: false,
        fileUrl: '',
        thisContract: '',
        dialogSealVisible: false,
        sealPage: false,
        thisContractKey:1
      }
    },
    created() {
      Bus.$on('openSeal', args => {
        this.onSearchSeal();
        this.pdfVisible = !this.pdfVisible;
        this.dialogSealVisible = !this.dialogSealVisible;
      });
      Bus.$on('openList', args => {
        this.dialogSealVisible = !this.dialogSealVisible;
      });
      Bus.$on('openContract', args => {
        this.dialogContractVisible = false;
        this.previewPdf(args);
      });
      // this.getContract();
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

</style>
