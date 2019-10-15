<template>
  <div class="animated fadeIn requirement-basic">
    <el-row type="flex" class="rowClass">
      <el-col :span="3">
        <div class="demo-image__preview">
          <el-image
            style="width: 100px; height: 100px;border-radius: 9px"
            :src="slotData.details.pictures != null && slotData.details.pictures.length > 0 ? slotData.details.pictures[0].url : 'static/img/nopicture.png'"
            :preview-src-list="picUrls">
          </el-image>
        </div>
      </el-col>
      <el-col :span="21">
          <el-row type="flex">
            <el-col :span="5">
              <el-row type="flex" class="rowClass2">
                <el-col :span="6">
                  <h6 class="titleTextClass">联系人</h6>
                </el-col>
                <el-col :span="16" :offset="2">
                  <h6 class="contentTextClass">{{slotData.details.contactPerson}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" class="rowClass2">
                <el-col :span="6">
                  <h6 class="titleTextClass">品牌标题</h6>
                </el-col>
                <el-col :span="16" :offset="2">
                  <h6 class="contentTextClass">{{slotData.details.productName}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" class="rowClass2">
                <el-col :span="6">
                  <h6 class="titleTextClass">订购数量</h6>
                </el-col>
                <el-col :span="16" :offset="2">
                  <h6 class="contentTextClass">{{slotData.details.expectedMachiningQuantity}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" class="rowClass2">
                <el-col :span="6">
                  <h6 class="titleTextClass">产品品类</h6>
                </el-col>
                <el-col :span="16" :offset="2">
                  <h6 class="contentTextClass">{{slotData.details.category != null ? slotData.details.category.name : ''}}</h6>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="5">
              <el-row type="flex" class="rowClass2">
                <el-col :span="6">
                  <h6 class="titleTextClass">交货日期</h6>
                </el-col>
                <el-col :span="16" :offset="2">
                  <h6 class="contentTextClass">{{slotData.details.expectedDeliveryDate | timestampToTime}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" class="rowClass2">
                <el-col :span="6">
                  <h6 class="titleTextClass">联系方式</h6>
                </el-col>
                <el-col :span="16" :offset="2">
                  <h6 class="contentTextClass">{{slotData.details.contactPhone}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" class="rowClass2">
                <el-col :span="6">
                  <h6 class="titleTextClass">期望价格</h6>
                </el-col>
                <el-col :span="16" :offset="2">
                  <h6 class="contentTextClass">{{slotData.details.maxExpectedPrice}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" class="rowClass2">
                <el-col :span="6">
                  <h6 class="titleTextClass">生产地区</h6>
                </el-col>
                <el-col :span="16" :offset="2">
                  <h6 class="contentTextClass">{{productionAreas}}</h6>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="6">
              <el-row type="flex" class="rowClass2">
                <el-col :span="8">
                  <h6 class="titleTextClass2">合作方式</h6>
                </el-col>
                <el-col :span="14" :offset="2">
                  <h6 class="contentTextClass">{{getEnum('machiningTypes',slotData.details.machiningType)}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" class="rowClass2">
                <el-col :span="8">
                  <h6 class="titleTextClass2">是否需要打样</h6>
                </el-col>
                <el-col :span="14" :offset="2">
                  <h6 class="contentTextClass">{{getYesNo(slotData.details.proofingNeeded)}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" class="rowClass2">
                <el-col :span="8">
                  <h6 class="titleTextClass2">是否需要样衣</h6>
                </el-col>
                <el-col :span="14" :offset="2">
                  <h6 class="contentTextClass">{{getYesNo(slotData.details.samplesNeeded)}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" class="rowClass2">
                <el-col :span="8">
                  <h6 class="titleTextClass2">是否需要发票</h6>
                </el-col>
                <el-col :span="14" :offset="2">
                  <h6 class="contentTextClass">{{getYesNo(slotData.details.invoiceNeeded)}}</h6>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" class="rowClass2">
                <el-col :span="6">
                  <h6 class="titleTextClass2">附件</h6>
                </el-col>
                <el-col :span="16" :offset="2">
                  <el-row type="flex" align="middle" v-for="item of slotData.attachments">
                    <el-col :span="20">
                      <h6 class="contentTextClass">{{getFileName(item.url)}}</h6>
                    </el-col>
                    <el-col :span="4">
                      <el-link class="linkClass" :href="item.url" target="_blank" :underline="false">下载</el-link>
                    </el-col>
                  </el-row>
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
      </el-col>
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
