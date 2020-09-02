<template>
  <div>
    <el-table :data="data" stripe style="width: 100%" row-key="id">
      <!-- <el-table-column type="selection" :reserve-selection="true" width="55">
      </el-table-column> -->
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
      <el-table-column prop="unitPrice" label="接单单价/元" min-width="100"></el-table-column>
      <el-table-column label="接单总价/元" min-width="100">
        <template slot-scope="scope">
          {{getEntryTotalPrice(scope.row)}}
        </template>
      </el-table-column>
      <!-- <el-table-column label="预计总成本">
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
      </el-table-column> -->
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
      <el-table-column label="操作" min-width="150">
        <template slot-scope="scope">
          <!-- <span style="color:red;">{{scope.row.validateMsg!=null?scope.row.validateMsg:''}}</span> -->
          <!-- <i v-if="validateEntry(scope.row)" class="el-icon-warning" style="color:red;font-size:20px;"></i> -->
          <el-button type="text" @click="onDetail(scope.$index)">详情</el-button>
          <!-- 来源订单详情 -->
          <el-button type="text" @click="onOriginDetail(scope.row.originOrder.id)" v-if="scope.row.originOrder!=null">来源订单详情
          </el-button>
          <template v-if="canEdit(scope.row.auditState)">
            <el-button v-if="canUpdate" type="text" @click="onModify(scope.$index)">编辑</el-button>
            <el-button v-if="canDelete" slot="reference" type="text" @click="onDelete(scope.$index)"
              :disabled="data.length==1">删除
            </el-button>
          </template>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog :visible.sync="detailDialog" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <production-order-detail :id="openOrderId" v-if="detailDialog" />
    </el-dialog>
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

  import ProductionOrderDetail from '../production-order/details/ProductionOrderDetail'

  export default {
    name: 'SalesProductionProductsTable',
    components: {
      ProductionOrderDetail
    },
    props: {
      data: {
        type: Array
      },
      canUpdate: {
        type: Boolean,
        default: true,
      },
      canDelete: {
        type: Boolean,
        default: false
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
      validateEntry(entry) {
        return entry.costOrder == null;
      },
      //来源工单详情
      onOriginDetail(id) {
        this.openOrderId = id;
        this.detailDialog = true;
      }
    },
    data() {
      return {
        openOrderId: '',
        detailDialog: false
      }
    }
  }

</script>

<style scoped>

</style>
