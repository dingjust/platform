<template>
  <div class="app flex-row align-items-center">
    <div class="container">
      <b-row class="justify-content-center">
        <b-col md="4">
          <b-card-group>
            <b-card no-body class="p-4">
              <b-card-body>
                <h1>系统登录</h1>
                <p class="text-muted">衣加衣供应链平台</p>
                <b-input-group class="mb-3">
                  <div class="input-group-prepend">
                    <span class="input-group-text"><i class="icon-user"></i></span>
                  </div>
                  <input v-model="username" type="text" class="form-control" placeholder="请输入用户名">
                </b-input-group>
                <b-input-group class="mb-4">
                  <div class="input-group-prepend">
                    <span class="input-group-text"><i class="icon-lock"></i></span>
                  </div>
                  <input v-model="password" type="password"  class="form-control" placeholder="请输入密码">
                </b-input-group>
                <b-row>
                  <b-col cols="6">
                    <b-button variant="primary" class="px-4" @click="login" @keyup.enter="login">登录</b-button>
                  </b-col>
                </b-row>
              </b-card-body>
            </b-card>
          </b-card-group>
        </b-col>
      </b-row>
    </div>
  </div>
</template>
<script>
  export default {
    name: 'LoginPage',
    data() {
      return {
        username: '13631450151',
        password: '123456'
      }
    },
    created(){
      var vm = this;
      document.onkeydown = function(e) {
        var key = window.event.keyCode;
        if (key == 13) {
          vm.login();
        }
      }
    },
    methods: {
      login() {
        const username = this.username;
        const password = this.password;

        this.$store.dispatch('login', {username, password});
      },
    }
  }
</script>
