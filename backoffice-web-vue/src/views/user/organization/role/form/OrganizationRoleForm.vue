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
      <el-form :model="formData" :inline="true" label-position="right">
        <div class="main-container">
          <el-row type="flex">
            <el-col :span="12">
              <el-form-item>
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
              <permission-form ref="permissionForm" />
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
        this.setRoleData(result.data);
      },
      setRoleData (data) {
        this.formData.name = data.name;
        // data.roleList.forEach()
      },
      async onConfirm () {
        let checkData = this.$refs.permissionForm.checkData;
        let authData = this.$refs.permissionForm.authData;
        let roleIds = [];
        let flag;
        for (const key in checkData) {
          if (checkData.hasOwnProperty(key) && checkData[key].length > 0) {
            roleIds.push(Number(key));
            roleIds.push.apply(roleIds, checkData[key]);

            authData.forEach(item => {
              flag = item.children.some(val => val.id == Number(key));
              if (flag && roleIds.indexOf(item.id) < 0) {
                roleIds.push(item.id);
              }
            })
          }
        }

        let data = {
          id: this.formData.id,
          name: this.formData.name,
          remark: this.formData.remark,
          roleIds: roleIds
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
      }
    },
    data () {
      return {
        formData: {
          id: null,
          name: '',
          remark: '',
          roleIds: []
        }
      }
    },
    created () {
      if (this.id != null) {
        this.getRoleDetail();
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