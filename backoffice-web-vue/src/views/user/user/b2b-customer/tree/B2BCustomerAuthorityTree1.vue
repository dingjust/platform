<template>
  <div>
    <el-row type="flex" align="bottom">
      <el-checkbox :indeterminate="indeterminate" v-model="checkAll" @change="handleCheckAllChange" style="padding-bottom: 0px;margin-bottom: 0px">全选</el-checkbox>
    </el-row>
    <div>
      <div class="left_line1"></div>
      <el-row type="flex" align="top" v-for="(item, index) in roleListData" :key="index">
        <div class="bottom_line"></div>
        <el-col :span="4" style="margin-left: 5%">
          <el-checkbox ref="checkbox" :indeterminate="item.indeterminate" v-model="item.checked" :label="item.id"
                        @change="handleCheckNodeAllChange($event, item)">
            {{item.name}}
          </el-checkbox>
        </el-col>
        <el-col :span="20">
          <el-checkbox-group v-model="roleIdList" @change="handleCheckedNodeChange($event, item)">
            <el-checkbox v-for="role in item.children" :label="role.id" :key="role.id" style="width: 100px">
              {{role.name}}
            </el-checkbox>
          </el-checkbox-group>
        </el-col>
      </el-row>
    </div>
  </div>
</template>
<script>
  export default {
    name: 'B2BCustomerAuthorityTree1',
    props: {
      formData: Object,
      isRolePage: {
        type: Boolean,
        default: false
      }
    },
    computed: {

    },
    data () {
      return {
        watchFlag: [],
        allRoleList: [],
        checkAll: false,
        indeterminate: false,
        isIndeterminate: true,
        roleListData: [],
        roleIdList: [],
        defaultNode: []
      }
    },
    methods: {
      // // 具体权限 选/不选
      // handleCheckChange (flag, role) {
      //   let index;
      //   if (flag) {
      //     this.roleIdList.push(role.id);
      //   } else {
      //     index = this.roleIdList.indexOf(role.id);
      //     if (index > -1) {
      //       this.roleIdList.splice(index, 1);
      //     }
      //   }
      //   this.setRoleList();
      // },
      // 行（权限）选择图标显示判断
      handleCheckedNodeChange (checkList, item) {
        let belongToItemRoleList = [];
        let index;
        item.children.forEach(role => {
          index = checkList.indexOf(role.id);
          if (index > -1) {
            belongToItemRoleList.push(role.id);
          }
        })
        this.$refs.checkbox.forEach(checkbox => {
          if (checkbox.label == item.id) {
            item.indeterminate = belongToItemRoleList.length > 0 && belongToItemRoleList.length < item.children.length;
            if (belongToItemRoleList.length == item.children.length) {
              checkbox.model = true;
            } else {
              checkbox.model = false;
            }
          }
        })
        this.setRoleList();
        this._handleCheckAllChange();
      },
      // 行（权限）全选/全不选
      handleCheckNodeAllChange (flag, item) {
        if (flag) {
          this.pushRoleId(item);
        } else {
          this.popRoleId(item);
        }
        this.setRoleList();
        this._handleCheckAllChange();
      },
      _handleCheckAllChange () {
        this.indeterminate = this.roleIdList.length > 0 && this.roleIdList.length < this.allRoleList.length;
        this.checkAll = this.roleIdList.length === this.allRoleList.length;
      },
      handleCheckAllChange (flag) {
        console.log(this.$refs.checkbox);
        this.$refs.checkbox.forEach(val => {
          val.model = flag;
        })
        this.roleListData.forEach(item => {
          item.indeterminate = false;
          this.handleCheckNodeAllChange(flag, item);
        })
      },
      pushRoleId (item) {
        let index;
        for (let i = 0; i < item.children.length; i++) {
          index = this.roleIdList.indexOf(item.children[i].id);
          if (index == -1) {
            this.roleIdList.push(item.children[i].id);
          }
        }
        this.distinct(this.roleIdList);
      },
      popRoleId (item) {
        let index;
        for (let i = 0; i < item.children.length; i++) {
          index = this.roleIdList.indexOf(item.children[i].id);
          if (index > -1) {
            this.roleIdList.splice(index, 1);
          }
        }
        this.distinct(this.roleIdList);
      },
      setRoleList () {
        if (this.isRolePage) {
          this.formData.roleIds = this.roleIdList;
        } else {
          this.formData.b2bRoleList = this.roleIdList;
        }
      },
      async getRoleList () {
        const url = this.apis().getRoleList();
        const result = await this.$http.post(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        for (let i = 0; i < result.data.length; i++) {
          this.$set(result.data[i], 'indeterminate', false);
          this.$set(result.data[i], 'checked', false);
        }
        this.roleListData = result.data;

        this.roleListData.forEach(item => {
          item.children.forEach(role => {
            this.allRoleList.push(role.id);
          })
        })

        this.initial();
      },
      initial() {
        if (!this.isRolePage && this.formData.b2bRoleList.length > 0) {
          this.$nextTick(function () {
            this._setCheckChange(this.formData.b2bRoleList);
          })
        }
        if (this.isRolePage && this.formData.roleList.length > 0) {
          this.$nextTick(function () {
            this.setCheckChange(this.formData.roleList);
          })
        }
      },
      // 回显 行 全选/全不选
      _handleCheckedNodeChange (checkList, item) {
        console.log(checkList);
        console.log(checkList);
        this.$refs.checkbox.forEach(checkbox => {
          if (checkbox.label == item.id) {
            item.indeterminate = checkList.length > 0 && checkList.length < item.children.length;
            if (checkList.length == item.children.length) {
              checkbox.model = true;
            } else {
              checkbox.model = false;
            }
          }
        })
        this.setRoleList();
        this._handleCheckAllChange();
      },
      // 查看员工信息时回显权限
      _setCheckChange (b2bRoleList) {
        this.roleIdList = b2bRoleList;
        let childrenRoleList = [];
        let index;
        this.roleListData.forEach(item => {
          item.children.forEach(role => {
            index = b2bRoleList.indexOf(role.id);
            if (index > -1) {
              childrenRoleList.push(role.id);
            }
          })
          this._handleCheckedNodeChange(childrenRoleList, item);
          childrenRoleList = [];
        })
      },
      // 查看角色页面（选择角色）时回显角色的权限
      setCheckChange (roleList) {
        let checkList = [];
        let nodeItem;
        console.log(roleList);
        roleList.forEach(item => {
          this.roleListData.forEach(cItem => {
            if (item.id === cItem.id) {
              nodeItem = cItem;
            }
          })

          item.children.forEach(role => {
            this.roleIdList.push(role.id);
            checkList.push(role.id);
          })
          this.distinct(this.roleIdList);

          this._handleCheckedNodeChange(checkList, nodeItem);
          checkList = [];
        })
      },
      // 数组去重
      distinct(arr) {
        let result = []
        let obj = {};
        for (let i of arr) {
          if (!obj[i]) {
            result.push(i)
            obj[i] = 1
          }
        }
        return result
      }
    },
    watch: {
    },
    mounted () {
      this.getRoleList();
    },
    created () {
    }
  }
</script>
<style scoped>

  /deep/ .el-checkbox {
    margin-top: 10px;
  }

  /deep/ .bottom_line{
    width:36px;
    position:absolute;
    height:0;
    left: 6px;
    top: 20px;
    overflow:hidden;
    border-bottom:1px dashed #409EFF;
  }

  /deep/ .left_line1{
    width:10px;
    position:absolute;
    left: 6px;
    height:770px;
    overflow:hidden;
    border-left:1px dashed #409EFF;
  }
</style>
