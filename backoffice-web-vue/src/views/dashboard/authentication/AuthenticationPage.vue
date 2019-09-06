<template>
  <el-tabs type="border-card" v-model="activeName" @tab-click="handleClick" :stretch="false"  style="width: 100%" >
    <el-tab-pane label="企业认证" :disabled="isCompany" name="first">
      <authentication-enterprise-from  :companyState="companyState" :enterpriseSlotData="enterpriseSlotData" :enterpriseReadOnly="enterpriseReadOnly"/>
    </el-tab-pane>
    <el-tab-pane v-if="companyState == 'CHECK' && companyType == 'ENTERPRISE'" label="企业认证（认证中）" :disabled="isCompany" name="first">
      <authentication-enterprise-from  :companyState="companyState" :enterpriseSlotData="enterpriseSlotData" :enterpriseReadOnly="enterpriseReadOnly"/>
    </el-tab-pane>
    <el-tab-pane v-if="companyState == 'SUCCESS' && companyType == 'ENTERPRISE'" label="企业认证（已认证）" :disabled="isCompany" name="first">
      <authentication-enterprise-from  :companyState="companyState" :enterpriseSlotData="enterpriseSlotData" :enterpriseReadOnly="enterpriseReadOnly"/>
    </el-tab-pane>
    <el-tab-pane  label="个体户认证" :disabled="isBusiness" name="second">
      <authentication-business-from  :companyState="companyState" :businessSlotData="businessSlotData" :businessReadOnly="businessReadOnly"/>
    </el-tab-pane>
    <el-tab-pane v-if="companyState == 'CHECK' && companyType == 'INDIVIDUAL'" label="个体户认证" :disabled="isBusiness" name="second">
      <authentication-business-from  :companyState="companyState" :businessSlotData="businessSlotData" :businessReadOnly="businessReadOnly"/>
    </el-tab-pane>
    <el-tab-pane  v-if="companyState == 'SUCCESS' && companyType == 'INDIVIDUAL'"  label="个体户认证" :disabled="isBusiness" name="second">
      <authentication-business-from  :companyState="companyState" :businessSlotData="businessSlotData" :businessReadOnly="businessReadOnly"/>
    </el-tab-pane>
    <el-tab-pane v-if="personalState == 'UNCERTIFIED'" label="个人认证" :disabled="isPersonal" name="third">
      <authentication-personal-from :personalState="personalState" :personalSlotData="personalSlotData" :personalReadOnly="personalReadOnly"/>
    </el-tab-pane>
    <el-tab-pane  v-if="personalState == 'CHECK'" label="个人认证（认证中）" :disabled="isPersonal" name="third">
      <authentication-personal-from :personalState="personalState" :personalSlotData="personalSlotData" :personalReadOnly="personalReadOnly"/>
    </el-tab-pane>
    <el-tab-pane v-if="personalState == 'SUCCESS'" label="个人认证（已认证）" :disabled="isPersonal" name="third">
      <authentication-personal-from :personalState="personalState" :personalSlotData="personalSlotData" :personalReadOnly="personalReadOnly"/>
    </el-tab-pane>
  </el-tabs>
</template>

<script>
  import http from '@/common/js/http';
  import authenticationEnterpriseFrom from './AuthenticationEnterpriseFrom';
  import authenticationBusinessFrom from './AuthenticationBusinessFrom';
  import authenticationPersonalFrom from './AuthenticationPersonalFrom';

  export default {
    name: 'AuthenticationPage',
    components: {
      authenticationEnterpriseFrom,
      authenticationBusinessFrom,
      authenticationPersonalFrom,
    },
    mixins: [],
    computed: {

    },
    methods: {
      async getPersonalData(){
        const url = this.apis().getAuthenticationInfo();
        const result = await http.get(url);
        console.log(result);
        this.personalSlotData.username = result.data.name;
        this.personalSlotData.idCardNum = result.data.idCard;

        console.log(this.personalSlotData);
      },
      async getData(){
        console.log(this.companyState)
        const url = this.apis().getAuthenticationEnterprise();
        const result = await http.get(url);
        console.log(result);
        if(this.companyType == 'ENTERPRISE'){
          this.enterpriseSlotData.companyName = result.data.name;
          this.enterpriseSlotData.organization = result.data.organization;
          if(result.data.agent != null ){
            this.enterpriseSlotData.role = 'AGENT';
            this.enterpriseSlotData.username = result.data.agent.name;
            this.enterpriseSlotData.idCardNum = result.data.agent.idCardNum;
          }else{
            this.enterpriseSlotData.role = 'LEGAL';
            this.enterpriseSlotData.username = result.data.legal.name;
            this.enterpriseSlotData.idCardNum = result.data.legal.idCardNum;
          }
        }
        if(this.companyType == 'INDIVIDUAL'){
          this.businessSlotData.companyName = result.data.name;
          this.businessSlotData.username = result.data.legal.name;
          this.businessSlotData.idCardNum = result.data.legal.idCardNum;

        }
      },
      handleClick(tab, event) {
        console.log(tab, event);
      },
      async getAuthenticationState(){
        const url = this.apis().getAuthenticationState();
        const result = await http.get(url);
        console.log(result);
        this.personalState = result.data.personalState;
        this.companyState = result.data.companyState;
        if(result.data.companyState == 'UNCERTIFIED'){
          if(result.data.companyType == 'ENTERPRISE'){
            this.companyType = 'ENTERPRISE';
            this.enterpriseReadOnly = false
          }else if(result.data.companyType == 'INDIVIDUAL'){
            this.businessReadOnly = false
            this.companyType = 'INDIVIDUAL';
          }else{
            this.enterpriseReadOnly = false
            this.businessReadOnly = false
          }
        }else{
          if(result.data.companyType == 'ENTERPRISE'){
            this.enterpriseReadOnly = true
            this.companyType = 'ENTERPRISE';
            this.getData();
          }else {
            this.businessReadOnly = true
            this.companyType = 'INDIVIDUAL';
            this.getData();
          }
        }
        if(result.data.personalState == 'UNCERTIFIED'){
          this.personalReadOnly = false
        }else{
          this.personalReadOnly = true;
          this.getPersonalData();
        }
        // if(result.data.companyType == null){
        //   this.isCompany = null;
        // }else if(result.data.companyType == 'INDIVIDUAL'){
        //   this.isCompany = false;
        // }else{
        //   this.isCompany = true;
        // }

      },
      personal(){
        if(this.currentUser.type == 'BRAND'){

        }else{
          this.isPersonal = true;
        }
      },
    },
    data() {
      return {
        activeName: 'first',
        currentUser: this.$store.getters.currentUser,
        isCompany: false,
        isBusiness: false,
        isPersonal: false,
        companyType:'',
        companyState: '',
        personalState: '',
        enterpriseReadOnly: false,
        businessReadOnly: false,
        personalReadOnly: false,
        enterpriseSlotData:{
          companyName:'',
          organization:'',
          username:'',
          role:'LEGAL',
          name:'',
          idCardNum:''
        },
        businessSlotData:{
          role: "LEGAL",
          idCardNum:'',
          companyName:'',
          username:'',
          type:'WAY1',
        },
        personalSlotData:{
          username:'',
          idCardNum:'',
        },
      }
    },
    created() {
      this.getAuthenticationState();
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
