<template>
  <div class="permission-form-container">
    <el-container>
      <el-aside style="border-right: 2px solid #E6E6E6;">
        <h6 class="permission-form-hear">权限菜单</h6>
        <el-menu default-active="2"  @open="handleOpen" @close="handleClose" style="border-right: 0px">
          <el-submenu index="1">
            <template slot="title">
              <span>导航一</span>
            </template>
            <el-menu-item index="1-1">选项1</el-menu-item>
            <el-menu-item index="1-2">选项2</el-menu-item>
            <el-menu-item index="1-3">选项3</el-menu-item>
            <el-menu-item index="1-4-1">选项1</el-menu-item>
          </el-submenu>
        </el-menu>
      </el-aside>
      <el-main style="padding: 0px">
        <h6 class="form-hear">权限设置</h6>
      </el-main>
    </el-container>
  </div>
</template>

<script>
  export default {
    name: 'PermissionForm',
    props: [],
    components: {

    },
    computed: {

    },
    methods: {

    },
    data () {
      return {

      }
    },
    created () {

    }  
  }
</script>

<style scoped>
  .permission-form-container {
    border: 2px solid #E6E6E6;
  }

  .permission-form-hear {
    padding: 15px 0px 15px 20px;
    margin: 0px;
    border-bottom: 2px solid #E6E6E6;
  }

  .permission-form-container >>> .el-submenu__title {
    height: 40px;
    line-height: 40px;
  }

  .permission-form-container >>> .el-menu-item {
    height: 40px;
    line-height: 40px;
  }

</style>