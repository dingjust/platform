<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight"
      @selection-change="handleSelectionChange">
      <!-- <el-table-column type="selection" width="32"></el-table-column> -->
      <el-table-column label="产品编号" prop="code" min-width="100"></el-table-column>
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
          <el-button type="text" @click="onBelongDetail(scope.row)">
            {{scope.row.belongTo != undefined ? scope.row.belongTo.name:''}}
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="创建人" prop="creator.name"></el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="240">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">详情</el-button>
          <Authorized :permission="['SAMPLE_CLOTHES_PRODUCT_CREATE']">
            <el-button type="text" icon="el-icon-edit" @click="onDelete(scope.row)">删除</el-button>
          </Authorized>
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
    name: 'SampleProductList',
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
        this.$emit('onAdvancedSearch', 0, val);

        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onCurrentPageChanged(val) {
        this.$emit('onAdvancedSearch', val - 1);

        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
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
