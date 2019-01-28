<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  computed: {
    ...mapGetters('webchat', ['sessions', 'currentId'])
  },
  methods: {
    ...mapActions('webchat', ['selectSession'])
  }
}
</script>

<template>
<div class="list" data-list3912xe>
  <ul>
    <li
      v-for="item in sessions"
      :class="{ active: item.id === currentId }"
      @click="selectSession(item.id)" :key="item.id">
        <img class="avatar"  width="30" height="30" :alt="item.user.name" :src="item.user.img">
        <p class="name">{{item.user.name}}</p>
    </li>
  </ul>
</div>
</template>

<style lang="scss">
.web-chat-app[data-f42d2346wb] {
  .list[data-list3912xe] {
    overflow-y: scroll;
    height: 82%;
    width: calc(100% + 30px);

    li {
      padding: 12px 15px;
      border-bottom: 1px solid #292c33;
      cursor: pointer;
      transition: background-color 0.1s;
      &:hover {
        background-color: rgba(255, 255, 255, 0.03);
      }
      &.active {
        background-color: rgba(255, 255, 255, 0.1);
      }
    }
    .avatar,
    .name {
      vertical-align: middle;
    }
    .avatar {
      border-radius: 2px;
    }
    .name {
      display: inline-block;
      margin: 0 0 0 15px;
    }
  }
}
</style>
