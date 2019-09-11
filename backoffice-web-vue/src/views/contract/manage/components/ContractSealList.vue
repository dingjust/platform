<template>
  <div class="animated fadeIn" >
    <el-form :inline="true">
      <el-button class="product-select-btn" @click="onSelected">确定</el-button>
      <el-button class="product-select-btn" @click="onCreate">新建印章</el-button>
    </el-form>
    <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight"
              highlight-current-row @current-change="handleCurrentChange" @selection-change="handleSelectionChange">
      <el-table-column  label="印章" fixed>
        <template slot-scope="scope">
          <img width="100px" height="100px" :src="scope.row.media.url">
        </template>
      </el-table-column>
      <el-table-column label="印章名称" prop="name" width="220" fixed></el-table-column>
    </el-table>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged"
                   @current-change="onCurrentPageChanged"
                   :current-page="page.number + 1"
                   :page-size="page.size"
                   :page-count="page.totalPages"
                   :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  import SealForm from '../../seal/sealForm'
  import Bus from '@/common/js/bus.js';

  export default {
    name: 'ContractSealList',
    props: ["page"],
    methods: {
      onCreate() {
        Bus.$emit('openList');
        // this.$router.push("sealForm");
        this.fn.openSlider('创建', SealForm, '');
      },
      async onPageSizeChanged(val) {
        this._reset();

        if(keyword == null){
          keyword = '';
        }
        const url = this.apis().getSealsList();
        console.log(url)
        const result = await this.$http.post(url,{
          keyword: keyword
        }, {
          page: val,
          size: 10
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.sealPage = result;

      },
      async onCurrentPageChanged(val) {
        if(keyword == null){
          keyword = '';
        }
        const url = this.apis().getSealsList();
        console.log(url)
        const result = await this.$http.post(url,{
          keyword: keyword
        }, {
          page: val -1,
          size: 10
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.sealPage = result;

      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onSelected(item) {
        if(this.selectedItem == '' || this.selectedItem == null){
          return;
        }else{
          this.$emit('onSealSelectChange',this.selectedItem );
        }

      },
      handleSelectionChange(val) {
        this.selectedItem = val;
      },
      //选中行
      handleCurrentChange(val) {
        this.selectedItem = val;
      },
    },
    data() {
      return {
        selectedItem:{},
      }
    }
  }
</script>
<style>
  .purchase-list-button{
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
  .v-modal{
    display: none;
  }
</style>
