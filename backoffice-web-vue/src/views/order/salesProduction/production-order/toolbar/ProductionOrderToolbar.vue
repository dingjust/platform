<template>
  <div>
    <el-dialog :visible.sync="uniquecodeFormVisible" width="30%" class="uniquecode-dialog" append-to-body :close-on-click-modal="false">
      <uniquecode-import-form />
    </el-dialog>
    <el-form :inline="true">
      <el-row type="flex">
        <!-- <el-form-item label="品牌名"> -->
        <el-col :span="20">
          <el-input style="width:220px;" placeholder="订单号/产品名称/合作商/款号" v-model="queryFormData.keyword"
            class="purchase-toolbar-input"></el-input>
          <!-- </el-form-item> -->
          <el-form-item label="日期">
            <el-date-picker v-model="dateTime" type="daterange" align="right" unlink-panels range-separator="~"
              value-format="timestamp" @change="onDateChange" start-placeholder="开始日期" end-placeholder="截止日期"
              :picker-options="pickerOptions">
            </el-date-picker>
          </el-form-item>
          <!-- <el-form-item label="跟单员">
        <el-input placeholder="输入编号" class="purchase-toolbar-input"></el-input>
      </el-form-item> -->
            <!-- <el-input placeholder="" class="purchase-toolbar-input"></el-input> -->
            <!-- <el-select v-model="queryFormData.keyword" class="purchase-toolbar-input" placeholder="请选择" filterable
          reserve-keyword clearable>
          <el-option-group v-for="level1 in categories" :key="level1.code" :label="level1.name">
            <el-option v-for="level2 in level1.children" :key="level2.code" :label="level2.name" :value="level2.name">
            </el-option>
          </el-option-group>
        </el-select> -->
          <el-form-item label="分类">
            <el-cascader v-model="queryFormData.categories" :show-all-levels="false" :options="categories"
                :props="{ label: 'name',value:'code'}" clearable>
              </el-cascader>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
        <el-col :span="4">
          <el-row type="flex" justify="end">
            <el-button v-if="!isOutProduction" type="primary" class="create-button" @click="onCreate">创建外发订单</el-button>
          </el-row>
        </el-col>
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
  } = createNamespacedHelpers('ProductionOrderModule');

  export default {
    name: 'ProductionOrderToolbar',
    props: {
      isOutProduction: {
        type: Boolean,
        default: false
      }
    },
    components: {
      UniquecodeImportForm
    },
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setQueryFormData: 'queryFormData'
      }),
      onSearch () {
        this.$store.state.ProductionOrderModule.keyword = this.keyword;
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch () {
        this.setQueryFormData(this.queryFormData);
        this.$emit('onAdvancedSearch', 0);
      },
      onReset () {
        this.queryFormData.keyword = '';
        this.queryFormData.categories = [];
        this.queryFormData.createdDateTo = null;
        this.queryFormData.createdDateFrom = null;
        this.queryFormData.statuses = [];
        // const query = {
        //   code: '',
        //   requirementOrderCode: '',
        //   skuID: '',
        //   statuses: [],
        //   expectedDeliveryDateFrom: null,
        //   expectedDeliveryDateTo: null,
        //   createdDateFrom: null,
        //   createdDateTo: null,
        //   keyword: '',
        //   categories: []
        // }
        // this.setQueryFormData(query);
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
      jumpToOrderPurchase () {
        this.$router.push('/orderPurchase');
      },
      onCreate () {
        // this.$router.push('/sales/create/productionOrder');
        this.$emit('onCreate');
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
        keyword: this.$store.state.ProductionOrderModule.keyword,
        formData: this.$store.state.ProductionOrderModule.formData,
        queryFormData: this.$store.state.ProductionOrderModule.queryFormData,
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

</style>
