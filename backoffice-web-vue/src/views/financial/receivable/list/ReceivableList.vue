<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="外接订单号" prop="productionOrder.code"/>
      <!-- <el-table-column label="合同号" min-width="120px">
        <template slot-scope="scope">
          <template v-for="item in scope.row.productionOrder.agreements">
            <span :key="item.id">{{item.code}}</span>
          </template>
        </template>
      </el-table-column> -->
      <el-table-column label="关联SKU数" prop="itemSize"/>
      <el-table-column label="订单数量" prop="quantity"/>
      <el-table-column label="合作商" prop="belongTo.name"/>
      <!-- <el-table-column label="创建人" prop="creator.name" /> -->
      <el-table-column label="负责人" prop="productionOrder.creator.name" />
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{getEnum('financialState', scope.row.state)}}</span>
        </template>
      </el-table-column> -->
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
export default {
    name: 'ReceivableList',
    props: ['page'],
    components: {
    },
    computed: {
    },
    methods: {
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
      onDetail (row) {
        this.$emit('onDetail', row);
      }
    },
    data () {
      return {
      }
    },
    created () {
    },
    destroyed () {
      
    }
  }
</script>

<style scoped>

</style>