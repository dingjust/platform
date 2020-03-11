<template>
  <div>
<!--    <el-row type="flex" align="bottom">-->
<!--      <el-checkbox :indeterminate="indeterminate" v-model="checkAll" @change="handleCheckAllChange" style="padding-bottom: 0px;margin-bottom: 0px">全选</el-checkbox>-->
<!--    </el-row>-->
    <el-row type="flex" v-for="(item, index) in roleListData" :key="index" style="padding-bottom: 20px">
      <el-col :span="2">
        <el-row type="flex">
          <el-checkbox ref="superCheckbox" :indeterminate="item.indeterminate" v-model="item.checked" :label="item.id"
                        @change="handleCheckNodeAllChange($event, item)">
            {{item.name}}
          </el-checkbox>
        </el-row>
        <el-row type="flex" justify="center">
          <div class="left_line1"></div>
        </el-row>
      </el-col>
      <el-col :span="22" style="padding-top: 30px">
        <el-row type="flex" align="top" v-for="(role, index) in item.children" :key="index">
          <el-col :span="6">
            <el-row type="flex" align="middle">
              <el-col :span="1">
                <div class="bottom_line"></div>
              </el-col>
              <el-col :span="23">
                <el-checkbox ref="checkbox" :indeterminate="role.indeterminate" v-model="role.checked" :label="role.id" :name="item.id.toString()"
                             @change="handleCheckedParentNodeChange($event, role, item)">
                  {{role.name}}
                </el-checkbox>
              </el-col>
            </el-row>
          </el-col>
          <el-col :span="18">
            <el-checkbox-group v-model="roleIdList" @change="handleCheckedNodeChange($event, role, item)">
              <el-checkbox v-for="role1 in role.children" :label="role1.id" :key="role1.id" style="width: 100px">
                {{role1.name}}
              </el-checkbox>
            </el-checkbox-group>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>
