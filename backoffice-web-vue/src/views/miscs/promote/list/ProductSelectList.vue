<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" :reserve-selection="true" @select="onSelect" @select-all="onSelectAll"
              @selection-change="handleSelectionChange" @row-click="clickRow" :row-key="getRowKeys">
      <el-table-column type="selection" width="55" :reserve-selection="true" :selectable="selectable"/>
      <el-table-column label="产品图片" width="100">
        <template slot-scope="scope">
          <img width="54px" height="54px"
               :src="scope.row.thumbnail!=null&&scope.row.thumbnail.length!=0?scope.row.thumbnail.url:'static/img/nopicture.png'">
        </template>
      </el-table-column>
      <el-table-column label="产品名" prop="name" min-width="200"></el-table-column>
      <el-table-column label="款号" prop="skuID" min-width="120"></el-table-column>
      <el-table-column label="品类" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.category.name}}</span> </template>
      </el-table-column>
      <el-table-column v-if="isTenant()" label="供应商" prop="belongTo" min-width="120">
        <template slot-scope="scope">
          <el-button type="text" @click="onBelongDetail(scope.row)">
            {{scope.row.belongTo != undefined ? scope.row.belongTo.name:''}}
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="approvalStatus">
        <template slot-scope="scope">
          <span>{{getEnum('approvalStatuses', scope.row.approvalStatus)}}</span>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                   :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-dialog :visible.sync="factoryDetailsPageVisible" width="80%" class="purchase-dialog"
               :close-on-click-modal="false" append-to-body>
      <factory-details-read v-if="factoryDetailsPageVisible" :slotData="belongDetailsData"></factory-details-read>
    </el-dialog>
    <el-dialog :visible.sync="brandDetailsPageVisible" width="80%" class="purchase-dialog"
               :close-on-click-modal="false" append-to-body>
      <brand-details-read v-if="brandDetailsPageVisible" :slotData="belongDetailsData">
      </brand-details-read>
    </el-dialog>
  </div>
</template>

<script>
  import FactoryDetailsRead from '../../../user/company/factory/details/FactoryDetailsRead';
  import BrandDetailsRead from '../../../user/company/brand/details/BrandDetailsRead';
  export default {
    name: 'ProductSelectList',
    components: {BrandDetailsRead, FactoryDetailsRead},
    props: ['page'],
    methods: {
      onSelect (selection, row, flag) {
        const index = this.selectedItems.findIndex((item)=> item.id == row.id)
        if (this.selectedItems.length >= 20 && index == -1) {
          this.$refs.resultTable.toggleRowSelection(row);
          return;
        }
        if (index > -1) {
          this.selectedItems.splice(index, 1);
        } else {
          this.selectedItems.push(row);
        }

        this.$store.state.PromoteProductModule.promoteProductList = this.selectedItems;
      },
      onSelectAll (selection) {
        console.log(selection)
        console.log(this.selectedItems)
        let arr = [];
        selection.forEach(item => {
          const flag = this.selectedItems.some(val => {
            return item.id == val.id;
          })
          if (!flag) {
            arr.push(item);
          }
        })
        if (arr.length > 0) {
          arr.forEach(row => {
            this.onSelect(null, row);
          })
        } else {
          this.page.content.forEach(item => {
            const index = this.selectedItems.findIndex((row)=> item.id == row.id)
            if (index > -1) {
              this.selectedItems.splice(index, 1);
            }
          });
        }
      },
      clickRow (row) {
        if (this.selectedItems.length < 20) {
          this.$refs.resultTable.toggleRowSelection(row);
          this.onSelect([], row);
        } else if (this.selectedItems.length >= 20) {
          const flag = this.selectedItems.find(function (item) {
            return item.id == row.id;
          })
          if (flag) {
            this.$refs.resultTable.toggleRowSelection(row);
            this.onSelect([], row);
          }
        }
      },
      getRowKeys (row) {
        return row.id;
      },
      selectable (row, index) {
        if (this.selectedItems.length < 20) {
          return true;
        }
        const flag = this.selectedItems.find(function (item) {
          return item.id == row.id;
        })
        return flag;
      },
      handleSelectionChange (val) {
        // this.$store.state.PromoteProductModule.promoteProductList = Object.assign([], this.selectedItems);
      },
      onPageSizeChanged (val) {
        this._reset();

        if (this.$store.state.ApparelProductsModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', val);
      },
      onCurrentPageChanged (val) {
        if (this.$store.state.ApparelProductsModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          return;
        }

        this.$emit('onSearch', val - 1);
      },
      async onBelongDetail (item) {
      // 工厂
        if (item.belongTo.type == 'FACTORY') {
          let url = this.apis().getFactory(item.belongTo.uid);
          if (this.isTenant()) {
            url += '?sort=creationtime,desc';
          }
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.belongDetailsData = result;
          this.factoryDetailsPageVisible = true;
        } else if (item.belongTo.type == 'BRAND') {
        // 品牌
          let url = this.apis().getBrand(item.belongTo.uid);
          if (this.isTenant()) {
            url += '?sort=creationtime,desc';
          }
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          if (result.duties == null || result.duties == undefined) {
            result.duties = '经理';
          }
          this.belongDetailsData = result;
          this.brandDetailsPageVisible = true;
        } else {

        }
      },
      // 回显
      showProduct () {
        const list = this.$store.state.PromoteProductModule.promoteProductList;
        const content = this.page.content;
        console.log(list)
        console.log(content)
        if (list.length > 0) {
          content.forEach(item => {
            list.forEach(val => {
              if (val.product && item.id === val.product.id) {
                this.$refs.resultTable.toggleRowSelection(item);
              }
            })
          })
        }
        list.forEach(item => {
          this.selectedItems = [];
          if (item.product) {
            this.selectedItems.push(item.product);
          } else {
            this.selectedItems.push(item);
          }
        })
      }
    },
    watch: {
      'page': function (nVal, oVal) {
        if (nVal) {
          this.showProduct();
        }
      }
    },
    data () {
      return {
        belongDetailsData: '',
        factoryDetailsPageVisible: false,
        brandDetailsPageVisible: false,
        selectedItems: []
      }
    },
    created () {
      this.$nextTick(() => {
        this.showProduct();
      })
    }
  }
</script>

<style scoped>
  .table-style {
    border: solid #DCDFE6 1px;
    border-radius: 5px;
    padding: 2px 0px 12px 0px;
  }
</style>
