<template>
  <div>
<!--    <el-row type="flex" align="bottom">-->
<!--      <el-checkbox :indeterminate="indeterminate" v-model="checkAll" @change="handleCheckAllChange" style="padding-bottom: 0px;margin-bottom: 0px">全选</el-checkbox>-->
<!--    </el-row>-->
<!--    <div v-for="(item, index) in roleListData" :key="index">-->
    <el-row type="flex" v-for="(item, index) in roleListData" :key="index" style="padding-bottom: 20px">
      <el-col :span="2">
        <el-row type="flex">
          <el-checkbox ref="superCheckbox" :indeterminate="item.indeterminate" v-model="item.checked" :label="item.id"
                       @change="handleCheckNodeAllChange($event, item)">
            {{item.name}}
          </el-checkbox>
        </el-row>
        <el-row type="flex" justify="center">
          <div ref="leftLine" class="leftLine" :style="{ height: leftLH[index] + 'px' }"></div>
        </el-row>
      </el-col>
      <el-col :span="22" style="padding-top: 30px">
        <el-row type="flex" align="top" v-for="(role, index) in item.children" :key="index">
          <el-col :span="6">
            <el-row type="flex" align="middle">
              <el-col :span="1">
<!--                <div :class="index == 0 ? 'left_line1' : 'left_line2'"></div>-->
                <div class="bottom_line1"></div>
              </el-col>
              <el-col :span="23">
                <el-checkbox ref="checkbox" :indeterminate="role.indeterminate" v-model="role.checked" :label="role.id"
                             @change="handleCheckedParentNodeChange($event, role, item)">
                  {{role.name}}
                </el-checkbox>
              </el-col>
            </el-row>
          </el-col>
          <el-col :span="18">
            <el-checkbox-group v-model="roleIdList" @change="handleCheckedNodeChange($event, role, item)">
              <el-checkbox v-for="role1 in role.children" :label="role1.id" :key="role1.id" style="width: 150px">
                {{role1.name}}
              </el-checkbox>
            </el-checkbox-group>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
