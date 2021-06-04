<template>
  <div class="contract-toolbar-container">
    <!-- <el-dialog :visible.sync="dialogVisible" width="80%" height="50%" class="purchase-dialog" :close-on-click-modal="false">
      <contract-type @onSearch="onSearch" @closeContractTypeDialog="onCloseDialog" @openPreviewPdf="openPreviewPdf"/>
    </el-dialog> -->
    <el-form :inline="true">
      <el-form-item label="合同信息">
        <el-input placeholder="输入合同名称、编号、单号、合作商" style="width: 140px" v-model="queryFormData.title"></el-input>
      </el-form-item>
      <el-form-item label="日期">
        <el-date-picker v-model="dateArr" 
                        style="width: 220px"
                        type="daterange" 
                        value-format="timestamp"
                        range-separator="至" 
                        start-placeholder="开始日期" 
                        end-placeholder="结束日期">
        </el-date-picker>
        <!-- <template slot="label">
          <h6 class="formLabel">日期</h6>
        </template>
        <el-date-picker
          v-model="queryFormData.creationtimeStart"
          type="date"
          style="width: 130px"
          value-format="yyyy-MM-dd"
          placeholder="开始日期">
        </el-date-picker>
        ~
        <el-date-picker
          v-model="queryFormData.creationtimeEnd"
          type="date"
          style="width: 130px"
          value-format="yyyy-MM-dd"
          placeholder="截止日期">
        </el-date-picker> -->
      </el-form-item>
      <!-- <el-form-item label="合作商">
        <el-input placeholder="输入合作商名称" style="width: 140px;" v-model="queryFormData.partner"></el-input>
      </el-form-item> -->
      <el-form-item label="部门/人员" prop="name">
        <!-- <el-input placeholder="跟单员姓名" v-model="queryFormData.planLeader" class="input-item"></el-input> -->
        <dept-person-select ref="deptPersonSelect" :dataQuery="dataQuery" width="170"
                            :selectDept="queryFormData.depts" :selectPerson="queryFormData.users"/>
      </el-form-item>
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">合同类型</h6>
        </template>
        <el-select v-model="queryFormData.type" clearable placeholder="选择合同类型" style="width: 130px">
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
        <!-- <Authorized :permission="['AGREEMENT_CREATE']">
          <el-button type="primary" class="toolbar-search_input" @click="dialogVisible = true">创建合同</el-button>
        </Authorized> -->
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
  import { DeptPersonSelect } from '@/components'

  const {
    mapMutations
  } = createNamespacedHelpers('ContractModule');

  export default {
    name: 'ContractToolbar',
    props: ['queryFormData', 'dataQuery'],
    components: { ContractType, DeptPersonSelect },
    computed: {},
    methods: {
      ...mapMutations({
      }),
      onSearch () {
        this.$emit('onSearch', 0);
      },
      onCreateContract () {
        this.fn.openSlider('创建', ContractForm, '');
      },
      onReset () {
        this.queryFormData.title = '';
        this.queryFormData.partner = '';
        this.queryFormData.type = '';
        this.dateArr = [];
        this.$refs.deptPersonSelect.clearSelectData();
        this.$emit('onResetQuery');
      },
      onCloseDialog () {
        this.dialogVisible = false;
      },
      openPreviewPdf(val, code) {
        this.$emit('openPreviewPdf', val, code)
      }
    },
    data () {
      return {
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
        factories: [],
        brands: [],
        keyword: this.$store.state.ContractModule.keyword,
        orderCode: this.$store.state.ContractModule.orderCode,
        dateTime: this.$store.state.ContractModule.dateTime,
        formData: this.$store.state.ContractModule.formData,
        dialogVisible: false,
        type: this.$store.state.ContractModule.type,
        dateArr: [],
        TemplateType: this.$store.state.EnumsModule.TemplateType
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
    created () {
      Bus.$on('openContractType', args => {
        this.dialogVisible = !this.dialogVisible;
      })
    }
  }
</script>
<style scoped>
  .formLabel {
    font-size: 12px;display: inline-block;
  }

  .el-input__inner {
    /* border-radius: 5px; */
    line-height: 30px;
  }

  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .contract-toolbar-container >>> .el-form-item {
    margin-bottom: 0px;
  }

  .contract-toolbar-container >>> .el-date-editor .el-range-separator {
    width: 12%;
  }
</style>
