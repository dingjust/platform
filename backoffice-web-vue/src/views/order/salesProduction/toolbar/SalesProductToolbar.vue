<template>
  <div>
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <el-col :span="19" style="padding-top: 5px">
          <el-form-item label="订单信息" prop="name">
            <el-input placeholder="请输入订单号，订单名称" v-model="queryFormData.keyword"></el-input>
          </el-form-item>
          <el-form-item label="负责人" prop="name">
            <el-input placeholder="请输入跟单员姓名" v-model="queryFormData.name"></el-input>
          </el-form-item>
          <el-form-item label="合作商" prop="name">
            <el-input placeholder="请输入合作商名称" v-model="queryFormData.name"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
        <el-col :span="5">
          <el-row type="flex" justify="end">
            <el-button type="primary" class="create-button" @click="createSalesPlan">创建销售计划</el-button>
            <el-button type="primary" class="create-button" @click="createSalesOrder">创建销售订单</el-button>
          </el-row>
        </el-col>
      </el-row>
    </el-form>
    <sales-production-status-bar :queryFormData="queryFormData" :statuses="statuses" />
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import SalesProductionStatusBar from '../components/SalesProductionStatusBar';

  const {
    mapMutations
  } = createNamespacedHelpers('SalesProductionOrdersModule');

  export default {
    name: 'SalesProductionToolbar',
    components: {
      SalesProductionStatusBar
    },
    computed: {},
    data() {
      return {
        statuses: this.$store.state.EnumsModule.SalesProductionStatuses,
        queryFormData: {
          name: '',
          status: '',
          hasContact: '',
          isArrears: '',
          isDelay: ''
        }
      }
    },
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setQueryFormData: 'queryFormData'
      }),
      createSalesPlan() {
        this.$emit('createSalesPlan');
      },
      createSalesOrder() {
        this.$emit('createSalesOrder');
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
      onReset() {
        this.queryFormData.keyword = '';
        this.queryFormData.name = '';
        this.queryFormData.status = '';
        this.queryFormData.hasContact = '';
        this.queryFormData.isArrears = '';
        this.queryFormData.isDelay = '';
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

  .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 5px !important;
  }

</style>
