<template>
  <el-form :inline="true">
    <el-form-item label="物料名">
      <el-input placeholder="请输入物料名" v-model="queryFormData.name"></el-input>
    </el-form-item>
    <el-form-item label="物料编号">
      <el-input placeholder="请输入物料编号" v-model="queryFormData.code"></el-input>
    </el-form-item>
    <el-form-item label="物料类型">
      <el-select v-model="queryFormData.materialsType" placeholder="请选择">
        <el-option
          v-for="item in materialsType"
          :key="item.code"
          :label="item.name"
          :value="item.code">
        </el-option>
      </el-select>
    </el-form-item>
    <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
    <el-button native-type="reset" @click="onReset">重置</el-button>
    <el-button class="material-btn" @click="onNew">添加物料</el-button>
  </el-form>
</template>

<script>
  export default {
    name: 'MaterialToolbar',
    methods: {
      onNew() {
        this.$emit('onNew');
      },
      onSearch () {
        this.$emit('onSearch');
      },
      onReset () {
        this.queryFormData.name = '';
        this.queryFormData.code = '';
        this.queryFormData.materialsType = '';
      }
    },
    data () {
      return {
        queryFormData: this.$store.state.MaterialModule.queryFormData,
        materialsType: this.$store.state.EnumsModule.MaterialsType
      }
    }
  }
</script>

<style scoped>
  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .material-btn {
    background-color: #ffd60c;
  }
</style>
