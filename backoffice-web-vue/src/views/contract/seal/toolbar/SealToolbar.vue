<template>
  <el-form :inline="true">
    <el-row type="flex" justify="space-between">
      <el-col :span="8">
        <el-button-group>
          <el-button @click="onCreate">新建印章</el-button>
          <el-button>管理设置</el-button>
        </el-button-group>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" justify="space-between">
          <el-input v-model="keyword" placeholder="输入名称"></el-input>
          <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
        </el-row>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapMutations
  } = createNamespacedHelpers('ContractSealModule');

  export default {
    name: 'SealToolbar',
    components: {},
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
      }),
      onSearch() {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onCreate() {
        this.$router.push("sealForm");
      }
    },
    data() {
      return {
        keyword: this.$store.state.ContractSealModule.keyword,
      }
    },
    created() {}
  }

</script>
<style>
  .el-input__inner {
    /* border-radius: 5px; */
    line-height: 30px;
  }

  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
    margin-left: 20px;
  }

</style>
