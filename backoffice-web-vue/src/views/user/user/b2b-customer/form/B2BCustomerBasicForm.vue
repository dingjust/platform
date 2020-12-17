<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row>
        <div class="customer-list-title">
          <h6>添加员工</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <div class="titleCardClass">
        <el-form ref="form" :model="formData" :rules="rules" :inline="true" :hide-required-asterisk="true">
          <div class="titleClass">
            <h6>基本信息</h6>
          </div>
          <div style="margin: 20px 20px 40px 40px">
            <el-row type="flex">
              <el-col :span="12">
                <el-form-item prop="name">
                  <template slot="label">
                    <h6 class="titleTextClass">
                      员工姓名
                      <span style="color: #F56C6C">*</span>
                    </h6>
                  </template>
                  <el-row type="flex">
                    <el-input
                      placeholder="请填写员工姓名"
                      v-model="formData.name"
                      size="mini"
                      style="width: 194px"
                    ></el-input>
                  </el-row>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item prop="uid">
                  <template slot="label">
                    <h6 class="titleTextClass">
                      员工账号
                      <span style="color: #F56C6C">*</span>
                    </h6>
                  </template>
                  <el-row type="flex">
                    <el-input
                      placeholder="请输入员工账号"
                      v-model="formData.uid"
                      size="mini"
                      style="width: 194px"
                    ></el-input>
                  </el-row>
                </el-form-item>
                <h6 style="padding-left: 25%;color: #909399;padding-top: 10px">员工初始密码与账号相同</h6>
              </el-col>
            </el-row>
            <el-row type="flex">

              <el-col :span="12">
                <el-form-item prop="b2bDept">
                  <template slot="label">
                    <h6 class="titleTextClass">
                      所属部门
                      <span style="color: #FFFFFF">*</span>
                    </h6>
                  </template>
                  <el-row type="flex">
                    <el-tree-select :props="props"
                                    :placeholder="'请选择部门'"
                                    :options="deptList"
                                    :value="formData.b2bDept.id"
                                    :label="formData.b2bDept.name"
                                    @getValue="selectDept">
                    </el-tree-select>
                  </el-row>
                </el-form-item>
              </el-col>

              <el-col :span="12">
                <el-form-item prop="b2bRoleGroup">
                  <template slot="label">
                    <h6 class="titleTextClass">
                      选择角色
                      <span style="color: #FFFFFF">*</span>
                    </h6>
                  </template>
                  <el-row type="flex">
                    <el-select v-model="formData.b2bRoleGroup" placeholder="请选择角色" value-key="id" @change="roleSelect">
                      <el-option
                        v-for="item in roleGroupList"
                        :key="item.id"
                        :label="item.name"
                        :value="item"
                      ></el-option>
                    </el-select>
                  </el-row>
                </el-form-item>
              </el-col>
            </el-row>
          </div>
          <div class="titleClass">
            <h6>权限选择</h6>
          </div>
          <div style="margin: 20px 20px 40px 40px">
            <b2-b-customer-permission-form :formData="formData" ref="permissionForm"/>
          </div>
        </el-form>
      </div>
      <el-row type="flex" justify="center">
        <el-button class="buttonClass" @click="onSave">
          <h6>保存</h6>
        </el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import B2BCustomerPermissionForm from './B2BCustomerPermissionForm';
  import ElTreeSelect from '../tree/treeSelect';
  import LeaveTipDialog from '../../../../common/LeaveTipDialog';
  export default {
    name: 'B2BCustomerBasicForm',
    components: {LeaveTipDialog, ElTreeSelect, B2BCustomerPermissionForm },
    props: [],
    computed: {},
    methods: {
      async getDeptList () {
        const url = this.apis().getB2BCustomerDeptList();
        const result = await this.$http.post(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.deptList = result.data;
        this.getTreeData(this.deptList);
      },
      async getRoleGroupList () {
        let formData = {};
        const url = this.apis().getB2BCustomerRoleGroupList();
        const result = await this.$http.post(url, formData, {
          page: 0,
          size: 100
        });
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.roleGroupList = result.content;
      },
      async roleSelect (data) {
        const url = this.apis().getB2BCustomerRoleGroupDetails(data.id);
        const result = await this.$http.get(url);
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$refs.permissionForm.setCheckRoleList(result.data.roleList);
      },
      selectDept (val) {
        this.deptId = val;
      },
      async onSave () {
        this.$refs['form'].validate(valid => {
          if (valid) {
            if (!this.formData.b2bRoleList || this.formData.b2bRoleList.length == 0) {
              this.$message.error('权限不能为空');
              return
            }
            this.isSave = true;
            this._onSave();
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      async _onSave () {
        let data = {
          name: this.formData.name,
          uid: this.formData.uid,
          b2bDept: this.deptId == 0 ? null : { id: this.deptId },
          b2bRoleGroup: this.formData.b2bRoleGroup,
          b2bRoleList: this.distinct(this.formData.b2bRoleList)
        };
        if (this.formData.hasOwnProperty('id')) {
          data.id = this.formData.id;
        }
        // return;
        const url = this.apis().createB2BCustomer();
        const result = await this.$http.post(url, data);
        if (result.code == 0) {
          // let index = result['errors'][0].message.indexOf(':');
          // let msg = result['errors'][0].message.substring(index + 1);
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('添加员工成功');
        this.$router.push({
          name: '员工'
        });
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
      getTreeData (data) {
        for (var i = 0; i < data.length; i++) {
          if (data[i].children == null) {
            return;
          }
          if (data[i].children.length < 1) {
            data[i].children = undefined;
          } else {
            this.getTreeData(data[i].children);
          }
        }
      }
    },
    data () {
      var checkContactPhone = (rule, value, callback) => {
        // const reg = /^[1][3,4,5,6,7,8,9][0-9]{9}$/;
        // if (value === '') {
        //   callback(new Error('请输入手机号码'));
        // } else if (!reg.test(value)) {
        //   callback(new Error('请输入合法手机号码'));
        // } else {
          callback();
        // }
      };
      return {
        rules: {
          name: [
            { required: true, message: '必填', trigger: 'blur' },
            { max: 10, message: '员工名称最多可输入10个字符', trigger: 'blur' }
          ],
          uid: [{validator: checkContactPhone, type: 'object', trigger: 'blur'}]
        },
        uid: '',
        name: '',
        mobileNumber: '',
        formData: {},
        roleGroupList: [],
        deptList: [],
        deptId: 0,
        props: {
          value: 'id',
          label: 'name',
          children: 'children'
          // disabled:true
        },
        count: 0,
        leave: {},
        status: false,
        isSave: false,
        tipDialogVisible: false,
        hasDept: true
      };
    },
    created () {
      this.getDeptList();
      this.getRoleGroupList();
      if (this.$route.params.formData != null) {
        this.formData = Object.assign({}, this.$route.params.formData);
        if (this.formData.b2bDept == null) {
          this.hasDept = false;
          this.$set(this.formData, 'b2bDept', {id: 0});
        }
        this.deptId = this.formData.b2bDept.id;
      } else {
        this.formData = Object.assign({}, this.$store.state.B2BCustomersModule.formData);
      }
    },
    watch: {
      formData: {
        handler (val) {
          if (val) {
            this.count++
          }
        },
        deep: true
      },
      deptId: function (nval, oval) {
        if (nval) {
          this.count++;
        }
      }
    },
    beforeRouteLeave (to, from, next) {
      next(false);
      const flag = !this.isSave && ((this.$route.params.formData != null && !this.hasDept && this.count > 2) ||
                                  (this.$route.params.formData != null && this.hasDept && this.count > 3) ||
                                  (this.$route.params.formData == null && this.count > 1));
      if (flag) {
        this.$confirm('是否离开此页面 , 更改内容将不会被保存', '提示', {
          confirmButtonText: '离开页面',
          cancelButtonText: '留在页面',
          type: 'warning',
          showClose: false,
          closeOnHashChange: false
        }).then(() => {
          next();
        }).catch(() => {
          throw new Error('取消成功！')
        })
      } else {
        next();
      }
    }
  };
</script>
<style scoped>
  .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }

  .titleClass {
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

  .customer-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .b2bCustomer-toolbar .formLabel {
    font-size: 12px;
    display: inline-block;
  }

  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 70px;
    font-size: 14px;
    /*font-weight: bold;*/
  }

  .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 0px;
  }

  .buttonClass {
    padding: 10px 120px 0px 120px;
    margin-top: 40px;
    background-color: #ffd60c;
    color: #0b0e0f;
    border-radius: 8px;
  }
</style>
