<template>
  <div class="permission-form">
    <div class="aside">
      <div>
        <h6 class="form-container">权限菜单</h6>
      </div>
      <el-scrollbar class="scrollbar-container">
        <el-menu @select="selectMenu" @open="openMenu" :unique-opened="true" style="border-right: 0px">
          <el-submenu v-for="item in authData" :index="item.id + ''" :key="item.id">
            <template slot="title">
              <div>
                <el-checkbox v-model="item.checked" :indeterminate="item.indeterminate" 
                             @change="handleCheckAllChange($event, item)" />
                <span style="padding-left: 10px; font-size: 14px; color: #606266;">{{item.name}}</span>
              </div>
            </template>
            <el-menu-item v-for="val in item.children" :index="val.id + ''" :key="val.id">
              <el-checkbox v-model="val.checked" :indeterminate="val.indeterminate" 
                           @change="handleCheckSecondChange($event, item, val)" />
              <span style="padding-left: 10px; font-size: 14px; color: #606266;">{{val.name}}</span>
            </el-menu-item>
          </el-submenu>
        </el-menu>
      </el-scrollbar>
    </div>
    <div class="main">
      <div class="main-container">
        <div style="width: 50%">
          <h6 class="form-container" style="color: #909399">操作权限 
            <span v-if="checkSecondData.id" style="color: #F56C6C"> ({{checkSecondData.name}})</span>
          </h6>
        </div>
        <div style="width: 50%">
          <h6 class="form-container" style="color: #909399">数据权限</h6>
        </div>
      </div>
      <div class="main-container">
        <el-scrollbar class="scrollbar-container">
          <div class="main-container">
            <div style="width: 50%; padding: 10px 0px 15px 20px;">
              <el-checkbox-group v-model="checkedThire[checkSecondData.id]" v-if="checkSecondData.id" @change="handleChangeThireGroup">
                <el-checkbox v-for="val in checkSecondData.children" :label="val.id" :key="val.id" >{{val.name}}</el-checkbox>
              </el-checkbox-group>
            </div>
            <div style="width: 50%; padding: 10px 0px 15px 20px;">
              <el-checkbox-group v-model="checkedPer[checkSecondData.id]" v-if="checkSecondData.id" @change="handleChangePer">
                <el-checkbox v-for="val in dataPermission" :label="val.code" :key="val.code">{{val.name}}</el-checkbox>                                          
              </el-checkbox-group>
            </div>
          </div>
        </el-scrollbar>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PermissionFormV2',
  props: ['authData', 'checkedThire', 'checkedPer', 'roleIds'],
  data () {
    return {
      checkSecondData: {},
      dataPermission: [
        {
          code: 'ALL_DATA',
          name: '全部数据'
        }, {
          code: 'BELONG_DEPT_DATA',
          name: '部门数据'
        }, {
          code: 'SELF_DATA',
          name: '个人数据'
        }
      ]
    }
  },
  methods: {
    handleCheckAllChange (event, first) {
      if (event) {
        first.children.forEach(item => {
          this.$set(item, 'checked', true);
          this.$set(item, 'indeterminate', false);

          if (item.children && item.children.length > 0) {
            this.$set(this.checkedThire, item.id, item.children.map(val => val.id));
          }
        })
      } else {
        first.children.forEach(item => {
          this.$set(item, 'checked', false);
          this.$set(item, 'indeterminate', false);

          this.$set(this.checkedThire, item.id, []);
        })
      }

      this.$set(first, 'indeterminate', false);
    },
    handleCheckSecondChange (event, first, second) {
      if (event) {
        if (second.children && second.children.length > 0) {
          this.$set(this.checkedThire, second.id, second.children.map(val => val.id));
        }
      } else {
        this.$set(this.checkedThire, second.id, []);
      }

      this.changeFirst(first);

      this.$set(second, 'indeterminate', false);
    },
    handleChangeThireGroup (event, second) {
      let checkSecondData = this.checkSecondData;
      if (second) {
        checkSecondData = second;
      }
      if (event.length === checkSecondData.children.length) {
        this.$set(checkSecondData, 'checked', true);  
        this.$set(checkSecondData, 'indeterminate', false);  
      } else if (event.length < checkSecondData.children.length && event.length > 0) {
        this.$set(checkSecondData, 'checked', false);  
        this.$set(checkSecondData, 'indeterminate', true);  
      } else {
        this.$set(checkSecondData, 'checked', false);  
        this.$set(checkSecondData, 'indeterminate', false);  
      }

      let parentId = this.checkSecondData.parentId;
      let index = this.authData.findIndex(item => item.id === parentId);
      this.changeFirst(this.authData[index]);
    },
    changeFirst (first) {
      // 处理一级选择显示
      let everyChecked = first.children.every(item => item.checked);
      let someChecked = first.children.some(item => item.checked);
      
      let someIndeterminate = first.children.some(item => item.indeterminate);
      
      if (everyChecked) {
        this.$set(first, 'checked', true);
        this.$set(first, 'indeterminate', false);
      } else if (someChecked || someIndeterminate) {
        this.$set(first, 'checked', false);
        this.$set(first, 'indeterminate', true);
      } else {
        this.$set(first, 'checked', false);
        this.$set(first, 'indeterminate', false);
      }
    },
    handleChangePer (list) {
      if (list.length > 1) {
        this.checkedPer[this.checkSecondData.id] = [list.pop()];
      }
    },
    selectMenu (index, indexPath) {
      let checkSecondData = this.authData.filter(
        item => (item.id + '') === indexPath[0])[0].children.filter(
        item => (item.id + '') === indexPath[1])[0];

      if (!this.checkedThire.hasOwnProperty(checkSecondData.id)) {
        this.$set(this.checkedThire, checkSecondData.id, []);
      }
      this.$set(this, 'checkSecondData', checkSecondData);
      
      if (!this.checkedPer.hasOwnProperty(checkSecondData.id)) {
        this.$set(this.checkedPer, checkSecondData.id, ['SELF_DATA']);
      }
    },
    openMenu (index, indexPath) {
      let checkSecondData = this.authData.filter(
          item => (item.id + '') === index)[0].children[0];

      if (!this.checkedThire.hasOwnProperty(checkSecondData.id)) {
        this.$set(this.checkedThire, checkSecondData.id, []);
      }
      this.$set(this, 'checkSecondData', checkSecondData);

      if (!this.checkedPer.hasOwnProperty(checkSecondData.id)) {
        this.$set(this.checkedPer, checkSecondData.id, ['SELF_DATA']);
      }
    }
  },
  created () {
  }
}
</script>

<style scoped>
  .permission-form {
    display: flex;
    border: 2px solid #E6E6E6;
    min-height: 550px;
    height: 550px;
  }

  .aside {
    border-right: 2px solid #E6E6E6;
    min-width: 220px;
    width: 220px;
  }

  .main {
    margin: 0px;
  }

  .main-container {
    width: 100%;
    display: flex;
  }

  .scrollbar-container {
    height: 495px;
    width: 100%;
  }

  .form-container {
    padding: 15px 0px 15px 20px;
    margin: 0px;
    border-bottom: 2px solid #E6E6E6;
  }

  .permission-form >>> .el-scrollbar__wrap{
    overflow-x: hidden;
  }

  .permission-form >>> .el-submenu__title {
    height: 40px;
    line-height: 40px;
  }

  .permission-form >>> .el-menu-item {
    height: 40px;
    line-height: 40px;
  }
</style>