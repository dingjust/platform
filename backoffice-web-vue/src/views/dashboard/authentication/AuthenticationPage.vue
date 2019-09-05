<template>
  <el-tabs type="border-card" v-model="activeName" @tab-click="handleClick" :stretch="false"  style="width: 100%" >
    <el-tab-pane label="企业认证" :disabled="isCompany" name="first">
      <authentication-enterprise-from />
    </el-tab-pane>
    <el-tab-pane label="个体户认证" :disabled="isBusiness" name="second">
      <authentication-business-from />
    </el-tab-pane>
    <el-tab-pane label="个人认证" :disabled="isPersonal" name="third">
      <authentication-personal-from  :personalSlotData="personalSlotData"/>
      <!--<authentication-personal-result :disabled="openPersonalDialog" />-->
    </el-tab-pane>
  </el-tabs>
</template>

<script>
  import http from '@/common/js/http';
  import authenticationEnterpriseFrom from './AuthenticationEnterpriseFrom';
  import authenticationBusinessFrom from './AuthenticationBusinessFrom';
  import authenticationPersonalFrom from './AuthenticationPersonalFrom';
  import authenticationPersonalResult from './AuthenticationPersonalResult';

  export default {
    name: 'AuthenticationPage',
    components: {
      authenticationEnterpriseFrom,
      authenticationBusinessFrom,
      authenticationPersonalFrom,
      authenticationPersonalResult
    },
    mixins: [],
    computed: {

    },
    methods: {
      async getPersonalData(){
        const url = this.apis().personalAuthentication();
        const result = await http.get(url);
        console.log(result);
        this.personalSlotData.username = result.data.name;
        this.personalSlotData.idCardNum = result.data.idCard;

        console.log(this.personalSlotData);
      },
      handleClick(tab, event) {
        console.log(tab, event);
      },
      async getAuthenticationState(){
        const url = this.apis().getAuthenticationState();
        const result = await http.get(url);
        console.log(result);
        if(result.data.companyState == 'UNCERTIFIED'){
          this.openEnterpriseDialog = true
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
          if(this.openPersonalDialog){
            this.personalFormVisible = true;
            this.openPersonalDialog = false
          }else{
            this.personalFormVisible = false
            this.openPersonalDialog = true

          }

        }else{
          this.isPersonal = true;
        }
      },
    },
    data() {
      return {
        activeName: 'first',
        uniquecodeFormVisible: false,
        enterpriseFormVisible: false,
        personalFormVisible: false,
        businessFormVisible: false,
        currentUser: this.$store.getters.currentUser,
        isCompany: false,
        isBusiness: false,
        isPersonal: false,
        companyState: '',
        personalState: '',
        openPersonalDialog: false,
        openEnterpriseDialog: false,
        personalResultFormVisible: false,
        personalReadOnly: false,
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
