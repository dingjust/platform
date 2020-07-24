<template>
  <div class="permission-form-container">
    <el-container>
      <el-aside style="border-right: 2px solid #E6E6E6;">
        <h6 class="permission-form-hear" style="min-width: 298px">权限菜单</h6>
        <el-menu @select="selectAuth" @open="menuOpen" 
          :unique-opened="true" style="border-right: 0px">
          <template v-for="item in authData">
            <!-- 一级 -->
            <el-submenu :index="item.id + ''" :key="item.id"> 
              <template slot="title">
                <span>{{item.name}}</span>
              </template>
              <template v-for="val in item.children">
                <!-- 二级 -->
                <el-menu-item :index="val.id + ''" :key="val.id">
                  <el-checkbox v-model="checkState[val.id].checked" :indeterminate="checkState[val.id].indeterminate" 
                               @change="handleAll($event, val)" class="second-enum"></el-checkbox>
                  {{val.name}}
                </el-menu-item>
              </template>
            </el-submenu>
          </template>
        </el-menu>
      </el-aside>
      <el-main style="padding: 0px">
        <h6 class="permission-form-hear">权限设置</h6>
        <div class="checkbox-container">
          <template v-for="item in secondList">
            <el-checkbox-group v-model="checkData[item.id]" :key="item.id" 
              v-show="item.id == authList.id" @change="checkboxChange($event, item)">
              <template v-for="val in authList.children">
                <el-checkbox :label="val.id" :key="val.id" class="permission-checkbox">{{val.name}}</el-checkbox>
              </template>
            </el-checkbox-group>
          </template>
        </div>
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
      async getList () {
        const url = this.apis().getRoleList();
        const result = await this.$http.post(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.authData = result.data;
        result.data.forEach(item => {
          if (item.children && item.children.length > 0) {
            this.secondList.push.apply(this.secondList, item.children);
          }
          item.children.forEach(val => {
            this.$set(this.checkData, val.id, []);
            this.$set(this.checkState, val.id, {
              checked: false,
              indeterminate: false
            })
          })
        })
      },
      menuOpen (index) {
        let id = Number(index);
        let i = this.authData.findIndex(item => item.id == id);
        if (i >= 0) {
          this.selectAuth(this.authData[i].children[0].id);
        }
      },
      selectAuth (index, indexPath) {
        let i = this.secondList.findIndex(item => item.id == index);
        if (i >= 0) {
          this.authList = this.secondList[i];
        }
      },
      checkboxChange (list, item) {
        this.checkState[item.id].checked = list.length == item.children.length;
        this.checkState[item.id].indeterminate = list.length > 0 && list.length < item.children.length;
      },
      handleAll (flag, item) {
        if (flag) {
          this.checkData[item.id] = item.children.map(item => item.id);
        } else {
          this.checkData[item.id] = [];
        }
      }
    },
    data () {
      return {
        defaultActive: '',
        authData: [],
        secondList: [],
        authList: [],
        checkData: {},
        checkState: {}
      }
    },
    created () {
      this.getList();
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

  .permission-checkbox {
    width: 130px;
  }

  .second-enum {
    margin: 0px 10px 6px 0px;
  }

  .checkbox-container {
    padding: 10px 20px;
  }
</style>