<template>
  <div>
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <el-col :span="24">
          <el-form-item label="订单信息">
            <el-input placeholder="输入订单号、产品名或货号" v-model="queryFormData.keyword" style="width: 130px"></el-input>
          </el-form-item>
          <!-- <el-form-item label="负责人">
            <el-input placeholder="输入负责人名称" v-model="queryFormData.merchandiserName" style="width: 120px"></el-input>
          </el-form-item> -->
          <el-form-item label="部门/人员" prop="name">
            <dept-person-select ref="deptPersonSelect" :dataQuery="dataQuery" width="120"
                                :selectDept="queryFormData.depts" :selectPerson="queryFormData.users"/>
          </el-form-item>
          <el-form-item label="合作商">
            <el-input placeholder="输入合作商名称" v-model="queryFormData.cooperatorName" style="width: 120px"></el-input>
          </el-form-item>
          <el-form-item label="创建时间">
            <el-date-picker
              v-model="dateArr"
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
    name: 'ShippingOrdersToolbar',
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
        this.dateArr = null;
        this.queryFormData.keyword = '';
        this.queryFormData.cooperatorName = '';
        this.queryFormData.merchandiserName = '';
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
      dateArr: function (newVal, oldVal) {
        if (newVal == null) {
          this.queryFormData.createdDateFrom = '';
          this.queryFormData.createdDateTo = '';
        } else {
          this.queryFormData.createdDateFrom = newVal[0];
          this.queryFormData.createdDateTo = newVal[1];
        }
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
  }

  /deep/ .el-date-editor .el-range-separator {
    width: 12%;
  }
</style>