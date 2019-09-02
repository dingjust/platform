<template>
  <div class="uniquecode-form-body">
    <el-row class="uniquecode-form-title-row">
      <el-col :span="22" >
        <h6 >企业认证</h6>
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" justify="start" :gutter=3 >
      <el-col :span="7" :push="2">
        <el-button type="info" disabled >企业名称</el-button>
      </el-col>
      <el-col :span="15">
        <el-input size="small" v-model="companyName" placeholder="企业名称" />
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" >
      <el-col :span="7" :push="3">
        <el-button type="info" disabled >税号</el-button>
      </el-col>
      <el-col :span="15">
        <el-input size="small" v-model="organization" placeholder="税号" />
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" >
      <el-col :span="7" :push="1">
        <el-button type="info" disabled >法定代表人</el-button>
      </el-col>
      <el-col :span="15">
        <el-input size="small" v-model="username" placeholder="法定代表人" />
      </el-col>
    </el-row>
    <el-row class="form-row">
      <el-col :span="7" >
        <el-button type="info" disabled >选择办理人身份</el-button>
      </el-col>
      <el-col :span="13">
      <el-radio-group v-model="role"  size="mini">
        <el-radio-button style="margin-left: 5px"  label="LEGAL">我是法人</el-radio-button>
        <el-radio-button style="margin-right: 15px " label="AGENT">我是代理人</el-radio-button>
      </el-radio-group>
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" >
      <el-col :span="7" :push="1">
        <el-button type="info" disabled >操作人姓名</el-button>
      </el-col>
      <el-col :span="15">
        <el-input size="small" v-model="name" placeholder="操作人姓名" />
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" >
      <el-col :span="7">
        <el-button type="info" disabled >操作人身份证号</el-button>
      </el-col>
      <el-col :span="15">
        <el-input size="small" v-model="idCardNum" placeholder="操作人身份证号" />
      </el-col>
    </el-row>
    <el-row class="seal_custom-row" type="flex" justify="center" align="middle">
      <el-button style="margin-top: 10px;width: 200px" size="mini" type="warning" @click="onSave" >提交认证</el-button>
    </el-row>
  </div>
</template>

<script>
  import http from '@/common/js/http';
  export default {
    name: 'AuthenticationEnterpriseFrom',
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
        }else if(this.organization == null || this.organization == ''){
          this.$message.error('税号不能为空');
          return;
        }else if(this.name == null || this.name == ''){
          this.$message.error('操作人姓名不能为空');
          return;
        }else{
          const url = this.apis().enterpriseAuthentication();
          const tempData = {
            companyName: this.companyName,
            organization: this.organization,
            role: this.role,
            username: this.username,
            idCardNum: this.idCardNum,
            verifyWay: 'WAY1',
            companyType: 'TYPE1'
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
        role: "LEGAL",
        companyName:'',
        username:'',
        idCardNum:'',
        organization:'',
        name:'',
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
