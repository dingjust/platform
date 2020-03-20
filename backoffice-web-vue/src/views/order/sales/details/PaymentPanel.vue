<template>
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
      <el-col :span="2" :offset="3">
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
</template>

<script>
  export default {
    name: "PaymentPanel",
    components: {},
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
      timeCount() {
        this.timeStr = this.timeFn(this.date);
      }
    },
    data() {
      return {
        timeStr: '00小时00分钟00秒',
        date: 1584515889,
      }
    },
    created() {
      setInterval(this.timeCount, 1000);

    },
    mounted() {}
  };

</script>
<style>
</style>
