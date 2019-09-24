<template>

  <div >
    <el-dialog :visible.sync="dialogOrderVisible" width="80%" class="purchase-dialog" append-to-body>
      <contract-supplement-form  :slotData="slotData" />
    </el-dialog>
    <div style="float:right;margin-bottom: 10px;margin-top: 10px;height: 30px;">
      <el-button type="warning" v-if="slotData.state != 'INVALID'" @click="onBCXY" class="toolbar-search_input">增加补充协议</el-button>
      <el-button type="warning" @click="onDownload(slotData.code)" class="toolbar-search_input">下载</el-button>
      <el-button v-if="slotData.state != 'COMPLETE' && slotData.state != 'INVALID'"
        type="warning" class="toolbar-search_input" @click="onRefuseConfirm(slotData.code)">拒签</el-button>
      <el-button v-if="slotData.state != 'COMPLETE' && slotData.state != 'INVALID'" type="warning" class="toolbar-search_input" @click="onSearchSeal">签署
      </el-button>
      <el-button v-if="slotData.state != 'COMPLETE' && slotData.state != 'INVALID'" type="warning" class="toolbar-search_input"
        @click="onRevokeConfirm(slotData.code)">撤回</el-button>
    </div>
    <iframe id='previewPdf' :src="'https://sc.nbyjy.net/dist/b2b/static/pdf/web/viewer.html?file=' + fileUrl"
      height="480" width="100%">
    </iframe>
  </div>
</template>

<script>
  import http from '@/common/js/http';
  import ContractSealList from "../components/ContractSealList";
  import Bus from '@/common/js/bus.js';
  import ContractSupplementForm from '../ContractSupplementForm'

  export default {
    name: 'ContractPreviewPdf',
    props: ['slotData', 'fileUrl'],
    components: {
      ContractSealList,
      ContractSupplementForm,
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        sealPage: '',
        reFresh:true,
        dialogOrderVisible:false,
      }
    },
    methods: {
      onBCXY(){
        this.dialogOrderVisible = true;
        Bus.$emit('closePdfView');
      },
      async onRefuseConfirm(code) {
        this.$confirm('是否拒绝签署合同?', '拒签', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.onRefuse(code);
        });
      },
      async onRefuse(code){
        Bus.$emit('closePdfView');
        const url = this.apis().refuseContract(code);
        const result = await this.$http.get(url);
        this.$message.success(result.msg);
      },
      async onRevokeConfirm(code) {
        this.$confirm('是否撤回合同?', '撤回', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.onRefuse(code);
        });
      },
      async onRevoke(code) {
        const url = this.apis().revokeContract(code);
        const result = await this.$http.get(url);
        this.$message.success(result.msg);
        Bus.$emit('closePdfView');
      },
      async onDownload(code) {
        const url = this.apis().downContract(code);
        const result = await http.get(url);

        window.location.href = 'https://sc.nbyjy.net/b2b/user/agreement/download/' + result.data;
      },
      async onSearchSeal() {
        console.log('ffe2')
        Bus.$emit('openSeal');
        Bus.$emit('closePdfView');
      },
    },
    created() {
      Bus.$on('closeDialogOrderVisible', args => {
        this.dialogOrderVisible = false;
      });
      Bus.$on('openContract1', args => {
        Bus.$emit('openContract');
        // this.dialogContractVisible = false;
        // this.previewPdf(args);
      });
    },
  }

</script>

<style>
  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  /* .v-modal{
    display: none;
  } */
  .toolbar .toolbarViewer {
    display: none;
  }

</style>
