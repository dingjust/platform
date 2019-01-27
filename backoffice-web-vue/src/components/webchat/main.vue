<script>
import ChatStore from './store'
import Card from './card'
import List from './list'
import ChatText from './text'
import Message from './message'
import { mapGetters, mapActions } from 'vuex'

const SEND_TEXT_CTRLS = '按 Ctrl + Enter 发送'
const SEND_TEXT_ENTER = '按 Enter 发送'

export default {
  name: 'WebChat',
  components: { Card, List, ChatText, Message },
  data() {
    return {
      fontSize: 12,
      visible: false,
      mini: false,
      sendctrls: SEND_TEXT_CTRLS,
      sendenter: SEND_TEXT_ENTER
    }
  },
  computed: {
    ...mapGetters('webchat', ['user', 'sessionWho'])
  },
  methods: {
    ...mapActions('webchat', ['initData']),
    doOpen() {
      this.mini = false
      this.visible = true
    },
    doClose() {
      this.visible = false
      this.mini = false
    },
    minimize() {
      this.visible = false
      this.mini = true
    },
    maximize() {
      this.mini = false
      this.visible = true
    },
    sendMessage() {
      if (this.$refs.stext) {
        this.$refs.stext.sendMSG()
      }
    },
    clickCommand(cmd) {
      if (this.$refs.stext) {
        this.$refs.stext.sendmode = cmd
        this.$refs.stext.placeholder = cmd === 'ctrls' ? SEND_TEXT_CTRLS : SEND_TEXT_ENTER
      }
    }
  },
  mounted() {
    if (!this.$store) {
      throw new Error('chat app need vuex import')
    }
    this.$store.registerModule('webchat', ChatStore)
    this.initData()
  }
}
</script>

<template>
<transition>
  <div v-if="visible" class="web-chat-app" data-f42d2346wb>
    <div class="sidebar">
      <card></card>
      <list></list>
    </div>
    <div :class="['main', `ft${fontSize}`]">
      <div class="win-top">
        <span class="with-who">{{sessionWho.user.name}}</span>
        <i class="el-icon-minus" @click="minimize"></i>
        <i class="el-icon-close" @click="doClose"></i>
      </div>
      <message></message>
      <chat-text ref="stext"></chat-text>
      <div class="operation">
        <el-select v-model="fontSize" placeholder="字体" size="mini">
          <el-option
            v-for="item in [12, 14, 16, 18]"
            :key="item"
            :label="`${item}号字体`"
            :value="item">
          </el-option>
        </el-select>
        <el-dropdown
          @click="sendMessage"
          @command="clickCommand"
          size="mini"
          type="primary"
          trigger="click"
          split-button>发送
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item command="ctrls">{{sendctrls}}</el-dropdown-item>
            <el-dropdown-item command="enter">{{sendenter}}</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </div>
    </div>
  </div>
  <div class="web-chat-mini" v-if="!visible && mini" @click="maximize" data-f42d2346wb>
    <img class="avatar" :title="user.name" :src="user.img">
    <span class="name">{{user.name}}</span>
  </div>
</transition>
</template>
<style lang="scss">
.web-chat-mini[data-f42d2346wb] {
  position: fixed;
  right: 20px;
  bottom: 60px;
  display: flex;
  align-items: center;
  padding: 2px 5px;
  height: 28px;
  color: #ccc;
  font-size: 14px;
  cursor: pointer;
  z-index: 999;
  background-color: #464646;
  box-shadow: 1px 1px 1px 1px rgba(0,0,0,0.3);

  img {
    width: 24px;
    height: 24px;
    margin-right: 10px;
  }
}

.web-chat-app[data-f42d2346wb] {
  position: fixed;
  width: 800px;
  height: 600px;
  top: calc((100% - 600px)/2);
  left: calc((100% - 800px)/2);
  border-radius: 3px;
  box-shadow: 0px 1px 30px 3px rgba(0,0,0,0.3);
  overflow: hidden;

  .el-dropdown__caret-button {
    height: 28px;
  }

  ul{
    padding: 0;
  }

  li{
    list-style: none;
    text-align: left;
  }

  .ft12 .font-text {
    font-size: 12px;
  }
  .ft14 .font-text {
    font-size: 14px;
  }
  .ft16 .font-text {
    font-size: 16px;
  }
  .ft18 .font-text {
    font-size: 18px;
  }

  .win-top {
    height: 30px;
    line-height: 30px;
    text-align: right;
    border-bottom: 1px solid #ddd;

    .with-who {
      float: left;
      margin-left: 20px;
    }

    i {
      font-size: 16px;
      font-weight: bold;
      margin-right: 5px;
      cursor: pointer;
      color: #666;
    }
    i:hover{
      color: #000;
    }
  }

  .sidebar,
  .main {
    height: 100%;
  }
  .sidebar {
    position: absolute;
    top: 0px;
    left: 0;
    width: 200px;
    color: #f4f4f4;
    background-color: #2e3238;
    overflow: hidden;
    z-index: 1;
  }
  .main {
    position: relative;
    overflow: hidden;
    background-color: #eee;
    margin-left: 200px;
  }
  .sending-text, .operation{
    position: absolute;
    width: 100%;
    left: 0;
  }
  .sending-text{
    bottom: 30px;
    padding-top: 10px;
    box-sizing: border-box;
    background-color: white;
  }
  .operation {
    background-color: white;
    text-align: right;
    height: 30px;
    bottom: 0px;
    padding-right: 10px;
    box-sizing: border-box;

    .el-select {
      width: 100px;
      margin-right: 5px;
    }
  }
  .message {
    height: calc(100% - 210px);
  }
}
</style>
