<template>
  <div>
    <el-table :data="orders" stripe style="width: 100%">
      <el-table-column label="外发订单号" prop="code"></el-table-column>
      <el-table-column label="合作商" prop="cooperator.name">
      </el-table-column>
      <el-table-column label="跟单员">
        <template slot-scope="scope">
          <span>{{scope.row.partyAOperator ? scope.row.partyAOperator.name : ''}}</span>
        </template>
      </el-table-column>
      <el-table-column label="审批状态" prop="status">
        <template slot-scope="scope">
          <span>{{getEnum('OutboundOrderStatuses', scope.row.status)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="120">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">查看</el-button>
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
      },
      taskIds: {
        type: Array
      }
    },
    methods: {
      onDetail(row) {
        this.$router.push('/sales/outboundOrder/' + row.code);
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
      async getOrdersByTaskIds(ids) {
        const url = this.apis().searchPurchaseByTaskIds();
        const result = await this.$http.post(url, {
          "productionTaskIds": ids
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
      }
      //根据单号获取单个订单详情
      else if (this.codes != null && this.codes.length > 0) {
        this.getDetail(this.codes[0]);
      }
    }
  }

</script>

<style scoped>

</style>
