<template>
  <div :data="slotData" style="width: 100%">
    <div style="float:right;margin-bottom: 10px;margin-top: 10px;">
      <el-button type="warning"  @click="onDownload(slotData.code)" class="toolbar-search_input">下载</el-button>
      <el-button  v-if="currentUser.companyName == slotData.partner &&
          slotData.state == 'SIGN' || slotData.state == 'PARTY_A_SIGN' || slotData.state == 'PARTY_B_SIGN'"
                  type="warning" class="toolbar-search_input" @click="onRefuse(slotData.code)" >拒签</el-button>
      <el-button v-if="slotData.state == 'SIGN' || slotData.state == 'PARTY_A_SIGN' ||
             slotData.state == 'PARTY_B_SIGN'"  type="warning" class="toolbar-search_input"
                 @click="onSearchSeal">签署</el-button>
      <el-button v-if="currentUser.companyName != slotData.partner &&
             slotData.state != 'COMPLETE'"  type="warning" class="toolbar-search_input"
                 @click="onRevoke(slotData.code)">撤回</el-button>
    </div>
    <iframe id='previewPdf' :src="'http://sc.nbyjy.net/dist/b2b/static/pdf/web/viewer.html?file=' + fileUrl" height="560"
            width="100%">
    </iframe>
  </div>
</template>

<script>
  import http from '@/common/js/http';
  import ContractSealList from "../components/ContractSealList";
  import Bus from '@/common/js/bus.js';

  export default {
    name: 'ContractPreviewPdf',
    props: ['slotData','fileUrl'],
    components: {
      ContractSealList
    },
    data () {
      return {
        currentUser: this.$store.getters.currentUser,
        sealPage:'',
      }
    },
    methods: {
      async onRefuse(code){
        const url = this.apis().refuseContract(code);
        const result = await this.$http.get(url);
        console.log(result);
        this.$message.error(result.msg);
      },
      async onRevoke(code){
        console.log(code);
        const url = this.apis().revokeContract(code);
        const result = await this.$http.get(url);
        console.log(result);
        this.$message.error(result.msg);
      },
      async onDownload(code){
        const url = this.apis().downContract(code);
        const result = await http.get(url);
        console.log(result);

        window.location.href = 'http://sc.nbyjy.net/b2b/user/agreement/download/' + result.data;
      },
      async onSearchSeal() {
        Bus.$emit('openSeal');
      },
    },
    created () {
    }
  }
</script>

<style>
  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
  .v-modal{
    display: none;
  }
  .toolbar .toolbarViewer{
    display: none;
  }
</style>
