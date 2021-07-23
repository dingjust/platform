<template>
  <div class="animated fadeIn requirement-basic">
    <!--<el-row><h6>产品图片</h6></el-row>-->
    <el-row type="flex" class="rowClass">
      <el-col style="width: 130px">
        <div class="demo-image__preview">
          <el-image
            style="width: 100px; height: 100px;border-radius: 9px"
            :src="slotData.details.pictures != null && slotData.details.pictures.length > 0 ? slotData.details.pictures[0].url : 'static/img/nopicture.png'"
            :preview-src-list="picUrls" :z-index="9999">
          </el-image>
        </div>
      </el-col>
      <el-col>
        <el-row type="flex" class="rowClass">
          <el-col :span="12">
            <el-row type="flex">
              <h6 class="titleTextClass2">标题</h6>
              <h6 class="contentTextClass">{{slotData.details.productName}}</h6>
            </el-row>
          </el-col>
          <el-col :span="12">
            <el-row type="flex">
              <h6 class="titleTextClass2">面料类别</h6>
              <h6 class="contentTextClass">{{slotData.details.majorCategory ? slotData.details.majorCategory.name : ''}}</h6>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" class="rowClass">
          <el-col :span="12">
            <el-row type="flex">
              <h6 class="titleTextClass2">订购数量</h6>
              <h6 class="contentTextClass">{{slotData.details.expectedMachiningQuantity}}</h6>
            </el-row>
          </el-col>
          <el-col :span="12">
            <el-row type="flex">
              <h6 class="titleTextClass2">产品品类</h6>
              <h6 class="contentTextClass">{{slotData.details.category != null ? slotData.details.category.name : ''}}</h6>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" class="rowClass">
          <el-col :span="12">
            <el-row type="flex">
              <h6 class="titleTextClass2">联系人</h6>
              <h6 class="contentTextClass">{{slotData.details.agentContactPerson ? slotData.details.agentContactPerson : slotData.details.contactPerson}}</h6>
            </el-row>
          </el-col>
          <el-col :span="12">
            <el-row type="flex">
              <h6 class="titleTextClass2">联系方式</h6>
              <h6 class="contentTextClass">{{slotData.details.agentContactPhone ? slotData.details.agentContactPhone : slotData.details.contactPhone}}</h6>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" class="rowClass">
          <el-col :span="12">
            <el-row type="flex">
              <h6 class="titleTextClass2">微信号</h6>
              <h6 class="contentTextClass">{{slotData.details.contactWeChatNo}}</h6>
            </el-row>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <el-row style="padding:10px;border:1px solid #c8c8c8;border-radius: 8px">
      <el-row type="flex">
        <el-col :span="8">
          <el-row type="flex" class="rowClass2">
            <h6 class="titleTextClass2">期望价格</h6>
            <h6 class="contentTextClass">
              {{slotData.details.maxExpectedPrice === -1 ? '面议' : slotData.details.maxExpectedPrice}}
            </h6>
          </el-row>
        </el-col>
        <el-col :span="8">
          <el-row type="flex" class="rowClass2">
            <h6 class="titleTextClass2">交货日期</h6>
            <h6 class="contentTextClass">{{slotData.details.expectedDeliveryDate | timestampToTime}}</h6>
          </el-row>
        </el-col>
        <el-col :span="8">
          <el-row type="flex" class="rowClass2">
            <h6 class="titleTextClass2">生产地区</h6>
            <h6 class="contentTextClass">{{productionAreas}}</h6>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex">
        <el-col :span="8">
          <el-row type="flex" class="rowClass2">
            <h6 class="titleTextClass2">合作方式</h6>
            <h6 class="contentTextClass">{{getEnum('machiningTypes',slotData.details.machiningType)}}</h6>
          </el-row>
        </el-col>
        <el-col :span="8">
          <el-row type="flex" class="rowClass2">
            <h6 class="titleTextClass2">是否需要打样</h6>
            <h6 class="contentTextClass">{{getYesNo(slotData.details.proofingNeeded)}}</h6>
          </el-row>
        </el-col>
        <el-col :span="8">
          <el-row type="flex" class="rowClass2">
            <h6 class="titleTextClass2">是否需要发票</h6>
            <h6 class="contentTextClass">{{getYesNo(slotData.details.invoiceNeeded)}}</h6>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex">
        <el-col :span="8">
          <el-row type="flex" class="rowClass2">
            <h6 class="titleTextClass2">订单尺码</h6>
            <h6 class="contentTextClass" v-if="slotData.details.sizeType">
              {{getEnum('RequirementSizeType',slotData.details.sizeType)}}</h6>
          </el-row>
        </el-col>
        <el-col :span="8">
          <el-row type="flex" class="rowClass2">
            <h6 class="titleTextClass2">订单颜色</h6>
            <h6 class="contentTextClass" v-if="slotData.details.colorType">
              {{getEnum('RequirementColorType',slotData.details.colorType)}}</h6>
          </el-row>
        </el-col>
        <el-col :span="8">
          <el-row type="flex" class="rowClass2">
            <h6 class="titleTextClass2">生产地区</h6>
            <h6 class="contentTextClass">{{productiveDistricts}}</h6>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex">
        <el-col :span="8">
          <el-row type="flex" class="rowClass2">
            <h6 class="titleTextClass2">工厂规模</h6>
            <h6 class="contentTextClass" v-if="slotData.details.populationScale">
              {{getEnum('populationScales',slotData.details.populationScale)}}</h6>
          </el-row>
        </el-col>
        <el-col :span="8">
          <el-row type="flex" class="rowClass2">
            <h6 class="titleTextClass2">生产模式</h6>
            <h6 class="contentTextClass" v-if="slotData.details.productionMode">
              {{getEnum('ProductionModes',slotData.details.productionMode)}}</h6>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" class="rowClass2">
        <h6 class="titleTextClass2">备注</h6>
        <h6 class="contentTextClass">{{slotData.remarks}}</h6>
      </el-row>
      <el-row type="flex" class="rowClass2">
        <el-col style="width: 105px">
          <h6 class="titleTextClass2">附件</h6>
        </el-col>
        <el-col>
          <el-row type="flex" align="middle" v-for="(item, index) of slotData.attachments" :key="index">
              <h6 class="contentTextClass" style="margin-right: 20px">{{getFileName(item.url)}}</h6>
              <el-link class="linkClass" :href="item.url" :download="getFileName(item.url)" target="_blank" :underline="false">下载</el-link>
          </el-row>
        </el-col>
      </el-row>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'RequirementOrderBasicInfoPage',
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
        if (this.slotData.details.productiveOrientations && this.slotData.details.productiveOrientations.length > 0) {
          return this.slotData.details.productiveOrientations.map(item => item.name).toString();
        }

        return '';
      },
      productiveDistricts: function () {
        // 新修改 使用productiveDistricts
        let productiveDistricts = '';
        if (this.slotData.details.productiveDistricts && this.slotData.details.productiveDistricts.length > 0) {
          this.slotData.details.productiveDistricts.forEach(item => productiveDistricts += item.name + ', ');
          return productiveDistricts.substring(0, productiveDistricts.length - 3);
        }
        return '';
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
  .requirement-basic .rowClass{
    margin-bottom:10px;
  }
  .requirement-basic .rowClass2{
    margin-bottom:20px;
  }
  .requirement-basic .textClass{
    font-size: 15px;
    font-weight: bold;
  }
  .requirement-basic .titleTextClass{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-weight: bold;
  }

  .requirement-basic .titleTextClass2{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 85px;
    font-weight: bold;
    margin-right: 20px;
  }

  .requirement-basic .contentTextClass{
    color: #A9A9A9;
    font-weight: 400;
  }

  .requirement-basic .linkClass{
    color: #ffd60c;
    margin-bottom: 6px;
  }

</style>
