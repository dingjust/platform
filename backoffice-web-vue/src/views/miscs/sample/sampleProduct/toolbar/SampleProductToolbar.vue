<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入样衣编号" v-model="keyword"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
      <el-button type="primary" icon="el-icon-plus" @click="onNew">创建样衣</el-button>
    </el-button-group>
  </el-form>
</template>

<script>

  export default {
    name: 'SampleProductToolbar',
    props: [],
    mixins: [],
    components: {
    },
    computed: {},
    methods: {
      onSearch() {
        this.$emit('onSearch',this.keyword, 0);
      },
      onAdvancedSearch() {
        this.$emit('onAdvancedSearch', 0);
      },
      onNew() {
        let formData = {};
        this.$emit('onNew', formData);
      }
    },
    data() {
      return {
        keyword: this.$store.state.SampleProductModule.keyword,
        formData: this.$store.state.SampleProductModule.formData,
      }
    }
  }
</script>
