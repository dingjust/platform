import Vue from 'vue'
import WebChat from './main.vue'

export default {
  data() {
    return {
      instanceChat: null
    }
  },
  methods: {
    initInstanceChat() {
      const WebChatConstructor = Vue.extend(WebChat)
      this.instanceChat = new WebChatConstructor({
        el: document.createElement('div'),
        store: this.$store
      })
    },
    WebChat(options = {}) {
      if (!this.instance) {
        this.initInstanceChat()
      }

      if (!this.instanceChat.visible) {
        for (let prop in options) {
          if (options.hasOwnProperty(prop)) {
            this.instanceChat[prop] = options[prop]
          }
        }
        document.body.appendChild(this.instanceChat.$el)
      }
    },

    openChat() {
      if (this.instanceChat) {
        this.instanceChat.doOpen()
      } else {
        this.WebChat()
      }
      this.instanceChat.visible = true
    },

    closeChat() {
      if (this.instanceChat) {
        this.instanceChat.doClose()
        this.instanceChat.visible = false
      }
    }
  }
}
