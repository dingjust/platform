<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="organization-list-title">
            <h6>{{this.id ? '编辑角色' : '创建角色'}}</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" :model="formData" :inline="true" label-position="right" :rules="rules">
        <div class="main-container">
          <el-row type="flex">
            <el-col :span="12">
              <el-form-item prop="name">
                <template slot="label">
                  <span>角色名称<span style="color: #F56C6C">*</span></span>
                </template>
                <el-input v-model="formData.name" placeholder="请输入角色名称，如：生产经理"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="角色描述">
                <el-input v-model="formData.remark"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex">
            <el-form-item style="margin-bottom: 0px">
              <template slot="label">
                <span>权限设置<span style="color: #F56C6c">*</span></span>
              </template>
            </el-form-item>
          </el-row>
          <el-row type="flex">
              <!-- <permission-form ref="permissionForm" :roleIds="formData.roleList" :dataPermissions="formData.dataPermissions"/> -->
            <el-form-item label="" prop="roleIds" class="permission-form-table">
              <permission-form-v2 ref="permissionFormV2" :authData="authData" :roleIds="formData.roleList" 
                                :checkedThire="checkedThire" :checkedPer="checkedPer" />
            </el-form-item>
          </el-row>
        </div>
      </el-form>
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
        <el-button class="personnel-confirm-btn" @click="onConfirm">提交</el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import {PermissionForm} from '../../index.js'
  import PermissionFormV2 from '../../components/PermissionFormV2'
  export default {
    name: 'OrganizationRoleForm',
    props: ['id'],
    components: {
      PermissionForm,
      PermissionFormV2
    },
    data () {
      var validateRoleIds = (rule, value, callback) => {
        if (value && value.length > 0) {
          callback();
        } else {
          return callback(new Error('请选择权限'));
        }
      };
      return {
        authData: [],
        checkedThire: {},
        checkedPer: {},
        formData: {
          id: null,
          name: '',
          remark: '',
          roleIds: [],
          dataPermissions: []
        },
        rules: {
          name: [{ required: true, message: '请输入角色名称', trigger: 'blur' }],
          roleIds: [{required: true, validator: validateRoleIds, trigger: 'blur'}]
        }
      }
    },
    methods: {
      async getRoleDetail () {
        if (this.id) {
          const url = this.apis().getB2BCustomerRoleGroupDetails(this.id);
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          if (result.code === 0) {
            this.$message.error(result.msg);
            return;
          }
          this.formData = result.data;
        }

        this.getList();
      },
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

        this.initData();
      },
      initData () {
        if (this.formData.dataPermissions) {
          this.formData.dataPermissions.forEach(item => {
            this.$set(this.checkedPer, item.id, [item.permission]);
          })
        }

        let list;
        let itemIndex;
        let valIndex;
        let checked = false;
        let indeterminate = false;
        if (this.formData.roleList) {
          this.formData.roleList.forEach(item => {
            itemIndex = this.authData.findIndex(v1 => v1.id === item.id);
            item.children.forEach(val => {
              list = val.children.map(v => v.id);
              this.$set(this.checkedThire, val.id, list);
  
              valIndex = this.authData[itemIndex].children.findIndex(v2 => v2.id === val.id);
  
              checked = !this.authData[itemIndex].children[valIndex].children || 
                          this.authData[itemIndex].children[valIndex].children.length === 0 ||
                          this.authData[itemIndex].children[valIndex].children.length === list.length;
              indeterminate = list.length > 0 && 
                              (this.authData[itemIndex].children[valIndex].children && 
                              list.length < this.authData[itemIndex].children[valIndex].children.length);
  
              this.$set(this.authData[itemIndex].children[valIndex], 'checked', checked);
              this.$set(this.authData[itemIndex].children[valIndex], 'indeterminate', indeterminate);
            })
  
            this.$refs.permissionFormV2.changeFirst(this.authData[itemIndex]);
          })
        }
      },
      getId (arr) {
        let list = arr.children.map(item => item.id);
        this.formData.roleIds.push.apply(this.formData.roleIds, list);
      },
      onConfirm () {
        this.$refs['form'].validate((valid) => {
          if (valid) {
            this._onConfirm();
          } else {
            this.$message.error('请完善需求信息');
            return false;
          }
        });
      },
      async _onConfirm () {
        let data = {
          id: this.formData.id,
          name: this.formData.name,
          remark: this.formData.remark,
          roleIds: [],
          dataPermissions: []
        }
        // 处理数据权限
        for (const key in this.checkedPer) {
          data.dataPermissions.push({
            id: key,
            permission: this.checkedPer[key][0]
          });
        }

        for (const key in this.checkedThire) {
          data.roleIds = data.roleIds.concat(this.checkedThire[key]);
        }

        this.authData.forEach(item => {
          if (item.checked || item.indeterminate) {
            data.roleIds.push(item.id);
            item.children.forEach(val => {
              if (val.checked || val.indeterminate) {
                data.roleIds.push(val.id);
              }
            })
          }
        })

        const url = this.apis().saveB2BCustomerRoleGroup();
        const result = await this.$http.post(url, data);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success(data.id ? '编辑角色成功' : '创建角色成功');
        this.$router.go(-1);
      },
      validateField (name) {
        this.$refs.brandForm.validateField(name);
      }
    },
    created () {
      this.getRoleDetail();
    },
  }
</script>

<style scoped>
  .organization-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .main-container {
    padding: 0px 50px;
  } 

  .personnel-confirm-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .permission-form-table {
    width: 100%;
  }
  .permission-form-table >>> .el-form-item__content{
    width: 100%;
  }
</style>