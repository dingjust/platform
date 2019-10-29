<template>
  <div class="animated fadeIn quote-basic">
    <el-row type="flex" style="margin-bottom: 10px">
      <el-col :span="6">
        <el-row type="flex">
          <div class="border-line">
            <h6 style="font-weight: bold;font-size: 15px;">订单报价&nbsp;&nbsp;</h6>
          </div>
          <h6 style="color: red;font-weight: bold;font-size: 15px">￥{{slotData.unitPrice ? slotData.unitPrice : '--'}}</h6>
        </el-row>
      </el-col>
      <el-col :span="4">
        <el-row type="flex">
          <h6>面料价格&nbsp;</h6>
          <h6 style="color: red">￥{{slotData.unitPriceOfFabric ? slotData.unitPriceOfFabric : '--'}}</h6>
        </el-row>
      </el-col>
      <el-col :span="4">
        <el-row type="flex">
          <h6>辅料价格&nbsp;</h6>
          <h6 style="color: red">￥{{slotData.unitPriceOfExcipients ? slotData.unitPriceOfExcipients : '--'}}</h6>
        </el-row>
      </el-col>
      <el-col :span="4">
        <el-row type="flex">
          <h6>加工价格&nbsp;</h6>
          <h6 style="color: red">￥{{slotData.unitPriceOfProcessing ? slotData.unitPriceOfProcessing : '--'}}</h6>
        </el-row>
      </el-col>
      <el-col :span="4">
        <el-row type="flex">
          <h6>其他价格&nbsp;</h6>
          <h6 style="color: red">￥{{slotData.costOfOther ? slotData.costOfOther : '--'}}</h6>
        </el-row>
      </el-col>
    </el-row>
    <el-row type="flex" style="margin-bottom: 10px">
      <el-col :span="12">
        <el-row type="flex" align="bottom">
          <div class="border-line">
            <h6 style="font-weight: bold;font-size: 15px;">交货时间&nbsp;&nbsp;</h6>
          </div>
          <h6 style="color: red;font-size: 14px">{{slotData.expectedDeliveryDate | timestampToTime}}</h6>
        </el-row>
      </el-col>
      <el-col :span="12">
        <el-row type="flex" align="bottom">
          <div class="border-line">
            <h6 style="font-weight: bold;font-size: 15px;">打样费&nbsp;&nbsp;</h6>
          </div>
          <h6 style="color: red;font-size: 14px">￥{{slotData.costOfSamples ? slotData.costOfSamples : '--'}}</h6>
        </el-row>
      </el-col>
    </el-row>
      <el-row type="flex">
        <el-col :span="1">
          <h6 class="titleTextClass">备注</h6>
        </el-col>
        <el-col :span="22" :offset="1">
          <h6 class="contentTextClass">{{slotData.remarks}}</h6>
        </el-col>
      </el-row>
  </div>
</template>

<script>
  export default {
    name: 'QuoteBasicInfoPage',
    props: ['slotData'],
    computed: {
      picUrls: function () {
        if (this.slotData.details.pictures != null && this.slotData.details.pictures.length > 0) {
          return this.slotData.details.pictures.map(pic => pic.url);
        } else {
          return [];
        }
      },
      productionAreas: function () {
        var text = '';
        if (this.slotData.details.productiveOrientations != null && this.slotData.details.productiveOrientations.length > 0) {
          for (let area of this.slotData.details.productiveOrientations) {
            text += area.name;
            text += '、';
          }
        }

        var index = text.indexOf('、');
        if (index !== -1) {
          text = text.slice(0, index);
        }
        return text;
      }
    },
    methods: {
      getFileName (url) {
        if (url != null) {
          var index = url.lastIndexOf('/');
          if (index !== -1) {
            url = url.slice(index + 1, url.length);
          }
        }
        return url;
      },
      getYesNo (bool) {
        var text = '';
        if (bool != null) {
          if (bool) {
            text = '是';
          } else {
            text = '否'
          }
        }
        return text;
      }
    }
  }
</script>

<style scoped>
  .quote-basic .rowClass{
    margin-bottom:10px;
  }
  .quote-basic .rowClass2{
    margin-bottom:20px;
  }
  .quote-basic .textClass{
    font-size: 15px;
    font-weight: bold;
  }
  .quote-basic .titleTextClass{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-weight: bold;
  }

  .quote-basic .titleTextClass2{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 85px;
    font-weight: bold;
  }

  .quote-basic .contentTextClass{
    color: #A9A9A9;
    font-weight: 400;
  }

  .quote-basic .linkClass{
    color: #ffd60c;
    margin-bottom: 6px;
  }

  .border-line{
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    /*height: 14px;*/
  }

</style>
