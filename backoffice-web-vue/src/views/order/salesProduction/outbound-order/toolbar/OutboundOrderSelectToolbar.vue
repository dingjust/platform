<template>
  <div class="outbount-select-toolbar">
    <el-form :inline="true">
      <el-form-item label="订单信息" prop="name">
        <el-input placeholder="请输入订单号，订单名称" v-model="queryFormData.name"></el-input>
      </el-form-item>
      <el-form-item label="部门/人员" prop="name">
        <dept-person-select ref="deptPersonSelect" :dataQuery="dataQuery" width="170"
                            :selectDept="queryFormData.depts" :selectPerson="queryFormData.users"/>
      </el-form-item>
      <el-form-item label="合作商" prop="name">
        <el-input placeholder="请输入合作商名称" v-model="queryFormData.targetCooperator"></el-input>
      </el-form-item>
      <el-button-group>
        <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
        <el-button native-type="reset" @click="onReset">重置</el-button>
      </el-button-group>
    </el-form>
  </div>
</template>

<script>
import { DeptPersonSelect } from '@/components'
export default {
  name: 'OutboundOrderSelectToolbar',
  components: { DeptPersonSelect },
  props: ['queryFormData', 'dataQuery'],
  methods: {
    onAdvancedSearch () {
      this.$emit('onAdvancedSearch');
    },
    onReset() {
      this.queryFormData.name = '';
      this.queryFormData.merchandiser = '';
      this.queryFormData.targetCooperator = '';
      this.$refs.deptPersonSelect.clearSelectData();
      this.$emit('onReset');
    },
  }
}
</script>

<style scoped>
  .outbount-select-toolbar >>> .el-form-item {
    margin-bottom: 0px;
  }
</style>