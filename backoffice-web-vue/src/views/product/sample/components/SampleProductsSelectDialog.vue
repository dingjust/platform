<template>
  <div class="animated fadeIn">
    <el-row type="flex" style="margin-bottom:10px">
      <div class="title-box">
        款式选择:
      </div>
    </el-row>
    <el-row type="flex" :gutter="20">
      <el-col :span="8">
        <el-input v-model="keyword" placeholder="根据产品名/编号/款号" @keyup.enter.native="onSubmit"></el-input>
      </el-col>
      <el-col :span="16">
        <el-button type="text" @click="onSearch">查找</el-button>
        <el-button type="text" @click="onNew">创建款式</el-button>
        <el-button class="sample-slelct-btn" size="mini" @click="onConfirm">确定</el-button>
      </el-col>
    </el-row>
    <el-row type="flex">
      <el-table ref="resultTable" stripe :data="page.content" highlight-current-row
        @current-change="handleCurrentChange" :height="autoHeight" :row-key="getRowKeys">
        <!--        <el-table-column type="selection" width="55"></el-table-column>-->
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
    <el-dialog :visible.sync="detailsVisiable" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sample-product-details-page v-if="detailsVisiable" @closeDialog="closeDialog" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  import SampleProductDetailsPage from "../details/SampleProductDetailsPage";

  const {
    mapGetters,
    mapMutations,
    mapActions
  } = createNamespacedHelpers('SampleProductsModule');

  export default {
    name: 'SampleProductsSelectDialog',
    components: {
      SampleProductDetailsPage
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
      onSearch(page, size) {
        this.setAdvancedSearch(false);
        const keyword = this.keyword;
        const url = this.apis().getSampleProducts();
        this.search({
          url,
          keyword,
          page,
          size
        });
      },
      getRowKeys(row) {
        return row.id;
      },
      handleCurrentChange(newRow, oldRow) {
        this.multipleSelection = newRow;
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
        this.$emit('onSelectSample', this.multipleSelection);
      }
    },
    data() {
      return {
        multipleSelection: '',
        keyword: '',
        detailsVisiable: false
      }
    },
    created() {
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

  .title-box{
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
