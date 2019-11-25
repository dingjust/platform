<template>
  <div>
    <el-dialog :destroy-on-close="true" :visible.sync="dialogTemplateVisible" width="80%" class="purchase-dialog"
               append-to-body>
      <el-button class="product-select-btn" @click="onFileSelectSure">确定</el-button>
      <el-divider direction="vertical"></el-divider>
      <el-button class="product-select-btn" @click="onCreateTemp">创建模板</el-button>
      <contract-template-select :tempType="tempType" @fileSelectChange="onFileSelectChange" ref="contractTemplateSelect"/>
    </el-dialog>
    <el-dialog :visible.sync="tempFormVisible" class="purchase-dialog" width="80%" append-to-body>
      <template-form v-if="tempFormVisible" @contractTemplateSelect="contractTemplateSelect" :tempFormVisible="tempFormVisible" v-on:turnTempFormVisible="turnTempFormVisible"/>
    </el-dialog>
    <el-dialog :visible.sync="dialogOrderVisible" width="80%" class="purchase-dialog" append-to-body>
      <contract-order-select v-if="dialogOrderVisible" :page="orderPage" @onSearchOrder="onSearchOrder"
                             @onOrderSelectChange="onOrderSelectChange"/>
    </el-dialog>
    <el-dialog :visible.sync="dialogContractVisible" width="80%" class="purchase-dialog" append-to-body>
      <el-button-group>
        <el-button class="product-select-btn" @click="onContractSelectSure">确定</el-button>
      </el-button-group>
      <contract-select :mockData="mockData" @fileSelectChange="onContractSelectChange"/>
    </el-dialog>
    <el-dialog :visible.sync="dialogPreviewVisible" width="80%">
      <el-row slot="title">
        <el-button>生成合同</el-button>
      </el-row>
      <contract-preview/>
    </el-dialog>
    <el-dialog :visible.sync="pdfVisible" :show-close="true" style="width: 100%">
      <contract-preview-pdf :fileUrl="fileUrl" :slotData="thisContract"/>
    </el-dialog>
    <el-form ref="contractPurchaseForm" :model="contractPurchaseFormData" label-position="left" :rules="rules" label-width="88px" hide-required-asterisk>
      <el-row type="flex" justify="center" align="middle">
        <span class="create-contract-title">采购订单</span>
      </el-row>
      <contract-type-select @contractTypeChange="onContractTypeChange" class="contractTypeSelect"/>
      <el-row class="create-contract-row" type="flex" justify="start" v-if="contractType!='3'">
        <el-col :push="2" :span="8">
          <span class="tips">合同类型</span>
          <el-radio v-model="contractType" label="1">模板合同</el-radio>
          <el-radio v-model="contractType" label="2">自定义合同上传</el-radio>
        </el-col>
      </el-row>
     <el-row class="create-contract-row">
       <el-col :span="20" :offset="2">
         <el-input size="small" placeholder="选择订单" :value="ordersCodeStr" :disabled="true">
           <el-button slot="prepend" :disabled="orderReadOnly" @click="dialogOrderVisible=true">关联订单</el-button>
         </el-input>
       </el-col>
     </el-row>
      <el-row class="create-contract-row">
        <el-col :span="20" :offset="2">
          <el-input size="small" placeholder="选择框架协议" v-model="selectContract.title" :disabled="true">
            <el-button slot="prepend" @click="openKJHTSelect">选择已签协议</el-button>
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType=='1'">
        <el-col :span="20" :offset="2">
          <el-input size="small" placeholder="选择合同模板" v-model="selectFile.title" :disabled="true">
            <el-button slot="prepend" @click="selectTemp('')">合同模板</el-button>
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType!='1'">
        <el-col :span="20" :offset="2">
          <el-input size="small" placeholder="请输入合同编号" v-model="contractCode">
            <el-button slot="prepend" :disabled="true">合同编号</el-button>
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType!='1'">
        <el-col :span="8" :offset="2">
          <el-upload name="file" :action="mediaUploadUrl" list-type="picture-card" :data="uploadFormData"
                     :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers"
                     :on-exceed="handleExceed"
                     :file-list="fileList" :on-preview="handlePreview" multiple :limit="1" :on-remove="handleRemove">
            <div slot="tip" class="el-upload__tip">只能上传PDF文件</div>
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
          </el-upload>
        </el-col>
      </el-row>

      <!--      <el-row class="create-contract-row" v-if="contractType=='1'" type="flex" justify="start">-->
      <!--        <el-col :push="2" :span="8">-->
      <!--          <span class="tips">合同类型</span>-->
      <!--          <el-radio v-model="hasFrameworkContract" :label="false">无框架合同</el-radio>-->
      <!--          <el-radio v-model="hasFrameworkContract" :label="true">有框架合同</el-radio>-->
      <!--        </el-col>-->
      <!--        <el-col v-if="hasFrameworkContract" :span="5" :offset="2">-->
      <!--          <el-input size="small" placeholder="选择框架协议" v-model="selectContract.title" :disabled="true">-->
      <!--            <el-button slot="prepend" @click="openKJHTSelect">选择已签协议</el-button>-->
      <!--          </el-input>-->
      <!--        </el-col>-->
      <!--      </el-row>-->
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
    </el-form>
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
    import ContractSelect from './components/ContractSelect';

    const {
      mapGetters,
      mapActions
    } = createNamespacedHelpers(
      'ContractModule'
    );

    export default {
      name: 'ContractPurchaseForm',
      props: ['slotData', 'formData'],
      components: {
        ContractTypeSelect,
        ContractTemplateSelect,
        ContractPreview,
        ContractOrderSelect,
        TemplateForm,
        ContractPreviewPdf,
        ContractSelect
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
        },
        ordersCodeStr: function () {
          var result = '';
          this.orderSelectFiles.forEach(element => {
            result += element.code + ' ';
          });
          return result;
        }
      },
      methods: {
        ...mapActions({
          search: 'search',
          refresh: 'refresh'
        }),
        selectTemp (str) {
          this.tempType = 'CGDD';
          //   if (this.hasFrameworkContract) {
          // } else {
          //   this.tempType = 'WTSCHT';
          // }

          this.dialogTemplateVisible = true;
        },
        async onSearchOrder (keyword, page, size) {
          var _page = 0;
          var _size = 10;
          if (page) {
            _page = page;
          }
          if (size) {
            _size = size;
          }
          const url = this.apis().getPurchaseOrders();
          const result = await this.$http.post(url, {
            statuses: ['PENDING_PAYMENT', 'IN_PRODUCTION', 'WAIT_FOR_OUT_OF_STORE', 'OUT_OF_STORE', 'COMPLETED']
          }, {
            page: _page,
            size: _size
          });
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.orderPage = result;
        },
        onContractTypeChange (val) {
          if (val != null || val != '') {
            this.contractType = val;
          }
        },
        // 文件选择（缓存，并未确定）
        onFileSelectChange (data) {
          this.cacheSelectFile = data;
        },
        onContractSelectChange (data) {
          this.cacheSelectContract = data;
        },
        // 订单选择
        onOrderSelectChange (data) {
          this.orderContractClick(data).then(value => {
            if (value) {
              this.orderSelectFiles = data;
              this.dialogOrderVisible = false;
            }
          });
        },
        // 文件选择确定
        onFileSelectSure () {
          this.dialogTemplateVisible = false;
          this.selectFile = this.cacheSelectFile;
        },
        onContractSelectSure () {
          this.dialogContractVisible = false;
          this.selectContract = this.cacheSelectContract;
        },
        handleExceed (files, fileList) {
          if (fileList > 1) {
            this.$message.warning(`已达最大文件数`);
            return false;
          }
        },
        handleRemove (file) {
          this.fileList = [];
          this.pdfFile = '';
        },
        async onSavePdf () {
          // if (!this.isOrderClickPass) {
          //   this.$message.error('订单的相关品牌与工厂不一致，请重新选择');
          //   return;
          // }
          var agreementType = null;
          if (this.contractType == '3') {
            agreementType = 'CUSTOMIZE_COMPLETED';
          }
          if (this.contractType == '2') {
            agreementType = 'CUSTOMIZE';
          }
          if (this.orderSelectFiles.length == 0) {
            this.$message.error('请选择订单');
            return;
          }
          if (this.pdfFile.id == null || this.pdfFile.id == '') {
            this.$message.error('请先上传PDF文件');
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

          let data = {
            'pdf': this.pdfFile,
            'role': role,
            'title': '',
            'customizeCode': this.contractCode,
            'agreementType': agreementType,
            'orderCodes': this.orderSelectFiles.map((order) => order.code)
          }

          const url = this.apis().saveContract();
          let formData = Object.assign({}, data);
          const result = await http.post(url, formData);

          if (result.code == 1) {
            this.$message.success(result.msg);
          } else if (result.code == 0) {
            this.$message.error(result.msg);
            return;
          }

          if (result.data != null && result.data != '') {
            Bus.$emit('openContract', result.data);
          }

          this.$emit('onSearch');
          this.$emit('closeContractPurchaseFormDialog');
          this.$emit('closeContractTypeDialog');
        },
        async onSave () {
          // if (!this.isOrderClickPass) {
          //   this.$message.error('订单的相关品牌与工厂不一致，请重新选择');
          //   return;
          // }
          // return;
          if (this.orderSelectFiles.length == 0) {
            this.$message.error('请选择订单');
            return;
          }

          let bool = false;
          this.orderSelectFiles.forEach((file) => {
            if (file.status == 'PENDING_CONFIRM' || file.status == 'CANCELLED') {
              this.$message.error('当前选择的订单不能是待确认状态和已取消状态');
              bool = true;
            }
          });
          if(bool) return;

          if (this.selectFile.id == null || this.selectFile.id == '') {
            this.$message.error('请选择合同模板');
            return;
          }
          let role = '';
          if (this.partyA) {
            role = 'PARTYA';
          } else {
            role = 'PARTYB';
          }
          var frameAgreementCode = '';
          if (this.hasFrameworkContract) {
            this.agreementType = '';
            if (this.selectContract.code == null || this.selectContract.code == '') {
              return;
            }

            if (this.selectContract.code != null && this.selectContract.code != '') {
              frameAgreementCode = this.selectContract.code;
            }
          }


          let data = {
            'userTempCode': this.selectFile.code,
            'role': role,
            'title': '',
            'frameAgreementCode': frameAgreementCode,
            'orderCodes': this.orderSelectFiles.map((order) => order.code)
          }
          const url = this.apis().saveContract();
          let formData = Object.assign({}, data);
          const result = await http.post(url, formData);

          if (result.code == 1) {
            this.$message.success(result.msg);
          } else if (result.code == 0) {
            this.$message.error(result.msg);
            return;
          }

          if (result.data != null && result.data != '') {
            Bus.$emit('openContract', result.data);
          }
          this.$emit('onSearch');
          this.$emit('closeContractPurchaseFormDialog');
          this.$emit('closeContractTypeDialog');
        },
        onSetOrderCode () {
          if (this.slotData != null && this.slotData != '') {
            this.orderSelectFiles.push(this.slotData);
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
          this.fn.closeSlider(false);
          // this.$router.push("templateForm");
          // this.fn.openSlider('创建', TemplateForm);
          this.tempFormVisible = true;
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
          this.pdfFile = response;
        },
        async getContractList (uid) {
          const url = this.apis().getContractsList();
          const result = await http.post(url, {
            isFrame: true,
            partyACompany: uid,
            state: 'COMPLETE'
          }, {
            page: 0,
            size: 100
          });
          this.mockData = result.content;
        },
        openKJHTSelect () {
          if (this.orderSelectFiles == null || this.orderSelectFiles.length == 0) {
            this.$message.error('请选择关联订单');
            return;
          }

          if (this.currentUser.type == 'BRAND') {
            if (this.orderSelectFiles[0].purchaser != null) {
              this.companyUid = this.orderSelectFiles[0].purchaser.uid;
            }
          } else {
            if (this.orderSelectFiles[0].belongTo != null) {
              this.companyUid = this.orderSelectFiles[0].belongTo.uid;
            }
          }
          this.getContractList(this.companyUid);
          this.dialogContractVisible = true;
        },
        //  订单验证
        async orderContractClick (orders) {
          var flag = false
          if (this.contractType != '1') {
            flag = true
          }
          let data = {
            'orderCodes': orders.map((order) => order.code),
            'type': 'CGDD',
            'isPdfAgreement': flag
          }
          const url = this.apis().orderContractClick();
          const result = await http.post(url, data);
          if (result.code === 0) {
            this.$message.error(result.msg);
            return false;
          } else if (result.code === 1) {
            this.isOrderClickPass = true;
            return true;
          }
        },
        turnTempFormVisible () {
          this.tempFormVisible = !this.tempFormVisible;
        },
        contractTemplateSelect () {
          this.$refs.contractTemplateSelect.onSearchTemp();
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
          orderSelectFiles: [],
          selectFile: {},
          selectContract: {},
          fileList: [],
          dialogPreviewVisible: false,
          orderReadOnly: false,
          input1: '',
          mockData: [],
          orderPage: [],
          disabled: false,
          pdfFile: '',
          pdfVisible: false,
          fileUrl: '',
          thisContract: '',
          agreementType: '',
          tempType: '',
          tempData: [],
          allData: [],
          companyUid: '',
          dialogContractVisible: false,
          cacheSelectContract: '',
          contractCode: '',
          isOrderClickPass: false,
          tempFormVisible: false
        };
      },
      created () {
        this.onSearchOrder('', 0, 10);
        this.onSetOrderCode();
      },
      watch: {
        dialogOrderVisible: function (n, o) {
          if (!n) {
            this.orderContractClick();
          }
        }
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

  /deep/ .el-upload__tip {
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

  /deep/ .el-upload-list__item-file-name {
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

</style>
