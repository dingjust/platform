<template>
  <div>
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <el-col :span="20" style="padding-top: 5px">
          <el-form-item label="订单信息" prop="name">
            <el-input placeholder="请输入订单号，订单名称" v-model="queryFormData.name"></el-input>
          </el-form-item>
          <el-form-item label="负责人" prop="name">
            <el-input placeholder="请输入跟单员姓名" v-model="queryFormData.merchandiser"></el-input>
          </el-form-item>
          <el-form-item label="合作商" prop="name">
            <el-input placeholder="请输入合作商名称" v-model="queryFormData.targetCooperator"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
        <el-col :span="4" v-if="!isSelect">
          <el-row type="flex" justify="end">
            <authorized :permission="['OUT_ORDER_CREATE']">
              <el-button type="primary" class="create-button" @click="createProductOutbound">创建产品外发</el-button>
            </authorized>
            <authorized :permission="['OUT_ORDER_CREATE']">
              <el-button type="primary" class="create-button" @click="createOutboundOrder">创建工单外发</el-button>
            </authorized>
          </el-row>
        </el-col>
      </el-row>
    </el-form>
    <!--    <sales-production-status-bar :queryFormData="queryFormData" :statuses="statuses"/>-->
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapActions,
  } = createNamespacedHelpers(
    'OutboundOrderModule'
  );

  import SalesProductionStatusBar from '../../components/SalesProductionStatusBar';
  export default {
    name: 'OutboundOrderToolbar',
    props: {
      queryFormData: {
        type: Object
      },
      isSelect: {
        type: Boolean,
        default: false
      }
    },
    components: {
      SalesProductionStatusBar
    },
    computed: {},
    methods: {
      onAdvancedSearch() {
        this.$emit('onAdvancedSearch');
      },
      onReset() {
        this.queryFormData.name = '';
        this.queryFormData.merchandiser = '';
        this.queryFormData.targetCooperator = '';
      },
      createOutboundOrder() {
        this.$emit('createOutboundOrder');
      },
      //产品外发
      createProductOutbound(){
        this.$emit('createProductOutbound');
      }
    },
    data() {
      return {
        // queryFormData: this.$store.state.OutboundOrderModule.queryFormData
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
    width: 100px;
    height: 40px;
    color: #606266;
  }

  /deep/ .el-form-item {
    margin-bottom: 5px;
  }

</style>
