<template>
  <div class="animated fadeIn">
    <b-nav-item-dropdown right no-caret>
      <template slot="button-content">
        <div @click="onArrowDown">
          <el-row type="flex" align="middle">
            <el-image :src="currentUser.profilePicture != null ? currentUser.profilePicture.url : 'static/img/avatars/user.jpg'" fit="cover" class="img-avatar img-head" alt></el-image>
            <span class="name">{{currentUser.username}}</span>
            <i class="el-icon-arrow-down arrow" v-show="arrowDown"></i>
            <i class="el-icon-arrow-up arrow" v-show="!arrowDown"></i>
          </el-row>
        </div>
      </template>
      <b-dropdown-header tag="div" class="text-center">
        <strong>我的</strong>
      </b-dropdown-header>
      <b-dropdown-item @click="onJumpToMy">
        <i class="el-icon-user-solid my-icon"></i> 我的
      </b-dropdown-item>
      <!-- <b-dropdown-item class="px-3" @click="onChangePassword">
        <i class="icon-envelope-letter"></i> 重置密码
      </b-dropdown-item>-->
      <b-dropdown-item @click="onLogout">
        <i class="el-icon-s-help my-icon"></i> 退出登录
      </b-dropdown-item>
    </b-nav-item-dropdown>
    <el-dialog title="修改密码" :visible.sync="dialogVisible" :modal="false" width="30%">
      <change-password-page :username="currentUser.username" :ignore-old-password="false"
        @onChangePassword="doChangePassword" @onCancel="onCancel" />
    </el-dialog>
  </div>
</template>
<script>
  import axios from 'axios';
  import ChangePasswordPage from '@/views/shared/account/password/ChangePasswordPage';
  import {
    log
  } from 'util';

  export default {
    name: 'header-dropdown-accnt',
    components: {
      ChangePasswordPage
    },
    methods: {
      onArrowDown () {
        this.arrowDown = !this.arrowDown;
      },
      onChangePassword () {
        this.dialogVisible = true;
      },
      onLogout () {
        axios.post('/logout').finally(() => {
          //刷新清除缓存
          this.$router.go(0);
          this.$router.push('/login');
        });

        // 清除sessionStorage缓存
        sessionStorage.clear();
      },
      onCancel () {
        this.dialogVisible = false;
      },
      async doChangePassword (oldPassword, newPassword) {
        const url = this.apis().changePassword(this.currentUser.username);
        const result = await this.$http.put(url, null, {
          old: oldPassword,
          new: newPassword
        });

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.dialogVisible = false;

        this.$message.success('密码修改成功');
      },
      onJumpToMy () {
        this.$router.push('/account/my');
      }
    },
    created () {},
    data () {
      return {
        dialogVisible: false,
        currentUser: this.$store.getters.currentUser,
        arrowDown: true
      };
    },
    mounted () {
      this.$root.$on('bv::dropdown::show', bvEvent => {
        console.log('Dropdown is about to be shown', bvEvent);
      });
    }
  };
</script>
<style>
  .arrow {
    color: #000;
    font-size: 16px;
    margin-right: 10px;
  }

  .my-icon {
    color: #000 !important;
  }

  .img-head {
    height: 30px;
    width: 30px;
    border-radius: 50%;
  }

</style>
