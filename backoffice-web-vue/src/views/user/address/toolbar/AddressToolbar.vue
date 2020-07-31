<template>
  <el-form :inline="true">
    <el-button-group>
      <Authorized :permission="['COMPANY_ADDRESS_CREATE']">
        <el-button type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
      </Authorized>
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
