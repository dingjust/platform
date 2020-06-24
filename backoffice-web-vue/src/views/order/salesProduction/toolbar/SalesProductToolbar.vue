<template>
  <div>
    <el-form :inline="true" label-position="left">
      <el-row type="flex" justify="space-between">
        <el-col :span="17">
          <el-form-item label="订单信息" prop="name">
            <el-input placeholder="订单号，订单名称" v-model="queryFormData.keyword" class="input-item"></el-input>
          </el-form-item>
        <!-- </el-col> -->
        <!-- <el-col :span="5"> -->
          <el-form-item label="负责人" prop="name">
            <el-input placeholder="跟单员姓名" v-model="queryFormData.name" class="input-item"></el-input>
          </el-form-item>
        <!-- </el-col> -->
        <!-- <el-col :span="5"> -->
          <el-form-item label="合作商" prop="name">
            <el-input placeholder="合作商名称" v-model="queryFormData.name" class="input-item"></el-input>
          </el-form-item>
        <!-- </el-col> -->
        <!-- <el-col :span="1" style="margin-right:10px"> -->
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button native-type="reset" @click="onReset">重置</el-button>
          </el-button-group>
        </el-col>
        <el-col :span="7" v-if="!isPending">
          <el-row type="flex" justify="end">
            <el-button-group>
              <el-button type="primary" size="small" @click="onUniqueCodeImport">唯一码导入
              </el-button>
              <el-button size="small" @click="createSalesPlan">创建销售计划</el-button>
              <el-button size="small" @click="createSalesOrder">创建销售订单</el-button>
            </el-button-group>
          </el-row>
        </el-col>
      </el-row>
    </el-form>
    <el-dialog :visible.sync="uniqueCodeImportFormVisible" width="30%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <unique-code-import-form @callback="onImportCallback" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import SalesProductionStatusBar from '../components/SalesProductionStatusBar';
  import UniqueCodeImportForm from '../form/UniqueCodeImportForm';

  const {
    mapMutations
  } = createNamespacedHelpers('SalesProductionOrdersModule');

  export default {
    name: 'SalesProductionToolbar',
    props: {
      isPending: {
        type: Boolean,
        default: false
      }
    },
    components: {
      SalesProductionStatusBar,
      UniqueCodeImportForm
    },
    computed: {},
    data() {
      return {
        statuses: this.$store.state.EnumsModule.SalesProductionStatuses,
        uniqueCodeImportFormVisible: false,
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
      onUniqueCodeImport() {
        this.uniqueCodeImportFormVisible = true;
      },
      onImportCallback() {
        this.uniqueCodeImportFormVisible = false;
        this.$emit('onAdvancedSearch', 0);
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
  .input-item {
    width: 140px;    
  }

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

  .create-button_blue {
    /* background-color: #ecf5ff;
    border-color: #b3d8ff; */
    /* width: 50px; */
    height: 25px;
    /* color: #409eff; */
  }

  .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 5px !important;
  }

</style>
