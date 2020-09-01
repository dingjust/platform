<template>
  <div class="contract-seal-list">
    <el-dialog :visible.sync="dialogOrderVisible" width="80%" :close-on-click-modal="false" append-to-body>
      <seal-form v-if="dialogOrderVisible" @closeDialog="dialogOrderVisible=false" @callback="onCallBack"/>
    </el-dialog>
    <div>
      <el-row type="flex" justify="center" align="middle">
        <h5>选择签章</h5>
      </el-row>
      <div class="opera-btn-row">
        <Authorized :permission="['AGREEMENT_SEAL_CREATE_DELETE']">
          <el-button type="text" class="common-btn" @click="onCreate">新建印章</el-button>
        </Authorized>
        <Authorized :permission="['AGREEMENT_SIGN']">
          <el-button class="product-select-btn common-btn" @click="onSelected">去签署</el-button>
        </Authorized>
      </div>
      <el-divider></el-divider>
      <template v-if="page.content.slice(0, 5).length > 0">
        <el-row type="flex" justify="start" align="middle">
          <template v-for="item in page.content.slice(0, 5)">
            <el-col :span="4" :key="item.code" :class="isSelect(item) ? 'seal-item seal-item-select' : 'seal-item'" 
                    @click.native="handleCurrentChange(item)">
              <el-row type="flex" justify="center" align="middle">
                <img style="width: 100px" :src="item.media.url">
              </el-row>
            </el-col>
          </template>
        </el-row>
        <el-row type="flex" justify="start" align="middle">
          <template v-for="item in page.content.slice(0, 5)">
            <el-col :span="4" :key="item.code" style="margin-left: 20px;">
              <el-row type="flex" justify="center" align="middle" style="margin-top: 10px">
                <h6 style="margin-bottom: 0px;">{{item.name}}</h6>
              </el-row>
            </el-col>
          </template>
        </el-row>
      </template>
      <template v-if="page.content.slice(5, 10).length > 0">
        <el-row type="flex" justify="start" align="middle" style="margin-top: 10px">
          <template v-for="item in page.content.slice(5, 10)">
            <el-col :span="4" :key="item.code" :class="isSelect(item) ? 'seal-item seal-item-select' : 'seal-item'" 
                    @click.native="handleCurrentChange(item)">
              <el-row type="flex" justify="center" align="middle">
                <img style="width: 100px" :src="item.media.url">
              </el-row>
            </el-col>
          </template>
        </el-row>
        <el-row type="flex" justify="start" align="middle">
          <template v-for="item in page.content.slice(5, 10)">
            <el-col :span="4" :key="item.code" style="margin-left: 20px;">
              <el-row type="flex" justify="center" align="middle" style="margin-top: 10px">
                <h6 style="margin-bottom: 0px;">{{item.name}}</h6>
              </el-row>
            </el-col>
          </template>
        </el-row>
      </template>
      <!-- <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight"
                highlight-current-row @current-change="handleCurrentChange" @selection-change="handleSelectionChange">
        <el-table-column  label="印章" fixed>
          <template slot-scope="scope">
            <img width="100px" height="100px" :src="scope.row.media.url">
          </template>
        </el-table-column>
        <el-table-column label="印章名称" prop="name" width="220" fixed></el-table-column>
      </el-table> -->
      <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                    @size-change="onPageSizeChanged"
                    @current-change="onCurrentPageChanged"
                    :current-page="page.number + 1"
                    :page-size="page.size"
                    :page-count="page.totalPages"
                    :total="page.totalElements">
      </el-pagination>
    </div>
  </div>
</template>

<script>
  import SealForm from '../../seal/SealForm'
  import Bus from '@/common/js/bus.js';

  export default {
    name: 'ContractSealList',
    props: ["page"],
    components: {
      SealForm
    },
    created(){
      Bus.$on('closeFrom', args => {
      this.dialogOrderVisible = false;
        Bus.$emit('closeSeal');
    });
    },
    methods: {
      isSelect (item) {
        return item.code === this.selectedItem.code;
      },
      onCreate() {
        this.dialogOrderVisible = true;
        // this.$router.push("SealForm");
        // this.fn.openSlider('创建', SealForm, '');
      },
      async onPageSizeChanged(val) {
        this.$emit('onSearchSeal', 0, val);
        // this._reset();

        // if(keyword == null){
        //   keyword = '';
        // }
        // const url = this.apis().getSealsList();
        // const result = await this.$http.post(url,{
        //   keyword: keyword
        // }, {
        //   page: val,
        //   size: 10
        // });
        // if (result["errors"]) {
        //   this.$message.error(result["errors"][0].message);
        //   return;
        // }
        // this.sealPage = result;

      },
      async onCurrentPageChanged(val) {
        this.$emit('onSearchSeal', val - 1, 10);
        // if(keyword == null){
        //   keyword = '';
        // }
        // const url = this.apis().getSealsList();
        // const result = await this.$http.post(url,{
        //   keyword: keyword
        // }, {
        //   page: val -1,
        //   size: 10
        // });
        // if (result["errors"]) {
        //   this.$message.error(result["errors"][0].message);
        //   return;
        // }
        // this.sealPage = result;

      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onSelected(item) {
        if (this.selectedItem == null || this.selectedItem.code == null) {
          this.$message.warning('请选择签章！');
          return;
        }

        this.$emit('onSealSelectChange',this.selectedItem );
      },
      handleSelectionChange(val) {
        this.selectedItem = val;
      },
      //选中行
      handleCurrentChange(val) {
        if (this.selectedItem.code === val.code) {
          this.selectedItem = {};
          return;
        }
        this.selectedItem = val;
      },
      onCallBack(){
        this.$emit('onSearchSeal');
      }
    },
    data() {
      return {
        selectedItem:{},
        dialogOrderVisible:false,
      }
    }
  }
</script>
<style scoped>
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
    width: 80px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    border: 0px solid #FFD60C;
    border-radius: 3px;
  }

  .common-btn {
    margin-right: 20px;
  }

  .el-table__body tr.current-row>td {
    background-color: #ffc107;
  }
  .v-modal{
    display: none;
  }

  .opera-btn-row {
    display: flex;
    justify-content: flex-end;
  }

  .contract-seal-list >>> .el-divider--horizontal {
    margin: 12px 0;
  }

  .seal-item {
    border-radius: 5px;
    margin-left: 20px;
    height: 100px;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .seal-item-select {
    box-shadow: 0px 0px 8px #FFD60C;
  }

  .seal-item:hover {
    box-shadow: 0px 0px 8px #FFD60C;
  }
</style>
