<template>
  <div>
    <el-container class="permission-form-container">
      <el-aside style="border-right: 2px solid #E6E6E6;">
        <h6 class="permission-form-hear" style="min-width: 298px">权限菜单</h6>
        <el-menu @select="selectAuth" @open="menuOpen" 
          :unique-opened="true" style="border-right: 0px">
          <template v-for="(item, parentIndex) in authData">
            <!-- 一级 -->
            <el-submenu :index="item.id + ''" :key="item.id"> 
              <template slot="title">
                <el-checkbox v-model="item.checked" :indeterminate="item.indeterminate"
                            @change="handleOneAll($event, item)" class="second-enum"></el-checkbox>
                <span>{{item.name}}</span>
              </template>
              <template v-for="val in item.children">
                <!-- 二级 -->
                <el-menu-item :index="val.id + ''" :key="val.id">
                  <el-checkbox v-model="val.checked" :indeterminate="val.indeterminate" 
                               @change="handleAll($event, val, parentIndex)" class="second-enum"></el-checkbox>
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
    props: ['roleIds'],
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
        this.authData = this.sortList(result.data);

        this.authData.forEach(item => {
          if (item.children && item.children.length > 0) {
            this.secondList.push.apply(this.secondList, item.children);
          }
          item.children.forEach(val => {
            this.$set(this.checkData, val.id, []);
          })
        })

        this.authData.forEach(item => {
          this.$set(item, 'checked', false);
          this.$set(item, 'indeterminate', false);
          item.children.forEach(val => {
            this.$set(val, 'checked', false);
            this.$set(val, 'indeterminate', false);
          })
        })

        this.$nextTick(() => {
          if (this.roleIds && this.roleIds.length > 0) {
            this.initData();
          }
        })
      },
      sortList (data) {
        let copyData = Object.assign([], data);
        let arr = [];
        let index;
        let copyIndex;
        this.sequence.forEach(item => {
          index = data.findIndex(val => val.name === item);
          if (index >= 0) {
            arr.push(data[index]);
          }
          copyIndex = copyData.findIndex(val => val.name === item);
          if (copyIndex >= 0) {
            copyData.splice(copyIndex, 1);
          }
        })
        if (copyData.length > 0) {
          arr.push.apply(arr, copyData);
        }
        return arr;
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
        let parentIndex = this.authData.findIndex(val => val.id === item.parentId);
        let index = this.authData[parentIndex].children.findIndex(val => val.id === item.id);
        // 处理二级
        this.authData[parentIndex].children[index].checked = list.length == item.children.length;
        this.authData[parentIndex].children[index].indeterminate = list.length > 0 && list.length < item.children.length;
        // 处理一级
        this.changeParentState(parentIndex);
      },
      changeParentState (parentIndex) {
        // 处理一级
        let count = 0;
        let indeterminateCount = 0;
        if (this.authData[parentIndex] && this.authData[parentIndex].children.length > 0) {
          this.authData[parentIndex].children.forEach(value => {
            if (value.checked) {
              count += 1;
            }
            if (value.indeterminate) {
              indeterminateCount += 1;
            } 
          })
          this.authData[parentIndex].checked = count == this.authData[parentIndex].children.length;
          this.authData[parentIndex].indeterminate = (count > 0 && count < this.authData[parentIndex].children.length) || 
                                                      (indeterminateCount > 0 && indeterminateCount <= this.authData[parentIndex].children.length);
        }
      },
      handleOneAll (flag, item) {
        item.indeterminate = false;
        if (item.children && item.children.length > 0) {
          item.children.forEach(val => {
            this.handleAll(flag, val, item.id);
            val.indeterminate = false;
            val.checked = flag;
          })
        }
      },
      handleAll (flag, val, parentIndex) {
        // 处理二级
        val.indeterminate = false;
        if (flag == true && val.children && val.children.length > 0) {
          this.checkData[val.id] = val.children.map(item => item.id);
        } else if (flag == false) {
          this.checkData[val.id] = [];
        }

        this.changeParentState(parentIndex);
      },
      // 数据回显
      initData () {
        let list;
        let parentIndex;
        let childIndex;
        this.roleIds.forEach(parent => {
          if (parent.children && parent.children.length > 0) {
            parentIndex = this.authData.findIndex(i => i.id == parent.id);
            parent.children.forEach(item => {
              childIndex = this.authData[parentIndex].children.findIndex(c => c.id == item.id);
              if (item.children && item.children.length > 0) {
                list = item.children.map(val => val.id);
                // 回显一二级
                this.checkboxChange(list, this.authData[parentIndex].children[childIndex]);
                
                // 回显三级
                this.checkData[item.id] = list;
              } else {
                // 回显二级无子权限
                this.authData[parentIndex].children[childIndex].checked = true;
                this.authData[parentIndex].children[childIndex].indeterminate = false;
              }
            })
          }
          // 回显一级
          if (this.authData[parentIndex].children.length === parent.children.length) {
            this.authData[parentIndex].checked = true;
            this.authData[parentIndex].indeterminate = false;
          } else {
            this.authData[parentIndex].checked = false;
            this.authData[parentIndex].indeterminate = true;
          }
        })
      }
    },
    data () {
      return {
        authData: [],
        secondList: [],
        authList: [],
        checkData: {},
        checkState: {},
        sequence: ['任务中心', '订单管理', '生产管理', '外发管理', '产品管理', '财务管理', '企业管理', '合同管理', '设置中心']
      }
    },
    created () {
      // this.getList();
    }  
  }
</script>

<style scoped>
  .permission-form-container {
    border: 2px solid #E6E6E6;
    height: 550px;
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
    width: 150px;
  }

  .second-enum {
    margin: 0px 10px 6px 0px;
  }

  .checkbox-container {
    padding: 10px 20px;
  }
</style>
