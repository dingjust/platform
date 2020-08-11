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
            <el-col :span="24">
              <permission-form ref="permissionForm" :roleIds="formData.roleList" :dataPermissions="formData.dataPermissions"/>
            </el-col>
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
  export default {
    name: 'OrganizationRoleForm',
    props: ['id'],
    components: {
      PermissionForm
    },
    computed: {
    },
    methods: {
      async getRoleDetail () {
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
        this.$nextTick(() => {
          this.$refs.permissionForm.getList();
        })
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
        let checkData = this.$refs.permissionForm.checkData;
        let checkPerdata = this.$refs.permissionForm.checkPerdata;
        let authData = this.$refs.permissionForm.authData;
        
        let roleIds = [];
        let flag;
        for (const key in checkData) {
          if (checkData.hasOwnProperty(key) && checkData[key].length > 0) {
            // 保存三级菜单
            roleIds.push.apply(roleIds, checkData[key]);
          }
        }

        authData.forEach(parent => {
          // 保存一级菜单
          if (parent.checked || parent.indeterminate) {
            roleIds.push(parent.id)
          }
          parent.children.forEach(item => {
            // 保存二级菜单
            if (item.checked || item.indeterminate) {
              roleIds.push(item.id)
            }
          })
        })

        // 保存数据权限
        let dataPermissions = [];
        for (const key in checkPerdata) {
          if (checkPerdata.hasOwnProperty(key) && checkPerdata[key].length > 0) {
            dataPermissions.push({
              id: key,
              permission: checkPerdata[key][0]
            })
          }
        }

        let data = {
          id: this.formData.id,
          name: this.formData.name,
          remark: this.formData.remark,
          roleIds: roleIds,
          dataPermissions: dataPermissions
        }
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
    data () {
      var validateRoleIds = (rule, value, callback) => {
        if (value && value.length > 0) {
          callback();
        } else {
          return callback(new Error('请选择权限'));
        }
      };
      return {
        formData: {
          id: null,
          name: '',
          remark: '',
          roleIds: [],
          dataPermissions: []
        },
        rules: {
          name: [{ required: true, message: '请输入角色名称', trigger: 'blur' }],
        }
      }
    },
    watch: {
    },
    created () {
      if (this.id != null) {
        this.getRoleDetail();
      } else {
        this.$nextTick(() => {
          this.$refs.permissionForm.getList();
        })
      }
    },
    destroyed () {

    }    
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
</style>