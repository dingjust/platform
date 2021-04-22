<template>
  <div>
    <contract-steps :step="2"/>
    <!-- 合同模板选择 -->
    <el-dialog :destroy-on-close="true" :visible.sync="dialogTemplateVisible" width="80%"
               class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <Authorized :permission="['AGREEMENT_TMPL_CREATE']">
        <el-button class="product-select-btn" @click="onCreateTemp">创建模板</el-button>
      </Authorized>
      <el-divider direction="vertical"></el-divider>
      <el-button class="product-select-btn" @click="onFileSelectSure">确定</el-button>
      <contract-template-select :tempType="tempType" @fileSelectChange="onFileSelectChange" ref="contractTemplateSelect"/>
    </el-dialog>
    <!-- 合同模板 创建 -->
    <el-dialog :visible.sync="tempFormVisible" class="purchase-dialog" width="80%" append-to-body :close-on-click-modal="false">
      <template-form v-if="tempFormVisible" @contractTemplateSelect="contractTemplateSelect"
                     :slotData="templateData" :templateId="templateId"
                     :tempFormVisible="tempFormVisible" v-on:turnTempFormVisible="turnTempFormVisible"/>
    </el-dialog>
    <!-- 选择合作商 -->
    <el-dialog :visible.sync="suppliersSelectVisible" width="40%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <supplier-select @onSelect="onSuppliersSelect" />
    </el-dialog>
    <!-- 预览合同 -->
    <el-dialog :visible.sync="dialogPreviewVisible" width="80%" :close-on-click-modal="false">
      <el-row slot="title">
        <el-button>生成合同</el-button>
      </el-row>
      <contract-preview />
    </el-dialog>
    <!-- 合同详情pdf -->
    <el-dialog :visible.sync="pdfVisible" :show-close="true" style="width: 100%" :close-on-click-modal="false">
      <contract-preview-pdf :fileUrl="fileUrl" :slotData="thisContract" />
    </el-dialog>
    
    <div>
      <el-row type="flex" justify="center" align="middle">
        <span class="create-contract-title">框架协议</span>
      </el-row>
      <contract-type-select :isSignedPaper="isSignedPaper" @contractTypeChange="onContractTypeChange" class="contractTypeSelect" />
      <el-row class="create-contract-row" type="flex" justify="start" v-if="contractType!='3'">
        <el-col :push="2" :span="8">
          <span class="tips">合同类型</span>
          <el-radio v-model="contractType" label="1" :disabled="isSignedPaper">模板合同</el-radio>
          <el-radio v-model="contractType" label="2">自定义合同上传</el-radio>
        </el-col>
      </el-row>
      <el-row class="create-contract-row">
        <el-col :span="20" :offset="2">
          <el-input size="small" placeholder="选择合作商" v-model="suppliers.name" :disabled="true">
            <template slot="prepend">合作商</template>
            <el-button slot="append" :disabled="orderReadOnly" @click="suppliersSelectVisible=true" class="select-btn">选择合作商</el-button>
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType=='1'">
        <el-col :span="20" :offset="2">
          <el-input size="small" placeholder="选择合同模板" v-model="selectFile.title" :disabled="true">
            <template slot="prepend">合同模板</template>
            <el-button slot="append" @click="selectTemp('')" class="select-btn">合同模板</el-button>
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType=='1'">
        <el-col :span="20" :offset="2">
          <el-input size="small" placeholder="广东省广州市白云区" v-model="selectFile.signLocation">
            <template slot="prepend">签订地点</template>
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType!='1'">
        <el-col :span="20" :offset="2">
          <el-input size="small" placeholder="请输入合同编号" v-model="contractCode">
            <template slot="prepend">合同编号</template>
            <!-- <el-button slot="prepend" :disabled="true">合同编号</el-button> -->
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType === '2'">
        <el-col :span="8" :offset="2">
          <p-d-f-upload ref="pdfUpload" :vFileList.sync="pdfFile" :fileLimit="1"></p-d-f-upload>
          <!-- <el-upload name="file" :action="mediaUploadUrl" list-type="picture-card" :data="uploadFormData"
                     :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers"
                     :on-exceed="handleExceed"
                     :file-list="fileList" :on-preview="handlePreview" multiple :limit="1" :on-remove="handleRemove">
            <div slot="tip" class="el-upload__tip" v-if="contractType !== '3'">只能上传PDF文件</div>
            <i class="el-icon-plus"></i>
            <div slot="file" slot-scope="{file}">
              <img class="el-upload-list__item-thumbnail" src="static/img/pdf.png" alt="">
              <span class="el-upload-list__item-actions">
                <span v-if="!disabled" class="el-upload-list__item-delete" @click="handleRemove(file)">
                  <i class="el-icon-delete"></i>
                </span>
                <span v-if="!disabled" class="el-upload-list__item-file-name">
                  {{file.name}}
                </span>
              </span>
            </div>
          </el-upload> -->
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType === '3'">
        <el-col :span="22" :offset="2">
          <images-upload ref="imagesUpload" :slotData="paperList" :limit="99" :uploadType="uploadType"></images-upload>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" type="flex" justify="start">
        <el-col :push="2" :span="3">
        <div style="margin-top: 5px;"><span class="tips">合同有效期</span></div>
        </el-col>
        <el-col :push="1" :span="8">
          <div>
            <el-date-picker v-model="dateTime" type="daterange" align="right" unlink-panels range-separator="至"
                            value-format="yyyy-MM-dd"  start-placeholder="开始日期" end-placeholder="结束日期" :picker-options="pickerOptions">
            </el-date-picker>
          </div>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" type="flex" justify="start">
        <el-col :push="2" :span="8">
          <span class="tips">我的身份</span>
          <el-radio v-model="partyA" :label="true">我是甲方</el-radio>
          <el-radio v-model="partyA" :label="false">我是乙方</el-radio>
        </el-col>
      </el-row>

      <el-row class="create-contract-row" type="flex" justify="center">
        <el-col :span="4" :offset="-2">
