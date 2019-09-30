<template>
  <div class="animated fadeIn factory-capacity">
    <el-row>
      <h6 class="textClass">工厂能力</h6>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">设计</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.design">{{getEnum('FactoryDesign',slotData.design)}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">打板</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.pattern">{{getEnum('FactoryPattern',slotData.pattern)}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">合作商</h6>
      </el-col>
      <el-col :span="20">
        <h6>{{slotData.cooperativeBrand}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">覆盖范围</h6>
      </el-col>
      <el-col :span="20">
        <h6>{{slotData.coverageArea}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">优势品类</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-html="adeptAtCategories"></h6>
        <!--<el-input-->
          <!--type="textarea"-->
          <!--:readonly="true"-->
          <!--v-model="adeptAtCategories">-->
        <!--</el-input>-->
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">关键词</h6>
      </el-col>
      <el-col :span="20">
        <h6>{{slotData.keyword}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">自营产品</h6>
      </el-col>
      <el-col :span="20">
        <h6>{{slotData.proprietaryProducts != null ? slotData.proprietaryProducts : 0}} SKU</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'FactoryCapacityInfoPage',
    props: ['slotData'],
    computed: {
      adeptAtCategories: function () {
        if(this.slotData.adeptAtCategories === undefined){
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
          text = text.slice(0,text.lastIndexOf('、'));
          result += text+'<br/><br/>';
        }
        return result;
      }
    }
  }
</script>

<style scoped>
  .factory-capacity .rowClass{
    margin-bottom:10px;
  }
  .factory-capacity .rowClass2{
    margin-bottom:40px;
  }
  .factory-capacity .textClass{
    font-size: 15px;
    font-weight: bold;
  }
  .factory-capacity .titleTextClass{
    color: #C0C0C0;
  }

</style>
