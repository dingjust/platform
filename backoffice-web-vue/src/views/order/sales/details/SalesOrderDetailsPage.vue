<template>
  <div class="animated fadeIn content">
    <!-- <el-dialog @open="getContract" @close="initContract" :visible.sync="dialogDetailVisible" width="85%"
      class="purchase-dialog" :close-on-click-modal="false">
      <purchase-order-details-page :contracts="contracts" :slotData="contentData" @onDetails="onDetails"
                                   :dialogDetailVisible="dialogDetailVisible" @onSearch="onSearch"
                                   @closeDialogDetailVisible="closeDialogDetailVisible"/>
    </el-dialog>
    <el-dialog :visible.sync="cannelMsgVisible" width="50%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <purchase-order-cannel-msg-dialog :contracts="contracts" :slotData="contentData"
                                        @closeCannelMsgVisible="closeCannelMsgVisible" @onSearch="onSearch"/>
    </el-dialog>-->
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
            <div class="sale-details-b1_body">
              <el-row type="flex" align="top">
                <h6>
                  订单当前状态：
                  <span style="color:red;font-weight: bold;">等待买家付款</span>
                </h6>
              </el-row>
              <el-row type="flex">
                <el-col :span="20" :offset="3">
                  <h6>
                    您还有
                    <span style="color:red;font-weight: bold;">{{timeStr}}</span>来完成支付，超时订单将会自动取消
                  </h6>
                </el-col>
              </el-row>
              <el-row style="flex" align="bottom">
                <el-col :span="3" :offset="3">
                  <h6 class="sales-details-info">您可以</h6>
                </el-col>
                <el-col :span="3">
                  <el-button class="sales-order-btn" @click="onPay">去支付</el-button>
                </el-col>
                <el-col :span="3">
                  <el-button type="text">取消订单</el-button>
                </el-col>
              </el-row>
            </div>
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
                <el-row type="flex">
                  <el-col :span="14">
                    <h6>订单编号：456456456156456456</h6>
                  </el-col>
                  <el-col :span="10">
                    <h6>供应商：广州贸易服装有限公司</h6>
                  </el-col>
                </el-row>
                <el-row type="flex">
                  <el-col :span="14">
                    <h6>姓名：张三</h6>
                  </el-col>
                  <el-col :span="10">
                    <h6>联系方式：18888888888</h6>
                  </el-col>
                </el-row>
                <el-row type="flex">
                  <el-col :span="14">
                    <h6>联系方式：1388888888</h6>
                  </el-col>
                  <el-col :span="10">
                    <h6>地址：广东庞爰是低级哦亲我今儿哦</h6>
                  </el-col>
                </el-row>
                <el-row type="flex">
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

  export default {
    name: "SalesOrderDetailsPage",
    props: ["code"],
    components: {
      OrderRowsTable
    },
    computed: {},
    methods: {
      onPay() {},
      // 计算两个时间差 dateBegin 开始时间
      timeFn(dateBegin) {
        //如果时间格式是正确的，那下面这一步转化时间格式就可以不用了
        var dateEnd = new Date(); //获取当前时间
        var dateDiff = dateEnd.getTime() - dateBegin; //时间差的毫秒数
        var dayDiff = Math.floor(dateDiff / (24 * 3600 * 1000)); //计算出相差天数
        var leave1 = dateDiff % (24 * 3600 * 1000) //计算天数后剩余的毫秒数
        var hours = Math.floor(leave1 / (3600 * 1000)) //计算出小时数
        //计算相差分钟数
        var leave2 = leave1 % (3600 * 1000) //计算小时数后剩余的毫秒数
        var minutes = Math.floor(leave2 / (60 * 1000)) //计算相差分钟数
        //计算相差秒数
        var leave3 = leave2 % (60 * 1000) //计算分钟数后剩余的毫秒数
        var seconds = Math.round(leave3 / 1000)

        var leave4 = leave3 % (60 * 1000) //计算分钟数后剩余的毫秒数
        var minseconds = Math.round(leave4 / 1000)
        var timeFn = hours + "小时 " + minutes + " 分钟" + seconds + " 秒";
        return timeFn;
      },
      timeCount(){
        this.timeStr=this.timeFn(this.date);
      }
    },
    data() {
      return {
        timeStr: '00小时00分钟00秒',
        date: 1584515889,
      };
    },
    created() {
      setInterval(this.timeCount, 1000);
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

</style>
