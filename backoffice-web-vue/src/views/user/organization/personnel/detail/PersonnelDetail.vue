<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="organization-list-title">
            <h6>编辑员工</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <div style="height: 400px">
        <el-tabs v-model="activeName" @tab-click="handleClick">
          <el-tab-pane label="基本信息" name="BASIC">
            <el-row type="flex" justify="end">
              <Authorized :permission="['COMPANY_CUSTOMER_MODIFY']">
                <el-button @click="onEdit">编辑</el-button>
              </Authorized>
              <Authorized :permission="['COMPANY_CUSTOMER_ENABLE']">
                <el-button @click="onForbidden">禁用</el-button>
              </Authorized>
              <Authorized :permission="['COMPANY_CUSTOMER_ENABLE']">
                <el-button @click="onEnabled">启用</el-button>
              </Authorized>
            </el-row>
            <el-form ref="form" :inline="true" :model="formData" :hide-required-asterisk="true" label-width="90px" label-position="left">
              <el-row type="flex" justify="start" align="middle" class="personnel-detail-basic-row">
                <el-col :span="12">
                  <el-form-item label="姓名：">
                    <template slot="label"><span>姓&#x3000;&#x3000;名：</span></template>
                    <h6 class="basic-title" v-if="!editState">{{this.formData.name}}</h6>
                    <el-input v-else v-model="formData.name"></el-input>
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="联系方式：" prop="contactPhone" :rules="[{ required: true, validator: validatePhone, trigger: 'change'}]">
                    <h6 class="basic-title" v-if="!editState">{{this.formData.contactPhone}}</h6>
                    <el-input v-else v-model="formData.contactPhone"></el-input>
                  </el-form-item>
                </el-col>
              </el-row> 
              <el-row type="flex" justify="start" align="middle" class="personnel-detail-basic-row">
                <el-col :span="12">
                  <el-form-item label="登陆账号：">
                    <h6 class="basic-title">{{this.formData.uid}}</h6>
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="状态：">
                    <template slot="label"><span>状&#x3000;&#x3000;态：</span></template>
                    <h6 class="basic-title">{{this.formData.loginDisabled ? '禁用' : '启用'}}</h6>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row type="flex" justify="start" align="middle" class="personnel-detail-basic-row">
                <el-col :span="12">
                  <el-form-item label="所属部门：">
                    <h6 class="basic-title" v-if="!editState">{{this.formData.b2bDept ? this.formData.b2bDept.name : ''}}</h6>
                    <select-tree v-else :treeData="deptList" :vSelectData.sync="formData.b2bDept"/>
                  </el-form-item>
                </el-col>
              </el-row>
            </el-form>
            <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
              <Authorized :permission="['COMPANY_CUSTOMER_MODIFY']">
                <el-button class="personnel-role-btn" @click="onConfirm">确定</el-button>
              </Authorized>
            </el-row>
          </el-tab-pane>
          <el-tab-pane label="权限配置" name="AUTHORITY">
            <personnel-role-info :formData="formData" @onSave="_onConfirm"/>
          </el-tab-pane>
        </el-tabs>
      </div>
    </el-card>
  </div>
</template>

<script>
import { SelectTree } from '@/components'
import PersonnelRoleInfo from './PersonnelRoleInfo'
export default {
  name: 'PersonnelDetail',
  props: ['id'],
  components: {
    SelectTree,
    PersonnelRoleInfo
  },
  computed: {
    role: function () {
      let str = '';
      if (this.formData.b2bRoleGroupList && this.formData.b2bRoleGroupList.length > 0) {
        this.formData.b2bRoleGroupList.forEach((item, index) => {
          str += item.name;
          if (this.formData.b2bRoleGroupList.length - 1 != index) {
            str += '/';
          }
        })
      }
      return str;
    }
  },
  methods: {
    async getDetail () {
      const url = this.apis().getPersonnelDetail(this.id);
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
      if (this.formData.b2bRoleGroupList == null) {
        this.formData.b2bRoleGroupList = [];
      }
      this.$nextTick(() => {
        this.$refs.form.clearValidate();
      })
    },
    async getDeptList () {
      const url = this.apis().getB2BCustomerDeptList();
      const result = await this.$http.post(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      this.deptList = result.data;
    },
    onEdit () {
      this.editState = true;
    },
    onForbidden () {
      if (this.formData.loginDisabled === true) {
        this.$message.warning('此账号已禁用！');
        return;
      }
      this._changeLoginDisabled();
    },
    onEnabled () {
      if (this.formData.loginDisabled === false) {
        this.$message.warning('此账号已启用！');
        return;
      }
      this._changeLoginDisabled();
    },
    async _changeLoginDisabled () {
      let data = {
        id: this.formData.id,
        uid: this.formData.uid
      }
      const currentUser = this.$store.getters.currentUser;
      const url = this.apis().changeLoginDisabled(currentUser.uid);
      const result = await this.$http.put(url, data);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code == 0) {
        this.$message.error(result.msg);
        return;
      }
      this.$message.success('更改员工账号状态成功');
      this.getDetail();
    },
    handleClick (tab, event) {

    },
    onConfirm () {
      this.$refs.form.validate((vaild) => {
        if (vaild) {
          this.$confirm('是否确认更新员工信息?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this._onConfirm();
          });
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
        uid: this.formData.uid,
        name: this.formData.name,
        contactPhone: this.formData.contactPhone,
        b2bDept: {
          id: this.formData.b2bDept ? this.formData.b2bDept.id : null 
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
      this.$message.success('编辑员工信息成功');
      this.getDetail();
      this.editState = false;
      // this.$router.go(-1);
    },
    validateField (name) {
      this.$refs.form.validateField(name);
    },
    validatePhone (rule, value, callback) {
      const reg = /^[1][3,4,5,6,7,8,9][0-9]{9}$/;
      if (value === '') {
        callback(new Error('请输入手机号码'));
      } else if (!reg.test(value)) {
        callback(new Error('请输入合法手机号码'));
      } else {
        callback();
      }
    }
  },
  data () {
    return {
      activeName: 'BASIC',
      editState: false,
      deptList: [],
      formData: {
        uid: '',
        name: '',
        contactPhone: '',
        loginDisabled: false,
        b2bDept: {
          name: ''
        },
        b2bRoleGroup: {
          name: ''
        }
      }
    }
  },
  watch: {
    'formData.contactPhone': function (nval, oval) {
      this.validateField('contactPhone');
    }
  },
  created () {
    this.getDetail();
    this.getDeptList();
  } 
}
</script>

<style scoped>
  .organization-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .personnel-detail-basic-row {
    margin-left: 20px;
  }

  .personnel-role-btn {
    background-color: #ffd60c;
    color: #000;
    width: 80px;
    height: 35px;
    border-radius: 6px;
    margin-bottom: 10px;
  }

  .basic-title {
    text-align: right;
    vertical-align: middle;
    float: left;
    font-size: 14px;
    color: #606266;
    line-height: 32px;
    padding: 0 12px 0 0;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
  }
</style>
