<template>
  <div>
    <el-form :inline="true">
      <el-row type="flex">
        <el-form-item label="工厂/客户">
          <el-input style="width:220px;" v-model="queryFormData.keyword" class="purchase-toolbar-input"></el-input>
        </el-form-item>
        <el-form-item label="交期">
          <el-date-picker v-model="dateTime" type="daterange" align="right" unlink-panels range-separator="~"
            value-format="timestamp" @change="onDateChange" start-placeholder="开始日期" end-placeholder="截止日期"
            :picker-options="pickerOptions">
          </el-date-picker>
        </el-form-item>
        <!-- <el-form-item label="跟单员">
      <el-input placeholder="输入编号" class="purchase-toolbar-input"></el-input>
    </el-form-item> -->
        <el-row type="flex" align="top">
          <el-col :span="24">
            <el-button-group>
              <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
              <el-button native-type="reset">重置</el-button>
            </el-button-group>
          </el-col>
        </el-row>
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
  } = createNamespacedHelpers('ProductionProgressReportModule');

  export default {
    name: 'ProductionProgressReportToolbar',
    components: {},
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setQueryFormData: 'queryFormData',
      }),
      onSearch() {
        this.$store.state.ProductionProgressReportModule.keyword = this.keyword;
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch() {
        this.setQueryFormData(this.queryFormData);
        this.$emit('onAdvancedSearch', 0);
      },
      async getFactories(query) {
        const url = this.apis().getFactories();
        const result = await this.$http.post(url, {
          keyword: query
        }, {
          page: 0,
          size: 10
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
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
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.brands = result.content;
      },
      onDateChange(values) {
        this.queryFormData.expectedDeliveryDateFrom = values[0];
        this.queryFormData.expectedDeliveryDateTo = values[1];
        this.onAdvancedSearch();
      },
      async getCategories() {
        const url = this.apis().getMinorCategories();
        const results = await this.$http.get(url);
        if (!results['errors']) {
          this.categories = results;
        }
      },
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
        keyword: this.$store.state.ProductionProgressReportModule.keyword,
        formData: this.$store.state.ProductionProgressReportModule.formData,
        queryFormData: this.$store.state.ProductionProgressReportModule.queryFormData,
        categories: [],
      }
    },
    created() {
      if (this.isTenant()) {
        this.getFactories();
        this.getBrands();
      }
    },
    watch: {
      dateTime: function (newVal, oldVal) {
        if (newVal == null) {
          this.queryFormData.expectedDeliveryDateFrom = null;
          this.queryFormData.expectedDeliveryDateTo = null;
        } else {
          this.queryFormData.expectedDeliveryDateFrom = newVal[0];
          this.queryFormData.expectedDeliveryDateTo = newVal[1];
        }
      }
    }
  }

</script>
<style>
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
