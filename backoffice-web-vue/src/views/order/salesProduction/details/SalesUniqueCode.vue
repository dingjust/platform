<!--
* @Description: 外接订单 唯一码详情
* @Date 2021/06/07 15:09
* @Author L.G.Y
-->
<template>
  <div>
    <el-row type="flex">
      <h6>唯一码</h6>
    </el-row>
    <el-row type="flex" style="margin-left:20px" align="middle">
      <h6 style="margin: 0px 10px 0px 0px;">{{formData.uniqueCode}}</h6>
    </el-row>
    <el-row type="flex" style="margin-left:20px">
      <div id="qrCode" ref="qrCodeDiv"></div>
    </el-row>
  </div>
</template>

<script>
import QRCode from 'qrcodejs2';

export default {
  name: 'SalesUniqueCode',
  props: ['formData'],
  methods: {
    onQRCode () {
      this.$nextTick(() => {
        new QRCode(this.$refs.qrCodeDiv, {
          text: 'https://ht.nbyjy.net/app/page/business/orders/import?code=' + this.formData.uniqueCode,
          width: 100,
          height: 100,
          colorDark: "#333333", //二维码颜色
          colorLight: "#ffffff", //二维码背景色
          correctLevel: QRCode.CorrectLevel.H //容错率，L/M/H
        });
      })
    }
  },
  mounted () {
    this.onQRCode();
  } 
}
</script>

<style scoped>

</style>