<script>
import { mapActions } from 'vuex'

export default {
  name: 'ChatText',
  data() {
    return {
      content: '',
      sendmode: 'ctrls',
      placeholder: '按 Ctrl + Enter 发送'
    }
  },
  methods: {
    ...mapActions('webchat', ['sendMessage']),

    onKeyup(e) {
      if (this.sendmode === 'ctrls' && e.ctrlKey && e.keyCode === 13) {
        this.sendMSG()
      } else if (this.sendmode === 'enter' && e.keyCode === 13) {
        this.sendMSG()
      }
    },
    sendMSG() {
      if (this.content.length) {
        this.sendMessage(this.content)
        this.content = ''
      }
    }
  }
}
</script>

<template>
<div class="sending-text" data-atx31t34>
  <textarea class="font-text" :placeholder="placeholder" v-model="content" @keyup="onKeyup"></textarea>
</div>
</template>

<style lang="scss">
.web-chat-app[data-f42d2346wb] {
  .sending-text[data-atx31t34] {
    height: 130px;
    border-top: solid 1px #ddd;

    textarea {
      padding: 0 20px;
      height: 100%;
      width: 100%;
      border: none;
      outline: none;
      font-family: "Micrsofot Yahei";
      resize: none;
      box-sizing: border-box;
    }
  }
}
</style>
