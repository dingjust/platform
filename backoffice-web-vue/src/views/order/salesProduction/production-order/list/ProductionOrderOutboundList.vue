<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" style="width: 100%" v-if="pageType == 'OUTBOUND_ORDER'">
      <el-table-column label="外发单号" prop="code"></el-table-column>
      <el-table-column label="生产负责人" prop="productionLeader.name"></el-table-column>
      <el-table-column label="跟单员" prop="merchandiser.name"></el-table-column>
      <el-table-column label="订单状态">
        <template slot-scope="scope">
          <span>{{getEnum('OutboundOrderStatuses', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">查看</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-table ref="resultTable" stripe :data="page.content" style="width: 100%" 
      v-if="pageType == 'OUTBOUND_PRODUCTION_ORDER'">
      <el-table-column label="外发工单号" prop="code"></el-table-column>
      <el-table-column label="产品" min-width="150">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
              <img width="54px" v-if="scope.row.product!=null" height="54px"
                :src="scope.row.product.thumbnail!=null&&scope.row.product.thumbnail.length!=0?scope.row.product.thumbnail.url:'static/img/nopicture.png'">
            </el-col>
            <el-col :span="16">
              <el-row>
                <span v-if="scope.row.product.category">{{scope.row.product.category.parent.name}}-{{scope.row.product.category.name}}</span>
              </el-row>
              <el-row>
                <span>货号:{{scope.row.product!=null?scope.row.product.skuID:''}}</span>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="当前进度" prop="progressWorkSheet.currentPhase.name"></el-table-column>
      <el-table-column label="跟单员" prop="merchandiser.name"></el-table-column>
      <el-table-column label="交货日期">
        <template slot-scope="scope">
          <span>{{scope.row.progressWorkSheet.expectedDeliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="订单标签"></el-table-column> -->
      <el-table-column label="订单状态">
        <template slot-scope="scope">
          <span>{{orderState(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">查看</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'ProductionOrderOutboundList',
    props: ['page', 'pageType'],
    components: {},
    computed: {

    },
    methods: {
      onDetail (row, type) {
        if (this.pageType == 'OUTBOUND_ORDER') {
          this.$router.push('/sales/outboundOrder/' + row.id);
        } else if (this.pageType == 'OUTBOUND_PRODUCTION_ORDER') {
          this.$router.push('/sales/productionOrder/' + row.id);
        }
      },
      orderState (row) {
        if (row.state == 'TO_BE_ALLOCATED') {
          return '待生产';
        }
        return this.getEnum('ProductionTaskOrderState', row.state);
      }
    },
    data () {
      return {

      }
    },
    watch: {

    },
    created () {
    }
  }
</script>

<style scoped>

</style>