<template>
  <div>
    <el-table ref="resultTable" stripe :data="[]">
      <el-table-column label="外发单号" prop="code"></el-table-column>
      <el-table-column label="生产负责人" prop="productionLeader.name"></el-table-column>
      <el-table-column label="跟单员" prop="merchandiser.name"></el-table-column>
      <el-table-column label="交货日期">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单状态">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">查看</el-button>
        </template>
      </el-table-column>
    </el-table>
    <!-- <el-table ref="resultTable" stripe :data="[]">
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
                <span>货号:{{scope.row.product!=null?scope.row.product.skuID:''}}</span>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="当前进度"></el-table-column>
      <el-table-column label="跟单员" prop="merchandiser.name"></el-table-column>
      <el-table-column label="交货日期">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单标签"></el-table-column>
      <el-table-column label="订单状态">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">查看</el-button>
        </template>
      </el-table-column>
    </el-table> -->
  </div>
</template>

<script>
  export default {
    name: 'ProductionOrderOutboundList',
    props: [],
    components: {},
    computed: {

    },
    methods: {
      getOrder () {
      },
      onDetail (row) {

      }
    },
    data () {
      return {

      }
    },
    created () {
      this.getOrder();
    }
  }
</script>

<style scoped>

</style>