<template>
  <el-form :inline="true">
    <el-row type="flex" justify="space-between">
      <el-col :span="12">
        <el-form-item label="签章名称">
          <el-input v-model="keyword" placeholder="输入印章名称"></el-input>
        </el-form-item>
        <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
      </el-col>
      <el-col :span="2">
        <Authorized :permission="['AGREEMENT_SEAL_CREATE_DELETE']">
          <el-button class="create-button" @click="onCreate">新建印章</el-button>
        </Authorized>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import SealForm from '../SealForm'
  import http from '@/common/js/http';

  const {
    mapMutations
  } = createNamespacedHelpers('ContractSealModule');

  export default {
    name: 'SealToolbar',
    components: {},
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword'
      }),
      onSearch () {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onCreate () {
        this.$emit('onCreate');
        // this.$router.push("SealForm");
        // this.fn.openSlider('创建', SealForm, '');
      }
    },
    data () {
      return {
        keyword: this.$store.state.ContractSealModule.keyword
      }
    },
    created () {}
  }
</script>
<style scoped>
  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
    margin-left: 20px;
    color:#000000;
  }

  .create-button {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    width: 100px;
    color: #606266;
  }
</style>