<script>
  export default {
    name: 'B2BCustomerAuthorityTree1',
    components: {},
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
        defaultNode: [],
        secondRoleArr: []
      }
    },
    methods: {
      // 个体勾选 （个体——>行）
      handleCheckedNodeChange (checkList, role, item) {
        let belongToItemRoleList = [];
        let index;
        let indeterminateFlag = false;
        let checkFlag = false;
        if (role.children) {
          role.children.forEach(role1 => {
            index = checkList.indexOf(role1.id);
            if (index > -1) {
              belongToItemRoleList.push(role1.id)
            }
          })
          this.$refs.checkbox.forEach(checkbox => {
            if (checkbox.label === role.id) {
              indeterminateFlag = belongToItemRoleList.length > 0 && belongToItemRoleList.length < role.children.length;
              this.$set(role, 'indeterminate', indeterminateFlag);
              checkFlag = belongToItemRoleList.length === role.children.length;
              checkbox.model = checkFlag;
            }
          })
        }
        this.secondRoleArr.forEach(item => {
          if (item.id == role.id) {
            item.indeterminateFlag = indeterminateFlag;
            item.checkFlag = checkFlag;
          }
        })

        this.setRoleList();
        this._handleCheckedNodeChange(item);
      },
      // 行勾选 （行——>父）
      _handleCheckedNodeChange (item) {
        let indeterminateCount = 0;
        let indeterminateFlag = false;
        let checkCount = 0;
        this.secondRoleArr.forEach(value => {
          if (value.parentId == item.id) {
            if (value.indeterminateFlag) {
              indeterminateCount++;
            }
            if (value.checkFlag) {
              checkCount++;
            }
          }
        })
        this.$refs.superCheckbox.forEach(superCheckbox => {
          if (superCheckbox.label == item.id) {
            indeterminateFlag = indeterminateCount > 0 || (checkCount > 0 && checkCount != item.children.length);
            this.$set(item, 'indeterminate', indeterminateFlag);
            superCheckbox.model = checkCount === item.children.length;
          }
        })

        this.setRoleList();
      },
      // 行——>个体
      handleCheckedParentNodeChange (flag, role, item) {
        this.secondRoleArr.forEach(item => {
          if (item.id == role.id) {
            item.checkFlag = flag;
            item.indeterminateFlag = false;
            this.$set(role, 'indeterminate', false);
          }
        })
        if (flag) {
          if (!role.children || role.children.length > 0) {
            this.pushRoleId(role);
          } else {
            this.roleIdList.push(role.id);
          }
        } else {
          if (!role.children || role.children.length > 0) {
            this.popRoleId(role);
          } else {
            let index = this.roleIdList.indexOf(role.id);
            if (index > -1) {
              this.roleIdList.splice(index, 1);
            }
          }
        }
        this._handleCheckedNodeChange(item);
      },
      // 父级——>行
      handleCheckNodeAllChange (flag, item) {
        if (flag) {
          item.children.forEach(role => {
            this.pushRoleId(role);
            this.$refs.checkbox.forEach(checkbox => {
              if (checkbox.label === role.id) {
                checkbox.model = true;
              }
            })
          })
        } else {
          item.children.forEach(role => {
            this.popRoleId(role);
            this.$refs.checkbox.forEach(checkbox => {
              if (checkbox.label === role.id) {
                checkbox.model = false;
              }
            })
          })
        }
        this.setRoleList();
      },
      pushRoleId (item) {
        let index;
        if (item.children) {
          for (let i = 0; i < item.children.length; i++) {
            index = this.roleIdList.indexOf(item.children[i].id);
            if (index === -1) {
              this.roleIdList.push(item.children[i].id);
            }
          }
        } else {
          this.roleIdList.push(item.id);
        }
        this.distinct(this.roleIdList);
      },
      popRoleId (item) {
        let index;
        if (item.children) {
          for (let i = 0; i < item.children.length; i++) {
            index = this.roleIdList.indexOf(item.children[i].id);
            if (index > -1) {
              this.roleIdList.splice(index, 1);
            }
          }
        } else {
          index = this.roleIdList.indexOf(item.id);
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
        this.roleListData = result.data;

        let node;
        this.roleListData.forEach(item => {
          item.children.forEach(role => {
            node = {
              id: role.id,
              indeterminateFlag: false,
              checkFlag: false,
              parentId: item.id
            };
            this.secondRoleArr.push(node);
          })
        })

        this.initial();
      },
      initial () {
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
      // 查看员工信息时回显权限
      _setCheckChange (b2bRoleList) {
        this.roleIdList = b2bRoleList;
        this.roleListData.forEach(item => {
          item.children.forEach(role => {
            this.handleCheckedNodeChange(b2bRoleList, role, item);
          })
        })
      },
      // 查看角色页面（选择角色）时回显角色的权限
      setCheckChange (roleList) {
        let checkList = [];
        roleList.forEach(item => {
          item.children.forEach(role => {
            if (role.children) {
              role.children.forEach(role1 => {
                checkList.push(role1.id);
              })
            } else {
              checkList.push(role.id);
              this.$refs.checkbox.forEach(checkbox => {
                if (checkbox.label == role.id) {
                  checkbox.model = true;
                }
              })
              this.secondRoleArr.forEach(item => {
                if (item.id == role.id) {
                  item.checkFlag = true;
                  item.indeterminateFlag = false;
                  this.$set(role, 'indeterminate', false);
                }
              })
              this._handleCheckedNodeChange(item);
            }
          })
        })
        this.distinct(checkList);
        this.roleIdList = checkList;
        roleList.forEach(item => {
          item.children.forEach(role => {
            if (role.children) {
              this.handleCheckedNodeChange(checkList, role, item);
            }
          })
        })
        checkList = [];
      },
      // 数组去重
      distinct (arr) {
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
    width: 35%;
    position: absolute;
    height: 52%;
    left: -33%;
    top: 2px;
    overflow: hidden;
    border-bottom: 1px dashed #409EFF;
  }

  /deep/ .left_line1{
    position: absolute;
    height: 70px;
    left: 6px;
    top: 0px;
    overflow: hidden;
    border-left: 1px dashed #409EFF;
  }
</style>
