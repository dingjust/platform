<script>
import { mapGetters } from 'vuex'
function fillz(d) {
  return d < 10 ? `0${d}` : d
}

export default {
  name: 'message',
  filters: {
    // 将日期过滤为 hour:minutes
    time(date) {
      if (typeof date === 'string') {
        date = new Date(date)
      }
      return `${fillz(date.getHours())} : ${fillz(date.getMinutes())} : ${fillz(date.getSeconds())}`
    }
  },

  directives: {
    scrollBottom: {
      update(el) {
        setTimeout(() => { el.scrollTop = el.scrollHeight }, 100)
      }
    }
  },

  computed: {
    ...mapGetters('webchat', ['user', 'sessionWho'])
  },

  methods: {
    parseContent(data) {
      return String(data).replace(/\n/g, '<br/>')
    }
  }
}
</script>

<template>
<div class="message" v-scroll-bottom="sessionWho.messages" data-7694f680>
  <ul v-if="sessionWho">
    <li v-for="item in sessionWho.messages" :key="item.id">
      <p class="time">
        <span>{{ item.date | time }}</span>
      </p>
      <div class="msg-content" :class="{ self: item.self }">
        <img class="avatar" width="30" height="30" :src="item.self ? user.img : sessionWho.user.img" />
        <div class="text font-text" v-html="parseContent(item.content)"></div>
      </div>
    </li>
  </ul>
</div>
</template>

<style lang="scss">
.web-chat-app[data-f42d2346wb] {
  .message[data-7694f680] {
    padding: 10px 15px;
    overflow-y: scroll;

    li {
      margin-bottom: 15px;
    }
    .time {
      margin: 7px 0;
      text-align: center;

      > span {
        display: inline-block;
        padding: 0 18px;
        font-size: 12px;
        color: #fff;
        border-radius: 2px;
        background-color: #dcdcdc;
      }
    }
    .avatar {
      float: left;
      margin: 0 10px 0 0;
      border-radius: 3px;
    }
    .text {
      display: inline-block;
      position: relative;
      padding: 0 10px;
      max-width: calc(100% - 80px);
      min-height: 30px;
      line-height: 2;
      text-align: left;
      word-break: break-all;
      background-color: #fafafa;
      border-radius: 4px;

      &:before {
        content: " ";
        position: absolute;
        top: 9px;
        right: 100%;
        border: 6px solid transparent;
        border-right-color: #fafafa;
      }
    }

    .self {
      text-align: right;

      .avatar {
        float: right;
        margin: 0 0 0 10px;
      }
      .text {
        background-color: #b2e281;

        &:before {
          right: inherit;
          left: 100%;
          border-right-color: transparent;
          border-left-color: #b2e281;
        }
      }
    }
  }
}
</style>
