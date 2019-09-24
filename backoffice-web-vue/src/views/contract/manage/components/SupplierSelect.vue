<template>
  <div class="animated fadeIn">
    <el-form :inline="true">
      <el-form-item label="">
        <el-input placeholder="请输入名称查询" v-model="queryFormData.keyword"></el-input>
      </el-form-item>
      <el-button type="text" @click="onSearch">查找</el-button>
      <el-button type="text" @click="jumpToCreate">添加合作商</el-button>
      <el-button class="product-select-btn" @click="onSure">确定</el-button>
    </el-form>
    <el-table ref="resultTable" stripe :data="page.content" highlight-current-row @current-change="handleCurrentChange"
      @selection-change="handleSelectionChange" :height="autoHeight">
      <el-table-column label="合作商名称" prop="name">
        <template slot-scope="scope">
          <span v-if="scope.row.partner != null"> {{scope.row.partner.name}}</span>
          <span v-else> {{scope.row.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="联系人" prop="contactPerson">
        <template slot-scope="scope">
          <span v-if="scope.row.partner != null"> {{scope.row.partner.contactPerson}}</span>
          <span v-else> {{scope.row.contactPerson}}</span>
        </template>
      </el-table-column>
      <el-table-column label="联系方式" prop="contactPhone">
        <template slot-scope="scope">
          <span v-if="scope.row.partner != null"> {{scope.row.partner.contactPhone}}</span>
          <span v-else> {{scope.row.contactPhone}}</span>
        </template>
      </el-table-column>
      <el-table-column label="类型" prop="type">
        <template slot-scope="scope">
          <span> {{getEnum('CooperatorType',scope.row.type)}}</span>
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
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions,
    mapGetters,
  } = createNamespacedHelpers('CooperatorModule');

  export default {
    name: 'SuppliersSelect',
    computed: {
      ...mapGetters({
        page: 'page',
        queryFormData: 'queryFormData'
      })
    },
    methods: {
      ...mapActions({
        searchAdvanced: 'searchAdvanced'
      }),
      onPageSizeChanged(val) {
        this._reset();

        if (this.$store.state.CooperatorModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.$store.state.CooperatorModule.isAdvancedSearch) {
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
      onSearch(page, size) {
        const queryFormData = {'type':'online'};
        const url = this.apis().getCooperators();
        this.searchAdvanced({
          url,
          queryFormData,
          page,
          size
        });
      },
      numberFormatter(val) {
        if (val.price !== null && val.price !== '' && val.price !== 'undefined') {
          return parseFloat(val.price).toFixed(2);
        }
      },
      handleSelectionChange(val) {
        this.multipleSelection = val;
      },
      //选中行
      handleCurrentChange(val) {
        this.selectSupplier = val;
      },
      onSure() {
        var result = {};
        if (this.selectSupplier.partner != null) {
          result = {
            id: this.selectSupplier.id,
            name: this.selectSupplier.partner.name,
            person: this.selectSupplier.partner.contactPerson,
            phone: this.selectSupplier.partner.contactPhone
          };
        } else {
          result = {
            id: this.selectSupplier.id,
            name: this.selectSupplier.name,
            person: this.selectSupplier.contactPerson,
            phone: this.selectSupplier.contactPhone
          };
        }
        this.$emit('onSelect', result);
      },
      getCooperator(cooperator) {
        if (cooperator.partner != null) {
          return {
            name: cooperator.partner.name,
            person: cooperator.partner.contactPerson,
            phone: cooperator.partner.contactPhone
          };
        } else {
          return {
            name: cooperator.name,
            person: cooperator.contactPerson,
            phone: cooperator.contactPhone
          };
        }
      },
      jumpToCreate() {
        this.$router.push('/miscs/cooperator/cooperatorCreate');
      }
    },
    created() {
      this.onSearch();
    },
    data() {
      return {
        statuses: this.$store.state.CooperatorModule.statuses,
        suppliers: [],
        multipleSelection: [],
        selectSupplier: '',
      }
    }
  }

</script>
<style>
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
    height: 25px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    border: 0px solid #FFD60C;
  }

  .el-table__body tr.current-row>td {
    background-color: #ffc107;
  }

</style>
