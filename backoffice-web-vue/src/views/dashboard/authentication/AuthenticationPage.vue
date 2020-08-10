<template>
  <el-card class="card-body">
    <el-row type="flex" align="middle">
      <el-col :span="12">
        <div class="auth-btn" :class="{'auth-btn_active':activeName=='first'}" @click="activeName='first'">
          <h6>企业认证<span class="auth-state"
              :class="{'auth-state_success':companyState == 'SUCCESS'}">{{companyBtnState}}</span>
          </h6>
        </div>
      </el-col>
      <el-col :span="12">
        <div class="auth-btn" :class="{'auth-btn_active':activeName=='third'}" @click="onPersonal">
          <h6>个人认证<span class="auth-state"
              :class="{'auth-state_success':personalState == 'SUCCESS'}">{{personalBtnState}}</span></h6>
        </div>
      </el-col>
    </el-row>
    <template v-if="activeName=='first'&&hackSet">
      <el-row type="flex" justify="end">
        <div class="state-tag">
          <el-image style="width: 200px; height: 200px" v-if="companyState == 'SUCCESS'"
            src="static/img/auth_success.png" fit="contain"></el-image>
          <el-image style="width: 200px; height: 200px" v-if="companyState == 'FAIL'" src="static/img/auth_fail.png"
            fit="contain"></el-image>
        </div>
      </el-row>
      <authentication-enterprise-from :companyState="companyState" :enterpriseSlotData="enterpriseSlotData"
        :enterpriseReadOnly="enterpriseReadOnly" />
    </template>
    <template v-if="activeName=='third'&&hackSet">
      <el-row type="flex" justify="end">
        <div class="state-tag">
          <el-image style="width: 200px; height: 200px" v-if="personalState == 'SUCCESS'"
            src="static/img/auth_success.png" fit="contain"></el-image>
          <el-image style="width: 200px; height: 200px" v-if="personalState == 'FAIL'" src="static/img/auth_fail.png"
            fit="contain"></el-image>
        </div>
      </el-row>
      <authentication-personal-from :personalState="personalState" :personalSlotData="personalSlotData"
        :personalReadOnly="personalReadOnly" />
    </template>
    <el-row type="flex" justify="center">
      <h6 class="red-message">注：以上所有信息确保与营业执照上信息一致。</h6>
    </el-row>
    <el-row type="flex" justify="center">
      <h6 class="red-message">剩余认证次数3次，超过三次后将需要收50元一次的认证费用。</h6>
    </el-row>
  </el-card>
</template>

