<template>
  <div>
    <template v-if="!hasPermission">
      <div @click.stop="onCheck">
        <slot></slot>
      </div>
    </template>
    <template v-else>
      <slot></slot>
    </template>
  </div>
</template>

<script>
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
        return false;
      }
    },
    methods: {
      onCheck() {
        this.$message('这是一条消息提示');
        event.stopPropagation();
      }
    },
    data() {
      return {

      }
    },
  }

</script>