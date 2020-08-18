<template>
  <div class="production-contract">
    <div class="contract-title">
      <div>
        <h6 style="margin: 0px">合同：
          <span style="color: #909399">{{this.contracts.length > 0 ? '(已创建)' : '(未上传)'}}</span>
        </h6>
      </div>
      <div v-if="canSign">
        <el-button type="text" @click="onUpload">
          <template v-if="isSignedPaper">
            <el-row type="flex" justify="center" align="middle">
              <i class="el-icon-upload" style="font-size: 20px"></i>
            </el-row>
            <el-row type="flex" justify="center" align="middle">
              <h6 class="upload-text">点击上传</h6>
            </el-row>
          </template>
          <template v-else>去创建合同</template>
        </el-button>
      </div>
    </div>
    <el-row type="flex" justify="start" align="middle">
      <template v-for="item in contracts">
        <el-col :span="8" :key="item.code" :title="item.title" @click.native="showContract(item)" class="contract-item">
          <el-row type="flex" justify="center" align="middle">
            <!-- <div class="sign-icon">
              <img style="width: 80%" src="static/img/signed.png" />
            </div> -->
            <div>
              <img style="width: 100%" src="static/img/pdf.png"/>
            </div>
          </el-row>
          <el-row type="flex" justify="center" align="middle">
            <h6 class="upload-text nowrap-text">{{item.title}}</h6>
          </el-row>
        </el-col>
      </template>
    </el-row>
    <el-dialog :visible.sync="dialogVisible" width="80%" class="purchase-dialog" :close-on-click-modal="false" append-to-body>
      <contract-type v-if="dialogVisible" @onSearch="callback" :slotData="slotData" :isSignedPaper="isSignedPaper"
                      @closeContractTypeDialog="dialogVisible=false" @openPreviewPdf="openPreviewPdf"/>
    </el-dialog>
    <el-dialog :visible.sync="pdfVisible" :show-close="true" width="80%" style="width: 100%" append-to-body :close-on-click-modal="false">
      <contract-preview-pdf :fileUrl="fileUrl" :slotData="thisContract" @onSearch="onSearch"/>
    </el-dialog>
  </div>
</template>

<script>
import ContractType from '@/views/contract/manage/components/ContractType'
import ContractPreviewPdf from '@/views/contract/manage/components/ContractPreviewPdf'
export default {
  name: 'ProductionContract',
  props: {
    slotData: {
      type: Object,
      default: () => {}
    },
    contracts: {
      type: Array,
      default: () => []
    },
    // 只能 创建已签纸质合同
    isSignedPaper: {
      type: Boolean,
      default: false
    },
    canSign: {
      type: Boolean,
      default: false
    }
  },
  components: {
    ContractPreviewPdf,
    ContractType
  },
  computed: {
  },
  methods: {
    callback () {
      this.$emit('callback');
    },
    onUpload () {
      this.dialogVisible = true;
    },
    showContract (item) {
      this.openPreviewPdf(item, item.code);
    },
    async openPreviewPdf (val, code) {
      this.thisContract = val;
      let queryCode = '';
      if (code != null && code != '') {
        queryCode = code;
      } else {
        queryCode = val.code;
      }
      const url = this.apis().downContract(queryCode);
      const result = await this.$http.get(url);

      const aa = '/b2b/user/agreement/download/' + result.data;

      this.pdfVisible = true;
      this.fileUrl = encodeURIComponent(aa)
    },
    onSearch () {
      this.pdfVisible = false;
      this.$emit('callback');
    }
  },
  data () {
    return {
      thisContract: '',
      thisContractKey: 1,
      fileUrl: '',
      dialogVisible: false,
      pdfVisible: false
    }
  }
}
</script>

<style scoped>
  .contract-title {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .upload-text {
    margin-bottom: 0px;
    font-size: 12px;
  }

  .nowrap-text {
    display: inline-block;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .contract-item {
    padding: 5px;
    border-radius: 5px;
  }
  .contract-item:hover {
    background-color: #ffd60c;
  }

  .sign-icon {
    display: flex;
    position: absolute;
    justify-content: flex-end;
  }
</style>