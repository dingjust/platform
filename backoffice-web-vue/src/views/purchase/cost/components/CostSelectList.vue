<!--
* @Description: 成本单选择列表
* @Date 2021/03/03 14:06
* @Author L.G.Y
-->
<template>
  <div class="animated fadeIn">
    <div class="stock-toolbar">
      <el-form :inline="true">
        <div class="form-container">
          <div>
            <el-form-item label="订单信息">
              <el-input v-model="queryFormData.keyword" placeholder="请输入订单信息"></el-input>
            </el-form-item>
            <el-button-group>
              <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
              <el-button native-type="reset" @click="onReset">重置</el-button>
            </el-button-group>
          </div>
        </div>
      </el-form>
    </div>
    <div>
      <el-table ref="resultTable" stripe="" :data="page.content" :height="autoHeight"
        row-key="id" @selection-change="handleSelectionChange" @row-click="rowClick">
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column label="单号" prop="code"></el-table-column>
        <el-table-column label="关联工单" prop="productionOrder.code"></el-table-column>
        <el-table-column label="创建人" prop="creator.name"></el-table-column>
        <el-table-column label="创建时间" min-width="80">
          <template slot-scope="scope">
            <span>{{scope.row.creationtime | timestampToTime}}</span>
          </template>
        </el-table-column>
      </el-table>
      <div class="pt-2"></div>
      <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
        @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
        :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
      </el-pagination>
    </div>
    <el-row type="flex" justify="center" style="margin-top:20px">
      <el-button round class="submit-btn" @click="onSubmit">确定</el-button>
    </el-row>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex';

const { mapGetters, mapActions } = createNamespacedHelpers(
  'CostOrderModule'
);

export default {
  name: 'CostSelectList',
  computed: {
    ...mapGetters({
      page: 'page'
    })
  },
  data () {
    return {
      queryFormData: {
        keyword: '',
        statuses: 'PENDING_ACCOUNT'
      },
      multipleSelection: []
    }
  },
  methods: {
    ...mapActions({
      searchAdvanced: 'searchAdvanced'
    }),
    onAdvancedSearch (page, size) {
      const query = this.queryFormData;
      const url = this.apis().searchCostOrder();
 
      this.searchAdvanced({url, query, page, size});
    },
    onReset () {
      this.queryFormData.keyword = '';
    },
    onPageSizeChanged(val) {
      this.onAdvancedSearch(0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged(val) {
      this.onAdvancedSearch(val - 1);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    handleSelectionChange (val) {
      if (val.length > 1) {
        this.$refs.resultTable.toggleRowSelection(val[0]);
        this.multipleSelection = [val[1]];
      } else {
        this.multipleSelection = val;
      }
    },
    rowClick (val) {
      this.$refs.resultTable.toggleRowSelection(val);
    },
    onSubmit () {
      this.$emit('onSelectCost', this.multipleSelection[0]);
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>
  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }

  .form-container {
    display: flex;
    justify-content: space-between;
    align-items: top;
  }

  .stock-toolbar >>> .el-form-item {
    margin-bottom: 0px;
  }

  /deep/ .el-table th>.cell .el-checkbox {
    display: none;
  }

  .submit-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
    width: 200px;
  }
</style>