<template>
  <div>
    <el-form :inline="true">
      <el-row type="flex">
        <el-col :span="24">
          <el-input style="width:180px;" placeholder="订单号/产品名称/款号"
                    v-model="queryFormData.keyword" class="purchase-toolbar-input">
          </el-input>
          <!-- <el-form-item label="部门/人员" prop="name">
            <dept-person-select ref="deptPersonSelect" :dataQuery="dataQuery" width="170"
                                :selectDept="queryFormData.depts" :selectPerson="queryFormData.users"/>
          </el-form-item> -->
          <el-form-item label="日期">
            <el-date-picker v-model="dateTime" type="daterange" align="right" unlink-panels range-separator="~"
              value-format="timestamp" @change="onDateChange" start-placeholder="开始日期" end-placeholder="截止日期"
              :picker-options="pickerOptions">
            </el-date-picker>
          </el-form-item>
          <el-form-item label="分类">
            <el-cascader v-model="queryFormData.categories" :show-all-levels="false" :options="categories"
                :props="{ label: 'name',value:'code'}" clearable style="width: 150px">
              </el-cascader>
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
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapMutations
  } = createNamespacedHelpers('ContractModule');
  import { DeptPersonSelect } from '@/components'

  export default {
    name: 'SalesOrderToolbar',
    props: ['queryFormData', 'dataQuery'],
    components: {
      DeptPersonSelect
    },
    computed: {},
    methods: {
      ...mapMutations({
      }),
      onSearch () {
        this.$store.state.SalesOrdersModule.keyword = this.keyword;
        // this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch () {
        // this.setQueryFormData(this.queryFormData);
        this.$emit('onAdvancedSearch', 0, 10);
      },
      async getFactories (query) {
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
      async getBrands (query) {
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
      onDateChange (values) {
        console.log(values[0]);
        this.queryFormData.createdDateFrom = values[0];
        this.queryFormData.createdDateTo = values[1];
        this.onAdvancedSearch();
      },
      async getCategories () {
        const url = this.apis().getMinorCategories();
        const results = await this.$http.get(url);
        if (!results['errors']) {
          this.categories = results;
        }
      },
      onReset () {
        this.queryFormData.keyword = '';
        this.queryFormData.createdDateFrom = '';
        this.queryFormData.createdDateTo = '';
        this.queryFormData.categories = [];
        // this.$refs.deptPersonSelect.clearSelectData();
        // this.$emit('onResetQuery');
      }
    },
    data () {
      return {
        uniquecodeFormVisible: false,
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
        dateTime: '',
        factories: [],
        brands: [],
        keyword: this.$store.state.SalesOrdersModule.keyword,
        formData: this.$store.state.SalesOrdersModule.formData,
        // queryFormData: this.$store.state.SalesOrdersModule.queryFormData,
        categories: []
      }
    },
    created () {
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

</style>
