<template>
  <div class="pend-out-view-list">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" row-key="id">
      <el-table-column label="订单号" min-width="300px" fixed="left">
        <template slot-scope="scope">
          <el-row type="flex" justify="start" align="middle">
            <span style="margin-right:5px">{{scope.row.code}}</span>
            <el-tag type="info" effect="plain" style="margin-right:5px"
              :class="scope.row.originCompany == null ? 'business-tag' : 'pending-tag'">
              {{scope.row.originCompany == null ? '自创' : '线上'}}</el-tag>
            <el-tag style="margin-right:5px" type="primary" v-if="scope.row.payOnline">线上支付</el-tag>
            <el-tag type="warning" v-if="scope.row.agentOrder">代运营订单</el-tag>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="甲方公司" prop="originCooperator.name" show-overflow-tooltip min-width="150px"></el-table-column>
      <el-table-column label="乙方公司" prop="belongTo.name" show-overflow-tooltip min-width="150px"></el-table-column>
      <el-table-column label="款数" prop="entrySize" min-width="60px"></el-table-column>
      <el-table-column label="订单数量" prop="totalQuantity" min-width="70px"></el-table-column>
      <el-table-column label="服务费比例" prop="serviceFeePercent" min-width="80px"></el-table-column>
      <el-table-column label="订单金额" prop="totalPrimeCost" min-width="70px"></el-table-column>
      <el-table-column label="结算金额" prop="onlinePaidAmount" min-width="70px"></el-table-column>
      <el-table-column label="甲方渠道码" min-width="105px">
        <template slot-scope="scope">
          <span v-if="scope.row.sendBy">{{scope.row.sendBy.channelCode}}</span>
        </template>
      </el-table-column>
      <el-table-column label="乙方渠道码" min-width="105px">
        <template slot-scope="scope">
          <span v-if="scope.row.creator">{{scope.row.creator.channelCode}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" min-width="115px">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单状态" min-width="70px">
        <template slot-scope="scope">
          <span>{{getEnum('SalesProductionOrderState', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单标签" min-width="100px">
        <template slot-scope="scope">
          <el-tag :type="isAgreementsComplete(scope.row)?'success':'info'">
            {{isAgreementsComplete(scope.row)?'已签合同':'未签合同'}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="60px">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)" class="purchase-list-button">详情</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
export default {
  name: 'PendOutViewList',
  props: ['page'],
  methods: {
    getCooperator(row) {
      if (!row.targetCooperator) {
        return '';
      }
      return row.targetCooperator.type == 'ONLINE' ? row.targetCooperator.partner.name : row.targetCooperator.name;
    },
    onPageSizeChanged(val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged(val) {
      this.$emit('onAdvancedSearch', val - 1);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onDetail(row) {
      this.$router.push('/order/pend-out/' + row.id);
    },
    //判断是否已签合同
    isAgreementsComplete(row) {
      if (row.agreements) {
        let index = row.agreements.findIndex(entry => entry.state == 'COMPLETE');
        return index != -1;
      }
      return false;
    }
  }
}
</script>

<style scoped>
  .pend-out-view-list >>> .el-table th>.cell .el-checkbox {
    display: none;
  }

  .warning-icon {
    color: #ff1744;
    font-size: 20px;
  }

  .sure-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    width: 150px;
    height: 35px;
  }

  .pending-tag {
    color: #67c23a;
    border-Color: #67c23a
  }

  .business-tag {
    color: #ffd60c;
    border-Color: #ffd60c
  }

</style>
