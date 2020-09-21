<template>
  <div>
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <el-col :span="22">
          <el-form-item label="订单信息" class="toolbar-form-item">
            <el-input placeholder="输入订单号、产品名或货号" v-model="queryFormData.keyword"></el-input>
          </el-form-item>
          <!-- <el-form-item label="部门/人员" prop="name" class="toolbar-form-item">
            <dept-person-select ref="deptPersonSelect" :dataQuery="dataQuery"
                                :selectDept="queryFormData.depts" :selectPerson="queryFormData.users"/>
          </el-form-item> -->
          <el-form-item label="合作商" class="toolbar-form-item">
            <el-input placeholder="输入合作商名称" v-model="queryFormData.operatorName"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
        <el-col :span="2">
          <el-button type="primary" class="create-button" @click="onCreate">创建采购需求</el-button>
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
        this.queryFormData.productionLeaderName = '';
        this.queryFormData.operatorName = '';
        this.queryFormData.creationtimeStart = '';
        this.queryFormData.creationtimeEnd = '';
        // this.$refs.deptPersonSelect.clearSelectData();
        // this.$emit('onResetQuery');
      },
      onCreate () {
        this.$emit('onCreate');
      }
    },
    data () {
      return {
      }
    },
    watch: {
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
</style>