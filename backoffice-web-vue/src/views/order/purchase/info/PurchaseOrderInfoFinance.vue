<template>
  <div class="info-finance-body">
    <el-dialog :visible.sync="reconciliatioFormVisible" width="80%" class="purchase-dialog" append-to-body>
      <purchase-order-info-reconciliation :slotData="slotData" />
    </el-dialog>
    <el-dialog :visible.sync="financeFormVisible" width="60%" class="purchase-dialog" append-to-body>
      <purchase-order-finance-form :slotData="slotData" />
    </el-dialog>
    <el-row type="flex" justify="space-between" align="middle" class="info-finance-body-title-row">
      <div class="info-title">
        <h6 class="info-title_text">财务（当前选用“森马”财务方案）</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="space-between" align="middle" class="info-finance-body-title-row2">
      <h6 class="info-title_text2">进度</h6>
      <el-button class="info-finance-logistics_info-btn1" @click="reconciliatioFormVisible=!reconciliatioFormVisible">
        查看对账单</el-button>
    </el-row>
    <el-row style="margin-top:10px;">
      <el-timeline>
        <el-timeline-item placement="top" v-for="(activity, index) in activities" :key="index"
          :color="index==0?'#FFD60C':'#E4E7ED'">
          <el-row type="flex" justify="space-between" align="middle">
            <el-col :span="8">
              <h6 class="info-log-content">{{activity.content}}</h6>
            </el-col>
            <el-col :span="4">
              <h6 class="finance-log-content">{{activity.content2}}</h6>
            </el-col>
            <el-col :span="2">
              <img width="40px" height="15px" src="static/img/arrears.png" />
            </el-col>
            <el-col :span="8">
              <el-row type="flex" justify="end" align="middle">
                <el-button class="info-finance-logistics_info-btn3" @click="financeFormVisible=!financeFormVisible">收款
                </el-button>
                <el-button type="text" style="font-size:10px;">发送催款通知</el-button>
              </el-row>
            </el-col>
          </el-row>
        </el-timeline-item>
      </el-timeline>
    </el-row>
  </div>
</template>

<script>
  import PurchaseOrderInfoReconciliation from './PurchaseOrderInfoReconciliation';
  import PurchaseOrderFinanceForm from './PurchaseOrderFinanceForm';

  export default {
    name: 'PurchaseOrderInfoFinance',
    props: ['slotData'],
    components: {
      PurchaseOrderInfoReconciliation,
      PurchaseOrderFinanceForm
    },
    mixins: [],
    computed: {

    },
    methods: {

    },
    data() {
      return {
        reconciliatioFormVisible: false,
        financeFormVisible: false,
        activities: [{
          perid: '定金',
          content: '签署后5天以内完成付款30%作为定金',
          content2: '部分欠款¥50000',
          isPay: 1
        }, {
          perid: '一期尾款',
          content: '签署后5天以内完成付款30%作为定金',
          content2: '已付￥5000',
          isPay: 2
        }, {
          perid: '二期尾款',
          content: '签署后5天以内完成付款30%作为定金',
          content2: '已付￥5000',
          isPay: 3
        }, ]
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

  .finance-log-content {
    font-weight: 500;
    color: rgba(0, 0, 0, 0.45);
    font-size: 10px;
    margin-top: 10px;
  }

  .info-finance-btn {
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

  .info-title_text2 {
    margin-top: 5px;
    margin-left: 10px;
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
  }

  .info-finance-body-title-row2 {
    background-color: rgba(0, 0, 0, 0.02);
    text-align: center;
  }

  .info-finance-btn:focus,
  .info-finance-btn:hover {
    color: #409EFF;
    border-color: #c6e2ff;
    background-color: #ecf5ff;
  }

  .info-finance-logistics_info-btn1 {
    /* width: 50px; */
    height: 20px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    text-align: center;
    border: 0px solid #FFD60C;
    padding-bottom: 15px;
  }

  .info-finance-logistics_info-btn3 {
    /* width: 60px; */
    height: 20px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    text-align: center;
    border: 0px solid #FFD60C;
    padding-bottom: 15px;
  }

</style>
