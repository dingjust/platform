<template>
  <div class="temp-toolbar">
    <el-form :inline="true">
      <div class="temp-top-row">
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
        <div>
          <el-button type="primary" @click="tempVisible = true">添加模板</el-button>
        </div>
      </div>
    </el-form>
    <el-dialog title="创建模板" :visible.sync="tempVisible" width="80%" append-to-body
      :close-on-click-modal="false">
      <contract-back-temp-form v-if="tempVisible" :detail="form" :isCreate="true" @callback="callback"/>
    </el-dialog>
  </div>
</template>

<script>
import ContractBackTempForm from '../form/ContractBackTempForm'

export default {
  name: 'ContractBackTempToolbar',
  components: { ContractBackTempForm },
  props: ['queryFormData'],
  methods: {
    onSearch () {
      this.$emit('onSearch', 0);
    },
    onReset () {
      this.queryFormData.title = '';
      this.queryFormData.type = '';
    },
    callback () {
      this.$emit('onSearch');
    }
  },
  data () {
    return {
      tempVisible: false,
      form: {
        title: '',
        code: '',
        header: '',
        content: '',
        type: '',
        available: true
      },
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

  .temp-top-row {
    display: flex;
    justify-content: space-between;
    align-items: top;
  }
</style>