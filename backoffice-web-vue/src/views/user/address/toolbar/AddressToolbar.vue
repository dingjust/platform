<template>
  <el-form :inline="true">
    <el-button-group>
      <el-button type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
    </el-button-group>
  </el-form>
</template>

<script>
  export default {
    name: 'AddressToolbar',
    components: {},
    computed: {},
    methods: {
      onNew() {
        let formData = {};
        Object.assign(formData, this.formData);

        this.$emit('onNew', formData);
      },
    },
    data() {
      return {
        formData: this.$store.state.AddressesModule.formData
      }
    }
  }
</script>
