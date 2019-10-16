<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="输入合作商名称/联系人/联系方式" v-model="queryFormData.keyword"  class="cooperator-toolbar-input"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
      <el-button native-type="reset" @click="queryFormData.keyword=''">重置</el-button>
    </el-button-group>
  </el-form>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  const {mapGetters} = createNamespacedHelpers('CooperatorModule');

  export default {
    name: 'CooperatorToolBar',
    props: [],
    computed: {
      ...mapGetters({
        queryFormData: 'queryFormData'
      })
    },
    methods: {
      onSearch (page, size) {
        this.$emit('onSearch', 0);
      }
    },
    data () {
      return {
      };
    }
  }
</script>

<style scoped>
  .cooperator-toolbar-input{
    width: 240px;
  }
</style>
