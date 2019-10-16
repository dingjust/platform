<template>
  <div class="animated fadeIn requirement-belongTo">
    <el-row type="flex">
      <el-col :span="8">
        <el-row type="flex" class="rowClass">
          <el-col :span="9">
            <div class="demo-image__preview">
              <el-image
                style="width: 100px; height: 100px;border-radius: 9px"
                :src="slotData.belongTo.profilePicture!= null && slotData.belongTo.profilePicture != '' ? slotData.belongTo.profilePicture.url : 'static/img/nopicture.png'">
              </el-image>
            </div>
          </el-col>
          <el-col :span="15">
            <el-row type="flex" class="rowClass2">
              <el-col :span="6">
                <h6 class="titleTextClass">公司</h6>
              </el-col>
              <el-col :span="16" :offset="2">
                <h6 class="contentTextClass">{{slotData.belongTo.name}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" class="rowClass2">
              <el-col :span="6">
                <h6 class="titleTextClass">联系人</h6>
              </el-col>
              <el-col :span="16" :offset="2">
                <h6 class="contentTextClass">{{slotData.belongTo.contactPerson}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" class="rowClass2">
              <el-col :span="6">
                <h6 class="titleTextClass">联系方式</h6>
              </el-col>
              <el-col :span="16" :offset="2">
                <h6 class="contentTextClass">{{slotData.belongTo.contactPhone}}</h6>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'RequirementOrderBelongToInfoPage',
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
      },
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
  .requirement-belongTo .rowClass{
    margin-bottom:10px;
  }
  .requirement-belongTo .rowClass2{
    margin-bottom:20px;
  }
  .requirement-belongTo .textClass{
    font-size: 15px;
    font-weight: bold;
  }
  .requirement-belongTo .titleTextClass{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-weight: bold;
  }

  .requirement-belongTo .titleTextClass2{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 85px;
    font-weight: bold;
  }

  .requirement-belongTo .contentTextClass{
    color: #A9A9A9;
    font-weight: 400;
  }

</style>
