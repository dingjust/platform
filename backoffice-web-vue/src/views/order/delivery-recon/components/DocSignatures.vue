<template>
  <div>
    <el-row type="flex" justify="end" style="margin-bottom: 20px">
      <el-button type="warning" @click="onDownload" class="toolbar-search_input">下载</el-button>
      <el-button type="warning" class="toolbar-search_input" v-if="canSign" @click="onSign">签署</el-button>
    </el-row>
    <div>
      <!-- <iframe id='previewPdf' :src="'static/pdf/web/viewer.html?file=' + fileUrl" -->
      <iframe id='previewPdf' :src="fileUrl"
        height="480" width="100%">
      </iframe>
      <a id="a"  target="_blank"></a>
    </div>
    <el-dialog :visible.sync="dialogSealVisible" width="60%" :show-close="true" :close-on-click-modal="false" append-to-body>
      <contract-seal-list v-if="dialogSealVisible" :page="sealPage" @onSearchSeal="onSearchSeal" @onSealSelectChange="onSealSelectChange" />
    </el-dialog>
  </div>
</template>

<script>
import ContractSealList from '@/views/contract/manage/components/ContractSealList'

export default {
  name: 'DocSignatures',
  props: ['fileUrl', 'pdfItem', 'order'],
  components: {
    ContractSealList
  },
  computed: {
    canSign: function () {
      if (this.order.state === 'PENDING_B_SIGN') {
        return this.order.shipParty.uid === this.$store.getters.currentUser.companyCode;
      } else if (this.order.state === 'PENDING_A_SIGN') {
        return this.order.receiveParty.uid === this.$store.getters.currentUser.companyCode;
      }
    }
  },
  data () {
    return {
      dialogSealVisible: false,
      sealPage: '',
      openUrl: ''
    }
  },
  methods: {
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
      const sealCode = data.code;

      const url = this.apis().doDocSign(this.pdfItem.code);
      const result = await this.$http.get(url, {
        sealCode: sealCode
      });

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
    },
    async onDownload () {
      const url = this.apis().getDocToken(this.pdfItem.code);
      const result = await this.$http.get(url);

      window.location.href = '/b2b/doc/signature/download/' + result.data + '/' + this.pdfItem.code;
    }
  }
}
</script>

<style scoped>
  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
</style>