<!--    <el-divider v-if="index != roleListData.length-1"></el-divider>-->
<!--    </div>-->
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
        secondRoleArr: [],
        leftLH: [],
        screenWidth: ''
      }
    },
    methods: {
      // 个体勾选 （个体——>行）
      handleCheckedNodeChange (checkList, role, item) {
        let belongToItemRoleList = [];
        let index;
        let indeterminateFlag = false;
        let checkFlag = false;
        if (role.children && role.children.length > 0) {
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
          }
        } else {
          if (!role.children || role.children.length > 0) {
            this.popRoleId(role);
          }
        }
        this._handleCheckedNodeChange(item);
      },
      // 父级——>行
      handleCheckNodeAllChange (flag, item) {
        this.$set(item, 'indeterminate', false);
        if (flag) {
          item.children.forEach(role => {
            this.pushRoleId(role);
            this.$set(role, 'indeterminate', false);
            this.$refs.checkbox.forEach(checkbox => {
              if (checkbox.label === role.id) {
                checkbox.model = true;
              }
            })
          })
        } else {
          item.children.forEach(role => {
            this.popRoleId(role);
            this.$set(role, 'indeterminate', false);
            this.$refs.checkbox.forEach(checkbox => {
              if (checkbox.label === role.id) {
                checkbox.model = false;
              }
            })
          })
        }
        this.secondRoleArr.forEach(value => {
          if (value.parentId == item.id) {
            value.indeterminateFlag = false;
            value.checkFlag = flag;
          }
        })
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
        this.roleIdList = this.distinct(this.roleIdList);
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
        this.roleIdList = this.distinct(this.roleIdList);
      },
      setRoleList () {
        let index;
        this.secondRoleArr.forEach(value => {
          index = this.roleIdList.indexOf(value.id);
          if (index > -1) {
            this.roleIdList.splice(index, 1);
          }
          index = this.roleIdList.indexOf(value.parentId);
          if (index > -1) {
            this.roleIdList.splice(index, 1);
          }
        })
        this.secondRoleArr.forEach(item => {
          if (item.checkFlag || item.indeterminateFlag) {
            this.roleIdList.push(item.id);
            this.roleIdList.push(item.parentId);
          }
        })
        this.roleIdList = this.distinct(this.roleIdList)
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
        this.leftLineHeightCount();
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
      // 选择角色回显角色权限
      setCheckRoleList (roleList) {
        // item 订单
        roleList.forEach(item => {
          this.roleIdList.push(item.id);
          if (item.children && item.children.length > 0) {
            // role打样订单
            item.children.forEach(role => {
              this.roleIdList.push(role.id);
              if (role.children && role.children.length > 0) {
                role.children.forEach(role1 => {
                  this.roleIdList.push(role1.id);
                })
              }
            })
          }
        })
        this.roleIdList = this.distinct(this.roleIdList);
        this.__setCheckChange(this.roleIdList);
      },
      // 查看员工信息时回显权限
      _setCheckChange (b2bRoleList) {
        this.roleIdList = b2bRoleList;
        this.$store.state.B2BCustomersModule.trainData = Object.assign([], b2bRoleList);
        this.__setCheckChange(b2bRoleList);
      },
      // 查看角色页面时回显角色的权限
      setCheckChange (roleList) {
        let checkList = [];
        roleList.forEach(item => {
          item.children.forEach(role => {
            if (role.children && role.children.length > 0) {
              role.children.forEach(role1 => {
                checkList.push(role1.id);
              })
            } else {
              checkList.push(role.id);
            }
          })
        })
        this.distinct(checkList);
        this.roleIdList = checkList;
        this.$store.state.B2BCustomersModule.trainData = Object.assign([], checkList);
        this.__setCheckChange(checkList);
        checkList = [];
      },
      __setCheckChange (roleList) {
        let index;
        this.roleListData.forEach(item => {
          item.children.forEach(role => {
            if (role.children && role.children.length > 0) {
              this.handleCheckedNodeChange(roleList, role, item);
            } else {
              index = this.$store.state.B2BCustomersModule.trainData.indexOf(role.id);
              if (index > -1) {
                this.secondRoleArr.forEach(value => {
                  if (value.id == role.id) {
                    value.indeterminateFlag = false;
                    value.checkFlag = true;
                  }
                })
                this.$refs.checkbox.forEach(checkbox => {
                  if (checkbox.label == role.id) {
                    checkbox.model = true;
                  }
                })
                this._handleCheckedNodeChange(item);
              }
            }
          })
        })
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
      },
      leftLineHeightCount () {
        this.leftLH = [];
        let item;
        let parentY;
        let childrenY;
        this.$nextTick(() => {
          this.roleListData.forEach(val => {
            item = val.children[val.children.length - 1];
            this.$refs.superCheckbox.forEach(superCheckbox => {
              if (val.id == superCheckbox.label) {
                parentY = superCheckbox.$el.getBoundingClientRect().y
              }
            })
            this.$refs.checkbox.forEach(checkbox => {
              if (item.id == checkbox.label) {
                childrenY = checkbox.$el.getBoundingClientRect().y;
              }
            })
            this.leftLH.push(childrenY - parentY);
          })
        })
      }
    },
    watch: {
      screenWidth: function (nVal, oVal) {
        if (nVal) {
          this.leftLineHeightCount();
        }
      }
    },
    mounted () {
      this.getRoleList();
      this.screenWidth = document.body.clientWidth;
      window.onresize = () => {
        return (() => {
          this.screenWidth = document.body.clientWidth;
        })();
      };
    },
    created () {
    }
  }
</script>
<style scoped>

  /deep/ .el-checkbox {
    margin-top: 10px;
  }

  /deep/ .bottom_line1{
    width: 35%;
    position: absolute;
    height: 52%;
    left: -33%;
    top: 2px;
    overflow: hidden;
    border-bottom: 1px dashed #409EFF;
  }

  .leftLine{
    position: absolute;
    /*height: 22px;*/
    left: 8%;
    top: -17px;
    overflow: hidden;
    border-left: 1px dashed #409EFF;
  }

  .left_line2{
    position: absolute;
    height: 35px;
    left: -34%;
    top: -14px;
    overflow: hidden;
    border-left: 1px dashed #409EFF;
  }

</style>
