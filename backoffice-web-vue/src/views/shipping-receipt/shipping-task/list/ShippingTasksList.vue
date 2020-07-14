<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <!-- <el-table-column label="发货任务单号" prop="code" min-width="120px" fixed="left"></el-table-column> -->
      <el-table-column label="生产工单" prop="productionTaskOrder.code" min-width="120px">
        <template slot-scope="scope">
          <el-button type="text" v-if="scope.row.productionTaskOrder!=null"
            @click="onProductionOrderDetail(scope.row.productionTaskOrder.id)">{{scope.row.productionTaskOrder.code}}
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="产品名称" min-width="150">
        <template slot-scope="scope">
          <el-row v-if="scope.row.product.name!=null" type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
              <img width="54px" v-if="scope.row.product!=null" height="54px"
                :src="scope.row.product.thumbnail!=null&&scope.row.product.thumbnail.length!=0?scope.row.product.thumbnail.url:'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>{{scope.row.product.name}}</span>
              </el-row>
              <el-row>
                <span>货号:{{scope.row.product!=null?scope.row.product.skuID:''}}</span>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="品类" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.product.category.parent.name}} - {{scope.row.product.category.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单数量">
        <template slot-scope="scope">
          {{countTotalAmount(scope.row.colorSizeEntries)}}
        </template>
      </el-table-column>      
      <el-table-column label="负责人" prop="merchandiser.name"></el-table-column>
      <el-table-column label="交货时间">
        <template slot-scope="scope">
          <span
            v-if="scope.row.productionTaskOrder!=null">{{scope.row.productionTaskOrder.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="标签"></el-table-column>
      <el-table-column label="操作" fixed="right">
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
    name: 'ShippingTasksList',
    props: ['page'],
    components: {

    },
    computed: {

    },
    methods: {
      onDetail(row) {
        this.$emit('onDetail', row);
      },
      onProductionOrderDetail(id) {
        this.$router.push('/sales/productionOrder/' + id);
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
      //统计订单数量
      countTotalAmount(colorSizeEntries) {
        var amount = 0;
        if (colorSizeEntries != null) {
          colorSizeEntries.forEach(entry => {
            let num = parseFloat(entry.quantity);
            if (!Number.isNaN(num)) {
              amount += num;
            }
          });
        }
        return amount;
      },
    },
    data() {
      return {

      }
    },
    create() {

    }
  }

</script>

<style scope>

</style>
