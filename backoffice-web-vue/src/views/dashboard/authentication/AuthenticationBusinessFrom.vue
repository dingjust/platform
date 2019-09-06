<template>
  <div class="uniquecode-form-body">
    <el-form ref="form" label-position="top" :model="businessSlotData" :rules="rules" :disabled="businessReadOnly">
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button style="width: 120px" type="info" disabled >企业名称</el-button>
      </el-col>
      <el-col :span="12">
        <el-input size="small" v-model="businessSlotData.companyName" placeholder="企业名称" />
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button style="width: 120px" type="info" disabled >认证方式</el-button>
      </el-col>
      <el-col :span="12">
        <el-radio-group v-model="businessSlotData.type"  size="mini">
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
        <el-input size="small" v-model="businessSlotData.username" placeholder="法人名称" />
      </el-col>
    </el-row>
    <el-row class="form-row" type="flex" justify="center" :gutter=15 >
      <el-col :span="3" >
        <el-button style="width: 120px" type="info" disabled >法人身份证号</el-button>
      </el-col>
      <el-col :span="12">
        <el-input size="small" v-model="businessSlotData.idCardNum" placeholder="法人身份证号" />
      </el-col>
    </el-row>
    <el-row class="seal_custom-row" type="flex" justify="center" align="middle">
      <el-button v-if="companyState == 'UNCERTIFIED'"  style="margin-top: 10px;width: 400px" size="mini" type="warning" @click="onSave" >提交认证</el-button>
    </el-row>
    </el-form>
    <el-row class="seal_custom-row" type="flex" justify="center" align="middle">
      <el-button v-if="companyState == 'CHECK'" style="margin-top: 10px;width: 400px" size="mini" type="warning" @click="onSave" >继续认证</el-button>
      <el-button v-if="companyState == 'SUCCESS'" style="margin-top: 10px;width: 400px" size="mini" type="warning" @click="onSave" >重新认证</el-button>
    </el-row>
  </div>
</template>

<script>
  import http from '@/common/js/http';

  export default {
    name: 'AuthenticationBusinessFrom',
    props: ['businessSlotData', 'businessReadOnly','companyState'],
    components: {

    },
    mixins: [],
    computed: {

    },
    methods: {
      async onSave(){
          const url = this.apis().enterpriseAuthentication();
          const tempData = {
            companyName: this.businessSlotData.companyName,
            organization: '',
            role: 'LEGAL',
            username: this.businessSlotData.username,
            idCardNum: this.businessSlotData.idCardNum,
            verifyWay: this.businessSlotData.type,
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
    },
    data() {
      return {
        rules: {
          companyName: [{required: true, message: '必填', trigger: 'blur'}],
          username: [{required: true, message: '必填', trigger: 'blur'}],
          idCardNum: [{required: true, message: '必填', trigger: 'blur'}],
          verifyWay: [{required: true, message: '必填', trigger: 'blur'}],
        },
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
