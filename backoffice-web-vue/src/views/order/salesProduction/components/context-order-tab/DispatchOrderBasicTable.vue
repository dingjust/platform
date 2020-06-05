<template>
  <div>
    <el-table :data="orders" stripe style="width: 100%">
      <el-table-column label="生产工单号">
      </el-table-column>
      <el-table-column label="产品" min-width="150">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
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
      <el-table-column label="生产工厂">
      </el-table-column>
      <el-table-column label="当前进度">
      </el-table-column>
      <el-table-column label="跟单员">
      </el-table-column>
      <el-table-column label="交货时间">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
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
    name: 'DispatchOrderBasicTable',
    components: {},
    props: {
      codes: {
        type: Array
      }
    },
    methods: {
      onProductDetail(row) {
        this.$router.push('/sales/production/' + id);
      },
      async getDetail(code) {
        const url = this.apis().getoutboundOrderDetail(code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.orders.push(result);
      },
    },
    data() {
      return {
        orders: []
      }
    },
    created() {
      //获取单个订单详情
      if (this.codes.length > 0) {
        this.getDetail(this.codes[0]);
      }
    }
  }

</script>

<style scoped>

</style>
