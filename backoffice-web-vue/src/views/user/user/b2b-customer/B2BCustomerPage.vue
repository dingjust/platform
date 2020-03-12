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
                                    @appendDept="appendDept" @removeDept="removeDept" />
        </el-aside>
        <el-main width="80%" class="info-main-body">
          <b2-b-customer-toolbar @onNew="onNew" @onSearch="onSearch" @onInvite="onInvite"/>
          <b2-b-customer-list :page="page" @onSearch="onSearch"
                              @editInfo="editInfo"
                              @setDepartmentHead="setDepartmentHead"
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
    <el-dialog :visible.sync="editRoleVisible" width="80%" :close-on-click-modal="false" class="purchase-dialog">
      <b2-b-customer-edit-role-dialog v-if='editRoleVisible' :slotData='roleGroupData' @saveRole='saveRole' @cannelNewRole='cannelNewRole'/>
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
        keyword: 'keyword',
        formData: 'formData'
      })
    },
    methods: {
      ...mapActions({
        search: 'search'
      }),
      onSearch (page, size) {
        const keyword = this.keyword;
        const url = this.apis().getB2BCustomers();
        this.search({url, keyword, page, size});
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
        this.roleGroupData = {
          id: '',
          name: '',
          roleList: [],
          roleIds: []
        };
        this.editRoleVisible = true;
      },
      async editRole (data) {
        const url = this.apis().getB2BCustomerRoleGroupDetails(data.id);
        const result = await this.$http.get(url);
        if (result == 0) {
          this.$message.error(result.msg);
          return;
        }
        this.roleGroupData = result.data;
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
        const result = await this.$http.put(url, data, data);
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
        let name = data.name;
        let deptName = data.b2bDept.name;
        this.$confirm('是否将 ' + name + ' 设为 ' + deptName + ' 的部门负责人?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._setDepartmentHead(data);
        });
      },
      _setDepartmentHead (data) {
        // TODO 设置部门负责人
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
      // async changeLoginDisabled (uid) {
      //   // const url = this.apis().changeLoginDisabled(uid);
      //   // const result = await this.$http.put(url);
      //   // if (result['errors']) {
      //   //   this.$message.error(result['errors'][0].message);
      //        return;
      //   // }
      //   this.$message.success('更改员工账号状态成功');
      //   this.onSearch();
      // },
      forbiddenUser (data) {
        this.$confirm('禁用后员工将无法正常使用账号 ， 请问是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          // this.changeLoginDisabled(data.uid);
        });
      },
      enableUser (data) {
        this.$confirm('启用账号后账号将恢复正常使用 ， 请问是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          // this.changeLoginDisabled(data.uid);
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
      }
    },
    data () {
      return {
        inviteDialogVisible: false,
        editRoleVisible: false,
        roleGroupData: {},
        roleIds: [],
        countRoleIds: [],
        workHandoverVisible: false,
        handoverData: ''
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
