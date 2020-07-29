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
      <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="基本信息" name="BASIC">
          <el-row type="flex" justify="start" align="middle" class="personnel-detail-basic-row">
            <el-col :span="8">
              <h6>姓名：{{this.formData.name}}</h6>
            </el-col>
            <el-col :span="8">
              <h6>联系方式：{{contactPhone}}</h6>
            </el-col>
            <el-col :span="8">
              <h6>状态：{{this.formData.loginDisabled ? '禁用' : '启用'}}</h6>
            </el-col>
          </el-row> 
          <el-row type="flex" justify="start" align="middle" class="personnel-detail-basic-row">
            <el-col :span="8">
              <h6>登陆账号：{{this.formData.uid}}</h6>
            </el-col>
            <el-col :span="8">
              <h6>所属部门：{{this.formData.b2bDept ? this.formData.b2bDept.name : ''}}</h6>
            </el-col>
            <el-col :span="8">
              <h6>角色：{{role}}</h6>
            </el-col>
          </el-row>
        </el-tab-pane>
        <el-tab-pane label="组织架构" name="ORGANIZATION">
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
        </el-tab-pane>
        <el-tab-pane label="权限配置" name="AUTHORITY">
          <personnel-role-info :formData="formData"/>
        </el-tab-pane>
      </el-tabs>
      <el-row type="flex" justify="center" align="middle" style="margin-top: 20px" v-if="activeName !== 'BASIC'">
        <el-button class="personnel-role-btn" @click="onConfirm">确定</el-button>
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
    contactPhone: function () {
      if (this.formData.contactPhone) {
        return this.formData.contactPhone.split(':')[1];
      }
    },
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
      this.originData = Object.assign({}, result.data);
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
    handleClick (tab, event) {

    },
    onConfirm () {
      return;
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
        name: this.formData.name,
        uid: this.formData.uid,
        // password: this.formData.password,
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
    }
  },
  data () {
    return {
      activeName: 'BASIC',
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
      },
      originData: {
        b2bDept: {
          name: ''
        }
      }
    }
  },
  created () {
    console.log(this.$route);
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
    margin: 20px 0px 0px 20px;
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