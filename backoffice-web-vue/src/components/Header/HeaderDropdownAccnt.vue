<template>
  <b-nav-item-dropdown right no-caret>
    <template slot="button-content">
      {{currentUser.username}}
      <img src="static/img/avatars/user.jpg" class="img-avatar"/>
    </template>
    <b-dropdown-header tag="div" class="text-center">
      <strong>我的</strong>
    </b-dropdown-header>
    <!--<b-dropdown-divider></b-dropdown-divider>-->
    <b-dropdown-item class="px-3" @click="onChat">
      <i class="icon-envelope-letter"></i> 在线聊天
    </b-dropdown-item>
    <b-dropdown-item @click="onLogout">
      <i class="fa fa-lock"></i> 退出登录
    </b-dropdown-item>
  </b-nav-item-dropdown>
</template>
<script>
  import axios from 'axios';
  import WebChat from '../webchat'

  export default {
    name: 'header-dropdown-accnt',
    mixins: [WebChat],
    methods: {
      onChat() {
        // this.fn.openSlider('在线客服', ChatPage);
        this.openChat()
      },
      onLogout() {
        axios.post('/logout')
          .finally(() => {
            this.$router.push('/login');
          });
      }
    },
    created() {
      this.currentUser = this.$store.getters.currentUser || {};
      // console.log(this.currentUser);
    },
    data() {
      return {
        currentUser: null,
        itemsCount: 42
      }
    }
  }
</script>
