<template>
  <div class="animated fadeIn">
    <el-dialog :visible.sync="dialogTableVisible" width="80%">
      <contract-details />
    </el-dialog>
    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange" v-if="isHeightComputed"
      :height="autoHeight">
      <el-table-column label="合同名称" fixed>
        <template slot-scope="scope">
          <span>
            <el-link @click="dialogTableVisible = true">{{scope.row.code}}</el-link>
          </span>
        </template>
      </el-table-column>
      <el-table-column label="合同编号" prop="code"></el-table-column>
      <el-table-column label="签署对象" v-if="!isBrand()" prop="belongTo.name">
        <template slot-scope="scope">
          <span v-if="scope.row.purchaser">{{scope.row.purchaser.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="签署对象" v-if="!isFactory()" prop="belongTo.name">
        <template slot-scope="scope">
          <span v-if="scope.row.belongTo">{{scope.row.belongTo.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.expectedDeliveryDate | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="当前状态" prop="status" :column-key="'status'" :filters="statuses">
        <template slot-scope="scope">
          <!-- <el-tag disable-transitions></el-tag> -->
          {{getEnum('purchaseOrderStatuses', scope.row.status)}}
        </template>
      </el-table-column>
      <!-- <el-table-column label="创建时间" prop="expectedDeliveryDate">
        <template slot-scope="scope">
          <span>{{scope.row.expectedDeliveryDate | formatDate}}</span>
        </template>
      </el-table-column> -->
      <el-table-column label="操作" width="250">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">下载</el-button>
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">拒签</el-button>
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">签署</el-button>
          <!-- <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">撤回</el-button> -->
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
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions
  } = createNamespacedHelpers('PurchaseOrdersModule');

  import ContractDetails from "../components/ContractDetails";

  export default {
    name: 'ContractSearchResultList',
    props: ["page"],
    components: {
      ContractDetails
    },
    computed: {},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      handleFilterChange(val) {
        this.statuses = val.status;

        this.$emit('onSearch', 0);
      },
      onPageSizeChanged(val) {
        this._reset();

        if (this.$store.state.PurchaseOrdersModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.$store.state.PurchaseOrdersModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          return;
        }

        this.$emit('onSearch', val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(row) {
        this.$emit('onDetails', row);
      },
    },
    data() {
      return {
        statuses: this.$store.state.PurchaseOrdersModule.statuses,
        dialogTableVisible: false
      }
    }
  }

</script>
<style>
  .el-table th {
    background-color: #FAFBFC;
  }

  .el-dialog__body {
    padding-left: 20px;
    padding-right: 0px;
    padding-bottom: 30px;
    padding-top: 0px;
    color: #606266;
    font-size: 14px;
    word-break: break-all;
  }

</style>
