<template>
  <div class="animated fadeIn quote-basic">
      <el-row type="flex">
        <el-col :span="6">
          <el-row type="flex" class="rowClass2">
            <el-col :span="6">
              <h6 class="titleTextClass">订单报价</h6>
            </el-col>
            <el-col :span="16" :offset="2">
              <h6 class="contentTextClass">{{slotData.unitPrice}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" class="rowClass2">
            <el-col :span="6">
              <h6 class="titleTextClass">交货时间</h6>
            </el-col>
            <el-col :span="16" :offset="2">
              <h6 class="contentTextClass">{{slotData.expectedDeliveryDate | timestampToTime}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" class="rowClass2">
            <el-col :span="6">
              <h6 class="titleTextClass">面料价格</h6>
            </el-col>
            <el-col :span="16" :offset="2">
              <h6 class="contentTextClass">{{slotData.unitPriceOfFabric}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" class="rowClass2">
            <el-col :span="6">
              <h6 class="titleTextClass">辅料价格</h6>
            </el-col>
            <el-col :span="16" :offset="2">
              <h6 class="contentTextClass">{{slotData.unitPriceOfExcipients}}</h6>
            </el-col>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex" class="rowClass2">
            <el-col :span="6">
              <h6 class="titleTextClass">加工价格</h6>
            </el-col>
            <el-col :span="16" :offset="2">
              <h6 class="contentTextClass">{{slotData.unitPriceOfProcessing}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" class="rowClass2">
            <el-col :span="6">
              <h6 class="titleTextClass">其他价格</h6>
            </el-col>
            <el-col :span="16" :offset="2">
              <h6 class="contentTextClass">{{slotData.costOfOther}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" class="rowClass2">
            <el-col :span="6">
              <h6 class="titleTextClass">打样费</h6>
            </el-col>
            <el-col :span="16" :offset="2">
              <h6 class="contentTextClass">{{slotData.costOfSamples}}</h6>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex">
        <el-col :span="1">
          <h6 class="titleTextClass">备注</h6>
        </el-col>
        <el-col :span="22" :offset="1">
          <h6 class="contentTextClass" style="margin-left: -12px">{{slotData.remarks}}</h6>
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

</style>
