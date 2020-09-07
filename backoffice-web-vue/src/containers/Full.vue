<style lang="scss">
  .app {
    overflow: hidden;
    line-height: 0;
  }
</style>
<template>
  <div class="app">
    <AppHeader />
    <div class="app-body">
      <Sidebar :navItems="nav" />
      <SideSlider />
      <main class="main">
        <!-- <breadcrumb :list="list" v-if="name!='仪表盘'" /> -->
        <tags-view />
        <div class="container-fluid">
          <transition name="fade-transform" mode="out-in">
            <!-- <keep-alive> -->
            <router-view></router-view>
            <!-- </keep-alive> -->
          </transition>
        </div>
      </main>
      <!--<AppAside/>-->
    </div>
  </div>
</template>

<script>
  // import nav from '../_nav';
  import {
    AppHeader,
    Sidebar,
    // Aside as AppAside,
    Breadcrumb,
    SideSlider,
    TagsView
  } from '../components/';

  export default {
    name: 'full',
    components: {
      AppHeader,
      Sidebar,
      // AppAside,
      Breadcrumb,
      SideSlider,
      TagsView
    },
    data() {
      return {
        nav: this.CONFIG.nav(this.$store.getters.currentUser.type).items,
      }
    },
    computed: {
      name() {
        return this.$route.name
      },
      list() {
        return this.$route.matched
      }
    }
  }
</script>
