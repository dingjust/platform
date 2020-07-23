<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="organization-list-title">
            <h6>创建角色</h6>
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
              <permission-form />
            </el-col>
          </el-row>
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import {PermissionForm} from '../../index.js'
  export default {
    name: 'OrganizationRoleForm',
    props: [],
    components: {
      PermissionForm
    },
    computed: {
    },
    methods: {
    },
    data () {
      return {
        formData: {
          name: '',
          remark: '',
          permissionList: ''
        }
      }
    },
    created () {
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
</style>