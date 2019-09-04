<template>
  <div class="animated fadeIn dashboard-card">
    <el-dialog :visible.sync="uniquecodeFormVisible" width="30%" class="uniquecode-dialog" append-to-body>
      <uniquecode-import-form />
    </el-dialog>
    <el-dialog :visible.sync="enterpriseFormVisible" width="30%" class="uniquecode-dialog" append-to-body>
      <authentication-enterprise-from/>
    </el-dialog>
    <el-dialog :visible.sync="personalFormVisible" width="30%" class="uniquecode-dialog" append-to-body>
      <authentication-personal-from />
    </el-dialog>
    <el-dialog :visible.sync="businessFormVisible" width="30%" class="uniquecode-dialog" append-to-body>
      <authentication-business-from />
    </el-dialog>
    <el-dialog :visible.sync="personalResultFormVisible" width="30%" class="uniquecode-dialog" append-to-body>
      <authentication-personal-result />
    </el-dialog>

    <el-row type="flex" align="middle" justify="start">
      <el-col :span="4">
        <div class="dashboard-title">
          <h6 class="dashboard-title_text">工具直通车：</h6>
        </div>
      </el-col>
      <el-button class="dashboard-toolbar-btn" size="mini" @click="jumpToOrderPurchase">创建线下订单</el-button>
      <el-button class="dashboard-toolbar-btn" size="mini" @click="uniquecodeFormVisible=!uniquecodeFormVisible">唯一码导入
      </el-button>
      <el-button class="dashboard-toolbar-btn" size="mini" @click="jumpToTemplate">电子合同模板</el-button>
      <el-button class="dashboard-toolbar-btn" size="mini" @click="enterprise">企业认证</el-button>
      <el-button class="dashboard-toolbar-btn" size="mini" @click="individualBusiness">个体户认证</el-button>
      <el-button class="dashboard-toolbar-btn" size="mini" @click="personal">个人认证</el-button>
    </el-row>
  </div>
</template>

<script>
  import UniquecodeImportForm from '@/components/custom/UniquecodeImportForm';
  import AuthenticationEnterpriseFrom from '../authentication/AuthenticationEnterpriseFrom';
  import AuthenticationPersonalFrom from '../authentication/AuthenticationPersonalFrom';
  import AuthenticationBusinessFrom from '../authentication/AuthenticationBusinessFrom';
  import AuthenticationPersonalResult from '../authentication/AuthenticationPersonalResult';
  import http from '@/common/js/http';

  export default {
    name: 'ToolbarCard',
    props:['dialogVisible'],
    components: {
      UniquecodeImportForm,
      AuthenticationEnterpriseFrom,
      AuthenticationPersonalFrom,
      AuthenticationBusinessFrom,
      AuthenticationPersonalResult,
    },
    computed: {

    },
    methods: {
      enterprise(){
        if(this.isCompany == null){
          this.enterpriseFormVisible = true
        }else if(this.isCompany == true){
          this.enterpriseFormVisible = true
        }else{
          this.$message.error('该账号已在进行企业认证，不能再进行个体户认证');
        }
      },
      individualBusiness(){
        if(this.isCompany == null){
          this.businessFormVisible = true
        }else if(this.isCompany == false){
          this.businessFormVisible = true
        }else{
          this.$message.error('该账号已在进行个体户认证，不能再进行企业认证');
        }
      },
      personal(){
        if(this.currentUser.type == 'BRAND'){
          if(!this.openPersonalDialog){
            this.personalFormVisible = true
          }else{
            this.personalResultFormVisible = true
          }

        }else{
          this.$message.error('工厂用户不能做个人认证');
        }
      },
      async getAuthenticationState(){
        const url = this.apis().getAuthenticationState();
        const result = await http.get(url);
        console.log(result);
        if(result.data.companyState == 'SUCCESS'){
          this.openEnterpriseDialog = true
        }
        if(result.data.personalState == 'SUCCESS'){
          this.openPersonalDialog = true
        }
        if(result.data.companyType == null){
          this.isCompany = null;
        }else if(result.data.companyType == 'INDIVIDUAL'){
          this.isCompany = false;
        }else{
          this.isCompany = true;
        }

      },
      showEnterpriseDialog(){
      },
      onSetting() {

      },
      jumpToTemplate() {
        this.$router.push("template");
      },
      jumpToOrderPurchase() {
        this.$router.push("orderPurchase");
      }
    },
    data() {
      return {
        uniquecodeFormVisible: false,
        enterpriseFormVisible: false,
        personalFormVisible:false,
        businessFormVisible:false,
        currentUser: this.$store.getters.currentUser,
        isCompany:null,
        companyState:'',
        personalState:'',
        openPersonalDialog:false,
        openEnterpriseDialog:false,
        personalResultFormVisible:false,
      };
    },
    created() {
      this.getAuthenticationState();
    }
  };

</script>
<style>
  .dashboard-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .dashboard-title2 {
    width: 100%;
    padding-left: 12px;
    height: 14px;
  }

  .dashboard-title_text {
    font-size: 12px;
    font-weight: bold;
    color: rgba(0, 0, 0, 0.85);
  }

  .dashboard-toolbar-btn {
    border: 0.5px solid rgba(255, 164, 3, 1);
    color: rgba(255, 164, 3, 1);
    /* height: ; */
    font-size: 10px;
  }

  .uniquecode-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .uniquecode-dialog-header {
    padding: 0px !important;
  }

  .uniquecode-dialog .el-dialog__header {
    padding: 0px !important;
  }
</style>
