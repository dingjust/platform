<template>
  <div class="production-order-toolbar-container">
    <el-dialog :visible.sync="uniquecodeFormVisible" width="30%" class="uniquecode-dialog" append-to-body
      :close-on-click-modal="false">
      <uniquecode-import-form />
    </el-dialog>
    <el-form :inline="true">
      <el-row type="flex">
        <el-col :span="24">
          <el-form-item label="订单信息">
            <el-input style="width:170px;" placeholder="输入订单号、产品名或货号" v-model="queryFormData.keyword"
              class="purchase-toolbar-input"></el-input>
          </el-form-item>
          <el-form-item label="部门/人员">
            <dept-person-select ref="deptPersonSelect" :dataQuery="dataQuery" width="160"
                                :selectDept="queryFormData.depts" :selectPerson="queryFormData.users"/>
          </el-form-item>
          <el-form-item label="合作商">
            <el-input style="width:140px;" placeholder="输入合作商名称" v-model="queryFormData.cooperator"
              class="purchase-toolbar-input"></el-input>
          </el-form-item>
          <el-form-item label="日期">
            <el-date-picker style="width:220px;" v-model="dateTime" type="daterange" align="right" unlink-panels range-separator="~"
              value-format="timestamp" @change="onDateChange" start-placeholder="开始日期" end-placeholder="截止日期"
              :picker-options="pickerOptions">
            </el-date-picker>
          </el-form-item>
          <!-- <el-form-item label="分类">
            <el-cascader v-model="queryFormData.categories" :show-all-levels="false" :options="categories"
              :props="{ label: 'name',value:'code'}" clearable>
            </el-cascader>
          </el-form-item> -->
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
        <!-- <el-col :span="2">
          <el-row type="flex" justify="end">
            <authorized :permission="['OUT_ORDER_CREATE']">
              <el-button v-if="!isOutProduction  && !isAllocating" type="primary" class="create-button"
                @click="onCreate">
                创建外发订单</el-button>
            </authorized>
            <authorized :permission="['PRODUCTION_TASK_ASSIGN']">
              <el-button v-if="isAllocating" type="primary" class="create-button" @click="onAllocating">去分配</el-button>
            </authorized>
          </el-row>
        </el-col> -->
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  import UniquecodeImportForm from '@/components/custom/UniquecodeImportForm';

  const {
    mapMutations
  } = createNamespacedHelpers('ProductionOrdersModule');
  import { DeptPersonSelect } from '@/components'

  export default {
    name: 'ProductionOrderToolbar',
    props: {
      queryFormData: {
        type: Object
      },
      isOutProduction: {
        type: Boolean,
        default: false
      },
      isAllocating: {
        type: Boolean,
        default: false
      },
      dataQuery: {
        type: Object
      }
    },
    components: {
      UniquecodeImportForm,
      DeptPersonSelect
    },
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        // setQueryFormData: 'queryFormData'
      }),
      // onSearch () {
      //   this.$store.state.ProductionOrdersModule.keyword = this.keyword;
      //   this.setKeyword(this.keyword);
      //   this.$emit('onAdvancedSearch', 0);
      // },
      onAdvancedSearch() {
        // this.setQueryFormData(this.queryFormData);
        this.$emit('onAdvancedSearch', 0);
      },
      onReset() {
        this.dateTime = null;
        this.queryFormData.keyword = '';
        this.queryFormData.categories = [];
        this.$refs.deptPersonSelect.clearSelectData();
        this.$emit('onResetQuery');
      },
      async getFactories(query) {
        const url = this.apis().getFactories();
        const result = await this.$http.post(url, {
          keyword: query
        }, {
          page: 0,
          size: 10
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.factories = result.content;
      },
      async getBrands(query) {
        const url = this.apis().getBrands();
        const result = await this.$http.post(url, {
          keyword: query
        }, {
          page: 0,
          size: 10
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.brands = result.content;
      },
      onDateChange(values) {
        this.queryFormData.createdDateFrom = values[0];
        this.queryFormData.createdDateTo = values[1];
        this.onAdvancedSearch();
      },
      async getCategories() {
        const url = this.apis().getMinorCategories();
        const results = await this.$http.get(url);
        if (!results['errors']) {
          this.categories = results;
        }
      },
      jumpToOrderPurchase() {
        this.$router.push('/orderPurchase');
      },
      onCreate() {
        // this.$router.push('/sales/create/productionOrder');
        this.$emit('onCreate');
      },
      onAllocating() {
        this.$emit('onAllocating');
      }
    },
    data() {
      return {
        uniquecodeFormVisible: false,
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
        dateTime: '',
        factories: [],
        brands: [],
        keyword: this.$store.state.ProductionOrdersModule.keyword,
        formData: this.$store.state.ProductionOrdersModule.formData,
        categories: []
        // queryFormData: this.$store.state.ProductionOrdersModule.queryFormData,
      }
    },
    created() {
      this.getCategories();
      if (this.isTenant()) {
        this.getFactories();
        this.getBrands();
      }
    },
    watch: {
      dateTime: function (newVal, oldVal) {
        if (newVal == null) {
          this.queryFormData.createdDateFrom = null;
          this.queryFormData.createdDateTo = null;
        } else {
          this.queryFormData.createdDateFrom = newVal[0];
          this.queryFormData.createdDateTo = newVal[1];
        }
      }
    }
  }

</script>
<style scoped>
  .el-input__inner {
    /* border-radius: 5px; */
    line-height: 30px;
  }

  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .el-date-editor--daterange.el-input__inner {
    width: 260px;
  }

  .purchase-toolbar-input {
    width: 120px;
  }

  .el-form-item__label {
    font-size: 13px;
  }

  .dashboard-toolbar-btn {
    border: 0.5px solid rgba(255, 164, 3, 1);
    color: rgba(255, 164, 3, 1);
    /* height: ; */
    font-size: 10px;
  }

  .create-button {
    background-color: #ffd60c;
    border-color: #DCDFE6;
    width: 100px;
    height: 40px;
    color: #606266;
  }

  .create-button:hover {
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
