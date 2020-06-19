<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column type="selection" width="55"/>
      <el-table-column label="发货任务单号" prop="code" min-width="120"></el-table-column>
      <el-table-column label="产品名称" min-width="150">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
              <img width="54px" v-if="scope.row.productionEntry.product!=null" height="54px"
                :src="scope.row.productionEntry.product.thumbnail!=null&&scope.row.productionEntry.product.thumbnail.length!=0?scope.row.productionEntry.product.thumbnail.url:'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>{{scope.row.productionEntry.product.name}}</span>
              </el-row>
              <el-row>
                <span>货号:{{scope.row.productionEntry.product!=null?scope.row.productionEntry.product.skuID:''}}</span>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="品类" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.productionEntry.product.category.parent.name}} - {{scope.row.productionEntry.product.category.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单数量"></el-table-column>
      <el-table-column label="创建人"></el-table-column>
      <el-table-column label="负责人"></el-table-column>
      <el-table-column label="发布任务"></el-table-column>
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
    name: 'ShippingOrdersList',
    props: ['page'],
    components: {

    },
    computed: {

    },
    methods: {
      onDetail (row) {
        this.$emit('onDetail', row);
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
      }
    },
    data () {
      return {

      }
    },
    create () {
      
    }
  }
</script>

<style scope>

</style>