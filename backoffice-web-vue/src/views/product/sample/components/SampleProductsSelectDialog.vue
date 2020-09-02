<template>
  <div class="animated fadeIn">
    <el-row type="flex" style="margin-bottom:10px">
      <div class="title-box">
        款式选择:
      </div>
    </el-row>
    <div style="display: flex;">
      <div>
        <el-form :inline="true">
          <el-form-item label="">
            <el-input  nput v-model="queryFormData.keyword" placeholder="根据产品名/编号/款号" @keyup.enter.native="onSubmit"></el-input>
          </el-form-item>
          <!-- <el-form-item label="部门/人员">
            <dept-person-select ref="deptPersonSelect" :dataQuery="dataQuery" width="170"
                        :selectDept="queryFormData.depts" :selectPerson="queryFormData.users"/>
          </el-form-item> -->
        </el-form>
      </div>
      <div>
        <el-button type="text" @click="onSearch(0, 10)">查找</el-button>
        <!-- <el-button type="text" @click="onReset">重置</el-button> -->
        <Authorized :permission="['SAMPLE_CLOTHES_PRODUCT_CREATE']">
          <el-button type="text" @click="onNew">创建款式</el-button>
        </Authorized>
        <el-button class="sample-slelct-btn" size="mini" @click="onConfirm">确定</el-button>
      </div>
    </div>
    <el-row type="flex">
      <el-table ref="resultTable" stripe :data="page.content" @selection-change="handleSelectionChange"
        :height="autoHeight" :row-key="getRowKeys" @row-click="handleClick">
        <el-table-column type="selection" width="55" :selectable="canSelect" :reserve-selection="true"></el-table-column>
        <el-table-column label="产品图片" width="120">
          <template slot-scope="scope">
            <img width="54px" height="54px"
              :src="scope.row.thumbnail!=null&&scope.row.thumbnail.length!=0?scope.row.thumbnail.url:'static/img/nopicture.png'">
          </template>
        </el-table-column>
        <el-table-column label="产品名" prop="name" min-width="200"></el-table-column>
        <el-table-column label="编号" prop="code" min-width="100"></el-table-column>
        <el-table-column label="款号" prop="skuID" min-width="120"></el-table-column>
        <el-table-column label="品类" min-width="120">
          <template slot-scope="scope">
            <span>{{scope.row.category.name}}</span> </template>
        </el-table-column>
        <el-table-column label="状态" prop="approvalStatus">
          <template slot-scope="scope">
            <span>{{getEnum('approvalStatuses', scope.row.approvalStatus)}}</span>
          </template>
        </el-table-column>
      </el-table>
    </el-row>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-dialog :visible.sync="detailsVisiable" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sample-product-details-page v-if="detailsVisiable" @closeDialog="closeDialog"/>
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import SampleProductDetailsPage from "../details/SampleProductDetailsPage";
  import { DeptPersonSelect } from '@/components'

  const {
    mapGetters,
    mapMutations,
    mapActions
  } = createNamespacedHelpers('SampleProductsModule');

  export default {
    name: 'SampleProductsSelectDialog',
    props: {
      selectedRow: {
        type: Array,
        defautl: () => []
      },
      isSingleSelect: {
        type: Boolean,
        default: false
      }
    },
    components: {
      SampleProductDetailsPage,
      DeptPersonSelect
    },
    computed: {
      ...mapGetters({
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      ...mapMutations({
        setAdvancedSearch: 'isAdvancedSearch'
      }),
      canSelect (row) {
        let index;
        if (this.selectedRow && this.selectedRow.length > 0) {
          index = this.selectedRow.findIndex(item => item.product.id === row.id);
          if (index > -1) {
            return false
          }
        }
        return true;
      },
      async onSearch(page, size) {
        // if (this.queryFormData.users.length <= 0 && this.queryFormData.depts.length <= 0) {
        //   this.onResetQuery();
        // }
        const query = this.queryFormData;
        const url = this.apis().getSampleProducts();
        await this.searchAdvanced({
          url,
          query,
          page,
          size
        });
        // if (this.selectedRow && this.selectedRow.length > 0) {
        //   this.echoData();
        // }
      },
      onReset () {
        this.queryFormData.keyword = '';
        // this.$refs.deptPersonSelect.clearSelectData();
        // this.onResetQuery();
      },
      handleSelectionChange(val) {
        if (this.isSingleSelect) {
          if (val.length > 1) {
            this.$refs.resultTable.toggleRowSelection(val[0], false);
            this.multipleSelection = [val[val.length - 1]];
          } else if (val.length <= 1) {
            this.multipleSelection = val;
          }
        } else {
          this.multipleSelection = val;
        }
      },
      handleClick (row) {
        if (!this.canSelect(row)) {
          return;
        }

        if (this.isSingleSelect && this.multipleSelection.length >= 1) {
          if (row.id === this.multipleSelection[0].id) {
            this.$refs.resultTable.toggleRowSelection(this.multipleSelection[0], false);
            return;
          }
          this.$refs.resultTable.toggleRowSelection(this.multipleSelection[0], false);
        }
        this.$refs.resultTable.toggleRowSelection(row);
      },
      getRowKeys(row) {
        return row.id;
      },
      onPageSizeChanged(val) {
        this.onSearch(0, val);
      },
      onCurrentPageChanged(val) {
        this.onSearch(val - 1);
      },
      onNew() {
        this.detailsVisiable = true;
      },
      closeDialog() {
        this.onSearch(this.page.number);
        this.detailsVisiable = false;
      },
      onSubmit() {
        this.onSearch();
      },
      onConfirm() {
        if (this.multipleSelection != null && this.multipleSelection.length > 0) {
          this.$emit('onSelectSample', this.multipleSelection);
        } else {
          this.$message('请选择产品');
        }
      },
      // echoData () {
      //   let index;
      //   this.page.content.filter(item => {
      //     index = this.selectedRow.findIndex(val => val.product.id === item.id);
      //     if (index > -1) {
      //       this.$refs.resultTable.toggleRowSelection(item);
      //     }
      //   });
      // },
      onResetQuery () {
        this.queryFormData = JSON.parse(JSON.stringify(Object.assign(this.queryFormData, this.dataQuery)));
      },
    },
    data() {
      return {
        multipleSelection: [],
        keyword: '',
        detailsVisiable: false,
        queryFormData: {
          keyword: ''
        },
        dataQuery: {}
      }
    },
    created() {
      // this.dataQuery = this.getDataPerQuery('SAMPLE_CLOTHES_PRODUCT');
      // this.onResetQuery();
      this.onSearch();
    }
  }

</script>

<style scoped>
  .sample-slelct-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
  }

  /deep/ .el-table tbody tr:hover>td {
    background-color: #FFD60C !important
  }

  /deep/ .el-table__footer-wrapper tbody td,
  .el-table__header-wrapper tbody td {
    background-color: #FFD60C !important
  }

  /deep/ .el-table--striped .el-table__body tr.el-table__row--striped.current-row td {
    background-color: #ffc107;
  }

  /deep/ .el-table__body tr.current-row>td {
    background-color: #ffc107;
  }

  .title-box {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
