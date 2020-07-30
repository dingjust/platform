<template>
  <div>
    <template v-if="!hasPermission">
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
    check
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
      hasPermission: function () {
        return check(this.permission);
      }
    },
    methods: {
      onCheck() {
        event.stopPropagation();
        this.$message('没有权限操作');
      }
    },
    data() {
      return {

      }
    },
  }

</script>
