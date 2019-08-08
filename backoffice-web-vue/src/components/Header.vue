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
    <div>
      <span
        class="navbar-brand"
        to="#"
      ></span>
    </div>
    <div class="navbar-toggler aside-menu-toggler">
      <span>宁波衣加衣供应链有限公司</span>
    </div>
    <b-navbar-nav class="ml-auto">
      <div class="input">
        <el-input
          placeholder="搜索..."
          prefix-icon="el-icon-search"
          v-model="input2"
          size="small"
        >
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
  data() {
    return {
      input2: ""
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
}

.el-input__inner {
  border-radius: 50px;
  line-height: 30px;
}

.vertical-divider {
  height: 20px;
  width: 0.3px;
  border: solid #000 0.3px;
  margin-right: 20px;
}
</style>
