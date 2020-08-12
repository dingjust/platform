<template>

  <div>
    <el-dialog :visible.sync="dialogOrderVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <contract-supplement-form :slotData="slotData" />
    </el-dialog>
    <el-dialog :visible.sync="dialogSealVisible" :show-close="true" :close-on-click-modal="false" append-to-body>
      <contract-seal-list :page="sealPage" @onSearchSeal="onSearchSeal" @onSealSelectChange="onSealSelectChange" />
    </el-dialog>
<!--    <el-dialog :visible.sync="dialogOrderVisible" width="50%" class="purchase-dialog" append-to-body>-->
<!--      <el-row :justify="center">-->
<!--        <h6>是否跳转到合同签署页面？</h6>-->
<!--      </el-row>-->
<!--      <el-row :justify="space-around">-->
<!--        <h6>是否跳转到合同签署页面？</h6>-->
<!--      </el-row>-->
<!--    </el-dialog>-->
    <div style="float:right;margin-bottom: 10px;margin-top: 10px;height: 30px;">
      <Authorized :permission="['AGREEMENT_CREATE']">
        <el-button type="warning" v-if="slotData.state != 'INVALID'" @click="onBCXY" class="toolbar-search_input">增加补充协议
        </el-button>
      </Authorized>
      <el-button type="warning" @click="onDownload(slotData.code)" class="toolbar-search_input">下载</el-button>
      <Authorized :permission="['AGREEMENT_SIGN']">
        <el-button v-if="slotData.state != 'COMPLETE' && slotData.state != 'INVALID' && !slotData.isCreator"
          type="warning" class="toolbar-search_input" @click="onRefuseConfirm(slotData.code)">拒签</el-button>
      </Authorized>
      <Authorized :permission="['AGREEMENT_SIGN']">
        <el-button v-if="slotData.state != 'COMPLETE' && slotData.state != 'INVALID' && slotData.isCreator" type="warning"
          class="toolbar-search_input" @click="onRevokeConfirm(slotData.code)">撤回</el-button>
      </Authorized>
      <Authorized :permission="['AGREEMENT_SIGN']">
        <el-button v-if="slotData.state != 'COMPLETE' && slotData.state != 'INVALID'" type="warning"
                  class="toolbar-search_input" @click="onSign">签署
        </el-button>
      </Authorized>
    </div>
    <!--<center>-->
    <!--<table height="150px" border="0" id='waitPage'>-->
    <!--<tr>-->
    <!--<td>-->
    <!--<img width='28' height='28' id='myImage' src='http://img.zcool.cn/community/0179f1574d2d656ac72525ae5f181d.gif' />-->
    <!--</td>-->
    <!--<td>加载中，请等待...</td>-->
    <!--</tr>-->
    <!--</table>-->
    <!--</center>-->
    <div v-if="!isLoading"
      style="width: 100px; height: 100px; z-index: 100; position: fixed; margin: 50px auto auto -50px; top: 50%; left: 50%;">
      加载中....</div>
    <!-- <iframe id='previewPdf' :src="'https://sc.nbyjy.net/dist/b2b/static/pdf/web/viewer.html?file=' + fileUrl"
      height="480" width="100%"> -->

    <!-- <iframe id='previewPdf' :src="'https://ht.nbyjy.net/static/pdf/web/viewer.html?file=' + fileUrl"
              height="480" width="100%"> -->

    <iframe id='previewPdf' :src="'static/pdf/web/viewer.html?file=' + fileUrl"
      height="480" width="100%">
    </iframe>
    <!--<iframe id='previewPdf' :src="'/static/pdf/web/viewer.html?file=' + fileUrl"-->
    <!--height="480" width="100%">-->
    <!--</iframe>-->
    <a id="a"  target="_blank"></a>
  </div>
</template>


<script>
  import http from '@/common/js/http';
  import ContractSealList from '../components/ContractSealList';
  import Bus from '@/common/js/bus.js';
  import ContractSupplementForm from '../ContractSupplementForm'

  export default {
    name: 'ContractPreviewPdf',
    props: ['slotData', 'fileUrl'],
    components: {
      ContractSealList,
      ContractSupplementForm
    },
    mounted () {
      this.isLoading = true;
    },
    data () {
      return {
        currentUser: this.$store.getters.currentUser,
        sealPage: '',
        reFresh: true,
        dialogOrderVisible: false,
        dialogSealVisible: false,
        isLoading: false,
        openUrl: ''
      }
    },
    methods: {
      onBCXY () {
        this.dialogOrderVisible = true;
        Bus.$emit('closePdfView');
      },
      async onRefuseConfirm (code) {
        this.$confirm('是否拒绝签署合同?', '拒签', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.onRefuse(code);
        });
      },
      async onRefuse (code) {
        Bus.$emit('closePdfView');
        const url = this.apis().refuseContract(code);
        const result = await this.$http.get(url);
        this.$message.success(result.msg);
      },
      async onRevokeConfirm (code) {
        this.$confirm('是否撤回合同?', '撤回', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.onRevoke(code);
        });
      },
      async onRevoke (code) {
        const url = this.apis().revokeContract(code);
        const result = await this.$http.get(url);
        this.$message.success(result.msg);
        Bus.$emit('closePdfView');
        this.$emit('onSearch');
      },
      async onDownload (code) {
        const url = this.apis().downContract(code);
        const result = await http.get(url);

        window.location.href = '/b2b/user/agreement/download/' + result.data;

        // window.location.href = 'https://sc.nbyjy.net/b2b/user/agreement/download/' + result.data;

        // window.location.href = 'https://ht.nbyjy.net/b2b/user/agreement/download/' + result.data;
      },
      async onSign () {
        await this.onSearchSeal(0, 10);
        this.dialogSealVisible = true;
      },
      async onSearchSeal (page, size, val, keyword) {
        if (val != null) {
          this.contractCode = val.code;
        }

        if (keyword == null) {
          keyword = '';
        }
        const url = this.apis().getSealsList();
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
      },
      async onSealSelectChange (data) {
        console.log(data);
        const sealCode = data.code;

        const url = this.apis().flowContract(this.slotData.code, sealCode);
        const result = await http.get(url);

        if (result.data != null) {
          this.openUrl = result.data;
          this.$confirm('是否跳转到合同签署页面?', '', {
            confirmButtonText: '是',
            cancelButtonText: '否',
            type: 'warning'
          }).then(() => {
            this.dialogSealVisible = false;
            this.$emit('closePdfVisible');
            window.open(result.data);
          });
        } else {
          this.$message.error(result.msg);
        }
      }
    },
    created () {
      Bus.$on('closeDialogOrderVisible', args => {
        this.dialogOrderVisible = false;
      });
      Bus.$on('openContract1', args => {
        Bus.$emit('openContract');
        // this.dialogContractVisible = false;
        // this.previewPdf(args);
      });
    }
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
