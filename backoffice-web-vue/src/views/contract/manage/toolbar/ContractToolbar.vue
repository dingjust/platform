<template>
  <el-form :inline="true">
    <el-form-item label="品牌名">
      <el-input placeholder="输入品牌名" v-model="keyword"></el-input>
    </el-form-item>
    <el-form-item label="日期">
      <el-date-picker v-model="dateTime" type="daterange" align="right" unlink-panels range-separator="至"
        start-placeholder="开始日期" end-placeholder="结束日期" :picker-options="pickerOptions">
      </el-date-picker>
    </el-form-item>
    <el-form-item label="合同编号">
      <el-input placeholder="输入编号" v-model="queryFormData.code"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
      <el-button  native-type="reset" @click="">重置</el-button>
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
    name: 'ContractToolbar',
    components: {},
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setQueryFormData: 'queryFormData',
      }),
      onSearch() {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
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
        keyword: this.$store.state.ContractModule.keyword,
        formData: this.$store.state.ContractModule.formData,
        queryFormData: this.$store.state.ContractModule.queryFormData,
      }
    },
    created() {
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

  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

</style>
