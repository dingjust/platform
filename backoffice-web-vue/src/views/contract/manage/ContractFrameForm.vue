<template>
  <div>
    <el-dialog :destroy-on-close="true" :visible.sync="dialogTemplateVisible" width="80%" class="purchase-dialog" append-to-body>
      <el-button-group>
        <el-button class="product-select-btn" @click="onFileSelectSure">确定</el-button>
        <el-button class="product-select-btn" @click="onCreateTemp">创建模板</el-button>
      </el-button-group>
      <contract-template-select :tempType="tempType" @fileSelectChange="onFileSelectChange" />
    </el-dialog>
    <el-dialog :visible.sync="suppliersSelectVisible" width="40%" class="purchase-dialog" append-to-body>
      <supplier-select @onSelect="onSuppliersSelect" />
    </el-dialog>
    <el-dialog :visible.sync="dialogPreviewVisible" width="80%">
      <el-row slot="title">
        <el-button>生成合同</el-button>
      </el-row>
      <contract-preview />
    </el-dialog>
    <el-dialog :visible.sync="pdfVisible" :show-close="true" style="width: 100%">
      <contract-preview-pdf :fileUrl="fileUrl" :slotData="thisContract" />
    </el-dialog>
    <div>
      <el-row type="flex" justify="center" align="middle">
        <span class="create-contract-title">创建合同</span>
      </el-row>
      <contract-type-select @contractTypeChange="onContractTypeChange" class="contractTypeSelect" />
      <el-row class="create-contract-row">
        <el-col :span="20" :offset="2">
          <el-input size="small" placeholder="选择合作商" v-model="suppliers.name" :disabled="true">
            <el-button slot="prepend" :disabled="orderReadOnly" @click="suppliersSelectVisible=true">合作商</el-button>
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
        <el-col :span="8" :offset="2">
          <el-upload name="file" :action="mediaUploadUrl" list-type="picture-card" :data="uploadFormData"
                     :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers" :on-exceed="handleExceed"
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
      <el-row class="create-contract-row" type="flex" justify="start">
        <el-col :push="2" :span="8">
          <span class="tips">合同有效期</span>
            <el-date-picker v-model="dateTime" type="daterange" align="right" unlink-panels range-separator="至"
                            value-format="yyyy-MM-dd"  start-placeholder="开始日期" end-placeholder="结束日期" :picker-options="pickerOptions">
            </el-date-picker>
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
          <!--<el-button class="create-contract-button" @click="dialogPreviewVisible=true">预览合同</el-button>-->
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
  } from "vuex";
  import ContractTypeSelect from "./components/ContractTypeSelect";
  import ContractTemplateSelect from "./components/ContractTemplateSelect";
  import ContractPreview from "./components/ContractPreview";
  import ContractOrderSelect from "./components/ContractOrderSelect";
  import http from '@/common/js/http';
  import TemplateForm from "../../contract/template/components/TemplateForm";
  import Bus from '@/common/js/bus.js';
  import ContractPreviewPdf from './components/ContractPreviewPdf'
  import SupplierSelect from '@/components/custom/SupplierSelect';


  const {
    mapGetters,
    mapActions
  } = createNamespacedHelpers(
    "ContractModule"
  );


  export default {
    name: "ContractForm",
    props: ['slotData'],
    components: {
      ContractTypeSelect,
      ContractTemplateSelect,
      ContractPreview,
      ContractOrderSelect,
      TemplateForm,
      ContractPreviewPdf,
      SupplierSelect,
    },
    computed: {
      ...mapGetters({
        page: "page",
        keyword: "keyword"
      }),
      uploadFormData: function () {
        return {
          fileFormat: 'DefaultFileFormat',
          conversionGroup: 'DefaultProductConversionGroup',
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
        search: "search",
        refresh: 'refresh'
      }),
      selectTemp(str){
        if(str == 'KJXY'){
          this.tempType = 'KJXY';
        }

        this.dialogTemplateVisible=true;
      },
      async onSearchOrder(keyword, page, size) {
        if (keyword == null) {
          keyword = '';
        }
        const url = this.apis().getPurchaseOrders();
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
        this.orderPage = result;
      },
      onContractTypeChange(val) {
        this.contractType = val;
      },
      //文件选择（缓存，并未确定）
      onFileSelectChange(data) {
        this.cacheSelectFile = data;
      },
      //订单选择
      onOrderSelectChange(data) {
        this.orderSelectFile = data;
        this.dialogOrderVisible = false;
      },
      //文件选择确定
      onFileSelectSure() {
        this.dialogTemplateVisible = false;
        this.selectFile = this.cacheSelectFile;
      },
      handleExceed(files, fileList) {
        if (fileList > 1) {
          this.$message.warning(`已达最大文件数`);
          return false;
        }

      },
      handleRemove(file) {
        this.fileList = [];
        this.pdfFile = '';
      },
      async onSavePdf() {
        if (this.pdfFile.id == null || this.pdfFile.id == '') {
          this.$message.error('请上传PDF');
          return;
        }
        if (this.suppliers.id == null || this.suppliers.id == '') {
          this.$message.error('请选择合作商');
          return;
        }
        if(this.dateTime == '' || this.dateTime == null){
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
          'pdf': this.pdfFile,
          'role': role,
          'title': '',
          'validityEnd': this.dateTime[1],
          'validityStart': this.dateTime[0],
          'isFrame' : true,
          'partnerCompanyCode':this.suppliers.id,
        }

        const url = this.apis().saveContract();
        let formData = Object.assign({}, data);
        const result = await http.post(url, formData);

        this.$message.success(result.msg);

        const searchUrl = this.apis().getContractsList();

        this.refresh({
          searchUrl
        });

        this.fn.closeSlider(true);
      },
      async onSave() {
        console.log(this.suppliers);
        if (this.suppliers.id == null || this.suppliers.id == '') {
          this.$message.error('请选择合作商');
          return;
        }
        if (this.selectFile.id == null || this.selectFile.id == '') {
          this.$message.error('请选择合同模板');
          return;
        }
        if(this.dateTime == '' || this.dateTime == null){
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
          'isFrame' : true,
          'partnerCompanyCode':this.suppliers.id,
        }

        const url = this.apis().saveContract();
        let formData = Object.assign({}, data);
        const result = await http.post(url, formData);

        this.$message.success(result.msg);

        if (result.data != null && result.data != '') {
          Bus.$emit('openContract', result.data);
        }

        const searchUrl = this.apis().getContractsList();

        this.refresh({
          searchUrl
        });
        this.fn.closeSlider(true);
      },
      onSetOrderCode() {
        if (this.slotData != null && this.slotData != '') {
          this.orderSelectFile = this.slotData;
          this.orderReadOnly = true;
          if (this.currentUser.type == 'BRAND') {
            this.partyA = true;
          } else {
            this.partyA = false;
          }
        }
      },
      onCreateTemp() {
        // this.$router.push("templateForm");
        this.fn.openSlider("创建", TemplateForm);
      },
      handlePreview(file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      },
      onBeforeUpload(file) {
        if (file.type !== 'application/pdf') {
          this.$message.error('选择的文件不是PDF文件');
          return false;
        }
        return true;
      },
      onSuccess(response) {
        this.pdfFile = response;
      },
      onSuppliersSelect(val) {
        this.suppliers = val;
        this.suppliersSelectVisible = false;
        // this.form.companyOfSeller = val.name;
        // this.form.contactPersonOfSeller = val.contactPerson;
        // this.form.contactOfSeller = val.contactPhone;
      },
    },
    data() {
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
        pdfFile: '',
        pdfVisible: false,
        fileUrl: '',
        thisContract: '',
        agreementType:'',
        tempType:'KJXY',
        tempData:[],
        allData:[],
        dateTime:'',
        pickerOptions: {
          shortcuts: [{
            text: '最近一周',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '最近一个月',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '最近三个月',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
              picker.$emit('pick', [start, end]);
            }
          }]
        },
        suppliersSelectVisible:false,
        suppliers:'',
      };
    },
    created() {
      this.onSearchOrder('', 0, 10);
      this.onSetOrderCode();
    }
  };

</script>
<style>
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

  .el-upload-list--picture-card .el-upload-list__item {
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

  .el-upload--picture-card {
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
  }

  .tips {
    margin-right: 15px;
    margin-left: 5px;
  }

</style>
