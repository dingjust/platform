<template>
  <div class="animated fadeIn">
    <!--<el-dialog :visible.sync="productDetailsVisible" width="80%" class="purchase-dialog" append-to-body>-->
    <!--<apparel-product-details-page :slotData="formData" @afterCreate="onAfterCreate"/>-->
    <!--</el-dialog>-->
    <el-form :inline="true">
      <el-form-item label="">
        <el-input placeholder="请输入账务方案名称查询" v-model="keyword"></el-input>
      </el-form-item>
      <!-- <el-button-group> -->
      <el-button type="text" @click="onSearch">查找</el-button>

      <!--<el-button type="text" @click="onNew">创建产品</el-button>-->
      <!-- </el-button-group> -->
      <el-button class="product-select-btn" @click="onSure">确定</el-button>
    </el-form>
    <!--v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight"-->
    <el-table :data="page.content"
      highlight-current-row @current-change="handleCurrentChange" @selection-change="handleSelectionChange">
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
    mapMutations
  } = createNamespacedHelpers('PayPlanModule');

  export default {
    name: 'PayPlanSelect',
    props: ['page'],
    computed: {},
    components: {
    },
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
      }),
      onPageSizeChanged (val) {
        this._reset();
        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        this.$emit('onSearch', val - 1);
      },
      _reset () {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onSearch () {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      numberFormatter (val) {
        if (val.price !== null && val.price !== '' && val.price !== 'undefined') {
          return parseFloat(val.price).toFixed(2);
        }
      },
      handleSelectionChange (val) {
        this.multipleSelection = val;
      },
      // 选中行
      handleCurrentChange (val) {
        this.selectPayPlan = val;
      },
      onSure () {
        this.$emit('onSelect', this.selectPayPlan);
      },
      onNew () {
        this.productDetailsVisible = true;
      },
      onAfterCreate () {
        console.log('sdssssss');
        this.productDetailsVisible = false;
      }
    },
    data () {
      return {
        multipleSelection: [],
        keyword: '',
        selectPayPlan: ''
      }
    },
    created () {
      this.$emit('onSearch', 0);
    }
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
