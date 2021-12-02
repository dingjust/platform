<template>
  <div class="animated fadeIn">
    <el-dialog title="温馨提示" :visible.sync="profileDialogVisible" width="400px" :close-on-click-modal="false">
      <profile-complete-dialog @onCancel="onCancel" />
    </el-dialog>
    <el-dialog title="温馨提示" :visible.sync="authenticationDialogVisible" width="400px" :close-on-click-modal="false">
      <authentication-dialog @onCancel="onCancel" />
    </el-dialog>
    <el-row :gutter="20">
      <el-col :xs="24" :sm="24" :lg="14">
        <el-row>
          <business-card />
        </el-row>
        <el-row class="hidden-lg-and-up">
          <account-entry-card />
        </el-row>
        <el-row class="hidden-lg-and-up">
          <progress-card :reportsProgress="reportsProgress" />
        </el-row>
        <el-row>
          <chart-card />
        </el-row>
        <el-row :gutter="10">
          <el-col :xs="24" :sm="12">
            <month-income-card :slot-data="lastMonthIncome" />
          </el-col>
          <el-col :xs="24" :sm="12">
            <month-income-card :slot-data="thisMonthIncome" />
          </el-col>
        </el-row>
        <el-row class="hidden-lg-and-up">
          <img class="dashboard-img" :src="CONFIG.CDN_OSS_DOMAIN+'/%E5%9B%BE%E7%89%87.png'" />
        </el-row>
      </el-col>
      <el-col class="hidden-md-and-down" :lg="10">
        <el-row>
          <account-entry-card />
        </el-row>
        <el-row>
          <progress-card :reportsProgress="reportsProgress" />
        </el-row>
        <el-row>
          <img class="dashboard-img" :src="CONFIG.CDN_OSS_DOMAIN+'/%E5%9B%BE%E7%89%87.png'" />
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
      onCancel() {
        this.profileDialogVisible = false;
        this.authenticationDialogVisible = false;
      },
      async getProfile() {
        var uid = this.$store.getters.currentUser.companyCode;
        var url;
        if (this.isBrand()) {
          url = this.apis().getBrand(uid);
        } else if (this.isFactory()) {
          url = this.apis().getFactory(uid);
        } else {
          return;
        }
        const result = await this.$http.get(url, null, true);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        return result;
      },
      async getAuthenticationState() {
        const url = this.apis().getAuthenticationState();
        const result = await this.$http.get(url,null,true);
        return result;
      },
      async initData() {
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

        if (!this.isTenant()) {
          const date = new Date();

          const fullYear = date.getFullYear();
          const month = date.getMonth();
          const lastMonth = month - 1 < 0 ? ((fullYear - 1) + '-12-01') : (fullYear + '-' + month + '-01');
          const thisMonth = fullYear + '-' + (month + 1) + '-01';
          const nextMonth = month + 1 > 11 ? ((fullYear + 1) + '-01-01') : (fullYear + '-' + (month + 2) + '-01');

          // 获取外发外接数量，金额统计
          this.lastMonthIncome = await this.getDashboardOrderStatistics({
            createdDateFrom: lastMonth,
            createdDateTo: thisMonth
          }, '上月统计');
          this.thisMonthIncome = await this.getDashboardOrderStatistics({
            createdDateFrom: thisMonth,
            createdDateTo: nextMonth
          }, '本月统计');

          await this.getReportsProgress();
        }
      },
      async getDashboardOrderStatistics(form, title) {
        const url = this.apis().getDashboardOrderStatistics();
        const result = await this.$http.post(url, form, null, true);

        let data = {
          title: title,
          outTotalAmount: 0,
          outTotalQuantity: 0,
          totalAmount: 0,
          totalQuantity: 0
        }
        if (result.code === 1) {
          data = Object.assign(data, result.data);
        }
        return data;
      },
      async getReportsProgress() {
        const url = this.apis().reportsProgress();
        const result = await this.$http.get(url, null, true);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.reportsProgress = result;
      }
    },
    data() {
      return {
        profileDialogVisible: false,
        authenticationDialogVisible: false,
        thisMonthIncome: {},
        lastMonthIncome: {},
        reportsProgress: {
          progress: {
            content: [],
            last: false,
            totalElements: 0,
            totalPages: 0,
            size: 5,
            number: 1,
            sort: null,
            first: false,
            numberOfElements: 5
          },
          order: {
            content: [],
            last: false,
            totalElements: 0,
            totalPages: 0,
            size: 5,
            number: 1,
            sort: null,
            first: false,
            numberOfElements: 5
          }
        },
      };
    },
    created() {
      this.initData();
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
