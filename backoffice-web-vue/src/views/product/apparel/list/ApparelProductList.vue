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
      <el-table-column label="款号" prop="skuID" min-width="120"></el-table-column>
      <el-table-column label="品类" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.category.name}}</span> </template>
      </el-table-column>
      <el-table-column v-if="isTenant()" label="所属" prop="belongTo" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.belongTo != undefined ? scope.row.belongTo.name:''}}</span>
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
          <el-button v-if="isFactory() && scope.row.approvalStatus==='unapproved'" type="text" icon="el-icon-edit"
            @click="onShelf(scope.row)">
            上架
          </el-button>
          <el-button v-if="(isFactory() || isTenant()) && scope.row.approvalStatus==='approved'" type="text" icon="el-icon-edit"
            @click="onOffShelf(scope.row)">
            下架
          </el-button>
          <el-button v-if="scope.row.approvalStatus==='unapproved'" type="text" icon="el-icon-edit" @click="onDelete(scope.row)">删除</el-button>
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
    computed: {
    },
    methods: {
      onPageSizeChanged (val) {
        this._reset();

        if (this.$store.state.ApparelProductsModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        if (this.$store.state.ApparelProductsModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          return;
        }

        this.$emit('onSearch', val - 1);
      },
      _reset () {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails (row) {
        this.$emit('onDetails', row);
      },
      onShelf (row) {
        this.$emit('onShelf', row);
      },
      onOffShelf (row) {
        if (this.isTenant()) {
          this.$confirm('您确定要下架该商品吗？', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this.$emit('platformOff', row);
          })
          return;
        }
        this.$emit('onOffShelf', row);
      },
      onDelete (row) {
        this.$confirm('您确定要删除该商品吗？删除以后不能恢复！', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          if (this.isTenant()) {
            this.$emit('platformDeleted', row);
            return;
          }
          this.$emit('onDelete', row);
        })
      },
      numberFormatter (val) {
        if (val.price !== null && val.price !== '' && val.price !== 'undefined') {
          return parseFloat(val.price).toFixed(2);
        }
      },
      handleSelectionChange (val) {
        this.multipleSelection = val;
      }
    },
    data () {
      return {
        multipleSelection: []
      };
    }
  };
</script>
