<template>
  <div>
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <el-col :span="24">
          <el-form-item label="订单信息" class="toolbar-form-item">
            <el-input placeholder="输入订单号、产品名或货号" v-model="queryFormData.keyword"></el-input>
          </el-form-item>
          <el-form-item label="采购员" prop="name" class="toolbar-form-item">
            <dept-person-select ref="deptPersonSelect" :dataQuery="dataQuery" width="130"
                                :selectDept="queryFormData.depts" :selectPerson="queryFormData.users"/>
          </el-form-item>
          <el-form-item label="供应商" class="toolbar-form-item">
            <el-input placeholder="输入供应商名称" v-model="queryFormData.cooperatorName" style="width: 130px"></el-input>
          </el-form-item>
          <el-form-item label="创建时间" class="toolbar-form-item">
            <el-date-picker v-model="dateArr"
                        style="width: 215px"
                        type="daterange" 
                        value-format="timestamp"
                        range-separator="至" 
                        start-placeholder="开始日期" 
                        end-placeholder="结束日期">
            </el-date-picker>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import { DeptPersonSelect } from '@/components'

  export default {
    name: 'PurchaseOrderToolbar',
    props: ['queryFormData', 'dataQuery'],
    components: {
      DeptPersonSelect
    },
    computed: {

    },
    methods: {
      onAdvancedSearch () {
        this.$emit('onAdvancedSearch', 0 , 10);
      },
      onReset () {
        this.dateArr = [];
        this.queryFormData.keyword = '';
        this.queryFormData.cooperatorName = '';
        this.queryFormData.creationtimeFrom = '';
        this.queryFormData.creationtimeTo = '';
        this.$refs.deptPersonSelect.clearSelectData();
        this.$emit('onResetQuery');
      }
    },
    data () {
      return {
        dateArr: []
      }
    },
    watch: {
      dateArr: function (nval, oval) {
        if (nval.length > 0) {
          this.queryFormData.creationtimeFrom = nval[0];
          this.queryFormData.creationtimeTo = nval[1];
        } else {
          this.queryFormData.creationtimeFrom = '';
          this.queryFormData.creationtimeTo = '';
        }
      }
    },
    create () {
      
    }
  }
</script>

<style scoped>
  .create-button {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    width: 100px;
    height: 40px;
    color: #606266;
  }

  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .toolbar-form-item {
    margin-bottom: 0px;
  }

  /deep/.el-date-editor .el-range-separator {
    width: 12%;
  }
</style>