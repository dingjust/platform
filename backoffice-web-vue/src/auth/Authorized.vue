<template>
  <div class="authorized-box">
    <template v-if="!hasPer">
      <div @click.capture="onCheck">
        <slot></slot>
      </div>
    </template>
    <template v-else>
      <slot></slot>
    </template>
  </div>
</template>

<script>
  import {
    hasPermission
  } from "./auth";

  export default {
    name: 'Authorized',
    props: {
      permission: {
        type: Array,
        default: () => {
          return [];
        }
      }
    },
    computed: {
      hasPer: function () {
        return hasPermission(this.permission);
      }
    },
    methods: {
      onCheck() {
        //如果提供了事件对象，则这是一个非IE浏览器 
        if (event && event.stopPropagation) {
          //因此它支持W3C的stopPropagation()方法 
          event.stopPropagation();
        } else {
          //否则，我们需要使用IE的方式来取消事件冒泡 
          window.event.cancelBubble = true;
        }

        this.$message('没有权限操作');
      }
    },
    data() {
      return {

      }
    },
  }

</script>
<style>
  .authorized-box {
    display: inline-block;
  }

  .authorized-box+.authorized-box {
    margin-left: 10px;
  }

  .el-button+.authorized-box {
    margin-left: 10px;
  }

  .authorized-box+.el-button {
    margin-left: 10px;
  }

</style>
