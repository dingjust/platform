<template>
  <div class="uniquecode-form-body">
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button style="width: 120px" type="info" disabled >企业名称</el-button>
      </el-col>
      <el-col :span="12">
        <el-input size="small" v-model="companyName" placeholder="企业名称" />
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button style="width: 120px" type="info" disabled >认证方式</el-button>
      </el-col>
      <el-col :span="12">
        <el-radio-group v-model="type"  size="mini">
          <el-radio-button label="WAY1">对公账号认证</el-radio-button>
          <el-radio-button label="WAY2">无对公账号认证</el-radio-button>
        </el-radio-group>
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button  style="width: 120px" type="info" disabled >法人名称</el-button>
      </el-col>
      <el-col :span="12">
        <el-input size="small" v-model="username" placeholder="法人名称" />
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button style="width: 120px" type="info" disabled >法人身份证号</el-button>
      </el-col>
      <el-col :span="12">
        <el-input size="small" v-model="idCardNum" placeholder="法人身份证号" />
      </el-col>
    </el-row>
    <el-row class="seal_custom-row" type="flex" justify="center" align="middle">
      <el-button style="margin-top: 10px;width: 400px" size="mini" type="warning" @click="onSave" >提交认证</el-button>
    </el-row>
  </div>
</template>

<script>
  import http from '@/common/js/http';

  export default {
    name: 'AuthenticationBusinessFrom',
    components: {

    },
    mixins: [],
    computed: {

    },
    methods: {
      async onSave(){
        if(this.companyName == null || this.companyName == ''){
          this.$message.error('企业名称不能为空');
          return;
        }else if(this.username == null || this.username == ''){
          this.$message.error('法人名字不能为空');
          return;
        }else if(this.idCardNum == null || this.idCardNum == ''){
          this.$message.error('法人身份证号不能为空');
          return;
        }else{
          const url = this.apis().enterpriseAuthentication();
          const tempData = {
            companyName: this.companyName,
            organization: '',
            role: 'LEGAL',
            username: this.username,
            idCardNum: this.idCardNum,
            verifyWay: this.type,
            companyType: 'TYPE2'
          };
          let formData = Object.assign({}, tempData);
          const result = await http.post(url, formData);
          if(result.data !=  null){
            window.open(result.data, '_blank');
          }else{
            this.$message.success(result.msg);
          }
        }

      }
    },
    data() {
      return {
        uniqueCode: '',
        order: '',
        role: "",
        idCardNum:'',
        companyName:'',
        username:'',
        type:'WAY1',
      }
    },
    created() {

    },
    mounted() {}

  }

</script>
<style>
  .form-row{
    margin-top: 10px;
  }
  .uniquecode-form-body {
    width: 100%;
  }

  .uniquecode-form-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .uniquecode-form-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .uniquecode-form-title-row {
    margin-bottom: 20px;
  }

  .uniquecode-form-order {
    background-color: rgba(0, 0, 0, 0.02);
    padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    padding-right: 10px;
    margin-top: 20px;
  }

  .uniquecode-form-text {
    font-size: 12px;
    color: rgba(51, 48, 48, 0.65);
  }

  .uniquecode-form-btn {
    background: #FFD60C;
    color: rgba(0, 0, 0, 0.85);
    width: 200px;
    margin-top: 20px;
  }

</style>