<script>
  import http from '@/common/js/http';
  import authenticationEnterpriseFrom from './AuthenticationEnterpriseFrom';
  import authenticationBusinessFrom from './AuthenticationBusinessFrom';
  import authenticationPersonalFrom from './AuthenticationPersonalFrom';
  import {
    ReturnNum
  } from '../../shipping-receipt/components/shipping-dynamic-table/table-constants';

  export default {
    name: 'AuthenticationPage',
    components: {
      authenticationEnterpriseFrom,
      authenticationBusinessFrom,
      authenticationPersonalFrom,
    },
    computed: {
      //企业认证状态
      companyBtnState: function () {
        if (this.companyState == 'UNCERTIFIED' || (this.companyType == 'INDIVIDUAL' &&
            this.companyState != 'UNCERTIFIED' && this.companyState != 'FAIL')) {
          return '(未认证)';
        } else if (this.companyState == 'FAIL' && this.companyType == 'ENTERPRISE') {
          return '(认证失败)';
        } else if (this.companyState == 'CHECK' && this.companyType == 'ENTERPRISE') {
          return '(认证中)';
        } else if (this.companyState == 'SUCCESS' && this.companyType == 'ENTERPRISE') {
          return '(已认证)';
        } else {
          return '';
        }
      },
      //个人认证状态
      personalBtnState: function () {
        if (this.personalState == 'UNCERTIFIED') {
          return '(未认证)';
        } else if (this.personalState == 'CHECK') {
          return '(认证中)';
        } else if (this.personalState == 'SUCCESS') {
          return '(已认证)'
        } else if (this.personalState == 'FAIL') {
          return '(认证失败)';
        } else {
          return '(未认证)';
        }
      },
      //企业表单修改
      enterpriseReadOnly: function () {
        if (this.companyState == 'UNCERTIFIED') {
          return false;
        } else {
          if (this.companyType == 'ENTERPRISE') {
            return true;
          }
          return false;
        }
      },
      //个人表单修改
      personalReadOnly: function () {
        if (this.personalState == 'UNCERTIFIED') {
          return false
        } else {
          return true;
        }
      }
    },
    methods: {
      async getPersonalData() {
        const url = this.apis().getAuthenticationInfo();
        const result = await http.get(url);
        this.personalSlotData.username = result.data.name;
        this.personalSlotData.idCardNum = result.data.idCard;
      },
      async getEnterpriseData() {
        const url = this.apis().getAuthenticationEnterprise();
        const result = await http.get(url);
        if (this.companyType == 'ENTERPRISE') {
          this.enterpriseSlotData.companyName = result.data.name;
          this.enterpriseSlotData.organization = result.data.organization;
          if (result.data.agent != null) {
            this.enterpriseSlotData.role = 'AGENT';
            this.enterpriseSlotData.username = result.data.agent.name;
            this.enterpriseSlotData.idCardNum = result.data.agent.idCardNum;
          } else {
            this.enterpriseSlotData.role = 'LEGAL';
            this.enterpriseSlotData.username = result.data.legal.name;
            this.enterpriseSlotData.idCardNum = result.data.legal.idCardNum;
          }
        }
        if (this.companyType == 'INDIVIDUAL') {
          this.businessSlotData.companyName = result.data.name;
          this.businessSlotData.username = result.data.legal.name;
          this.businessSlotData.idCardNum = result.data.legal.idCardNum;
        }
      },
      async getAuthenticationState() {
        const url = this.apis().getAuthenticationState();
        const result = await http.get(url);
        this.personalState = result.data.personalState;
        this.companyState = result.data.companyState;
        if (result.data.companyState == 'UNCERTIFIED') {
          if (result.data.companyType == 'ENTERPRISE') {
            this.companyType = 'ENTERPRISE';
          } else if (result.data.companyType == 'INDIVIDUAL') {
            this.companyType = 'INDIVIDUAL';
          }
        } else {
          if (result.data.companyType == 'ENTERPRISE') {
            this.companyType = 'ENTERPRISE';
          } else {
            this.companyType = 'INDIVIDUAL';
          }
          this.getEnterpriseData();
        }
        if (result.data.personalState != 'UNCERTIFIED') {
          this.getPersonalData();
        }
      },
      onPersonal() {
        //主账号已企业认证不能个人认证
        if (this.currentUser.mainUser && this.companyType == 'ENTERPRISE') { //是否主账号
          this.$message.error('主账号已进行企业认证后不能个人认证');
        } else {
          this.activeName = 'third';
        }
      }
    },
    data() {
      return {
        activeName: 'first',
        hackSet: true,
        currentUser: this.$store.getters.currentUser,
        isCompany: false,
        isBusiness: false,
        isPersonal: false,
        companyType: '',
        companyState: '',
        personalState: '',
        enterpriseShow: '',
        enterpriseShowCheck: '',
        businessShow: false,
        businessShowCheck: false,
        businessShowSuccess: false,
        personalShow: false,
        personalShowCheck: false,
        personalShowSuccess: false,
        enterpriseSlotData: {
          companyName: '',
          organization: '',
          username: '',
          role: 'LEGAL',
          name: '',
          idCardNum: ''
        },
        businessSlotData: {
          role: "LEGAL",
          idCardNum: '',
          companyName: '',
          username: '',
          type: 'WAY1',
        },
        personalSlotData: {
          username: '',
          idCardNum: '',
        },
      }
    },
    created() {
      this.getAuthenticationState();

    },
    watch: {
      'enterpriseReadOnly': {
        handler(val, oldVal) {
          this.hackSet = false;
          this.$nextTick(() => {
            this.hackSet = true;
          });
        },
      }
    }


  }

</script>
<style scoped>
  .card-body {
    padding-left: 50px;
    padding-right: 50px;
  }

  .form-row {
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

  .auth-btn {
    width: 100%;
    height: 35px;
    line-height: 35px;
    text-align: center;
    background-color: rgb(242 242 242);
  }

  .auth-btn:hover {
    cursor: pointer;
  }

  .auth-btn_active {
    background-color: #fff59d;
  }

  .auth-btn h6 {
    line-height: 35px;
  }

  .auth-state {
    color: #aaa;
  }

  .auth-state_success {
    color: #e86263;
  }

  .state-tag {
    height: 200px;
    width: 300px;
  }

  .red-message {
    color: red;
    font-size: 10px;
    margin-top: 20px;
  }

</style>
