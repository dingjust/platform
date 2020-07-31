<template>
  <div class="animated fadeIn">
    <el-form :inline="true">
      <el-form-item label="">
        <el-input placeholder="请输入账务方案名称查询" v-model="queryFormData.keyword"></el-input>
      </el-form-item>
      <el-button type="text" @click="onSearch">搜索</el-button>
      <Authorized :permission="['PAY_PLAN_OPERATE']">
        <el-button type="text" @click="onNew">创建账务方案</el-button>
      </Authorized>
      <el-button class="product-select-btn" @click="onSure">确定</el-button>
    </el-form>
    <!--v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight"-->
    <el-table :data="page.content" highlight-current-row @current-change="handleCurrentChange"
      @selection-change="handleSelectionChange">
      <!-- <el-table-column type="selection" width="32"></el-table-column> -->
      <el-table-column label="方案名称" prop="name">
      </el-table-column>
      <el-table-column label="账务类型" prop="payPlanType">
        <template slot-scope="scope">
          <span>{{getEnum('PayPlanType',scope.row.payPlanType)}}</span>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements" :page-sizes="[8,10,20]">
    </el-pagination>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapMutations
  } = createNamespacedHelpers('PayPlanModule');

  export default {
    name: 'PayPlanSelect',
    // props: ['page'],
    computed: {
      ...mapGetters({
        queryFormData: 'queryFormData'
      }),
      ...createNamespacedHelpers('PayPlanModule').mapGetters({
        page: 'page',
      }),
    },
    components: {},
    methods: {
      ...mapMutations({
        setQueryFormData: 'setQueryFormData',
      }),
      ...createNamespacedHelpers('PayPlanModule').mapActions({
        searchPayPlan: 'searchAdvanced'
      }),
      onPageSizeChanged(val) {
        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        this.$emit('onSearch', val - 1);
      },
      onSearch() {
        // this.$emit('onSearch', 0);
        this.onSearchPayPlan();
      },
      handleSelectionChange(val) {
        this.multipleSelection = val;
      },
      // 选中行
      handleCurrentChange(val) {
        this.selectPayPlan = val;
      },
      onSure() {
        this.$emit('onSelect', this.selectPayPlan);
      },
      onNew() {
        this.$router.push('/account/setting/payPlan/create');
      },
      async onSearchPayPlan(page, size) {
        const url = this.apis().getPayPlans();
        this.searchPayPlan({
          url,
          page,
          size
        });
      },
    },
    data() {
      return {
        multipleSelection: [],
        selectPayPlan: '',
        keyword: ''
      }
    },
    created() {
      this.onSearch();
    },
  }

</script>
<style>
  .product-info {
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    font-size: 12px;
  }

  .el-table--striped .el-table__body tr.el-table__row--striped.current-row td {
    background-color: #ffc107;
  }

  .product-select-btn {
    width: 70px;
    height: 25px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    border: 0px solid #FFD60C;
  }

  .el-table__body tr.current-row>td {
    background-color: #ffc107;
  }

</style>
