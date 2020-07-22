<template>
  <div class="personnel-toolbar-container">
    <el-form :inline="true">
      <el-row type="flex" justify="start">
        <el-col :span="22">
          <el-form-item label="员工信息">
            <el-input placeholder="输入员工信息" v-model="queryFormData.keyword"></el-input>
          </el-form-item>
          <!-- <el-form-item label="部门">
            <el-input placeholder="输入部门名称" v-model="queryFormData.deptName"></el-input>
          </el-form-item> -->
          <el-form-item label="角色">
            <el-input placeholder="输入角色名称" v-model="queryFormData.roleGroupName"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
        <!-- <el-col :span="2">
          <el-button class="material-btn" @click="onCreate">创建员工</el-button>
        </el-col> -->
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'OrganizationToolbar',
    props: ['queryFormData'],
    components: {

    },
    computed: {

    },
    methods: {
      onAdvancedSearch () {
        this.$emit('onAdvancedSearch', 0 , 10);
      },
      onReset () {
        this.queryFormData.keyword = '';
        // this.queryFormData.deptName = '';
        this.queryFormData.roleGroupName = '';
      },
      onCreate () {
        this.$emit('onCreate');
      }
    },
    data () {
      return {
      }
    },
    create () {
      
    }
  }
</script>

<style scoped>
  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
  
  .material-btn {
    background-color: #ffd60c;
    color: #606266
  }

  /* .personnel-toolbar-container >>> .el-form-item {
    margin-bottom: 0px;
  } */

</style>