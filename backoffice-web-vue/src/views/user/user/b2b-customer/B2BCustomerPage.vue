<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="customer-list-title">
          <h6>员工管理</h6>
        </div>
      </el-row>
      <div class="pt-1"></div>
      <el-container>
        <el-aside width="20%">
          <b2-b-customer-aside-form @editRole='editRole' @createRole="createRole" @removeRole="removeRole" @saveRoleName="saveRoleName"
                                    @appendDept="appendDept" @removeDept="removeDept" @searchInAside="searchInAside"/>
        </el-aside>
        <el-main width="80%" class="info-main-body">
          <b2-b-customer-toolbar @onNew="onNew" @onSearch="onSearch" @onInvite="onInvite"/>
          <b2-b-customer-list :page="page" @onSearch="onSearch"
                              @editInfo="editInfo"
                              @setDepartmentHead="setDepartmentHead"
                              @removeDepartmentHead="removeDepartmentHead"
                              @workHandover="workHandover"
                              @forbiddenUser="forbiddenUser"
                              @enableUser="enableUser"
                              @deleteUser="deleteUser"/>
        </el-main>
      </el-container>
    </el-card>
    <el-dialog :visible.sync="inviteDialogVisible" width="30%" :close-on-click-modal="false">
      <b2-b-customer-invite-dialog v-if="inviteDialogVisible" @onCannel="inviteCannel" @onConfirm="inviteConfirm"/>
    </el-dialog>
    <el-dialog :visible.sync="editRoleVisible" width="80%" :close-on-click-modal="false" class="purchase-dialog" :before-close="handleClose">
      <b2-b-customer-edit-role-dialog v-if='editRoleVisible' @saveRole='saveRole' @cannelNewRole='cannelNewRole' @watchCount='watchCount'/>
    </el-dialog>
    <el-dialog :visible.sync="workHandoverVisible" width="30%" :close-on-click-modal="false">
      <b2-b-customer-handover-dialog v-if="workHandoverVisible" :slot-data="handoverData"
                                     @onHandoverCannel="onHandoverCannel"
                                     @onHandoverConfirm="onHandoverConfirm"/>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('B2BCustomersModule');

  import B2BCustomerToolbar from './toolbar/B2BCustomerToolbar';
  import B2BCustomerList from './list/B2BCustomerList';
  import B2BCustomerAsideForm from './form/B2BCustomerAsideForm';
  import B2BCustomerInviteDialog from './dialog/B2BCustomerInviteDialog';
  import B2BCustomerEditRoleDialog from './dialog/B2BCustomerEditRoleDialog';
  import B2BCustomerHandoverDialog from './dialog/B2BCustomerHandoverDialog';
  import {B2BCustomersModule, UsersModule} from '../../../../store/modules';

  export default {
    name: 'B2BCustomerPage',
    components: {
      B2BCustomerHandoverDialog,
      B2BCustomerEditRoleDialog,
      B2BCustomerInviteDialog,
      B2BCustomerAsideForm,
      B2BCustomerToolbar,
      B2BCustomerList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        queryFormData: 'queryFormData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAside: 'searchAside'
      }),
      onSearch (page, size) {
        const url = this.apis().getB2BCustomers();
        this.search({url, page, size});
      },
      searchInAside (deptN, roleN) {
        const page = 0;
        const size = 10;
        const keyword = this.queryFormData.keyword;
        const deptName = deptN == '' ? this.queryFormData.deptName : deptN;
        const roleName = roleN == '' ? this.queryFormData.roleGroupName : roleN;
        const url = this.apis().getB2BCustomers();
        this.searchAside({url, keyword, deptName, roleName, page, size});
      },
      // async onDetails (item) {
      //   const url = this.apis().getB2BCustomer(item.uid);
      //   const result = await this.$http.get(url);
      //   if (result['errors']) {
      //     this.$message.error(result['errors'][0].message);
      //     return;
      //   }
      //
      //   this.fn.openSlider('员工：' + item.name, B2BCustomerDetailsPage, result);
      // },
      async getDeptList () {
        const url = this.apis().getB2BCustomerDeptList();
        const result = await this.$http.post(url);
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        let deptList = [{
          children: Object.assign([], result.data),
          depth: 0,
          name: '所有部门'
        }];
        this.$store.state.B2BCustomersModule.deptList = deptList;
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
        let roleGroupList = [{
          children: Object.assign([], result.content),
          depth: 0,
          name: '所有角色'
        }];
        this.$store.state.B2BCustomersModule.roleGroupList = roleGroupList;
      },
      onNew () {
        this.$router.push({
          name: '添加员工'
        });
      },
      onInvite () {
        this.inviteDialogVisible = true;
      },
      inviteCannel () {
        this.inviteDialogVisible = false;
      },
      inviteConfirm (formData) {
        // TODO 邀请员工
        this.onSearch();
        this.inviteDialogVisible = false;
      },
      async editInfo (data) {
        this.$router.push({
          name: '添加员工',
          params: {
            formData: Object.assign({}, data)
          }
        });
      },
      async appendDept (formData) {
        if (formData.id) {
          this.$message.success('修改部门名称成功');
          return;
        }
        this.$message.success('添加部门成功');
        this.getDeptList();
      },
      async removeDept (id) {
        const url = this.apis().deleteB2BCustomerDept(id);
        const result = await this.$http.delete(url);
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('删除部门成功');
        this.getDeptList();
      },
      async removeRole (id) {
        const url = this.apis().removeB2BCustomerRoleGroup(id);
        const result = await this.$http.delete(url);
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('删除角色成功');
        this.getRoleGroupList();
      },
      createRole () {
        const roleGroupData = {
          id: '',
          name: '',
          roleList: [],
          roleIds: []
        }
        this.$store.state.B2BCustomersModule.roleGroupData = roleGroupData;
        this.count = 0;
        this.editRoleVisible = true;
      },
      async editRole (data) {
        const url = this.apis().getB2BCustomerRoleGroupDetails(data.id);
        const result = await this.$http.get(url);
        if (result == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$store.state.B2BCustomersModule.roleGroupData = result.data;
        this.count = 0;
        this.editRoleVisible = true;
      },
      async saveRoleName (data) {
        const url = this.apis().getB2BCustomerRoleGroupDetails(data.id);
        const result = await this.$http.get(url);
        if (result == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.getRolesNode(result.data.roleList);
        data.roleIds = this.countRoleIds;

        const url1 = this.apis().saveB2BCustomerRoleGroup();
        const result1 = await this.$http.put(url1, data, data);
        if (result1.code == 0) {
          this.$message.error(result1.msg);
          return;
        }
        this.$message.success('修改角色名称成功');
        this.editRoleVisible = false;
        this.getRoleGroupList();
        this.countRoleIds = [];
      },
      getRolesNode (data) {
        if (data.length <= 0) {
          return;
        }
        for (let i = 0; i < data.length; i++) {
          if (data[i].children == null) {
            this.countRoleIds.push(data[i].id);
          } else {
            this.getRolesNode(data[i].children);
          }
        }
      },
      async saveRole (data) {
        const url = this.apis().saveB2BCustomerRoleGroup();
        const result = await this.$http.post(url, data, data);
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('保存角色成功');
        this.editRoleVisible = false;
        this.getRoleGroupList();
      },
      cannelNewRole () {
        this.editRoleVisible = false;
      },
      setDepartmentHead (data) {
        const name = data.name;
        const deptName = data.b2bDept.name;
        this.$confirm('是否将 \t' + name + ' \t设为\t ' + deptName + ' \t的部门负责人?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._setDepartmentHead(data);
        });
      },
      async _setDepartmentHead (data) {
        const url = this.apis().setDepartmentHead(data.uid);
        const result = await this.$http.put(url);
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('设置部门负责人成功');
        this.onSearch();
      },
      removeDepartmentHead (data) {
        const name = data.name;
        const deptName = data.b2bDept.name;
        this.$confirm('是否将 \t' + name + ' \t移除\t ' + deptName + ' \t的部门负责人?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          // TODO 移除部门负责人
          this.$message.error('请先完成工作交接再移除部门负责人');
        });
      },
      workHandover (data) {
        this.handoverData = Object.assign({}, data);
        this.workHandoverVisible = true;
      },
      onHandoverCannel () {
        this.workHandoverVisible = false;
      },
      onHandoverConfirm () {
        this.onSearch();
        this.workHandoverVisible = false;
      },
      async _changeLoginDisabled (data) {
        const currentUser = this.$store.getters.currentUser;
        const url = this.apis().changeLoginDisabled(currentUser.uid);
        const result = await this.$http.put(url, data);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('更改员工账号状态成功');
        this.onSearch();
      },
      forbiddenUser (data) {
        this.$confirm('禁用后员工将无法正常使用账号 ， 请问是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._changeLoginDisabled(data);
        });
      },
      enableUser (data) {
        this.$confirm('启用账号后账号将恢复正常使用 ， 请问是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._changeLoginDisabled(data);
        });
      },
      deleteUser (data) {
        this.$confirm('删除后员工将无法正常使用账号 ， 请问是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._deleteUser(data.uid);
        });
      },
      async _deleteUser (uid) {
        const url = this.apis().removeB2BCustomer(uid);
        const result = await this.$http.put(url);
        if (result.code == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('删除账号成功');
        this.onSearch();
      },
      watchCount () {
        this.count++;
      },
      handleClose (done) {
        if (this.count > 0) {
          // this.$confirm('是否确认关闭此弹窗，填写的信息将不会保存')
          //   .then(_ => {
          //     done();
          //   })
          //   .catch(_ => {
          //   });
          this.$confirm('是否确认关闭此弹窗 , 更改内容将不会被保存', '提示', {
            confirmButtonText: '离开页面',
            cancelButtonText: '留在页面',
            type: 'warning',
            showClose: false,
            closeOnHashChange: false
          }).then(() => {
            done();
          }).catch(() => {
          })
        } else {
          done();
        }
      }
    },
    data () {
      return {
        inviteDialogVisible: false,
        editRoleVisible: false,
        roleIds: [],
        countRoleIds: [],
        workHandoverVisible: false,
        handoverData: '',
        count: 0
      };
    },
    created () {
      this.onSearch();
      this.getDeptList();
      this.getRoleGroupList();
    }
  };
</script>
<style scoped>
  .info-main-body {
    width: 100%;
    border-left: 1px solid rgba(0, 0, 0, 0.09);
  }
  .customer-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  /deep/ .el-dialog__header {
    padding: 0px 0px 0px 0px;
  }
</style>
