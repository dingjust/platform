<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" row-key="id"
      @selection-change="handleSelectionChange" @row-click="rowClick">
      <el-table-column type="selection" :reserve-selection="true" width="55"></el-table-column>
      <el-table-column label="标题" prop="title" min-width="150"></el-table-column>
      <el-table-column label="外发订单号" prop="code" min-width="150">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
            <span style="margin-right:5px">{{scope.row.code}}</span>
            <el-tag v-if="scope.row.managementMode=='AUTOGESTION'" type="warning">自管</el-tag>
            <el-tag v-else type="success">协同</el-tag>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="合作商" :show-overflow-tooltip="true" min-width="120">
        <template slot-scope="scope">
          <span>{{getCooperator(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="关联产品数" prop="entrySize" min-width="85"></el-table-column>
      <el-table-column label="跟单员" prop="merchandiser.name" :show-overflow-tooltip="true" min-width="100">
      </el-table-column>
      <el-table-column label="创建时间" min-width="110">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单状态" min-width="70">
        <template slot-scope="scope">
          <span>{{getEnum('OutboundOrderStatuses', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单标签" min-width="90">
        <template slot-scope="scope">
          <el-tag :type="isAgreementsComplete(scope.row) ? 'success' : 'info'">
            {{isAgreementsComplete(scope.row) ? '已签合同' : '未签合同'}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="" v-if="showCancelList" min-width="30">
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
  name: 'OutboundOrderSelectList',
  props: ['page', 'singleChoice'],
  computed: {
    showCancelList: function () {
      return this.page.content.some(item => this.isApplyCanceling(item));
    }
  },
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
      this.$refs.resultTable.toggleRowSelection(row);
    },
    onSelect () {
      this.$emit('onSelect', this.selectionRow);
    },

    getCooperator(row) {
      return row.targetCooperator.type == 'ONLINE' ? row.targetCooperator.partner.name : row.targetCooperator.name;
    },
    //判断是否已签合同
    isAgreementsComplete(row) {
      if (row.agreements) {
        let index = row.agreements.findIndex(entry => entry.state == 'COMPLETE');
        return index != -1;
      }
      return false;
    },
    //判断是否正在申请取消订单
    isApplyCanceling(row) {
      if (row.currentCancelApply != null && row.currentCancelApply.state == 'PENDING') {
        return true;
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
</style>