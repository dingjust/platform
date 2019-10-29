<template>
  <div class="animated fadeIn requirement-belongTo">
    <el-row type="flex" justify="center" class="rowClass2">
      <div class="demo-image__preview">
        <el-image
          style="width: 100px; height: 100px;border-radius: 50%"
          :src="slotData.belongTo.profilePicture!= null && slotData.belongTo.profilePicture != '' ? slotData.belongTo.profilePicture.url : 'static/img/nopicture.png'">
        </el-image>
      </div>
    </el-row>
    <el-row type="flex" class="rowClass2">
      <el-col :span="8">
        <h6 class="titleTextClass">公司</h6>
      </el-col>
      <el-col :span="16">
        <h6 class="contentTextClass">{{slotData.belongTo.name}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass2">
      <el-col :span="8">
        <h6 class="titleTextClass">联系人</h6>
      </el-col>
      <el-col :span="16">
        <h6 class="contentTextClass">{{slotData.belongTo.contactPerson}}</h6>
      </el-col>
    </el-row>
    <el-row type="flex" class="rowClass2">
      <el-col :span="8">
        <h6 class="titleTextClass">联系方式</h6>
      </el-col>
      <el-col :span="16">
        <h6 class="contentTextClass">{{slotData.belongTo.contactPhone}}</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'RequirementOrderBelongToInfoPage',
    props: ['slotData'],
    computed: {
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

  .requirement-belongTo .titleTextClass{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-weight: bold;
  }

  .requirement-belongTo .contentTextClass{
    color: #A9A9A9;
    font-weight: 400;
  }

</style>
