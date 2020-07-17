<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" row-key="id"
      @selection-change="handleSelectionChange"  @row-click="rowClick">
      <el-table-column type="selection" width="55" v-if="isSelect"></el-table-column>
      <el-table-column label="生产订单号" prop="code"></el-table-column>
      <el-table-column label="合作商">
        <template slot-scope="scope">
          <span>{{getCooperator(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="关联产品数" prop="entrySize"></el-table-column>
      <el-table-column label="跟单员" prop="merchandiser.name"></el-table-column>
      <el-table-column label="审批状态">
        <template slot-scope="scope">
          <span>{{getEnum('SalesProductionAuditStatus', scope.row.sendAuditState)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{getEnum('OutboundOrderStatuses', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单标签" min-width="100">
      </el-table-column>
      <el-table-column label="操作" min-width="100">
        <template slot-scope="scope">
          <el-row>
            <el-button type="text" @click="onDetail(scope.row)" class="purchase-list-button">详情</el-button>
            <el-button v-if="canModify(scope.row)" type="text" @click="onModify(scope.row)"
              class="purchase-list-button">修改</el-button>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <!-- <div class="float-right"> -->
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <!-- </div> -->
    <el-row type="flex" justify="center" align="middle" style="margin-top: 20px" v-if="isSelect">
      <el-button class="sure-btn" @click="setSelectOrder">确定</el-button>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'OutboundOrderList',
    props: {
      page: {
        type: Object
      },
      isSelect: {
        type: Boolean,
        default: false
      }
    },
    computed: {},
    methods: {
      canModify(row) {
        if (!row.merchandiser || row.state == 'CANCELED' || row.merchandiser.uid != this.$store.getters.currentUser.uid) {
          return false;
        }
        return row.merchandiser.uid == this.$store.getters.currentUser.uid &&
          (row.sendAuditState == 'AUDITED_FAILED' || row.sendAuditState == 'NONE');
      },
      getCooperator(row) {
        return row.targetCooperator.type == 'ONLINE' ? row.targetCooperator.partner.name : row.targetCooperator.name;
      },
      onPageSizeChanged(val) {
        this.$emit('onAdvancedSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        this.$emit('onAdvancedSearch', val - 1);
      },
      onDetail(row) {
        this.$router.push('/sales/outboundOrder/' + row.id);
      },
      onModify(row) {
        this.$emit('onModify', row.id);
      },
      handleSelectionChange(val) {
        // 限制单选
        if (val.length > 1) {
          this.$refs.resultTable.toggleRowSelection(val[0], false);
          this.selectionRow = val[val.length - 1];
        } else if (val.length == 1) {
          this.selectionRow = val[val.length - 1];
        } else if (val.length == 0) {
          this.selectionRow = "";
        }
        this.$emit('onSelect', this.selectionRow);
      },
      rowClick(row) {
        if (this.selectionRow == "") {
          this.$refs.resultTable.toggleRowSelection(row, true);
        } else {
          if (this.selectionRow.id == row.id) {
            this.$refs.resultTable.toggleRowSelection(row, false);
          } else {
            this.$refs.resultTable.toggleRowSelection(this.selectionRow, false);
            this.$refs.resultTable.toggleRowSelection(row, true);
          }
        }
      },
      setSelectOrder () {
        this.$emit('setSelectOrder', this.selectionRow);
      }
    },
    data() {
      return {
        uid: this.$store.getters.currentUser.companyCode,
        selectionRow: ''
      }
    },
    created() {}
  }

</script>

<style scoped>
  /deep/ .el-table th>.cell .el-checkbox {
    display: none;
  }
</style>
