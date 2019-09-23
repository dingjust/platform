<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="输入账务方案名称查询" v-model="queryFormData.keyword"  class="cooperator-toolbar-input"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
      <el-button native-type="reset" @click="queryFormData.keyword=''">重置</el-button>
    </el-button-group>
  </el-form>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters} = createNamespacedHelpers('PayPlanModule');

  export default {
    name: 'PayPlanToolbar',
    components: {},
    computed: {
      ...mapGetters({
        queryFormData: 'queryFormData'
      })

    },
    methods: {
      onSearch () {
        this.$emit('onSearch');
      }
    },
    data () {
      return {
        formData: this.$store.state.AddressesModule.formData
      }
    }
  }
</script>
