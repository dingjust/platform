<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="生产单号" min-width="130">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.code}}</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="产品名称" min-width="150">
        <template slot-scope="scope">
          <span class="ellipsis-name" :title="scope.row.entries[0].product.baseProductDetail.name">
            {{scope.row.entries[0].product.baseProductDetail.name}}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="品类">
        <template slot-scope="scope">
          <span>{{scope.row.quality}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单数量">
        <template slot-scope="scope">
          <span>{{scope.row.entries[0].product.baseProductDetail.category.parent.name}}-{{scope.row.entries[0].product.baseProductDetail.category.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建人">
        <template slot-scope="scope">
          <span>{{scope.row.entries[0].product.baseProductDetail.category.parent.name}}-{{scope.row.entries[0].product.baseProductDetail.category.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="负责人">
        <template slot-scope="scope">
          <span>{{scope.row.entries[0].product.baseProductDetail.category.parent.name}}-{{scope.row.entries[0].product.baseProductDetail.category.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="指定工厂">
        <template slot-scope="scope">
          <span>{{scope.row.entries[0].product.baseProductDetail.category.parent.name}}-{{scope.row.entries[0].product.baseProductDetail.category.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建日期">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="交货时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="status">
        <template slot-scope="scope">
          <!-- <el-tag disable-transitions>{{getEnum('purchaseOrderStatuses', scope.row.status)}}</el-tag> -->
          <span>{{judgeState(scope.row)}}</span>
          <!--          <span>{{getEnum('salesOrderStatuses', scope.row.status)}}</span>-->
        </template>
      </el-table-column>
      <el-table-column label="订单标签" min-width="100">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="100">
        <template slot-scope="scope">
          <el-row>
<!--            <el-button type="text" @click="onDetails(scope.row)" class="purchase-list-button">详情</el-button>-->
<!--            <el-divider direction="vertical"></el-divider>-->
<!--            <el-button type="text" @click="onDetails(scope.row)" class="purchase-list-button">删除</el-button>-->
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <!-- <div class="float-right"> -->
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                   :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <!-- </div> -->
  </div>
</template>

<script>
  export default {
    name: 'ProductionTaskList',
    props: ['page'],
    methods: {
      onPageSizeChanged(val) {
        // this._reset();
        //
        // if (this.$store.state.SalesOrdersModule.isAdvancedSearch) {
        //   this.$emit('onAdvancedSearch', val);
        //   return;
        // }
        //
        // this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        // if (this.$store.state.SalesOrdersModule.isAdvancedSearch) {
        //   this.$emit('onAdvancedSearch', val - 1);
        //   return;
        // }
        //
        // this.$emit('onSearch', val - 1);
        // this.$nextTick(() => {
        //   this.$refs.resultTable.bodyWrapper.scrollTop = 0
        // });
      },
    }
  }
</script>

<style scoped>

</style>
