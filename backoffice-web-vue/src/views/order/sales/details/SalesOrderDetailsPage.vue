<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="2">
          <div class="orders-list-title">
            <h6>订单详情</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex" justify="center">
        <el-col :span="20">
          <div class="sale-details-b1">
            <div class="sale-details-stepbox">
              <el-steps :active="2" align-center finish-status="success">
                <el-step title="步骤1" description="这是一段很长很长很长的描述性文字"></el-step>
                <el-step title="步骤2" description="这是一段很长很长很长的描述性文字"></el-step>
                <el-step title="步骤3" description="这是一段很长很长很长的描述性文字"></el-step>
                <el-step title="步骤4" description="这是一段很长很长很长的描述性文字"></el-step>
              </el-steps>
            </div>
            <payment-panel />
            <delivery-panel />
            <receiving-panel />
            <return-panel/>
          </div>
          <div class="sale-details-b2">
            <div class="sale-details-b2_title">
              <el-row type="flex">
                <h5>订单信息</h5>
              </el-row>
            </div>
            <div class="sale-details-b2_body">
              <el-row type="flex">
                <el-col :span="14">
                  <h6>收货信息</h6>
                </el-col>
                <el-col :span="10">
                  <h6>卖家信息</h6>
                </el-col>
              </el-row>
              <div style="padding-left:20px;margin-top:10px">
                <el-row type="flex" class="sales-detail-row">
                  <el-col :span="14">
                    <h6>订单编号：456456456156456456</h6>
                  </el-col>
                  <el-col :span="10">
                    <h6>供应商：广州贸易服装有限公司</h6>
                  </el-col>
                </el-row>
                <el-row type="flex" class="sales-detail-row">
                  <el-col :span="14">
                    <h6>姓名：张三</h6>
                  </el-col>
                  <el-col :span="10">
                    <h6>联系方式：18888888888</h6>
                  </el-col>
                </el-row>
                <el-row type="flex" class="sales-detail-row">
                  <el-col :span="14">
                    <h6>联系方式：1388888888</h6>
                  </el-col>
                  <el-col :span="10">
                    <h6>地址：广东庞爰是低级哦亲我今儿哦</h6>
                  </el-col>
                </el-row>
                <el-row type="flex" class="sales-detail-row">
                  <el-col :span="14">
                    <h6>地址：非洲请问囧请叫我二我今儿哦i解耦</h6>
                  </el-col>
                </el-row>
                <order-rows-table style="margin-top:20px;" />
                <el-row type="flex" justify="end" style="margin-top:50px">
                  <h6>总计：<span class="sales-total-price">1200</span>元</h6>
                </el-row>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import http from "@/common/js/http";
  import OrderRowsTable from "./OrderRowsTable";
  import PaymentPanel from "./PaymentPanel";
  import DeliveryPanel from "./DeliveryPanel";
  import ReceivingPanel from "./ReceivingPanel";
  import ReturnPanel from "./ReturnPanel";

  export default {
    name: "SalesOrderDetailsPage",
    props: ["code"],
    components: {
      OrderRowsTable,
      PaymentPanel,
      DeliveryPanel,
      ReceivingPanel,
      ReturnPanel
    },
    computed: {},
    methods: {

    },
    data() {
      return {

      };
    },
    created() {
    },
    mounted() {}
  };

</script>
<style>
  .report {
    margin-bottom: 10px;
  }

  .sale-details-b1 {
    border: #d2d1d1 solid 0.5px;
    /* padding: 20px; */
    padding: 20px 0 0px 0;
  }

  .sale-details-b1_body {
    padding: 20px;
  }

  .sale-details-b2 {
    border: #d2d1d1 solid 0.5px;
    margin-top: 20px;
    padding: 0.5px 0.5px 0px 0.5px;
  }

  .sale-details-b2_title {
    background-color: #fafafa;
    border-bottom: #d2d1d1 solid 0.5px;
    padding: 10px 15px 10px 15px;
  }

  .sale-details-b2_body {
    padding: 30px 40px 30px 40px;
  }

  .sales-order-btn {
    background: #ffd60c;
    color: rgba(0, 0, 0, 0.85);
    width: 80px;
  }

  .sales-details-info {
    padding-top: 8px;
  }

  .sale-details-stepbox {
    border-bottom: #d2d1d1 solid 0.5px;
    padding: 20px 0px 20px 0px;
  }

  .sales-total-price {
    color: red;
    font-size: 14px;
  }

  .sales-detail-row {
    margin-bottom: 10px;
  }

</style>
