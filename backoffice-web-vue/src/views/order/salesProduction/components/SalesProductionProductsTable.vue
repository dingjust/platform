<template>
  <div>
    <el-table :data="data" stripe style="width: 100%">
      <el-table-column type="selection" width="55">
      </el-table-column>
      <el-table-column label="产品名称" min-width="150">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
              <img width="54px" v-if="scope.row.product!=null" height="54px"
                :src="scope.row.product.thumbnail!=null&&scope.row.product.thumbnail.length!=0?scope.row.product.thumbnail.url:'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>{{scope.row.product.name}}</span>
              </el-row>
              <el-row>
                <span>货号:{{scope.row.product!=null?scope.row.product.skuID:''}}</span>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="数量">
        <template slot-scope="scope">
          <span>{{getEntryTotalAmount(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column prop="unitPrice" label="预计销售单价/元" min-width="100"></el-table-column>
      <el-table-column label="预计销售总价/元" min-width="100">
        <template slot-scope="scope">
          {{getEntryTotalPrice(scope.row)}}
        </template>
      </el-table-column>
      <el-table-column label="预计总成本">
        <template slot-scope="scope">
          {{getEntryTotalCost(scope.row)}}
        </template>
      </el-table-column>
      <el-table-column label="预计利润">
        <template slot-scope="scope">
          {{getEntryProfit(scope.row)}}
        </template>
      </el-table-column>
      <el-table-column label="预计利润率">
        <template slot-scope="scope">
          {{getEntryProfitPercent(scope.row)}}%
        </template>
      </el-table-column>
      <el-table-column label="交货时间">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="审核状态">
        <template slot-scope="scope">
          <span>{{scope.row.auditState!=null? getEnum('SalesProductionAuditStatus', scope.row.auditState):''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="120">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.$index)">详情</el-button>
          <template v-if="canEdit(scope.row.auditState)">
            <el-button type="text" @click="onModify(scope.$index)">编辑</el-button>
            <el-button slot="reference" type="text" @click="onDelete(scope.$index)" :disabled="scope.$index==0">删除</el-button>
          </template>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  import {
    getEntryCostPrice,
    getEntryTotalAmount,
    getEntryTotalPrice,
    getEntryTotalCost,
    getEntryProfit,
    getEntryProfitPercent
  } from '../js/accounting.js';

  export default {
    name: 'SalesProductionProductsTable',
    components: {},
    props: {
      data: {
        type: Array
      }
    },
    methods: {
      getEntryCostPrice,
      getEntryTotalAmount,
      getEntryTotalPrice,
      getEntryTotalCost,
      getEntryProfit,
      getEntryProfitPercent,
      onProductDetail(row) {
        // this.salesProductDetailsVisible = true;
      },
      onDelete(index) {
        this.$emit('onDelete', index);
      },
      onClose() {

      },
      canEdit(state) {
        if (state == 'AUDITING' || state == 'PASSED') {
          return false;
        } else {
          return true;
        }
      },
      onDetail(index) {
        this.$emit('onDetail', index);
      },
      onModify(index) {
        this.$emit('onModify', index);
      },

    },
    data() {
      return {}
    }
  }

</script>

<style scoped>

</style>
