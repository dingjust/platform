<template>
  <div class="stock-toolbar">
    <el-form :inline="true">
      <div class="form-container">
        <div>
          <el-form-item label="订单信息">
            <el-input v-model="queryFormData.keyword" placeholder="请输入订单信息"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </div>
        <div>
          <!-- <el-button type="primary" class="toolbar-search_input" @click="onCreate">创建成本单</el-button> -->
        </div>
      </div>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'CostOrderToolbar',
  props: ['queryFormData'],
  methods: {
    onAdvancedSearch () {
      this.$emit('onAdvancedSearch', 0, 10);
    },
    onReset () {
      this.queryFormData.keyword = '';
    },    
    onCreate () {
      this.$router.push('/purchase/cost/create');
    }
  }
}
</script>

<style scoped>
  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .form-container {
    display: flex;
    justify-content: space-between;
    align-items: top;
  }

  .stock-toolbar >>> .el-form-item {
    margin-bottom: 0px;
  }
</style>