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
          <b2-b-customer-aside-form/>
        </el-aside>
        <el-main width="80%" class="info-main-body">
          <b2-b-customer-toolbar @onNew="onNew" @onSearch="onSearch" @onInvite="onInvite"/>
          <b2-b-customer-list :page="page" @onDetails="onDetails" @onSearch="onSearch"
                              @editInfo="editInfo"
                              @setDepartmentHead="setDepartmentHead"
                              @workHandover="workHandover"
                              @forbiddenUser="forbiddenUser"
                              @deleteUser="deleteUser"/>
        </el-main>
      </el-container>
    </el-card>
    <el-dialog :visible.sync="inviteDialogVisible" width="30%" :close-on-click-modal="false">
      <b2-b-customer-invite-dialog v-if="inviteDialogVisible" @onCannel="inviteCannel" @onConfirm="inviteConfirm"/>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('B2BCustomersModule');

  import B2BCustomerToolbar from './toolbar/B2BCustomerToolbar';
  import B2BCustomerList from './list/B2BCustomerList';
  import B2BCustomerDetailsPage from './details/B2BCustomerDetailsPage';
  import B2BCustomerAsideForm from './form/B2BCustomerAsideForm';
  import B2BCustomerInviteDialog from './dialog/B2BCustomerInviteDialog';

  export default {
    name: 'B2BCustomerPage',
    components: {
      B2BCustomerInviteDialog,
      B2BCustomerAsideForm,
      B2BCustomerToolbar,
      B2BCustomerList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword'
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
      async onDetails (item) {
        const url = this.apis().getB2BCustomer(item.uid);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('员工：' + item.name, B2BCustomerDetailsPage, result);
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
      editInfo (data) {
        this.$router.push({
          path: 'customerDetail'
        });
      },
      setDepartmentHead (data) {

      },
      workHandover (data) {

      },
      forbiddenUser (data) {

      },
      deleteUser (data) {

      }
    },
    data () {
      return {
        inviteDialogVisible: false
      };
    },
    created () {
      this.onSearch();
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
