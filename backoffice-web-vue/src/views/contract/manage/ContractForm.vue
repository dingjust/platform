<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="dialogTemplateVisible" width="80%" class="purchase-dialog" append-to-body>
          <el-button-group>
            <el-button class="product-select-btn" @click="onFileSelectSure">确定</el-button>
            <el-button class="product-select-btn" @click="onCreateTemp">创建模板</el-button>
          </el-button-group>
      <contract-template-select  @fileSelectChange="onFileSelectChange" />
    </el-dialog>
    <el-dialog :visible.sync="dialogOrderVisible" width="80%" class="purchase-dialog" append-to-body>
      <contract-order-select :page="orderPage" :onSearchOrder="onSearchOrder" @onOrderSelectChange="onOrderSelectChange" />
    </el-dialog>
    <el-dialog :visible.sync="dialogPreviewVisible" width="80%">
      <el-row slot="title">
        <el-button>生成合同</el-button>
      </el-row>
      <contract-preview />
    </el-dialog>
    <el-card class="box-card card-body">
      <el-row type="flex" justify="center" align="middle">
        <span class="create-contract-title">创建合同</span>
      </el-row>
      <contract-type-select @contractTypeChange="onContractTypeChange" class="contractTypeSelect" />
      <el-row type="flex" justify="space-around">
        <el-col :span="6">
          <el-row type="flex" justify="space-between">
            <el-radio v-model="hasFrameworkContract" :label="false">无框架合同</el-radio>
            <el-radio v-model="hasFrameworkContract" :label="true">有框架合同</el-radio>
          </el-row>
        </el-col>
        <el-divider direction="vertical"></el-divider>
        <el-col :span="6">
          <el-row type="flex" justify="space-between">
            <el-radio v-model="partyA" :label="true">我是甲方</el-radio>
            <el-radio v-model="partyA" :label="false">我是乙方</el-radio>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="create-contract-row">
        <el-col :span="20" :offset="2">
          <el-input size="small" placeholder="选择订单" v-model="orderSelectFile.code" :disabled="true">
            <el-button slot="prepend" :disabled="orderReadOnly" @click="dialogOrderVisible=true">关联订单</el-button>
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType=='1'">
        <el-col :span="20" :offset="2">
          <el-input size="small" placeholder="选择合同模板" v-model="selectFile.title" :disabled="true">
            <el-button slot="prepend" @click="dialogTemplateVisible=true">合同模板</el-button>
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType!='1'">
        <el-col :span="8" :offset="2">
           <el-input size="small" placeholder="选择纸质合同" v-model="input1" :disabled="true">
            <el-button slot="prepend">上传纸质合同</el-button>
          </el-input>
          <el-upload class="upload-demo" action="https://jsonplaceholder.typicode.com/posts/" multiple :limit="1"
            list-type="picture-card" :on-exceed="handleExceed" :file-list="fileList">
             <el-button size="small">上传纸质合同</el-button>
            <div slot="tip" class="el-upload__tip">只能上传PDF文件</div>
            <i slot="default" class="el-icon-plus"></i>
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
      <el-row class="create-contract-row" type="flex" justify="center">
        <el-col :span="4" :offset="-2">
          <!--<el-button class="create-contract-button" @click="dialogPreviewVisible=true">预览合同</el-button>-->
        </el-col>
        <el-col :span="4" :offset="2">
          <el-button class="create-contract-button_2" @click="onSave">生成合同</el-button>
        </el-col>
      </el-row>
    </el-card>
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
    },
    computed: {
      ...mapGetters({
        page: "page",
        keyword: "keyword"
      })
    },
    methods: {
      ...mapActions({
        search: "search",
        refresh: 'refresh'
      }),
      async onSearchOrder(keyword,page, size) {
        if(keyword == null){
          keyword = '';
        }
        console.log(2)
        const url = this.apis().getPurchaseOrders();
        const result = await this.$http.post(url,{
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
        console.log(result);
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
        console.log(data);
        this.orderSelectFile = data;
        this.dialogOrderVisible = false;
      },
      //文件选择确定
      onFileSelectSure() {
        this.dialogTemplateVisible = false;
        this.selectFile = this.cacheSelectFile;
        console.log(this.selectFile);
      },
      handleExceed(files, fileList) {
        this.$message.warning(`已达最大文件数`);
        console.log(files);
      },
      handleRemove(file) {
        this.fileList.pop(file);
      },
      async onSave(){
        if(this.orderSelectFile == null){
          return;
        }
        if(this.selectFile == null){
          return;
        }
        let role = '';
        if(this.partyA){
          role = 'PARTYA';
        }else{
          role = 'PARTYB';
        }

        let data = {
          'userTempCode' : this.selectFile.code,
          'role':role,
          'title':'',
          'orderCode':this.orderSelectFile.code,
        }

        const url = this.apis().saveContract();
        let formData = Object.assign({}, data);
        const result = await http.post(url, formData);

        this.$message.success(result.msg);

        const searchUrl = this.apis().getContractsList();
        // const result = await this.$http.post(url,{
        //   keyword: ''
        // }, {
        //   page: 0,
        //   size: 10
        // });
        // if (result["errors"]) {
        //   this.$message.error(result["errors"][0].message);
        //   return;
        // }

        this.refresh({searchUrl});

        this.fn.closeSlider(true);

      },
      onSetOrderCode(){
        if(this.slotData != null && this.slotData != ''){
          console.log(111)
          this.orderSelectFile = this.slotData;
          this.orderReadOnly = true;
          if(this.currentUser.type == 'BRAND'){
            this.partyA = true;
          }else{
            this.partyA = false;
          }
        }
      },
      onCreateTemp() {
        // this.$router.push("templateForm");
        this.fn.openSlider("创建", TemplateForm);
      },
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        contractType: '1',
        hasFrameworkContract: false,
        partyA: true,
        dialogTemplateVisible: false,
        dialogOrderVisible : false,
        cacheSelectFile: {},
        orderSelectFile:{},
        selectFile: {},
        fileList: [],
        dialogPreviewVisible: false,
        orderReadOnly : false,
        input1:'',
        mockData:[],
        orderPage:[],
      };
    },
    created(){
      this.onSearchOrder('',0,10);
      console.log('sss'+this.slotData);
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
    margin-left:10px;
  }
</style>
