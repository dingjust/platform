<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="dialogTemplateVisible" :show-close="false">
      <el-row slot="title" type="flex" justify="space-between" align="middle">
        <el-col :span="4">
          <div class="template-form-header">
            <h6>文件选择</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <el-button-group>
            <el-button class="template-form-button" @click="onFileSelectSure">确定</el-button>
            <el-button @click="dialogTemplateVisible=false">关闭</el-button>
          </el-button-group>
        </el-col>
      </el-row>
      <contract-template-select @fileSelectChange="onFileSelectChange" />
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
        <el-col :span="20" offset="2">
          <el-input size="small" placeholder="选择订单" v-model="input1" :disabled="true">
            <el-button slot="prepend">关联订单</el-button>
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType=='1'">
        <el-col :span="20" offset="2">
          <el-input size="small" placeholder="选择合同模板" v-model="selectFile.name" :disabled="true">
            <el-button slot="prepend" @click="dialogTemplateVisible=true">合同模板</el-button>
          </el-input>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" v-if="contractType!='1'">
        <el-col :span="20" offset="2">
          <!-- <el-input size="small" placeholder="选择纸质合同" v-model="input1" :disabled="true">
            <el-button slot="prepend">上传纸质合同</el-button>
          </el-input> -->
          <el-upload class="upload-demo" action="https://jsonplaceholder.typicode.com/posts/" multiple :limit="1"
            :on-exceed="handleExceed" :file-list="fileList">
            <el-button size="small">上传纸质合同</el-button>
            <div slot="tip" class="el-upload__tip">只能上传PDF文件</div>
          </el-upload>
        </el-col>
      </el-row>
      <el-row class="create-contract-row" type="flex" justify="center">
        <el-col :span="4" :offset="-2">
          <el-button class="create-contract-button" @click="dialogPreviewVisible=true">预览合同</el-button>
        </el-col>
        <el-col :span="4" :offset="2">
          <el-button class="create-contract-button_2">生成合同</el-button>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import ContractTypeSelect from "./components/ContractTypeSelect";
  import ContractTemplateSelect from "./components/ContractTemplateSelect";
  import ContractPreview from "./components/ContractPreview";

  export default {
    name: "CreateContract",
    components: {
      ContractTypeSelect,
      ContractTemplateSelect,
      ContractPreview
    },
    methods: {
      onContractTypeChange(val) {
        this.contractType = val;
      },
      //文件选择（缓存，并未确定）
      onFileSelectChange(data) {
        this.cacheSelectFile = data;
      },
      //文件选择确定
      onFileSelectSure() {
        this.dialogTemplateVisible = false;
        this.selectFile = this.cacheSelectFile;
      },
      handleExceed(files, fileList) {
        this.$message.warning(`${files}`);
        console.log(files);
      },
    },
    data() {
      return {
        contractType: '1',
        hasFrameworkContract: false,
        partyA: true,
        dialogTemplateVisible: false,
        cacheSelectFile: {},
        selectFile: {},
        fileList: [],
        dialogPreviewVisible: false,
      };
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

</style>
