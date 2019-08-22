<style lang="scss">
  .app {
    overflow: hidden;
    line-height: 0;
  }
</style>
<template>
  <div class="app">
    <AppHeader/>
    <div class="app-body">
      <Sidebar :navItems="nav"/>
      <SideSlider/>
      <main class="main">
        <breadcrumb :list="list" v-if="name!='仪表盘'"/>
        <div class="container-fluid">
          <router-view></router-view>
        </div>
      </main>
      <!--<AppAside/>-->
    </div>
    <!-- <AppFooter/> -->
  </div>
</template>

<script>
  // import nav from '../_nav';
  import {
    AppHeader,
    // AppFooter,
    Sidebar,
    // Aside as AppAside,
    Breadcrumb,
    SideSlider
  } from '../components/';

  export default {
    name: 'full',
    components: {
      AppHeader,
      Sidebar,
      // AppAside,
      // AppFooter,
      Breadcrumb,
      SideSlider
    },
    data () {
      return {
        nav: this.CONFIG.nav(this.$store.getters.currentUser.type).items,
      }
    },
    computed: {
      name () {
        return this.$route.name
      },
      list () {
        return this.$route.matched
      }
    }
  }
</script>
