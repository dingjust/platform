<template>
  <div>
  <el-dialog :visible.sync="dialogVisible" width="80%" height="50%" class="purchase-dialog" :close-on-click-modal="false">
    <contract-type @onSearch="onSearch" @closeContractTypeDialog="onCloseDialog" @openPreviewPdf="openPreviewPdf"/>
  </el-dialog>
  <el-form :inline="true">
    <el-form-item>
      <el-input style="width: 250px" placeholder="合同号/订单号/签署对象/合同名称" v-model="queryFormData.title"></el-input>
    </el-form-item>
    <el-form-item>
      <template slot="label">
        <h6 class="formLabel">日期</h6>
      </template>
      <el-date-picker
        v-model="queryFormData.creationtimeStart"
        type="date"
        style="width: 130px"
        value-format="yyyy-MM-dd"
        placeholder="开始日期">
      </el-date-picker>
      <el-date-picker
        v-model="queryFormData.creationtimeEnd"
        type="date"
        style="width: 130px"
        value-format="yyyy-MM-dd"
        placeholder="截止日期">
      </el-date-picker>
    </el-form-item>
    <el-form-item>
      <template slot="label">
        <h6 class="formLabel">合同类型</h6>
      </template>
      <el-select v-model="queryFormData.type" clearable placeholder="选择合同类型">
        <el-option
          v-for="item in TemplateType"
          :key="item.value"
          :label="item.name"
          :value="item.code">
        </el-option>
      </el-select>
    </el-form-item>
      <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
      <el-button  native-type="reset" @click="onReset">重置</el-button>
      <Authorized :permission="['AGREEMENT_CREATE']">
        <el-button type="primary" class="toolbar-search_input" @click="dialogVisible = true">创建合同</el-button>
      </Authorized>
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
    props: ['queryFormData'],
    components: {ContractType},
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
        this.queryFormData.creationtimeStart = '';
        this.queryFormData.creationtimeEnd = '';
        this.queryFormData.type = '';
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
        TemplateType: [{
          code: 'BCXY',
          name: '补充协议'
        },
        {
          code: 'WTSCHT',
          name: '委托生产合同'
        },
        {
          code: 'CGDD',
          name: '采购订单'
        },
        {
          code: 'KJXY',
          name: '框架协议'
        }
        ]
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

</style>
