<template>
  <div class="animated fadeIn factory-service">
    <el-row>
      <h6 class="textClass">工厂服务</h6>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">免费打样</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.freeProofing">{{getEnum('FactoryFreeProofing',slotData.freeProofing)}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">服务</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.service">{{getEnum('FactoryService',slotData.service)}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">合作方式</h6>
      </el-col>
      <el-col :span="20">
        <h6>{{cooperationModes}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass">
      <el-col :span="4">
        <h6 class="titleTextClass">质量等级</h6>
      </el-col>
      <el-col :span="20">
        <h6 v-if="slotData.qualityLevel != null">{{getEnum('FactoryQualityLevel',slotData.qualityLevel)}}</h6>
      </el-col>
    </el-row>

  </div>
</template>

<script>
  export default {
    name: 'FactoryServiceInfoPage',
    props: ['slotData'],
    computed: {
      cooperationModes: function () {
        if(this.slotData.cooperationModes === undefined){
          return '';
        }

        var result = '';
        for (var item of this.slotData.cooperationModes) {
          result += this.getEnum('cooperationModes', item) + '、';
        }
        result = result.slice(0, result.lastIndexOf('、'));
        return result;
      }
    }
  }
</script>

<style scoped>
  .factory-service .rowClass{
    margin-bottom:10px;
  }
  .factory-service .rowClass2{
    margin-bottom:40px;
  }
  .factory-service .textClass{
    font-size: 15px;
    font-weight: bold;
  }
  .factory-service .titleTextClass{
    color: #C0C0C0;
  }

</style>
