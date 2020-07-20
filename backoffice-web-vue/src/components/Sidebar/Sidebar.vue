<template>
  <div class="sidebar">
    <el-menu default-active="0" class="el-menu-vertical-demo" active-text-color="#FEB026" @open="handleOpen" @close="handleClose" :collapse="false" :unique-opened="true">
      <template v-for="(item,index) in navItems">
        <template v-if="item.children!=null">
          <el-submenu :key="index" :index="''+index">
            <template slot="title">
              <i :class="item.icon">
                <!-- <i >{{item.name}}</i> -->
              </i>
              <span slot="title">{{item.name}}</span>
            </template>
            <template v-for="(subItem,subIndex) in item.children">
              <router-link :key="subIndex" :to="subItem.url" v-if="routeCheck(subItem)">
                <el-menu-item :key="index+'-'+subIndex" :index="index+'-'+subIndex" :route="item.url" class="child-el-menu">
                  {{subItem.name}}
                </el-menu-item>
              </router-link>
            </template>
          </el-submenu>
        </template>
        <template v-else>
          <router-link :key="index" :to="item.url">
            <el-menu-item :index="''+index">
              <i v-if="item.icon!=null" :class="item.icon"></i>
              <span slot="title">{{item.name}}</span>
            </el-menu-item>
          </router-link>
        </template>
      </template>
    </el-menu>
  </div>
</template>
<script>
  import SidebarFooter from './SidebarFooter';
  import SidebarForm from './SidebarForm';
  import SidebarHeader from './SidebarHeader';
  import SidebarMinimizer from './SidebarMinimizer';
  import SidebarNavDivider from './SidebarNavDivider';
  import SidebarNavDropdown from './SidebarNavDropdown';
  import SidebarNavLink from './SidebarNavLink';
  import SidebarNavTitle from './SidebarNavTitle';
  import SidebarNavItem from './SidebarNavItem';
  import SidebarNavLabel from './SidebarNavLabel';

  import {hasPermission} from '@/auth/auth';

  export default {
    name: 'sidebar',
    props: {
      navItems: {
        type: Array,
        required: true,
        default: () => []
      }
    },
    components: {
      SidebarFooter,
      SidebarForm,
      SidebarHeader,
      SidebarMinimizer,
      SidebarNavDivider,
      SidebarNavDropdown,
      SidebarNavLink,
      SidebarNavTitle,
      SidebarNavItem,
      SidebarNavLabel
    },
    methods: {
      handleClick (e) {
        e.preventDefault();
        e.target.parentElement.classList.toggle('open')
      },
      handleOpen (key, keyPath) {
        console.log(key, keyPath);
      },
      handleClose (key, keyPath) {
        console.log(key, keyPath);
      },
      // 路由权限检测
      routeCheck (nav) {
        if (nav.meta != null && nav.meta.requiresAuth != null && nav.meta.requiresAuth) {
          if (hasPermission(nav.meta.permissions)) {
            return true;
          } else {
            return false;
          }
        } else {
          return true;
        }
      }
    }
  }
</script>

<style scoped lang="css">
  .nav-link {
    cursor: pointer;
  }

  .sidebar .el-submenu .el-menu-item {
    height: 50px;
    line-height: 50px;
    padding: 0 45px;
    min-width: 0px;
  }

  .sidebar .el-submenu .child-el-menu {
    font-size: 12px;
    height: 40px;
    line-height: 40px;
    padding: 0 45px;
    min-width: 0px;
  }

  .sidebar .el-menu-item:focus, .el-menu-item:hover {
    outline: 0;
    background-color: rgba(254,176,38,0.15);
  }

.sidebar{
  overflow: auto;
  /* height: 100%; */
  
}

.sidebar .el-menu{
  border:none
}

</style>
