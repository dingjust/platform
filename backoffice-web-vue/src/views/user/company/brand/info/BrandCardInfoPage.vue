<template>
  <div class="animated fadeIn brand-card">
    <el-row type="flex" justify="center" class="rowClass">
      <img style="border-radius:50%;" width="100px" height="100px" :src="slotData.profilePicture != null ? slotData.profilePicture.url : 'static/img/nopicture.png'" />
    </el-row>
    <el-row type="flex" justify="center" class="rowClass">
      <h6 class="textClass">{{slotData.name}}</h6>
    </el-row>

    <!--  星级显示  -->
<!--    <el-row type="flex" justify="start" class="rowClass">-->
<!--      <el-rate-->
<!--        :value="slotData.starLevel"-->
<!--        disabled-->
<!--        :colors="starColors"-->
<!--        disabled-void-color="#D3D3D3"-->
<!--      >-->
<!--      </el-rate>-->
<!--    </el-row>-->

    <el-row class="rowClass">
      <el-tag  size="mini" style="margin-right: 10px;" type="info">{{slotData.approvalStatus == 'approved' ? '已认证':'未认证'}}</el-tag>
      <el-tag v-for="label of slotData.labels" size="mini" style="margin-right: 10px;margin-bottom: 10px;" type="danger">{{label.name}}</el-tag>
    </el-row>
    <el-row class="rowClass" type="flex" justify="space-between">
      <el-col :span="8">
        <h6 style="font-weight: bold;color:grey;margin-right:10px">注册时间</h6>
      </el-col>
      <el-col :span="16">
        <h6 style="color:grey;">{{slotData.creationTime | timestampToTime}}</h6>
      </el-col>
    </el-row>
    <el-row class="rowClass2">
      <h6 class="textClass"><i class="factory-card-info">&#xe692;</i>公司认证</h6>
    </el-row>
    <el-row class="rowClass">
      <el-button class="buttonClass" @click="$router.push('/account/Authentication')">认证中心</el-button>
    </el-row>
    <el-row class="rowClass2">
      <h6 class="textClass"><i class="factory-card-info">&#xe694;</i>联系方式</h6>
    </el-row>
    <el-row class="rowClass" type="flex" justify="space-between">
      <el-col :span="8">
        <h6 class="textClass2">联系人</h6>
      </el-col>
      <el-col :span="16">
        <h6>{{slotData.contactPerson}}</h6>
      </el-col>
    </el-row>
    <el-row class="rowClass" type="flex" justify="space-between">
      <el-col :span="8">
        <h6 class="textClass2">联系电话</h6>
      </el-col>
      <el-col :span="16">
        <h6>{{slotData.contactPhone}}</h6>
      </el-col>
    </el-row>
    <el-row class="rowClass" type="flex" justify="space-between">
      <el-col :span="8">
        <h6 class="textClass2">座机电话</h6>
      </el-col>
      <el-col :span="16">
        <h6>{{slotData.phone}}</h6>
      </el-col>
    </el-row>
    <el-row class="rowClass" type="flex" justify="space-between">
      <el-col :span="8">
        <h6 class="textClass2">微信</h6>
      </el-col>
      <el-col :span="16">
        <h6>{{slotData.wechat}}</h6>
      </el-col>
    </el-row>
    <el-row class="rowClass" type="flex" justify="space-between">
      <el-col :span="8">
        <h6 class="textClass2">QQ号码</h6>
      </el-col>
      <el-col :span="16">
        <h6>{{slotData.qq}}</h6>
      </el-col>
    </el-row>
    <el-row class="rowClass" type="flex" justify="space-between">
      <el-col :span="8">
       <h6>邮箱地址</h6>
      </el-col>
      <el-col :span="16">
        <h6>{{slotData.email}}</h6>
      </el-col>
    </el-row>
    <el-row class="rowClass" type="flex" justify="space-between">
      <el-col :span="8">
        <h6 class="textClass2">
          经营地址
        </h6>
      </el-col>
      <el-col :span="16">
        <h6 v-if="slotData.contactAddress != null">
          {{slotData.contactAddress.details}}
        </h6>
      </el-col>
    </el-row>
<!--    <el-row class="rowClass" type="flex" justify="space-between" >-->
<!--      <el-col :span="8">-->
<!--        <h6 class="textClass2">坐标定位</h6>-->
<!--      </el-col>-->
<!--      <el-col :span="16">-->
<!--        <h6>{{slotData.locationAddress}}</h6>-->
<!--      </el-col>-->
<!--    </el-row>-->
  </div>
</template>

<script>
    export default {
      name: 'BrandCardInfoPage',
      components: {},
      props: ['slotData'],
      computed: {},
      created () {

      },
      data: {

      }
    }
</script>

<style scoped>
  .brand-card .rowClass{
    margin-top:10px;
  }
  .brand-card .rowClass2{
    margin-top:40px;
  }
  .brand-card .textClass{
    font-size: 15px;
    font-weight: bold;
  }
  .brand-card .textClass2{
    text-align: justify;
    text-align-last: justify;
    display: block;
    width: 57px;
  }
  .brand-card .buttonClass{
    padding: 10px;background-color: #FFD60C;
    border-radius:8px;
    width: 100%;
  }
</style>
