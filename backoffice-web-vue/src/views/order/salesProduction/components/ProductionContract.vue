<template>
  <div class="production-contract">
    <div class="contract-title">
      <div :class="readOnly ? 'contract-list-title': ''">
        <h6 style="margin: 0px" :class="readOnly ? 'info-title_text' : ''">合同：
          <span style="color: #909399">{{this.contracts.length > 0 ? '(已创建)' : '(未上传)'}}</span>
        </h6>
      </div>
      <div v-if="!readOnly">
        <Authorized :permission="['AGREEMENT_CREATE']">
          <el-button type="text" @click="onUpload" style="padding: 0px;">
            <template v-if="isSignedPaper">
              <el-row type="flex" justify="center" align="middle">
                <i class="iconfont2_2" style="font-size: 20px;">&#xe6b9;</i>
              </el-row>
              <el-row type="flex" justify="center" align="middle">
                <h6 class="upload-text">点击上传</h6>
              </el-row>
            </template>
            <template v-else>去创建合同</template>
          </el-button>
        </Authorized>
      </div>
    </div>
    <el-row type="flex" justify="start" align="middle">
      <template v-for="item in contracts">
        <el-col :span="6" :key="item.code" :title="item.title" @click.native="showContract(item)" class="contract-item" style="width: 60px">
          <el-row type="flex" justify="center" align="middle">
            <!-- <div style="position: absolute;">
              <h6 class="state-title">{{item.state === 'COMPLETE' ? '已签署' : '未签署'}}</h6>
            </div> -->
            <div>
              <img style="width: 100%" src="static/img/word.png"/>
            </div>
          </el-row>
          <el-row type="flex" justify="center" align="middle">
            <h6 class="upload-text nowrap-text">{{item.title}}</h6>
          </el-row>
          <el-row type="flex" justify="center" align="middle">
            <h6 class="state-title">{{item.state === 'COMPLETE' ? '(已签署)' : '(未签署)'}}</h6>
          </el-row>
        </el-col>
      </template>
    </el-row>
    <el-dialog :visible.sync="dialogVisible" width="80%" class="purchase-dialog" :close-on-click-modal="false" append-to-body>
      <contract-type v-if="dialogVisible" @onSearch="callback" :slotData="slotData" :isSignedPaper="isSignedPaper"
                      @closeContractTypeDialog="dialogVisible=false" @openPreviewPdf="openPreviewPdf"/>
    </el-dialog>
    <el-dialog :visible.sync="pdfVisible" :show-close="true" width="80%" style="width: 100%" append-to-body :close-on-click-modal="false">
      <contract-preview-pdf :fileUrl="fileUrl" :slotData="thisContract" @onSearch="onSearch" :readOnly="readOnly"/>
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
    },
    readOnly: {
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
      if (!this.canSign) {
        if (this.slotData.state === 'TO_BE_ACCEPTED') {
          if (this.slotData.merchandiser && this.$store.getters.currentUser.uid === this.slotData.merchandiser.uid) {
            this.$message.warning('请等待对方执行接单操作！');
          } else {
            this.$message.warning('请先接单！');
          }
          return;
        } else if ((this.slotData.creator && this.$store.getters.currentUser.uid !== this.slotData.creator.uid) && 
            (this.slotData.merchandiser && this.$store.getters.currentUser.uid !== this.slotData.merchandiser.uid)) {
          this.$message.warning('此账号没有为此订单创建合同的权限！');
          return;
        } else if (this.contracts && this.contracts.length > 0) {
          this.$message.warning('此订单已创建合同！');
          return;
        }
        this.$message.warning('只有生产中或者已完成的订单能创建合同！');
        return;
      }
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

  .state-title {
    display: contents;
    font-size: 12px;
    width: 100%;
    margin-bottom: 0px;
    color: #606266;
  }

  .info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.85;
    margin: 0px;
  }

  .contract-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>