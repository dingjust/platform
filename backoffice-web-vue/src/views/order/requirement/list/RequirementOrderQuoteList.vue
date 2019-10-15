<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content">
      <el-table-column label="发布时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="公司名称" prop="belongTo.name" fixed>
      </el-table-column>
      <el-table-column label="报价" prop="unitPrice">
        <template slot-scope="scope">
          <span>订单报价：</span><span style="color: red">{{'￥'+scope.row.unitPrice}}</span>
        </template>
      </el-table-column>
      <el-table-column label="交货时间">
        <template slot-scope="scope">
          <span>{{scope.row.expectedDeliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="打样费" prop="costOfSamples">
        <template slot-scope="scope">
          <span style="color: red">{{'￥'+scope.row.costOfSamples}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="300px">
        <template slot-scope="scope">
          <slot name="operations" :item="scope.row"></slot>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged"
                   @current-change="onCurrentPageChanged"
                   :current-page="page.number + 1"
                   :page-size="page.size"
                   :page-sizes="[8, 10, 20]"
                   :page-count="page.totalPages"
                   :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions, mapMutations
  } = createNamespacedHelpers('RequirementOrdersModule');

  export default {
    name: 'RequirementOrderQuoteList',
    props: ['page'],
    components: {},
    computed: {},
    methods: {
      ...mapMutations({
        setOrdersPageNumber: 'setOrdersPageNumber',
        setOrdersPageSize: 'setOrdersPageSize'
      }),
      ...mapActions({
        searchQuotesAdvanced: 'searchQuotesAdvanced'
      }),
      onPageSizeChanged (val) {
        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        this.$emit('onSearch',val-1);
      },
      onDetails (row) {
        this.$emit('onDetails', row);
      },
      onDelete (row) {
        this.$emit('onDelete', row);
      }
    },
    data () {
      return {
      }
    }
  }
</script>
<style>

</style>
