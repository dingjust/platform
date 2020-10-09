<template>
  <div class="animated fadeIn">
    <el-dialog title="温馨提示" :visible.sync="profileDialogVisible" width="30%" :close-on-click-modal="false">
      <profile-complete-dialog @onCancel="onCancel"/>
    </el-dialog>
    <el-dialog title="温馨提示" :visible.sync="authenticationDialogVisible" width="30%" :close-on-click-modal="false">
      <authentication-dialog @onCancel="onCancel"/>
    </el-dialog>
    <el-row :gutter="20">
      <el-col :xs="24" :sm="24" :md="24" :lg="14" :xl="14">
        <el-row>
          <business-card/>
        </el-row>
        <el-row class="hidden-lg-and-up">
          <account-entry-card/>
        </el-row>
        <el-row class="hidden-lg-and-up">
          <progress-card/>
        </el-row>
        <el-row>
          <chart-card/>
        </el-row>
        <el-row :gutter="10">
          <el-col :xs="24" :sm="12">
            <month-income-card :slot-data="lastMonthIncome"/>
          </el-col>
          <el-col :xs="24" :sm="12">
            <month-income-card :slot-data="thisMonthIncome"/>
          </el-col>
        </el-row>
        <el-row class="hidden-lg-and-up">
          <img class="dashboard-img" src="https://yijiayi.oss-cn-shenzhen.aliyuncs.com/%E5%9B%BE%E7%89%87.png"/>
        </el-row>
      </el-col>
      <el-col class="hidden-md-and-down" :lg="10" :xl="10">
        <el-row>
          <account-entry-card/>
        </el-row>
        <el-row>
          <progress-card/>
        </el-row>
        <el-row>
          <img class="dashboard-img" src="https://yijiayi.oss-cn-shenzhen.aliyuncs.com/%E5%9B%BE%E7%89%87.png"/>
        </el-row>
      </el-col>
    </el-row>
    <!-- 旧页面布局 -->
    <!-- <el-row :gutter="20">
      <el-col :span="14">
        <el-row>
          <business-card/>
        </el-row>
        <el-row>
          <toolbar-card/>
        </el-row>
        <el-row>
          <chart-card/>
        </el-row>
        <el-row :gutter="10">
          <el-col :span="12">
            <month-income-card :slot-data="lastMonthIncome"/>
          </el-col>
          <el-col :span="12">
            <month-income-card :slot-data="thisMonthIncome"/>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="10">
        <el-row>
          <account-entry-card/>
        </el-row>
        <el-row>
          <progress-card/>
        </el-row>
        <el-row>
          <img class="dashboard-img" src="https://yijiayi.oss-cn-shenzhen.aliyuncs.com/%E5%9B%BE%E7%89%87.png"/>
        </el-row>
      </el-col>
    </el-row> -->
  </div>
</template>

<script>
    import BusinessCard from '../shared/BusinessCard';
    import ToolbarCard from '../shared/ToolbarCard';
    import ChartCard from '../shared/ChartCard';
    import MonthIncomeCard from '../shared/MonthIncomeCard';
    import AccountEntryCard from '../shared/AccountEntryCard';
    import ProgressCard from '../shared/ProgressCard';
    import ProfileCompleteDialog from '@/views/shared/dialog/ProfileCompleteDialog';
    import AuthenticationDialog from '@/views/shared/dialog/AuthenticationDialog';

    export default {
      name: 'FactoryDashboardPage',
      components: {
        BusinessCard,
        ToolbarCard,
        ChartCard,
        MonthIncomeCard,
        AccountEntryCard,
        ProgressCard,
        ProfileCompleteDialog,
        AuthenticationDialog
      },
      computed: {},
      methods: {
        onCancel () {
          this.profileDialogVisible = false;
          this.authenticationDialogVisible = false;
        },
        async getProfile () {
          var uid = this.$store.getters.currentUser.companyCode;
          var url;
          if (this.isBrand()) {
            url = this.apis().getBrand(uid);
          } else if (this.isFactory()) {
            url = this.apis().getFactory(uid);
          } else {
            return;
          }
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          return result;
        },
        async getAuthenticationState () {
          const url = this.apis().getAuthenticationState();
          const result = await this.$http.get(url);
          return result;
        }

      },
      data () {
        return {
          profileDialogVisible: false,
          authenticationDialogVisible: false,
          thisMonthIncome: {
            title: '本月营收',
            income: 1231.12,
            proofingOrders: 8,
            purchaseOrders: 10,
            incomed: 123,
            comparison: 0.264
          },
          lastMonthIncome: {
            title: '上月营收',
            income: 3134.12,
            proofingOrders: 23,
            purchaseOrders: 13,
            incomed: 1232,
            comparison: 0.3114
          }
        };
      },
      async created () {
        if (this.isBrand() || this.isFactory()) {
          var profile = await this.getProfile();
          var authenticationState = await this.getAuthenticationState();
          if (!profile.profileCompleted) {
            this.profileDialogVisible = true;
          } else if (!(authenticationState.data.personalState == 'SUCCESS' || authenticationState.data.companyState ==
                    'SUCCESS')) {
            this.authenticationDialogVisible = true;
          }
        }
      }
    };
</script>
<style>
  .dashboard-card {
    background-color: #ffffff;
    border-radius: 5px;
    width: 100%;
    padding-top: 10px;
    padding-left: 20px;
    padding-right: 20px;
    padding-bottom: 10px;
    margin-bottom: 10px;
  }

  .dashboard-img {
    width: 100%;
    border-radius: 5px;
  }

</style>