<!--          <el-button class="create-contract-button" @click="dialogPreviewVisible=true">预览合同</el-button>-->
        </el-col>
        <el-col :span="4" :offset="2">
          <el-button v-if="contractType == '1'" class="create-contract-button" @click="onSave">生成合同</el-button>

          <el-button v-else class="create-contract-button" @click="onSavePdf">生成合同</el-button>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import ContractTypeSelect from './components/ContractTypeSelect';
  import ContractTemplateSelect from './components/ContractTemplateSelect';
  import ContractPreview from './components/ContractPreview';
  import ContractOrderSelect from './components/ContractOrderSelect';
  import http from '@/common/js/http';
  import TemplateForm from '../../contract/template/components/TemplateForm';
  import Bus from '@/common/js/bus.js';
  import ContractPreviewPdf from './components/ContractPreviewPdf'
  // import SupplierSelect from './components/SupplierSelect';
  import { SupplierSelect, ImagesUpload, PDFUpload } from '@/components'
  import ContractSteps from './components/ContractSteps'
  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    'ContractModule'
  );

  export default {
    name: 'ContractFrameForm',
    props: ['slotData', 'templateData', 'templateId', 'isSignedPaper'],
    components: {
      ContractTypeSelect,
      ContractTemplateSelect,
      ContractPreview,
      ContractOrderSelect,
      TemplateForm,
      ContractPreviewPdf,
      SupplierSelect,
      ImagesUpload,
      PDFUpload,
      ContractSteps
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword'
      }),
      uploadFormData: function () {
        return {
          fileFormat: 'DefaultFileFormat',
          conversionGroup: 'DefaultProductConversionGroup'
        };
      },
      headers: function () {
        return {
          Authorization: this.$store.getters.token
        }
      }
    },
    methods: {
      ...mapActions({
        search: 'search',
        refresh: 'refresh'
      }),
      selectTemp (str) {
        if (str == 'KJXY') {
          this.tempType = 'KJXY';
        }

        this.dialogTemplateVisible = true;
      },
      onContractTypeChange (val) {
        this.contractType = val;
      },
      // 文件选择（缓存，并未确定）
      onFileSelectChange (data) {
        this.cacheSelectFile = data;
      },
      // 订单选择
      onOrderSelectChange (data) {
        this.orderSelectFile = data;
        this.dialogOrderVisible = false;
      },
      // 文件选择确定
      onFileSelectSure () {
        this.dialogTemplateVisible = false;
        this.selectFile = this.cacheSelectFile;
      },
      handleExceed (files, fileList) {
        if (fileList > 1) {
          this.$message.warning(`已达最大文件数`);
          return false;
        }
      },
      handleRemove (file) {
        this.fileList = [];
        this.pdfFile = [];
      },
      async onSavePdf () {
        // if (!this.pdfFile && this.pdfFile.length <= 0) {
        //   this.$message.error('请先上传PDF文件');
        //   return;
        // }
        if (this.contractType == '2' && (!this.pdfFile || this.pdfFile.length <= 0)) {
          this.$message.error('请先上传PDF文件');
          return;
        }
        if (this.contractType == '3' && (!this.paperList || this.paperList.length <= 0)) {
          this.$message.error('请先上传已签纸质合同');
          return;
        }
        if (this.suppliers.id == null || this.suppliers.id == '') {
          this.$message.error('请选择合作商');
          return;
        }
        if (this.dateTime == '' || this.dateTime == null) {
          this.$message.error('请选择合同有效期');
          return;
        }
        if (this.contractCode == null || this.contractCode == '') {
          this.$message.error('请输入自定义合同编号');
          return;
        }
        let role = '';
        if (this.partyA) {
          role = 'PARTYA';
        } else {
          role = 'PARTYB';
        }
        var agreementType = null;
        if (this.contractType == '3') {
          agreementType = 'CUSTOMIZE_COMPLETED';
          if (this.$refs.imagesUpload.isUploading()) {
            this.$message.warning('图片正在上传，请稍后再试！');
            return;
          }
        }
        if (this.contractType == '2') {
          agreementType = 'CUSTOMIZE';
          if (this.$refs.pdfUpload.isUploading()) {
            this.$message.warning('PDF文件正在上传，请稍后再试！');
            return;
          }
        }
        let data = {
          // 'pdf': this.pdfFile,
          'role': role,
          'title': '',
          'validityEnd': this.dateTime[1],
          'validityStart': this.dateTime[0],
          'isFrame': true,
          'agreementType': agreementType,
          'customizeCode': this.contractCode,
          'partnerCompanyCode': this.suppliers.id,
          'customizeType': 'KJXY',
          'signLocation': this.selectFile.signLocation !== '' ? this.selectFile.signLocation : '广东省广州市白云区'
        }

        if (this.contractType === '2') {
          this.$set(data, 'pdf', this.pdfFile[0]);
        } else if (this.contractType === '3') {
          this.$set(data, 'files', this.paperList)
        }

        const url = this.apis().saveContract();
        let formData = Object.assign({}, data);
        const result = await http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

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

          this.$emit('openPreviewPdf', this.thisContract, '');
        }

        this.$emit('onSearch');
        this.$emit('closeContractFrameFormDialog');
        this.$emit('closeContractTypeDialog');
      },
      async onSave () {
        if (this.suppliers.id == null || this.suppliers.id == '') {
          this.$message.error('请选择合作商');
          return;
        }
        if (this.selectFile.id == null || this.selectFile.id == '') {
          this.$message.error('请选择合同模板');
          return;
        }
        if (this.dateTime == '' || this.dateTime == null) {
          this.$message.error('请选择合同有效期');
          return;
        }
        let role = '';
        if (this.partyA) {
          role = 'PARTYA';
        } else {
          role = 'PARTYB';
        }
        let data = {
          'userTempCode': this.selectFile.code,
          'validityEnd': this.dateTime[1],
          'validityStart': this.dateTime[0],
          'role': role,
          'title': '',
          'isFrame': true,
          'partnerCompanyCode': this.suppliers.id,
          'customizeType': 'KJXY'
        }

        const url = this.apis().saveContract();
        let formData = Object.assign({}, data);
        const result = await http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

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

          this.$emit('openPreviewPdf', this.thisContract, '');
        }

        this.$emit('onSearch');
        this.$emit('closeContractFrameFormDialog');
        this.$emit('closeContractTypeDialog');
      },
      onSetOrderCode () {
        if (this.slotData && this.slotData.code) {
          this.orderSelectFile = this.slotData;
          this.orderReadOnly = true;
          if (this.currentUser.type == 'BRAND') {
            this.partyA = true;
          } else {
            this.partyA = false;
          }
        }
      },
      onCreateTemp () {
        // this.dialogTemplateVisible = false;
        // this.fn.closeSlider(false);
        this.tempFormVisible = true;
        // this.$router.push("templateForm");
        // this.fn.openSlider('创建', TemplateForm);
      },
      handlePreview (file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      },
      onBeforeUpload (file) {
        if (file.type !== 'application/pdf') {
          this.$message.error('选择的文件不是PDF文件');
          return false;
        }
        return true;
      },
      onSuccess (response) {
        // this.pdfFile[0] = response;
      },
      onSuppliersSelect (val) {
        this.suppliers = val;
        this.suppliersSelectVisible = false;
        // this.form.companyOfSeller = val.name;
        // this.form.contactPersonOfSeller = val.contactPerson;
        // this.form.contactOfSeller = val.contactPhone;
      },
      turnTempFormVisible () {
        this.tempFormVisible = !this.tempFormVisible;
      },
      contractTemplateSelect () {
        this.$refs.contractTemplateSelect.onSearchTemp();
      },
      gCooperator (cooperator) {
        if (cooperator.type === 'ONLINE') {
          return cooperator.partner;
        } else {
          return cooperator;
        }
      }
    },
    data () {
      return {
        currentUser: this.$store.getters.currentUser,
        contractType: '1',
        hasFrameworkContract: false,
        partyA: true,
        dialogTemplateVisible: false,
        dialogOrderVisible: false,
        cacheSelectFile: {},
        orderSelectFile: {},
        selectFile: {},
        fileList: [],
        dialogPreviewVisible: false,
        orderReadOnly: false,
        input1: '',
        mockData: [],
        orderPage: [],
        disabled: false,
        pdfFile: [],
        pdfVisible: false,
        fileUrl: '',
        thisContract: '',
        agreementType: '',
        tempType: 'KJXY',
        tempData: [],
        allData: [],
        dateTime: '',
        contractCode: '',
        pickerOptions: {
          shortcuts: [{
            text: '最近一周',
            onClick (picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '最近一个月',
            onClick (picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '最近三个月',
            onClick (picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
              picker.$emit('pick', [start, end]);
            }
          }]
        },
        suppliersSelectVisible: false,
        tempFormVisible: false,
        suppliers: '',
        paperList: [],
        uploadType: ''
      };
    },
    watch: {
      paperList: function (nval, oval) {
        if (nval && nval.length === 1) {
          this.uploadType = nval[0].mediaType;
        } else if (nval && nval.length === 0) {
          this.uploadType = '';
        }
      }
    },
    created () {
      if (this.isSignedPaper) {
        this.contractType = '3';
      }
      if (this.slotData && this.slotData.originCooperator && this.slotData.targetCooperator) {
        let originCooperator = this.gCooperator(this.slotData.originCooperator);
        let targetCooperator = this.gCooperator(this.slotData.targetCooperator);
        if (originCooperator.uid === this.$store.getters.currentUser.companyCode) {
          this.onSuppliersSelect(targetCooperator);
          this.orderReadOnly = true;
        } else if (targetCooperator.uid === this.$store.getters.currentUser.companyCode) {
          this.onSuppliersSelect(originCooperator);
          this.orderReadOnly = true;
        }
      }
      // this.onSearchOrder('', 0, 10);
      // this.onSetOrderCode();
    }
  };
</script>
<style scoped>
  .create-contract-title {
    font-weight: bold;
    font-size: 18px;
    margin-bottom: 50px;
    margin-top: 20px;
  }

  .create-contract-type_select {
    width: 280px;
    height: 100px;
    background: rgba(255, 164, 3, 1);
    opacity: 0.85;
    border-radius: 9px;
  }

  .dropdown-menu {
    width: 280px;
    height: 100px;
  }

  .card-body {
    background-color: #FAFBFC;
  }

  .contractTypeSelect {
    margin-bottom: 50px;
  }

  .create-contract-row {
    margin-top: 20px;
  }

  .create-contract-row_button {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .create-contract-button {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 100%;
    height: 40px;
  }

  .create-contract-button_2 {
    width: 100%;
    height: 40px;
  }

  .el-upload__tip {
    margin-top: 10px;
  }

  /* .upload_img {
    vertical-align: middle;
    display: inline-block;
    width: 70px;
    height: 70px;
    float: left;
    position: relative;
    z-index: 1;
    margin-left: -80px;
    background-color: #FFF
  } */

  /deep/ .el-upload-list--picture-card .el-upload-list__item {
    overflow: hidden;
    background-color: #fff;
    border: 0px solid #c0ccda !important;
    border-radius: 6px;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    width: 100px;
    height: 100px;
    margin: 0 8px 8px 0;
    display: inline-block;
  }

  /deep/ .el-upload--picture-card {
    background-color: #fbfdff;
    border: 1px dashed #c0ccda;
    border-radius: 6px;
    box-sizing: border-box;
    width: 100px;
    height: 100px;
    line-height: 100px;
    vertical-align: top;
  }

  .el-upload-list__item-file-name {
    position: absolute;
    right: 25px;
    top: 50px;
    font-size: 12px;
    color: #ffffff;
    display: none
  }

  .product-select-btn {
    width: 70px;
    height: 30px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    border: 0px solid #FFD60C;
    margin-top: 10px;
    margin-left: 10px;
    margin-bottom: 10px;
  }

  .tips {
    margin-right: 15px;
    margin-left: 5px;
  }

  /deep/ .el-date-editor .el-range-separator {
    width: 10%;
  }

  .select-btn {
    background-color: #ffd60c!important;
    color: #606266!important;
  }
</style>
