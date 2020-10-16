<template>
  <div>
    <el-form :inline="true">
      <el-row type="flex" justify="space-between" align="top">
        <el-col :span="22">
          <el-form-item label="订单信息" class="toolbar-form-item">
            <el-input placeholder="输入订单号、产品名或货号" v-model="queryFormData.keyword" style="width: 130px"></el-input>
          </el-form-item>
          <el-form-item label="创建人" class="toolbar-form-item">
            <dept-person-select ref="deptPersonSelect1" :dataQuery="dataQuery" width="120"
                                :selectDept="queryFormData.ctrDepts" :selectPerson="queryFormData.ctrUsers"/>
          </el-form-item>
          <el-form-item label="采购员" class="toolbar-form-item">
            <dept-person-select ref="deptPersonSelect2" :dataQuery="dataQuery" width="120"
                                :selectDept="queryFormData.depts" :selectPerson="queryFormData.users"/>
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
        <el-col :span="2">
          <authorized :permission="['PURCHASE_TASK_CREATE']">
            <el-button type="primary" class="create-button" @click="onCreate">创建采购需求</el-button>
          </authorized>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import { DeptPersonSelect } from '@/components'

  export default {
    name: 'PurchaseRequirementToolbar',
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
        this.queryFormData.creator = '';
        this.queryFormData.createdDateFrom = '';
        this.queryFormData.createdDateTo = '';
        this.$refs.deptPersonSelect1.clearSelectData();
        this.$refs.deptPersonSelect2.clearSelectData();
        this.$emit('onResetQuery');
      },
      onCreate () {
        this.$router.push('/purchase/requirement/create');
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
          this.queryFormData.createdDateFrom = nval[0];
          this.queryFormData.createdDateTo = nval[1];
        } else {
          this.queryFormData.createdDateFrom = '';
          this.queryFormData.createdDateTo = '';
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