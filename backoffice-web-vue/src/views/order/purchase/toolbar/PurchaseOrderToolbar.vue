<template>
  <el-form :inline="true">
    <el-form-item label="品牌名">
      <el-input placeholder="输入品牌名" v-model="queryFormData.purchasers[0]"  class="purchase-toolbar-input"></el-input>
    </el-form-item>
    <el-form-item label="日期">
      <el-date-picker v-model="dateTime" type="daterange" align="right" unlink-panels range-separator="~"
        value-format="timestamp" @change="onDateChange" start-placeholder="开始日期" end-placeholder="截止日期"
        :picker-options="pickerOptions">
      </el-date-picker>
    </el-form-item>
    <el-form-item label="跟单员">
      <el-input placeholder="输入编号" class="purchase-toolbar-input"></el-input>
    </el-form-item>
    <el-form-item label="分类">
      <!-- <el-input placeholder="" class="purchase-toolbar-input"></el-input> -->
      <el-select v-model="queryFormData.keyword" class="purchase-toolbar-input" placeholder="请选择" filterable reserve-keyword
        clearable>
        <el-option-group v-for="level1 in categories" :key="level1.code" :label="level1.name">
          <el-option v-for="level2 in level1.children" :key="level2.code" :label="level2.name" :value="level2.name">
          </el-option>
        </el-option-group>
      </el-select>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
      <el-button native-type="reset" @click="">重置</el-button>
    </el-button-group>
  </el-form>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapMutations
  } = createNamespacedHelpers('ContractModule');

  export default {
    name: 'PurchaseOrderToolbar',
    components: {},
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setQueryFormData: 'queryFormData',
      }),
      onSearch() {
        this.$store.state.PurchaseOrdersModule.keyword=this.keyword;
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
        console.log(values[0]);
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
        dateTime: '',
        factories: [],
        brands: [],
        keyword: this.$store.state.PurchaseOrdersModule.keyword,
        formData: this.$store.state.PurchaseOrdersModule.formData,
        queryFormData: this.$store.state.PurchaseOrdersModule.queryFormData,
        categories: [],
      }
    },
    created() {
      this.getCategories();
      if (this.isTenant()) {
        this.getFactories();
        this.getBrands();
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

</style>
