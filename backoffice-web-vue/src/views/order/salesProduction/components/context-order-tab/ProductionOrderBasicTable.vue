<template>
  <div>
    <el-table :data="orders" stripe style="width: 100%">
      <el-table-column label="生产订单号" min-width="130">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.code}}</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="产品" min-width="150">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
              <img width="54px" v-if="scope.row.product!=null" height="54px"
                :src="scope.row.product.images!=null&&scope.row.product.images.length!=0?scope.row.product.images[0].url:'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>{{scope.row.product!=null?scope.row.product.name:''}}</span>
              </el-row>
              <el-row>
                <span>货号:{{scope.row.product!=null?scope.row.product.skuID:''}}</span>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="生产订单状态" prop="status" :column-key="'status'">
        <template slot-scope="scope">
          <!-- <el-tag disable-transitions>{{getEnum('purchaseOrderStatuses', scope.row.status)}}</el-tag> -->
          <span>{{getEnum('purchaseOrderStatuses', scope.row.status)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="跟单员">
      </el-table-column>
      <el-table-column label="订单生成时间" min-width="100">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单标签">
      </el-table-column>
      <el-table-column label="订单状态">
        <!-- <template slot-scope="scope">
          <span>{{scope.row.status!=null? getEnum('SalesProductionAuditStatus', scope.row.auditState):''}}</span>
        </template> -->
      </el-table-column>
      <el-table-column label="操作" min-width="120">
        <template slot-scope="scope">
          <el-button type="text" @click="onProductDetail(scope.row)">查看</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'ProductionOrderBasicTable',
    components: {},
    props: {
      codes: {
        type: Array
      },
      taskIds: {
        type: Array
      },
      outboundOrderIds: {
        type: Array
      }
    },
    methods: {
      onProductDetail(row) {
        this.$router.push('/sales/productionOrder/' + row.id);
      },
      async getDetail(code) {
        const url = this.apis().getProductionOrderDetail(code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.orders.push(result);
      },
      async getOrdersByTaskIds(ids) {
        const url = this.apis().searchProductionByTaskIds();
        const result = await this.$http.post(url, {
          "productionTaskIds": ids
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.orders = result;
      },
      async getOrdersByOutboundOrderIds(ids) {
        const url = this.apis().searchProductionByTaskIds();
        const result = await this.$http.post(url, {
          "outboundOrderIds": ids
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.orders = result;
      },
    },
    data() {
      return {
        orders: []
      }
    },
    created() {
      //根据生产任务id查找
      if (this.taskIds != null && this.taskIds.length > 0) {
        this.getOrdersByTaskIds(this.taskIds);
      } else if (this.outboundOrderIds != null && this.outboundOrderIds.length > 0) {
        this.getOrdersByOutboundOrderIds(this.outboundOrderIds);
      }
    }
  }

</script>

<style scoped>

</style>
