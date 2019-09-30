<template>
  <div class="animated fadeIn factory-scale">
    <el-row>
      <h6 class="textClass">工厂规模</h6>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">人数</h6>
      </el-col>
      <el-col :span="20">
        <h6>{{getEnum('populationScales',slotData.populationScale)}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">厂房</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.factoryBuildingsQuantity">{{slotData.factoryBuildingsQuantity}}间</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">产线</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.productionLineQuantity">{{slotData.productionLineQuantity}}条</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">产值</h6>
      </el-col>
      <el-col :span="20">
        <h6>{{getEnum('scaleRanges',slotData.scaleRange)}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">生产模式</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.productionMode">{{getEnum('ProductionModes',slotData.productionMode)}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">设备</h6>
      </el-col>
      <el-col :span="20">
        <h6>{{equipments}}</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'FactoryScaleInfoPage',
    props: ['slotData'],
    computed: {
      equipments: function () {
        if(this.slotData.cuttingDepartment === undefined){
          return '';
        }
        var result = '';
        for (var item of this.slotData.cuttingDepartment) {
          result += this.getEnum('CuttingDepartment', item) + '，'
        }
        for (item of this.slotData.productionWorkshop) {
          result += this.getEnum('ProductionWorkshop', item) + '，'
        }
        for (item of this.slotData.lastDepartment) {
          result += this.getEnum('LastDepartment', item) + '，'
        }
        if(result.length > 0){
          result = result.slice(0,result.lastIndexOf('，'));
        }
        return result;
      }
    }
  }
</script>

<style scoped>
  .factory-scale .rowClass{
    margin-bottom:10px;
  }
  .factory-scale .rowClass2{
    margin-bottom:40px;
  }
  .factory-scale .textClass{
    font-size: 15px;
    font-weight: bold;
  }
  .factory-scale .titleTextClass{
    color: #C0C0C0;
  }

</style>
