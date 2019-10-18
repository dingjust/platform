<template>
  <div class="uniquecode-form-body">
    <el-form ref="form" label-position="top" :model="enterpriseSlotData" :rules="rules" :disabled="readOnly">
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button type="info" style="width: 120px" disabled >企业名称</el-button>
      </el-col>
      <el-col :span="12">
        <el-input size="small" v-model="enterpriseSlotData.companyName" placeholder="企业名称" />
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button style="width: 120px" type="info" disabled >社会统一信用代码</el-button>
      </el-col>
      <el-col :span="12">
        <el-input size="small" v-model="enterpriseSlotData.organization" placeholder="税号" />
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button type="info" style="width: 120px" disabled >选择办理人身份</el-button>
      </el-col>
      <el-col :span="12">
      <el-radio-group v-model="enterpriseSlotData.role"  size="mini">
        <el-radio-button style="margin-left: 5px"  label="LEGAL">我是法人</el-radio-button>
        <el-radio-button style="margin-right: 15px " label="AGENT">我是代理人</el-radio-button>
      </el-radio-group>
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button type="info" v-if="enterpriseSlotData.role=='AGENT'" style="width: 120px" disabled >代理人姓名</el-button>
        <el-button type="info" v-if="enterpriseSlotData.role=='LEGAL'" style="width: 120px" disabled >法定代表人</el-button>
      </el-col>
      <el-col :span="12">
        <el-input size="small" v-model="enterpriseSlotData.username" placeholder="姓名" />
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button type="info" style="width: 120px" disabled >身份证号</el-button>
      </el-col>
      <el-col :span="12">
        <el-input size="small" v-model="enterpriseSlotData.idCardNum" placeholder="身份证号" />
      </el-col>
    </el-row>
    <el-row class="seal_custom-row" type="flex" justify="center" align="middle">
      <el-button v-if="companyState == 'UNCERTIFIED'" style="margin-top: 10px;width: 400px" size="mini" type="warning" @click="onSave" >提交认证</el-button>
    </el-row>
    </el-form>
    <el-row class="seal_custom-row" type="flex" justify="center" align="middle">
      <el-button v-if="companyState == 'CHECK'" style="margin-top: 10px;width: 400px" size="mini" type="warning" @click="onSave" >继续认证</el-button>
      <el-button v-if="companyState == 'SUCCESS' || companyState == 'FAILED'" style="margin-top: 10px;width: 400px" size="mini" type="warning" @click="reAuthentication" >重新认证</el-button>
    </el-row>
  </div>
</template>

<script>
  import http from '@/common/js/http';
  export default {
    name: 'AuthenticationEnterpriseFrom',
    props: ['enterpriseSlotData', 'enterpriseReadOnly','companyState'],
    components: {

    },
    mixins: [],
    computed: {

    },
    methods: {
      async onSave(){
        if(this.enterpriseSlotData.companyName == null || this.enterpriseSlotData.companyName == ''){
          this.$message.error('请填写企业名称');
          return;
        }else if(this.enterpriseSlotData.organization == null || this.enterpriseSlotData.organization == ''){
          this.$message.error('请填写税号');
          return;
        }else if(this.enterpriseSlotData.role == null || this.enterpriseSlotData.role == ''){
          this.$message.error('请选择办理人身份');
          return;
        }else if(this.enterpriseSlotData.username == null || this.enterpriseSlotData.username == ''){
          this.$message.error('请填写办理人姓名');
          return;
        }else if(this.enterpriseSlotData.idCardNum == null || this.enterpriseSlotData.idCardNum == ''){
          this.$message.error('请填写办理人身份证');
          return;
        }else{
          const url = this.apis().enterpriseAuthentication();
          const tempData = {
            companyName: this.enterpriseSlotData.companyName,
            organization: this.enterpriseSlotData.organization,
            role: this.enterpriseSlotData.role,
            username: this.enterpriseSlotData.username,
            idCardNum: this.enterpriseSlotData.idCardNum,
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
      },
      reAuthentication(){
        this.readOnly = false;
      }
    },
    data() {
      return {
        rules: {
          companyName: [{required: true, message: '必填', trigger: 'blur'}],
          username: [{required: true, message: '必填', trigger: 'blur'}],
          idCardNum: [{required: true, message: '必填', trigger: 'blur'}],
          role: [{required: true, message: '必填', trigger: 'blur'}],
          organization: [{required: true, message: '必填', trigger: 'blur'}],
        },
        readOnly:false,
      }
    },
    created() {
      this.readOnly = this.enterpriseReadOnly;
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
