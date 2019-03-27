<template>
  <div class="animated fadeIn">
    <b-nav-item-dropdown right no-caret>
      <template slot="button-content">
        {{currentUser.username}}
        <img src="static/img/avatars/user.jpg" class="img-avatar" alt=""/>
      </template>
      <b-dropdown-header tag="div" class="text-center">
        <strong>我的</strong>
      </b-dropdown-header>
      <b-dropdown-item class="px-3" @click="onChangePassword">
        <i class="icon-envelope-letter"></i> 重置密码
      </b-dropdown-item>
      <b-dropdown-item @click="onLogout">
        <i class="fa fa-lock"></i> 退出登录
      </b-dropdown-item>
    </b-nav-item-dropdown>
    <el-dialog title="修改密码"
               :visible.sync="dialogVisible"
               :modal="false"
               width="30%">
      <change-password-page :username="currentUser.username"
                            :ignore-old-password="false"
                            @onChangePassword="doChangePassword"
                            @onCancel="onCancel"/>
    </el-dialog>
  </div>
</template>
<script>
  import axios from 'axios';
  import ChangePasswordPage from "@/views/shared/account/password/ChangePasswordPage";

  export default {
    name: 'header-dropdown-accnt',
    components: {ChangePasswordPage},
    methods: {
      onChangePassword() {
        this.dialogVisible = true;
      },
      onLogout() {
        axios.post('/logout')
          .finally(() => {
            this.$router.push('/login');
          });
      },
      onCancel() {
        this.dialogVisible = false;
      },
      async doChangePassword(oldPassword, newPassword) {
        const url = this.apis().changePassword(this.currentUser.username);
        const result = await this.$http.put(url, null, {
          old: oldPassword,
          new: newPassword
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.dialogVisible = false;

        this.$message.success('密码修改成功');
      }
    },
    created() {
    },
    data() {
      return {
        dialogVisible: false,
        currentUser: this.$store.getters.currentUser
      }
    }
  }
</script>
