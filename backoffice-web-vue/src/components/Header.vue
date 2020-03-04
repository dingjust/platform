<template>
  <div >
    <!--<el-dialog title="" :modal="true" :visible.sync="messageDialogVisible"  width="80%" class="radius-dialog "-->
               <!--:close-on-click-modal="false" >-->
      <!--<message-page />-->
    <!--</el-dialog>-->
    <header class="app-header navbar">
      <!-- <button class="navbar-toggler mobile-sidebar-toggler d-lg-none" type="button" @click="mobileSidebarToggle">
        <span class="navbar-toggler-icon"></span>
      </button> -->
      <!-- <b-link class="navbar-brand" to="#"></b-link> -->
      <!-- <button class="navbar-toggler sidebar-toggler d-md-down-none mr-auto" type="button" @click="sidebarToggle">
        <span class="navbar-toggler-icon"></span>
      </button> -->
      <!-- <div>
        <span class="navbar-brand" to="#"></span>
      </div>
      <div class="navbar-toggler aside-menu-toggler">
        <span>宁波衣加衣供应链有限公司</span>
      </div>
      <b-navbar-nav class="ml-auto">
        <HeaderDropdownAccnt />
      </b-navbar-nav> -->
      <el-dialog :visible.sync="uniquecodeFormVisible" width="30%" class="uniquecode-dialog" append-to-body>
        <uniquecode-import-form />
      </el-dialog>
      <div class="navbar-logo">
        <!-- <span class="navbar-brand" to="#"></span> -->
        <el-row type="flex" justify="center">
          <img class="navbar-logo-img" src="static/img/logo.51f4203.png" />
        </el-row>
        <el-row type="flex" justify="center">
          <span class="navbar-logo-title">钉单{{clientName}}端</span>
        </el-row>
      </div>
      <div class="navbar-toggler aside-menu-toggler">
        <el-row type="flex" align="middle">
          <span>{{currentUser.companyName}}</span>
          <img class="navbar-authentication-img" :src="authenticated" />
        </el-row>
      </div>
      <b-navbar-nav class="ml-auto">
        <el-dropdown style="margin-right:50px;" @command="handleCommand">
        <span class="el-dropdown-link navbar-dropdown">
          快捷功能<i class="el-icon-arrow-down el-icon--right"></i>
        </span>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item command="1">创建线下订单</el-dropdown-item>
            <el-dropdown-item command="2">唯一码导入</el-dropdown-item>
            <el-dropdown-item command="3">认证中心</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
        <div class="input">
          <el-input placeholder="搜索..." prefix-icon="el-icon-search" v-model="input2" size="small"
                    id="header-input__inner">
          </el-input>
        </div>
        <div class="icon-1">
          <i class="iconfont icon_font">&#xe63f;</i>
        </div>
        <div class="icon-2">
          <i class="iconfont icon_font_notification" @click="jumpToMessagePage">&#xe605;</i>
        </div>
        <div class="vertical-divider" />
        <HeaderDropdownAccnt />
      </b-navbar-nav>
    </header>
  </div>

</template>
<script>
  import HeaderDropdownAccnt from "./Header/HeaderDropdownAccnt";
  import UniquecodeImportForm from '@/components/custom/UniquecodeImportForm';

  export default {
    name: "AppHeader",
    components: {
      HeaderDropdownAccnt,
      UniquecodeImportForm
    },
    computed: {
      authenticated: function () {
        if (this.authenticationInfo == null) {
          return 'static/img/uncertified.png';
        } else {
          if (this.authenticationInfo.companyState != null && this.authenticationInfo.companyState == 'SUCCESS') {
            return 'static/img/certified.png';
          } else if (this.authenticationInfo.personalState != null && this.authenticationInfo.personalState ==
            'SUCCESS') {
            return 'static/img/certified.png';
          } else {
            return 'static/img/uncertified.png';
          }
        }
      },
      clientName: function () {
        if (this.currentUser.type != null && this.currentUser.type == 'BRAND') {
          return '品牌';
        } else if (this.currentUser.type != null && this.currentUser.type == 'FACTORY') {
          return '工厂';
        } else {
          return '平台';
        }
      }
    },
    data() {
      return {
        input2: "",
        uniquecodeFormVisible: false,
        authenticationInfo: this.$store.getters.authenticationInfo,
        currentUser: this.$store.getters.currentUser,
        messageDialogVisible: false,
      };
    },
    methods: {
      sidebarToggle(e) {
        e.preventDefault();
        document.body.classList.toggle("sidebar-hidden");
      },
      sidebarMinimize(e) {
        e.preventDefault();
        document.body.classList.toggle("sidebar-minimized");
      },
      mobileSidebarToggle(e) {
        e.preventDefault();
        document.body.classList.toggle("sidebar-mobile-show");
      },
      asideToggle(e) {
        e.preventDefault();
        document.body.classList.toggle("aside-menu-hidden");
      },
      handleCommand(command) {
        switch (command) {
          case '1':
            this.$router.push("/orderPurchase");
            break;
          case '2':
            this.uniquecodeFormVisible = !this.uniquecodeFormVisible;
            break;
          case '3':
            this.$router.push("/account/Authentication");
            break;
          default:
            break;
        }
      },
      jumpToMessagePage(){
        this.$router.push('/message');
      }
    }
  };

</script>

<style>
  .icon-1 {
    margin-left: 40px;
    margin-right: 20px;
  }

  .icon-2 {
    margin-left: 20px;
    margin-right: 40px;
  }

  .icon_font {
    font-size: 24px;
  }

  .icon_font_notification {
    font-size: 20px;
    font-family: "iconfont" !important;
    /* font-weight: 400; */
    /*color: #FF7A7A;*/
    font-style: normal;
    -webkit-font-smoothing: antialiased;
    -webkit-text-stroke-width: 0.2px;
    -moz-osx-font-smoothing: grayscale;
    cursor: pointer;
  }

  #header-input__inner {
    border-radius: 50px !important;
    line-height: 30px;
  }

  .vertical-divider {
    height: 20px;
    width: 0.3px;
    border: solid #000 0.3px;
    margin-right: 20px;
  }

  .navbar-logo {
    margin-left: 20px;
    margin-right: 80px;
    margin-bottom: 5px;
    width: 80px;
  }

  .navbar-authentication-img {
    width: 50px;
    height: 15px;
    margin-left: 15px;
  }

  .navbar-logo-img {
    width: 30px;
    height: 30px;
    margin-bottom: 5px;
  }

  .navbar-logo-title {
    font-size: 8px;
  }

  .navbar-dropdown {
    cursor: pointer;
    font-weight: 600;
  }

</style>
<style scoped>
  /deep/ .el-dialog__body{
    padding-top: 0px !important;
  }
</style>
