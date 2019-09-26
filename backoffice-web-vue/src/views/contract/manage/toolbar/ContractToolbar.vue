<template>
  <div>
  <el-dialog :visible.sync="dialogVisible" width="80%" height="50%" >
    <contract-type />
  </el-dialog>
  <el-form :inline="true">
    <el-form-item label="合同名称">
      <el-input placeholder="合同名称" v-model="keyword"></el-input>
    </el-form-item>
    <el-form-item label="日期">
      <el-date-picker v-model="dateTime" type="daterange" align="right" unlink-panels range-separator=" 至 "
        start-placeholder="开始日期" end-placeholder="结束日期" value-format="yyyy-MM-dd" :picker-options="pickerOptions">
      </el-date-picker>
    </el-form-item>
    <el-form-item label="合同编号">
      <el-input placeholder="输入编号" v-model="orderCode"></el-input>
    </el-form-item>
      <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
      <el-button  native-type="reset" @click="onReset">重置</el-button>
      <el-button type="primary" class="toolbar-search_input" @click="dialogVisible = true">创建合同</el-button>
  </el-form>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import ContractForm from '../ContractForm'
  import ContractType from '../components/ContractType'
  import Bus from '@/common/js/bus.js';

  const {
    mapMutations
  } = createNamespacedHelpers('ContractModule');

  export default {
    name: 'ContractToolbar',
    components: {ContractType},
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setOrderCode: 'orderCode',
        setDateTime:'dateTime',
        setQueryFormData: 'queryFormData',
      }),
      onSearch() {
        this.setKeyword(this.keyword);
        this.setOrderCode(this.orderCode);
        this.setDateTime(this.dateTime);
        this.$emit('onSearch', 0);
      },
      onCreateContract(){
        this.fn.openSlider('创建', ContractForm, '');
      },
      onReset(){
        this.keyword = '';
        this.dateTime = '';
        this.ordercode = '';
      },
    },
    data() {
      return {
        pickerOptions: {
          shortcuts: [{
            text: '最近一周',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '最近一个月',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
              picker.$emit('pick', [start, end]);
            }
          }, {
            text: '最近三个月',
            onClick(picker) {
              const end = new Date();
              const start = new Date();
              start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
              picker.$emit('pick', [start, end]);
            }
          }]
        },
        factories: [],
        brands: [],
        keyword: this.$store.state.ContractModule.keyword,
        orderCode: this.$store.state.ContractModule.orderCode,
        dateTime:this.$store.state.ContractModule.dateTime,
        formData: this.$store.state.ContractModule.formData,
        queryFormData: this.$store.state.ContractModule.queryFormData,
        dialogVisible:false,
      }
    },
    created() {
      Bus.$on('openContractType', args => {
        this.dialogVisible = !this.dialogVisible;
      })
    }
  }

</script>
<style>
  .el-input__inner {
    /* border-radius: 5px; */
    line-height: 30px;
  }

  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

</style>
