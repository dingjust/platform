<template>
  <div class="animated fadeIn">
    <el-form :inline="true">
      <el-form-item label="">
        <el-input placeholder="请输入名称查询" v-model="queryFormData.keyword"></el-input>
      </el-form-item>
      <el-button type="text" @click="onSearch">查找</el-button>
      <Authorized :permission="['COMPANY_COOPERATOR_CREATE']">
        <el-button type="text" @click="jumpToCreate">添加合作商</el-button>
      </Authorized>
      <el-button class="product-select-btn" @click="onSure">确定</el-button>
    </el-form>      
    <el-tabs v-model="activeName" @tab-click="handleClick" v-if="categories && categories.length <= 0">
      <template v-for="item in statuses">
        <el-tab-pane :label="item.name" :name="item.code" :key="item.code"></el-tab-pane>
      </template>
    </el-tabs>
    <el-table ref="resultTable" stripe :data="page.content" highlight-current-row @current-change="handleCurrentChange"
      @selection-change="handleSelectionChange" :height="autoHeight">
      <el-table-column label="合作商名称" prop="name">
        <template slot-scope="scope">
          <el-row type="flex">
            <span v-if="scope.row.partner != null"> {{scope.row.partner.name}}</span>
            <span v-else> {{scope.row.name}}</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="">
        <template slot-scope="scope">
          <el-row type="flex">
            <el-tag :type="getTagType(scope.row.category)">{{getEnum('CooperatorCategory',scope.row.category)}}</el-tag>
          </el-row>
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
    <el-dialog :visible.sync="dialogVisible" width="80%" append-to-body :close-on-click-modal="false">
      <cooperator-form-page v-if="dialogVisible" :isFromDialog="true" @callback="callback"/>
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  const {
    mapActions,
    mapGetters,
    mapMutations
  } = createNamespacedHelpers('CooperatorModule');

  import CooperatorFormPage from '@/views/miscs/cooperator/form/CooperatorFormPage'
  export default {
    name: 'SupplierSelect',
    props: {
      //合作商类型
      categories: {
        type: Array,
        default: () => {
          return [];
        }
      }
    },
    components: {
      CooperatorFormPage
    },
    computed: {
      ...mapGetters({
        page: 'page',
      })
    },
    methods: {
      ...mapActions({
        searchAdvanced: 'searchAdvanced'
      }),
      callback () {
        this.dialogVisible = false;
        this.onSearch();
      },
      onPageSizeChanged(val) {
        this.onSearch(0, val);

        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onCurrentPageChanged(val) {
        this.onSearch(val - 1, 10);

        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onSearch(page, size) {
        let queryFormData = this.queryFormData;
        if (this.categories != null && this.categories.length > 0) {
          queryFormData.category = this.categories
        }
        const url = this.apis().getCooperators();
        this.searchAdvanced({
          url,
          queryFormData,
          page,
          size
        });
      },
      handleClick (tab, event) {
        this.queryFormData.category = [tab.name];
        this.onSearch();
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
            phone: this.selectSupplier.partner.contactPhone,
            payPlan: this.selectSupplier.payPlan,
            approvalStatus: this.selectSupplier.partner.approvalStatus
          };
        } else {
          result = {
            id: this.selectSupplier.id,
            name: this.selectSupplier.name,
            person: this.selectSupplier.contactPerson,
            phone: this.selectSupplier.contactPhone,
            payPlan: this.selectSupplier.payPlan,
            approvalStatus: this.selectSupplier.approvalStatus
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
        this.dialogVisible = true;
        // this.$router.push('/account/cooperator/cooperatorCreate');
      },
      getTagType(category) {
        switch (category) {
          case 'SUPPLIER':
            return 'success';
            break;
          case 'CUSTOMER':
            return 'warning';
            break;
          case 'FABRIC_SUPPLIER':
            return '';
          default:
            return 'info';
            break;
        }
      }
    },
    created() {
      this.onSearch();
    },
    data() {
      return {
        statuses: this.$store.state.EnumsModule.CooperatorCategory,
        suppliers: [],
        multipleSelection: [],
        selectSupplier: '',
        queryFormData: {
          type: '',
          keyword: '',
          category: ['SUPPLIER']
        },
        dialogVisible: false,
        activeName: 'SUPPLIER'
      }
    }
  }

</script>
<style scoped>
  .product-info {
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    font-size: 12px;
  }

  .el-table--striped .el-table__body tr.el-table__row--striped.current-row td {
    background-color: #ffc107;
  }

  .product-select-btn {
    width: 70px !important;
    /* height: 25px; */
    background: #FFD60C !important;
    /* font-weight: 400; */
    color: rgba(0, 0, 0, 0.85) !important;
    /* font-size: 10px; */
    /* border-radius: 0px; */
    border: 0px solid #FFD60C !important;
  }

  .el-table__body tr.current-row>td {
    background-color: #ffc107;
  }

</style>
