<template>
  <div style="margin-top: 20px">
    <el-dialog :visible.sync="detailVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <outbound-order-entry-detail v-if="detailVisible" :formData="currentFormData" />
    </el-dialog>
    <el-dialog :visible.sync="taskDetailVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <production-task-detail v-if="taskDetailVisible" :id="productionTaskId"/>
    </el-dialog>
    <el-tabs type="border-card">
      <el-tab-pane label="产品明细">
        <el-table ref="resultTable" stripe :data="slotData.taskOrderEntries" :height="autoHeight">
          <el-table-column label="产品名称" prop="product.name"></el-table-column>
          <el-table-column label="货号" prop="product.skuID"></el-table-column>
          <el-table-column label="品类">
            <template slot-scope="scope">
              <span>{{scope.row.product.category ? scope.row.product.category.name : ''}}</span> </template>
          </el-table-column>
          <el-table-column label="数量" prop="totalQuantity"></el-table-column>
          <el-table-column label="单价/元" prop="billPrice"></el-table-column>
          <el-table-column label="总价/元" prop="totalPrice"></el-table-column>
          <el-table-column label="交货时间">
            <template slot-scope="scope">
              <span>{{scope.row.expectedDeliveryDate | timestampToTime}}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" min-width="100">
            <template slot-scope="scope">
              <el-row>
                <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
              </el-row>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
      <el-tab-pane label="订单进度">
        <el-table ref="resultTable" stripe :data="slotData.taskOrderEntries" highlight-current-row :height="autoHeight">
          <el-table-column label="产品名称" prop="product.name"></el-table-column>
          <el-table-column label="货号" prop="product.skuID"></el-table-column>
          <el-table-column label="对应生产进度工单"></el-table-column>
          <el-table-column label="当前进度" prop="billPrice"></el-table-column>
          <el-table-column label="延期状态" prop="totalPrice"></el-table-column>
          <el-table-column label="操作" min-width="100">
            <template slot-scope="scope">
              <el-row>
                <el-button type="text" @click="onOutboundEntryDetails(scope.row)">详情</el-button>
                <!-- <el-button type="text" @click="onDetails(scope.row)">详情</el-button> -->
              </el-row>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import {
    OutboundOrderEntryDetail,
  } from '../index';

  import {
    ProductionTaskDetail
  } from '../../production-task/index';


  export default {
    name: 'OutboundOrderCenterTable',
    props: ['slotData'],
    components: {
      ProductionTaskDetail,
      OutboundOrderEntryDetail
    },
    methods: {
      //任务详情
      onDetail(row) {
        this.taskDetailVisible = true;
        this.productionTaskId = row.productionTask.id;
      },
      //外发单详情
      onOutboundEntryDetails(row) {
        this.currentFormData = Object.assign({}, this.slotData);
        this.$set(this.currentFormData, 'taskOrderEntries', [row]);
        this.detailVisible = true;
      }
    },
    data() {
      return {
        taskDetailVisible: false,
        productionTaskId: '',
        detailVisible: false,
        currentFormData: ''
      }
    },
    created() {}
  }

</script>

<style scoped>

</style>
