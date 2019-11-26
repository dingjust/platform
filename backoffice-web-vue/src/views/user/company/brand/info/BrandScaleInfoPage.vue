<template>
  <div class="animated fadeIn brand-scale">
    <el-row>
      <h6 class="textClass">品牌信息</h6>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="5">
        <h6 class="titleTextClass">合作品牌</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.cooperativeBrand">{{slotData.cooperativeBrand}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="5">
        <h6 class="titleTextClass">产值规模</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.scaleRange">{{getEnum('scaleRanges', slotData.scaleRange)}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="5">
        <h6 class="titleTextClass">优势品类</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-html="adeptAtCategories"></h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="5">
        <h6 class="titleTextClass">风格</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.styles">{{stylessComputed}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="5">
        <h6 class="titleTextClass">年龄段</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.ageRanges">{{ageRangesComputed}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" align="middle" class="rowClass">
      <el-col :span="5">
        <h6 class="titleTextClass">春夏款价格段</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.priceRange1s">{{priceRange1sComputed}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" align="middle" class="rowClass">
      <el-col :span="5">
        <h6 class="titleTextClass">秋冬款价格段</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.priceRange2s">{{priceRange2sComputed}}</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
    export default {
      name: 'BrandScaleInfoPage',
      props: ['slotData'],
      computed: {
        stylessComputed: function () {
          if (this.slotData.styles === undefined) {
            return '';
          }
          var result = '';
          for (var style of this.slotData.styles) {
            result += this.getEnum('productStyles', style) + ',';
          }
          if (result.length > 0) {
            result = result.slice(0, result.lastIndexOf('，'));
          }
          return result;
        },
        ageRangesComputed: function () {
          if (this.slotData.ageRanges === undefined) {
            return '';
          }
          var result = '';
          for (var ageRange of this.slotData.ageRanges) {
            result += this.getEnum('ageRanges', ageRange) + ',';
          }
          if (result.length > 0) {
            result = result.slice(0, result.lastIndexOf('，'));
          }
          return result;
        },
        priceRange1sComputed: function () {
          if (this.slotData.priceRange1s > 0) {
            return '';
          }
          var result = '';
          for (var priceRange1 of this.slotData.priceRange1s) {
            result += this.getEnum('priceRanges', priceRange1) + ',';
          }
          if (result.length > 0) {
            result = result.slice(0, result.lastIndexOf('，'));
          }
          return result;
        },
        priceRange2sComputed: function () {
          if (this.slotData.priceRange2s > 0) {
            return '';
          }
          var result = '';
          for (var priceRange2 of this.slotData.priceRange2s) {
            result += this.getEnum('priceRanges', priceRange2) + ',';
          }
          if (result.length > 0) {
            result = result.slice(0, result.lastIndexOf('，'));
          }
          return result;
        },
        adeptAtCategories: function () {
          if (this.slotData.adeptAtCategories === undefined) {
            return '';
          }
          var codes = [];

          var map = {};
          for (var item of this.slotData.adeptAtCategories) {
            if (codes.indexOf(item.parent.code) < 0) {
              codes.push(item.parent.code);
              map[item.parent.name] = [item.name];
            } else {
              map[item.parent.name].push(item.name);
            }
          }

          var result = '';
          for (var key in map) {
            var text = key + '--';
            for (item of map[key]) {
              text += item + '、';
            }
            text = text.slice(0, text.lastIndexOf('、'));
            result += text + '<br/><br/>';
          }
          result = result.slice(0, result.lastIndexOf('<br/><br/>'));
          return result;
        }
      }
    }
</script>

<style scoped>
  .brand-scale .rowClass{
    margin-bottom:10px;
  }
  .brand-scale .rowClass2{
    margin-bottom:40px;
  }
  .brand-scale .textClass{
    font-size: 15px;
    font-weight: bold;
  }
  .brand-scale .titleTextClass{
    color: #C0C0C0;
    text-align: justify;
    text-align-last: justify;
    display: block;
    width: 57px;
  }
</style>
