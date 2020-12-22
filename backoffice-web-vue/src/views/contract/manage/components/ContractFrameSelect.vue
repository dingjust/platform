<template>
  <div class="animated fadeIn">
    <div style="height: 50px;">
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入合同编号/合同名称/签订对象" v-model="keyword"></el-input>
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
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" highlight-current-row  @current-change="handleCurrentChange"
        @selection-change="handleSelectionChange">
<!--      <el-table-column type="selection" width="55" :reserve-selection="true">-->
<!--      </el-table-column>-->
      <el-table-column label="合同编号" max-width="60">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.code}}</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="合同名称" max-width="60">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
<!--            <span>{{scope.row.title}}</span>-->
            <span class="ellipsis-name" :title="scope.row.title">
              {{scope.row.title}}
            </span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="签订对象" max-width="60">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.partner}}</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="合同有效期" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.validityStart | formatDate}} — {{scope.row.validityEnd | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="签订时间" max-width="60">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <!-- </div> -->
  </div>
</template>

<script>
  export default {
    name: 'ContractFrameSelect',
    props: ['orderSelectFiles'],
    components: {},
    computed: {},
    methods: {
      async onSearch (page, size) {
        let id = '';
        let companyUid = '';
        if (this.orderSelectFiles && this.orderSelectFiles.length > 0) {
          if (this.orderSelectFiles[0].targetCooperator.type === 'ONLINE') {
            id = this.orderSelectFiles[0].targetCooperator.partner.id;
            companyUid = this.orderSelectFiles[0].targetCooperator.partner.uid;
          } else {
            id = this.orderSelectFiles[0].targetCooperator.id;
          }
        }

        const keyword = this.keyword;
        const url = this.apis().getContractsList();
        const result = await this.$http.post(url, {
          type: 'KJXY',
          parnterCooperator: id,
          partyACompany: companyUid,
          state: 'COMPLETE',
          title: keyword
        }, {
          page: page,
          size: size
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.page = result;
      },
      onReset () {
        this.keyword = '';
      },
      async onPageSizeChanged (val) {
        this.onSearch(0, val);
        
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      async onCurrentPageChanged (val) {
        this.onSearch(val - 1, 10)

        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onSelected () {
        // if (item.code == this.selectedItem.code) {
        //   //空选择
        //   this.selectedItem = {};
        // } else {
        //   this.selectedItem = item;
        // }
        this.$emit('onContractSelectSure', this.selectedItem);
      },
      handleSelectionChange (val) {
        this.selectedItems = val;
      },
      // 选中行
      handleCurrentChange (val) {
        this.selectedItem = val;
      }
    },
    data () {
      return {
        statuses: this.$store.state.PurchaseOrdersModule.statuses,
        selectedItem: {},
        keyword: '',
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        }
      }
    },
    created () {
      this.onSearch(0, 10);
    }
  }
</script>
<style>
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
  .ellipsis-name {
    width: 150px;
    white-space:nowrap;
    text-overflow:ellipsis;
    overflow:hidden;
  }
</style>
