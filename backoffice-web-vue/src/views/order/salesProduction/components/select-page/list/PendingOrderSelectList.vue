<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight" row-key="id" 
      @selection-change="handleSelectionChange"  @row-click="rowClick">
      <el-table-column type="selection" :reserve-selection="true" width="55"></el-table-column>
      <el-table-column label="业务订单号" min-width="130">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
            <el-tag type="info" effect="plain" :class="scope.row.originCompany == null ? 'business-tag' : 'pending-tag'">
              {{scope.row.originCompany == null ? '业务订单' : '线上接单'}}</el-tag>
          </el-row>
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.code}}</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="客户">
        <template slot-scope="scope">
          <span>{{cooperatorName(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建人" prop="creator.name">
      </el-table-column>
      <el-table-column label="生产负责人" prop="productionLeader.name">
      </el-table-column>
      <el-table-column label="创建日期">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="审批状态">
        <template slot-scope="scope">
          <span>{{scope.row.auditState!=null? getEnum('SalesProductionAuditStatus', scope.row.auditState):''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单状态">
        <template slot-scope="scope">
          <span>{{getEnum('SalesProductionOrderState', scope.row.state)}}</span>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
      <el-button class="sure-btn" @click="onSelectOrder">确定</el-button>
    </el-row>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions
  } = createNamespacedHelpers('SalesProductionOrdersModule');

  export default {
    name: 'PendingOrderSelectList',
    props: {
      page: {
        type: Object
      }
    },
    components: {},
    computed: {
    },
    methods: {
      cooperatorName (row) {
        if (row.originCompany != null) {
          return row.originCompany.name;
        } else {
          return row.originCooperator.type == 'ONLINE' ? row.originCooperator.partner.name : row.originCooperator.name;
        }
      },
      onPageSizeChanged(val) {
        this._reset();

        if (this.$store.state.SalesProductionOrdersModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.$store.state.SalesProductionOrdersModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          return;
        }

        this.$emit('onSearch', val - 1);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
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
      onSelectOrder () {
        this.$emit('onSelectOrder', this.selectionRow);
      }
    },
    data() {
      return {
        selectionRow: '',
        statuses: this.$store.state.SalesProductionOrdersModule.statuses,
        orderTypeTagMap: {
          'SALES_PLAN': {
            'color': '#ffd60c',
            'borderColor': '#ffd60c'
          },
          'SALES_ORDER': {
            'color': '#67c23a',
            'borderColor': '#67c23a'
          },
        }
      }
    }
  }

</script>
<style scoped>
  .purchase-list-button {
    color: #FFA403;
  }

  .ellipsis-name {
    width: 50px;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }

  .pending-tag {
    color: #67c23a;
    border-Color: #67c23a
  }

  .business-tag {
    color: #ffd60c;
    border-Color: #ffd60c
  }

  .sure-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 81px;
    height: 35px
  }

  /deep/ .el-table th>.cell .el-checkbox {
    display: none;
  }
</style>
