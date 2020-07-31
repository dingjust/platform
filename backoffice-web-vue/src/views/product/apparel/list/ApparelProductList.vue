<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight"
      @selection-change="handleSelectionChange">
      <!-- <el-table-column type="selection" width="32"></el-table-column> -->
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
      <el-table-column v-if="isTenant()" label="所属" prop="belongTo" min-width="120">
        <template slot-scope="scope">
          <el-button type="text" @click="onBelongDetail(scope.row)">
            {{scope.row.belongTo != undefined ? scope.row.belongTo.name:''}}
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="approvalStatus">
        <template slot-scope="scope">
          <span>{{getEnum('approvalStatuses', scope.row.approvalStatus)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="240">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">详情</el-button>
          <el-button v-if="approvedShow(scope.row)" type="text" icon="el-icon-edit" @click="onShelf(scope.row)">
            上架
          </el-button>
          <el-button v-if="unapprovedShow(scope.row)" type="text" icon="el-icon-edit" @click="onOffShelf(scope.row)">
            下架
          </el-button>
          <el-button :disabled="!remove(scope.row)" type="text" icon="el-icon-edit"
                     @click="onDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  export default {
    name: 'ApparelProductList',
    props: ['page'],
    computed: {},
    methods: {
      approvedShow(row) {
        return this.isFactory() && row.approvalStatus === 'unapproved';
      },
      unapprovedShow(row) {
        return this.isFactory() && row.approvalStatus === 'approved';
      },
      remove(row) {
        return row.approvalStatus === 'unapproved';
      },
      onPageSizeChanged(val) {
        this._reset();

        if (this.$store.state.ApparelProductsModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.$store.state.ApparelProductsModule.isAdvancedSearch) {
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
      onBelongDetail(row) {
        this.$emit('onBelongDetail', row);
      },
      onShelf(row) {
        if (row.productType == null || row.productType.length <= 0 || row.productType.indexOf('FUTURE_GOODS') > -1) {
          console.log(row.productType);
          if (row.steppedPrices == null || row.steppedPrices.length <= 0 || row.basicProduction == null ||
            row.productionIncrement == null || row.productionDays == null) {
            this.$message.error('价格设置资料未完善，不可上架');
            return;
          }
          let flag = false;
          row.steppedPrices.some((p) => {
            if (p.minimumQuantity == null || p.price == null) {
              flag = true;
              return true;
            }
          });
          if (flag) {
            this.$message.error('价格设置资料未完善，不可上架');
            return;
          }
        }

        if (row.productType != null && (row.productType.indexOf('SPOT_GOODS') > -1 || row.productType.indexOf(
            'TAIL_GOODS') > -1)) {
          if (row.spotSteppedPrices == null || row.spotSteppedPrices.length <= 0 || row.deliveryDays == null) {
            this.$message.error('现货/库存尾货价格设置资料未完善，不可上架');
            return;
          }
          let flag = false;
          row.spotSteppedPrices.some((p) => {
            if (p.minimumQuantity == null || p.price == null) {
              flag = true;
              return true;
            }
          });
          if (flag) {
            this.$message.error('现货/库存尾货价格设置资料未完善，不可上架');
            return;
          }
          var totalQuality = this.totalQuality(row.colorSizes);
          row.spotSteppedPrices.sort(function (a, b) {
            return a.minimumQuantity - b.minimumQuantity;
          });
          if (totalQuality < row.spotSteppedPrices[0].minimumQuantity) {
            this.$message.error('库存总数量小于现货/库存最小起订量，不可上架');
            return;
          }
        }

        this.$emit('onShelf', row);
      },
      onOffShelf(row) {
        this.$emit('onOffShelf', row);
      },
      onDelete(row) {
        this.$emit('onDelete', row);
      },
      numberFormatter(val) {
        if (val.price !== null && val.price !== '' && val.price !== 'undefined') {
          return parseFloat(val.price).toFixed(2);
        }
      },
      handleSelectionChange(val) {
        this.multipleSelection = val;
      },
      totalQuality(colorSizes) {
        var total = 0;
        colorSizes.forEach((colorSize) => {
          if (colorSize.sizes != null) {
            colorSize.sizes.forEach((size) => {
              if (size.quality != null) {
                total += size.quality;
              }
            });
          }
        });
        return total;
      }
    },
    data() {
      return {
        multipleSelection: []
      };
    }
  };
</script>
