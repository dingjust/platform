<template>
  <div class="outbound-order-toolbar">
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <div>
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
        </div>
        <div v-if="!isSelect">
          <el-row type="flex" justify="end">
            <authorized :permission="['CLOTHES_OUT_ORDER_CREATE']">
              <el-button type="primary" class="create-button" @click="createProductOutbound">创建产品外发</el-button>
            </authorized>
            <authorized :permission="['OUT_ORDER_CREATE']">
              <el-button type="primary" class="create-button" @click="createOutboundOrder">创建工单外发</el-button>
            </authorized>
            <authorized :permission="['OUT_ORDER_CREATE']">
              <el-button type="primary" @click="importVisible = true">唯一码导入</el-button>
            </authorized>
          </el-row>
        </div>
      </el-row>
    </el-form>
    <el-dialog title="唯一码导入" :visible.sync="importVisible" width="80%" :close-on-click-modal="false" :close-on-press-escape="false">
      <outbound-import v-if="importVisible" @closeDialog="importVisible = false"/>
    </el-dialog>
  </div>
</template>

<script>
import OutboundImport from '../components/OutboundImport'
import { DeptPersonSelect } from '@/components'
export default {
  name: 'OutboundOrderToolbar',
  props: {
    queryFormData: {
      type: Object
    },
    isSelect: {
      type: Boolean,
      default: false
    },
    dataQuery: {
      type: Object
    }
  },
  components: {
    DeptPersonSelect,
    OutboundImport
  },
  methods: {
    onAdvancedSearch() {
      this.$emit('onAdvancedSearch');
    },
    onReset() {
      this.queryFormData.name = '';
      this.queryFormData.merchandiser = '';
      this.queryFormData.targetCooperator = '';
      this.$refs.deptPersonSelect.clearSelectData();
      this.$emit('onResetQuery');
    },
    // 工单外发
    createOutboundOrder() {
      this.$emit('createOutboundOrder');
    },
    //产品外发
    createProductOutbound(){
      this.$emit('createProductOutbound');
    }
  },
  data () {
    return {
      importVisible: false
    }
  }
}
</script>

<style scoped>
  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .create-button {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    color: #606266;
  }

  .outbound-order-toolbar >>> .el-form-item {
    margin-bottom: 5px;
  }

  .outbound-order-toolbar >>> .el-dialog__body {
    padding: 10px 20px!important;
  }
</style>
