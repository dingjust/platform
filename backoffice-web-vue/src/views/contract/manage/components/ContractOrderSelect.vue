<template>
  <div class="animated fadeIn">
    <div style="height: 50px;">
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入生产订单号/产品货号/品牌查询" v-model="queryFormData.name"></el-input>
        </el-form-item>
        <el-form-item label="">
          <el-button type="primary" class="toolbar-search_input" @click="onSearch">查找</el-button>
        </el-form-item>
        <el-form-item label="">
          <el-button  native-type="reset" @click="onReset">重置</el-button>
        </el-form-item>
        <el-form-item label="">
          <el-button type="primary" class="toolbar-search_input" @click="onSelected">确定</el-button>
        </el-form-item>
      </el-form>
    </div>
    <!-- <el-tabs v-model="activeName" @tab-click="handleClick">
      <template v-for="item in statuses">
        <el-tab-pane :label="tabName(item)" :name="item.code" :key="item.code"></el-tab-pane>
      </template>
    </el-tabs> -->
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" row-key="id"
      @selection-change="handleSelectionChange"  @row-click="rowClick">
      <el-table-column type="selection" :reserve-selection="true" width="55"></el-table-column>
      <el-table-column label="外发订单号" prop="code"></el-table-column>
      <el-table-column label="合作商">
        <template slot-scope="scope">
          <span>{{getCooperator(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="关联产品数" prop="entrySize"></el-table-column>
      <el-table-column label="跟单员" prop="merchandiser.name"></el-table-column>
      <el-table-column label="创建时间" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
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
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  export default {
    name: 'ContractOrderSelect',
    props: ['isSelectFile'],
    components: {},
    computed: {
    },
    methods: {
      async onSearch (page, size) {
        let _page = 0;
        let _size = 10;
        if (page && page instanceof Number) {
          _page = page;
        }
        if (size) {
          _size = size;
        }
        console.log(_page);
        const query = this.queryFormData;
        const url = this.apis().getoutboundOrdersList();
        const result = await this.$http.post(url, query, {
          page: _page,
          size: _size
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.page = result;
        // this.outboundOrderStateCount();
      },
      async outboundOrderStateCount() {
        const url = this.apis().outboundOrderStateCount();
        const result = await this.$http.post(url, this.queryFormData);
        if (result['errors']) {
          this.stateCount = {};
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.stateCount = {};
          this.$message.error(result.msg);
          return;
        }
        this.stateCount = result.data;
      },
      tabName(tab) {
        if (this.stateCount.hasOwnProperty(tab.code)) {
          return tab.name + '(' + this.stateCount[tab.code] + ')';
        }
        return tab.name;
      },
      handleClick(tab, event) {
        this.queryFormData.state = tab.name;
        this.onSearch(0, 10);
      },
      onReset () {
        this.queryFormData.keyword = '';
      },
      onPageSizeChanged (val) {
        this.onSearch(0, val);

        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onCurrentPageChanged (val) {
        this.onSearch(val - 1, 10);

        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      getCooperator(row) {
        return row.targetCooperator.type == 'ONLINE' ? row.targetCooperator.partner.name : row.targetCooperator.name;
      },
      handleSelectionChange (val) {
        // 限制单选
        if (val.length > 1) {
          this.$refs.resultTable.toggleRowSelection(val[0], false);
          this.selectionRow = val[val.length - 1];
        } else if (val.length == 1) {
          this.selectionRow = val[val.length - 1];
        } else if (val.length == 0) {
          this.selectionRow = "";
        }
      },
      rowClick (row) {
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
      onSelected () {
        this.$emit('onOrderSelectChange', [this.selectionRow]);
      }
    },
    data () {
      return {
        selectionRow: '',
        activeName: 'AUDIT_PASSED',
        stateCount: {},
        statuses: [{
          code: 'AUDIT_PASSED',
          name: '生产中'
        }, {
          code: 'COMPLETED',
          name: '已完成'
        }],
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        },
        queryFormData: {
          keyword: '',
          name: '',
          // state: 'AUDIT_PASSED',
          merchandiserPk: 'isMyself',
          states: ['AUDIT_PASSED', 'COMPLETED'],
          agreement: 'NOT_HAVE'
        },
      }
    },
    created () {
      this.onSearch(0, 10);
    }
  }
</script>
<style scoped>
  .purchase-list-button {
    color: #FFA403;
  }

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
    height: 30px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    border: 0px solid #FFD60C;
    margin-top: 10px;
  }

  .el-table__body tr.current-row>td {
    background-color: #ffc107;
  }

  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  /deep/ .el-table th>.cell .el-checkbox {
    display: none;
  }

</style>
