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
            <el-form :inline="true">
              <el-row type="flex" justify="start" align="middle" class="personnel-detail-basic-row">
                <el-col :span="12">
                  <el-form-item label="姓名：">
                    <h6 class="basic-title" v-if="!editState">{{this.formData.name}}</h6>
                    <el-input v-else v-model="formData.name"></el-input>
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="联系方式：">
                    <h6 class="basic-title" v-if="!editState">{{this.formData.contactPhone}}</h6>
                    <el-input v-else v-model="formData.contactPhone"></el-input>
                  </el-form-item>
                </el-col>
              </el-row> 
              <el-row type="flex" justify="start" align="middle" class="personnel-detail-basic-row" style="margin-bottom: 20px">
                <el-col :span="12">
                  <h6 class="basic-title">登陆账号：{{this.formData.uid}}</h6>
                </el-col>
                <el-col :span="12">
                  <h6 class="basic-title">状态：{{this.formData.loginDisabled ? '禁用' : '启用'}}</h6>
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
          </el-tab-pane>
          <!-- <el-tab-pane label="组织架构" name="ORGANIZATION">
            <el-form>
              <el-row type="flex" justify="center" align="middle">
                <el-col :span="8">
                  <el-form-item label="当前部门：">
                    <h6 class="basic-title">{{this.originData.b2bDept ? this.originData.b2bDept.name : ''}}</h6>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row type="flex" justify="center" align="middle">
                <el-col :span="8">
                  <el-form-item label="编辑部门：">
                    <select-tree :treeData="deptList" :vSelectData.sync="formData.b2bDept"/>
                  </el-form-item>
                </el-col>
              </el-row>
            </el-form>
          </el-tab-pane> -->
          <el-tab-pane label="权限配置" name="AUTHORITY">
            <personnel-role-info :formData="formData"/>
          </el-tab-pane>
        </el-tabs>
      </div>
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
        <Authorized :permission="['COMPANY_CUSTOMER_MODIFY']">
          <el-button class="personnel-role-btn" @click="onConfirm">确定</el-button>
        </Authorized>
      </el-row>
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
      this.$confirm('是否确认更新员工信息?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this._onConfirm();
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
      this.$message.success('添加员工成功');
      this.$router.go(-1);
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
