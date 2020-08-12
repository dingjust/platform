<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content">
      <el-table-column label="生产订单号" prop="code">
      </el-table-column>
      <el-table-column label="产品名称" prop="product.name">
      </el-table-column>
      <el-table-column label="产品款号" prop="product.skuID">
      </el-table-column>
      <el-table-column label="订单类型" prop="salesApplication">
        <template slot-scope="scope">
          <span> {{getEnum('salesApplication',scope.row.salesApplication)}}</span>
        </template>
      </el-table-column>
      <!--<el-table-column label="合作次数" v-if="!isFactory()" prop="belongTo.name">-->
      <!--<template slot-scope="scope">-->
      <!--<span v-if="scope.row.belongTo">{{scope.row.belongTo.name}}</span>-->
      <!--</template>-->
      <!--</el-table-column>-->
      <el-table-column label="订单状态" prop="status">
        <template slot-scope="scope">
          <span> {{getEnum('purchaseOrderStatuses',scope.row.status)}}</span>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <!-- <div class="float-right"> -->
    <el-pagination class="pagination-right" layout="total, sizes, prev,pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-sizes="[8,10,20]" :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <!-- </div> -->
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions,
    mapMutations
  } = createNamespacedHelpers('CooperatorModule');

  export default {
    name: 'CooperatorOrderList',
    props: ['page'],
    components: {},
    computed: {},
    methods: {
      ...mapMutations({
        setOrdersPageNumber: 'setOrdersPageNumber',
        setOrdersPageSize: 'setOrdersPageSize'
      }),
      ...mapActions({
        refresh: 'refresh'
      }),
      onPageSizeChanged(val) {
        this.setOrdersPageSize(val);
        this.setOrdersPageNumber(0);
        this.$emit('onSearch');
      },
      onCurrentPageChanged(val) {
        this.setOrdersPageNumber(val - 1);

        this.$emit('onSearch');
      },
      onDetails(row) {
        this.$emit('onDetails', row);
      },
      onDelete(row) {
        this.$emit('onDelete', row);
      }
    },
    data() {
      return {
        statuses: this.$store.state.CooperatorModule.statuses
      }
    }
  }

</script>
<style>
  .cooperator-list-button {
    color: #FFA403;
  }

</style>
