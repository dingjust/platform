<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" row-key="id"
      @selection-change="handleSelectionChange" @row-click="rowClick">
      <el-table-column type="selection" :selectable="selectable" :reserve-selection="true" width="55"></el-table-column>
      <el-table-column label="外接订单号" min-width="110">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.code}}</span>
            <el-tag type="info" effect="plain"
              :class="scope.row.originCompany == null ? 'business-tag' : 'pending-tag'">
              {{scope.row.originCompany == null ? '自创' : '线上'}}</el-tag>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="客户" :show-overflow-tooltip="true" min-width="120">
        <template slot-scope="scope">
          <span>{{cooperatorName(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建人" prop="creator.name" :show-overflow-tooltip="true">
      </el-table-column>
      <el-table-column label="创建日期">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单状态">
        <template slot-scope="scope">
          <span>{{getEnum('SalesProductionOrderState', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单标签" min-width="100">
        <template slot-scope="scope">
          <el-tag :type="isAgreementsComplete(scope.row)?'success':'info'">
            {{isAgreementsComplete(scope.row)?'已签合同':'未签合同'}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="">
        <template slot-scope="scope">
          <el-tooltip class="item" effect="dark" content="正在申请取消订单" placement="top" v-if="isApplyCanceling(scope.row)">
            <i class="el-icon-warning warning-icon"></i>
          </el-tooltip>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <div class="pt-2"></div>
    <el-row type="flex" justify="center">
      <el-button style="width: 120px;" type="primary" @click="onSelect">确定</el-button>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'PendingSalesSelectList',
  props: ['page', 'singleChoice'],
  methods: {
    handleSelectionChange(selection) {
      if (this.singleChoice && selection.length > 1) {
        this.$refs.resultTable.toggleRowSelection(selection[0], false);
        this.selectionRow = [selection[selection.length - 1]];
      } else {
        this.selectionRow = selection;
      }
    },
    rowClick(row) {
      if (row.originCompany == null) {
        return;
      }
      this.$refs.resultTable.toggleRowSelection(row);
    },
    onSelect () {
      this.$emit('onSelect', this.selectionRow);
    },
    selectable (row, index) {
      return row.originCompany != null;
    },
    cooperatorName(row) {
      if (row.originCompany != null) {
        return row.originCompany.name;
      } else {
        return row.originCooperator.type == 'ONLINE' ? row.originCooperator.partner.name : row.originCooperator.name;
      }
    },
    //判断是否正在申请取消订单
    isApplyCanceling(row) {
      if (row.currentCancelApply != null && row.currentCancelApply.state == 'PENDING') {
        return true;
      }
      return false;
    },
    //判断是否已签合同
    isAgreementsComplete(row) {
      if (row.agreements) {
        let index = row.agreements.findIndex(entry => entry.state == 'COMPLETE');
        return index != -1;
      }
      return false;
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
  },
  data () {
    return {
      selectionRow: []
    }
  }
}
</script>

<style scoped>
  .warning-icon {
    color: #ff1744;
    font-size: 20px;
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