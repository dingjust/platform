<template>
  <div class="temp-toolbar">
    <el-form :inline="true">
      <el-row type="flex" align="top">
        <el-form-item>
          <el-input v-model="queryFormData.keyword" placeholder="请输入模板名称"></el-input>
        </el-form-item>
        <el-form-item label="模板类型">
          <el-select v-model="queryFormData.type" clearable placeholder="选择模板类型">
            <el-option
              v-for="item in TemplateType"
              :key="item.value"
              :label="item.name"
              :value="item.code">
            </el-option>
          </el-select>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
          <el-button native-type="reset" @click="onReset">重置</el-button>
        </el-button-group>
      </el-row>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'ContractBackTempToolbar',
  props: ['queryFormData'],
  methods: {
    onSearch () {
      this.$emit('onSearch', 0);
    },
    onReset () {
      this.queryFormData.title = '';
      this.queryFormData.type = '';
    }
  },
  data () {
    return {
      TemplateType: [{
          code: 'BCXY',
          name: '补充协议'
        },
        {
          code: 'WTSCHT',
          name: '委托生产合同'
        },
        {
          code: 'CGDD',
          name: '采购订单'
        },
        {
          code: 'KJXY',
          name: '框架协议'
        },
        {
          code: 'ZFXY',
          name: '作废协议'
        }
      ],
    }
  }
}
</script>

<style scoped>
  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
  
  .contract-back-toolbar >>> .el-date-editor .el-range-separator {
    width: 8%;
  }

  .contract-back-toolbar >>> .el-form-item {
    margin-bottom: 0px;
  }
</style>