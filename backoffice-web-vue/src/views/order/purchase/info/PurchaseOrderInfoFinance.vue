<template>
  <div class="info-finance-body">
    <el-row type="flex" justify="space-between" align="middle" class="info-finance-body-title-row">
      <div class="info-title">
        <h6 class="info-title_text">财务（当前选用“森马”财务方案）</h6>
      </div>
      <el-button type="text" class="info-detail-logistics_info-btn2">查看对账单</el-button>
    </el-row>
    <el-row>
      <el-table :data="mockData" style="width: 100%">
        <el-table-column label="订单标签">
          <template slot-scope="scope">
            <el-tag type="danger">欠款</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="期数">
          <template slot-scope="scope">
            <span>第{{scope.row.term}}期</span>
          </template>
        </el-table-column>
        <el-table-column label="详细" min-width="300px">
          <template slot-scope="scope">
            <span>{{scope.row.detail}}</span>
          </template>
        </el-table-column>
        <el-table-column label="金额">
          <template slot-scope="scope">
            <span>￥{{scope.row.amount}}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
            <div class="info-finance-btn">确认已付</div>
          </template>
        </el-table-column>
      </el-table>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'PurchaseOrderInfoFinance',
    props: ['slotData'],
    components: {},
    mixins: [],
    computed: {

    },
    methods: {},
    data() {
      return {
        mockData: [{
          'term': '一',
          'detail': '签署后5天以内完成付款30%作为定金',
          'amount': 5000
        }, {
          'term': '二',
          'detail': '签署后5天以内完成付款30%作为定金',
          'amount': 5000
        }, {
          'term': '三',
          'detail': '签署后5天以内完成付款30%作为定金',
          'amount': 5000
        }, {
          'term': '一',
          'detail': '签署后5天以内完成付款30%作为定金',
          'amount': 5000
        }, {
          'term': '一',
          'detail': '签署后5天以内完成付款30%作为定金',
          'amount': 5000
        }]
      }
    },
    created() {}
  }

</script>
<style>
  .info-finance-body {
    width: 100%;
    margin-top: 20px;
  }

  .info-finance-btn{
    width: 50px;
    height: 25px;
    text-align: center;
    white-space: nowrap;
    cursor: pointer;
    background: #FFF;
    border: 1px solid #DCDFE6;
    color: #606266;
    -webkit-appearance: none;
    box-sizing: border-box;
    outline: 0;
    margin: 0;
    -webkit-transition: .1s;
    transition: .1s;
    font-weight: 500;
    border-radius: 4px;
    font-size: 10px;
}

.info-finance-btn:focus, .info-finance-btn:hover {
    color: #409EFF;
    border-color: #c6e2ff;
    background-color: #ecf5ff;
}
  

</style>
