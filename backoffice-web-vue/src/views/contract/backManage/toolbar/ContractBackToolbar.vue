<template>
  <div class="contract-back-toolbar">
    <el-form :inline="true">
      <el-form-item label="合同信息">
        <el-input v-model="queryFormData.title" placeholder="输入合同名称、编号、单号、合作商"></el-input>
      </el-form-item>
      <el-form-item label="日期">
        <el-date-picker v-model="dateArr" 
          style="width: 250px"
          type="daterange" 
          value-format="timestamp"
          range-separator="至" 
          start-placeholder="开始日期" 
          end-placeholder="结束日期"
          :picker-options="pickerOptions">
        </el-date-picker>
      </el-form-item>
      <el-form-item label="合同类型">
        <el-select v-model="queryFormData.type" clearable placeholder="选择合同类型">
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
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'ContractBackToolbar',
  props: ['queryFormData'],
  data () {
    return {
      dateArr: [],
      TemplateType: [
        {
          code: 'BCXY',
          name: '补充协议'
        }, {
          code: 'WTSCHT',
          name: '委托生产合同'
        }, {
          code: 'CGDD',
          name: '采购订单'
        }, {
          code: 'KJXY',
          name: '框架协议'
        }, {
          code: 'ZFXY',
          name: '作废协议'
        }
      ],
      pickerOptions: {
        shortcuts: [{
          text: '最近一周',
          onClick (picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
            picker.$emit('pick', [start, end]);
          }
        }, {
          text: '最近一个月',
          onClick (picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
            picker.$emit('pick', [start, end]);
          }
        }, {
          text: '最近三个月',
          onClick (picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
            picker.$emit('pick', [start, end]);
          }
        }]
      },
    }
  },
  methods: {
    onSearch () {
      this.$emit('onAdvancedSearch', 0, 10);
    },
    onReset () {
      this.queryFormData.title = '';
      this.queryFormData.type = '';
      this.dateArr = [];
    }
  },
  watch: {
    dateArr: function (nval, oval) {
      if (nval.length > 0) {
        this.queryFormData.creationtimeStart = nval[0];
        this.queryFormData.creationtimeEnd = nval[1];
      } else {
        this.queryFormData.creationtimeStart = '';
        this.queryFormData.creationtimeEnd = '';
      }
    }
  },  
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