<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="organization-list-title">
            <h6>{{this.$route.params.data == null ? '创建员工' : '员工详情'}}</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <div class="personnnel-label-card">
        <el-form ref="form" :model="formData" :rules="rules" :inline="true" :hide-required-asterisk="true">
          <div class="personnnel-label-title">
            <h6>基本信息</h6>
          </div>
          <div style="margin: 20px 20px 0px 40px">
            <el-row type="flex">
              <el-col :span="12">
                <el-form-item prop="name">
                  <template slot="label">
                    <span>员工姓名<span style="color: #F56C6C">*</span></span>
                  </template>
                  <el-input v-model="formData.name" placeholder="请输入员工姓名" class="personnel-input"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item prop="contactPhone">
                  <template slot="label">
                    <span>联系方式<span style="color: #F56C6C">*</span></span>
                  </template>
                  <el-input v-model="formData.contactPhone" placeholder="请输入手机号" class="personnel-input"></el-input>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row type="flex">
              <el-col :span="12">
                <el-form-item prop="uid">
                  <template slot="label">
                    <span>员工账号<span style="color: #F56C6C">*</span></span>
                  </template>
                  <el-input v-model="formData.uid" class="personnel-input"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item prop="password">
                  <template slot="label">
                    <span>登陆密码<span style="color: #F56C6C">*</span></span>
                  </template>
                  <el-input v-model="formData.password" class="personnel-input"></el-input>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row type="flex">
              <el-col :span="12">
                <el-form-item>
                  <template slot="label">
                    <span style="padding-right: 6px;">所属部门</span>
                  </template>
                  <select-tree :treeData="deptList" :vSelectData.sync="formData.b2bDept"/>
                </el-form-item>
                <!-- <el-button class="personnel-form-btn" @click="createDept">创建部门</el-button> -->
              </el-col>
              <el-col :span="12">
                <el-form-item>
                  <template slot="label">
                    <span style="padding-right: 6px;">选择角色</span>
                  </template>
                  <el-select v-model="formData.b2bRoleGroupList[0]" placeholder="请选择角色" value-key="id" clearable >
                    <el-option v-for="item in roleGroupList" :key="item.id" :label="item.name" :value="item" />
                  </el-select>
                </el-form-item>
                <!-- <el-button class="personnel-form-btn" @click="createRole">创建角色</el-button> -->
              </el-col>
            </el-row>
          </div>
        </el-form>
      </div>
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
        <el-button class="personnel-confirm-btn" @click="onConfirm">保存提交</el-button>
      </el-row>
    </el-card>
    <!-- <el-dialog :visible.sync="deptVisible" class="purchase-dialog" width="40%" append-to-body :close-on-click-modal="false">
    </el-dialog> -->
  </div>
</template>

<script>
  import {SelectTree} from '@/components/index.js'

  export default {
    name: 'PersonnelForm',
    props: [],
    components: {
      SelectTree
    },
    computed: {

    },
    methods: {
      async getDeptList () {
        const url = this.apis().getB2BCustomerDeptList();
        const result = await this.$http.post(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.deptList = result.data;
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
      createDept () {
        this.deptVisible = true;
      },
      createRole () {
        this.roleVisible = true;
      },
      onConfirm () {
        this.$refs['form'].validate((valid) => {
          if (valid) {
            this._onConfirm();
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      async _onConfirm () {
        let b2bRoleGroupList = this.formData.b2bRoleGroupList.map(item => {
          if (item.id != null && item.id != '') {
            return {id: item.id};
          }
        });
        let data = {
          id: this.formData.id,
          name: this.formData.name,
          uid: this.formData.uid,
          password: this.formData.password,
          contactPhone: this.formData.contactPhone,
          b2bDept: {
            id: this.formData.b2bDept.id != '' ? this.formData.b2bDept.id : null 
          },
          b2bRoleGroupList: b2bRoleGroupList
        };
        const url = this.apis().createB2BCustomer();
        const result = await this.$http.post(url, data);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('添加员工成功');
        this.$router.go(-1);
      },
      initData () {

      }
    },
    data () {
      return {
        rules: {
          name: [{ required: true, message: '必填', trigger: 'blur' }],
          uid: [{ required: true, message: '必填', trigger: 'blur' }],
          contactPhone: [{ required: true, message: '必填', trigger: 'blur' }],
          password: [{ required: true, message: '必填', trigger: 'blur' }],
        },
        formData: {
          id: null,
          name: '',
          uid: '',
          b2bRoleGroupList: [{
            id: ''
          }],
          b2bDept: {
            id: ''
          },
          contactPhone: '',
          password: ''
        },
        roleGroupList: '',
        deptList: [],
        deptVisible: false,
        roleVisible: false
      }
    },
    created () {
      this.getRoleGroupList();
      this.getDeptList();
      if (this.$route.params.data != null) {
        this.formData.id = this.$route.params.data.id;
        this.formData.name = this.$route.params.data.name;
        this.formData.uid = this.$route.params.data.uid;
        this.formData.b2bRoleGroup = this.$route.params.data.b2bRoleGroup;
        this.formData.b2bDept = this.$route.params.data.b2bDept != null ? this.$route.params.data.b2bDept : {id:''};
        this.formData.contactPhone = this.$route.params.data.contactPhone;
        this.formData.password = this.$route.params.data.password;
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

  .personnel-form-container {
    border: 1px solid #DCDCDC;
  }

  .personnnel-label-card{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }

  .personnnel-label-title {
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

  .personnel-input {
    width: 194px;
  }

  .personnel-form-btn {
    background-color: #ffd60c;
    color: #606266
  }

  .personnel-confirm-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }
</style>