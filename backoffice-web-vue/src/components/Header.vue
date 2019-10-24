<template>
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
      <div class="input">
        <el-input placeholder="搜索..." prefix-icon="el-icon-search" v-model="input2" size="small"
          id="header-input__inner">
        </el-input>
      </div>
      <div class="icon-1">
        <i class="iconfont icon_font">&#xe63f;</i>
      </div>
      <div class="icon-2">
        <i class="iconfont icon_font_notification">&#xe605;</i>
      </div>
      <div class="vertical-divider" />
      <HeaderDropdownAccnt />
    </b-navbar-nav>
  </header>
</template>
<script>
  import HeaderDropdownAccnt from "./Header/HeaderDropdownAccnt";

  export default {
    name: "AppHeader",
    components: {
      HeaderDropdownAccnt
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
        if(this.currentUser.type!=null&&this.currentUser.type=='BRAND'){
          return '品牌';
        }else if(this.currentUser.type!=null&&this.currentUser.type=='FACTORY'){
          return '工厂';
        }else{
          return '平台';
        }
      }
    },
    data() {
      return {
        input2: "",
        authenticationInfo: this.$store.getters.authenticationInfo,
        currentUser: this.$store.getters.currentUser,
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

  .navbar-logo-title{
    font-size: 8px;
  }

</style>
