<template>
  <div class="b2bCustomer-toolbar">
    <el-form :inline="true">
      <el-form-item label="">
        <template slot="label">
          <h6 class="formLabel">姓名</h6>
        </template>
        <el-input placeholder="请输入员工姓名" v-model="keyword" style="width: 150px"></el-input>
      </el-form-item>
      <el-form-item label="">
        <template slot="label">
          <h6 class="formLabel">角色</h6>
        </template>
        <el-input placeholder="请输入角色" v-model="b2bRoleGroup" style="width: 150px"></el-input>
      </el-form-item>
      <el-button style="background-color: #FFD60C" @click="onSearch" size="mini">搜索</el-button>
      <el-button @click="onReset" size="mini">重置</el-button>
      <el-button style="background-color: #FFD60C" @click="onInvite" size="mini">邀请员工</el-button>
      <el-button style="background-color: #FFD60C" @click="onNew" size="mini">添加员工</el-button>
    </el-form>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapMutations} = createNamespacedHelpers('B2BCustomersModule');

  export default {
    name: 'B2BCustomerToolbar',
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
      onNew () {
        let formData = {
          uid: '',
          name: '',
          roleList: [],
          b2bDept: '',
          b2bRoleGroup: '',
          b2bRoleList: []
        };
        // Object.assign(formData, this.formData);
        this.$emit('onNew', formData);
      },
      onReset () {
        this.keyword = '';
        this.name = '';
        this.role = '';
      },
      onInvite () {
        this.$emit('onInvite');
      }
    },
    data () {
      return {
        keyword: '',
        name: '',
        b2bRoleGroup: '',
        formData: this.$store.state.B2BCustomersModule.formData,
        categories: []
      }
    }
  }
</script>
<style scoped>
  .b2bCustomer-toolbar .formLabel {
    font-size: 12px;display: inline-block;
  }
  .el-button {
    margin-top: 2px;
  }
</style>
