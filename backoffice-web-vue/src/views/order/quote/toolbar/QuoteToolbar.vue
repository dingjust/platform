<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入报价单号" v-model="keyword"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
    </el-button-group>
  </el-form>
</template>

<script>
  export default {
    name: 'QuoteToolbar',
    components: {},
    computed: {},
    methods: {
      onSearch() {
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch() {
        this.$emit('onAdvancedSearch', 0);
      },
      onNew() {
        let formData = {};
        Object.assign(formData, this.formData);

        this.$emit('onNew', formData);
      },
    },
    data() {
      return {
        keyword: this.$store.state.QuotesModule.keyword,
        formData: this.$store.state.QuotesModule.formData,
      }
    }
  }
</script>
