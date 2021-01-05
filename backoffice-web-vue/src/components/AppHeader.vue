<template>
  <div>
    <header class="app-header navbar">
      <el-row type="flex" style="width:100%" align="middle">
        <el-col :xs="8" :sm="8" :md="10" :lg="12" :xl="12">
          <el-row type="flex" align="middle">
            <div class="navbar-logo">
              <img class="navbar-logo-img" src="static/img/logo.51f4203.png" />
              <span class="navbar-logo-title">钉单{{clientName}}端</span>
            </div>
            <div class="navbar-toggler aside-menu-toggler hidden-xs-only">
              <el-row type="flex" align="middle" style="white-space: nowrap;">
                <span style="color:#383e4b">{{currentUser.companyName}}</span>
                <el-tag :type="authenticated?'success':'info'" effect="dark" style="margin-left:10px" size="mini">
                  {{ authenticated?'已认证':'未认证'}}
                </el-tag>
              </el-row>
            </div>
          </el-row>
        </el-col>
        <el-col :xs="16" :sm="16" :md="14" :lg="12" :xl="12">
          <el-row type="flex" justify="space-between" align="middle">
            <el-col :xs="1" :sm="5" :md="6" :lg="7" :xl="8">
              <!-- <div class="input">
                <el-input placeholder="搜索..." prefix-icon="el-icon-search" v-model="input2" size="small"
                  id="header-input__inner"></el-input>
              </div> -->
            </el-col>
            <el-col :xs="23" :sm="19" :md="18" :lg="17" :xl="16">
              <el-row type="flex" justify="end">
                <i class="iconfont icon_font_notification" @click="jumpToMessagePage">&#xe605;</i>
                <h6 class="qr_code-title">APP下载</h6>
                <el-popover placement="bottom" width="280" v-model="qrVisible" trigger="hover">
                  <el-image style="width: 250px; height: 250px"
                    :src="CONFIG.CDN_OSS_DOMAIN+'/app_qr.png'" fit="fill"></el-image>
                  <el-row type="flex" justify="center">钉单APP下载</el-row>
                  <i class="iconfont2_2 icon-qr_code" slot="reference" @click="jumpToMessagePage">&#xe642;</i>
                </el-popover>
                <div class="vertical-divider" />
                <HeaderDropdownAccnt />
              </el-row>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
    </header>
  </div>
</template>
<script>
  import HeaderDropdownAccnt from "./Header/HeaderDropdownAccnt";
  import UniquecodeImportForm from "@/components/custom/UniquecodeImportForm";

  export default {
    name: "AppHeader",
    components: {
      HeaderDropdownAccnt,
      UniquecodeImportForm,
    },
    computed: {
      authenticated: function () {
        if (this.authenticationInfo == null) {
          return false;
        } else {
          if (
            this.authenticationInfo.companyState != null &&
            this.authenticationInfo.companyState == "SUCCESS"
          ) {
            return true;
          } else if (
            this.authenticationInfo.personalState != null &&
            this.authenticationInfo.personalState == "SUCCESS"
          ) {
            return true;
          } else {
            return false;
          }
        }
      },
      clientName: function () {
        if (this.currentUser.type != null && this.currentUser.type == "BRAND") {
          return "品牌";
        } else if (
          this.currentUser.type != null &&
          this.currentUser.type == "FACTORY"
        ) {
          return "工厂";
        } else {
          return "平台";
        }
      },
    },
    data() {
      return {
        input2: "",
        uniquecodeFormVisible: false,
        authenticationInfo: this.$store.getters.authenticationInfo,
        currentUser: this.$store.getters.currentUser,
        messageDialogVisible: false,
        qrVisible: false,
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
          case "1":
            this.$router.push("/orderPurchase");
            break;
          case "2":
            this.uniquecodeFormVisible = !this.uniquecodeFormVisible;
            break;
          case "3":
            this.$router.push("/account/Authentication");
            break;
          default:
            break;
        }
      },
      jumpToMessagePage() {
        this.$router.push("/message");
      },
    },
  };

</script>

<style>
  .icon-1 {
    margin-left: 40px;
    margin-right: 20px;
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
    margin-right: 20px;
    line-height: 20px;
    padding-top: 5px;
  }

  .icon-qr_code {
    margin-right: 20px;
    line-height: 28px;
    padding-top: 5px;
    font-size: 28px;
  }

  .icon-qr_code:hover {
    cursor: pointer;
  }

  #header-input__inner {
    border-radius: 50px !important;
    line-height: 30px;
  }

  .vertical-divider {
    height: 30px;
    width: 0.3px;
    border: solid #000 0.3px;
    margin-right: 20px;
  }

  .navbar-logo {
    margin-left: 20px;
    margin-right: 30px;
    /* margin-bottom: 5px; */
    width: 120px;
    white-space: nowrap;
    display: flex;
    align-items: center;
  }

  .navbar-authentication-img {
    width: 50px;
    height: 15px;
    margin-left: 15px;
  }

  .navbar-logo-img {
    width: 30px;
    height: 30px;
    /* margin-bottom: 5px; */
  }

  .navbar-logo-title {
    font-size: 8px;
  }

  .navbar-dropdown {
    cursor: pointer;
    font-weight: 600;
  }

  .qr_code-title {
    padding-top: 5px;
    line-height: 20px;
    margin-right: 5px;
    white-space: nowrap;
  }

</style>
