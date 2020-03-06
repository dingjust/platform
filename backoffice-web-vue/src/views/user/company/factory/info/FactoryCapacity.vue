<template>
  <div class="animated fadeIn factory-capacity-form">
    <el-row>
      <div class="titleClass">
        <h6>工厂能力</h6>
      </div>
    </el-row>
    <div style="margin: 20px 20px 40px 40px">
      <el-row class="info-row" type="flex" justify="start" align="bottom" :gutter="30">
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">设计</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <h6 class="info-data">{{getEnum('FactoryDesign',formData.design)}}</h6>
        </el-col>
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">免费打板</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <h6 class="info-data">{{getEnum('FactoryPattern',formData.pattern)}}</h6>
        </el-col>
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">覆盖范围</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <h6 class="info-data">{{formData.coverageArea}}</h6>
        </el-col>
      </el-row>
      <el-row class="info-row" type="flex" justify="start" align="bottom" :gutter="30">
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">合作方式</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex">
            <template v-for="val in formData.cooperationModes">
              <h6 :key="val" class="info-data" style="margin-right:10px;">{{getEnum('cooperationModes',val)}}</h6>
            </template>
          </el-row>
        </el-col>
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">质量等级</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex">
            <template v-for="val in formData.qualityLevels">
              <h6 :key="val" class="info-data" style="margin-right:10px;">{{getEnum('FactoryQualityLevel',val)}}</h6>
            </template>
          </el-row>
        </el-col>
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">工厂标签</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex">
            <template v-for="val in formData.labels">
              <h6 :key="val.code" class="info-data" style="margin-right:10px;">{{val.name}}</h6>
            </template>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="info-row" type="flex" justify="start" align="bottom" :gutter="30">
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">合作商</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex">
            <template v-for="val in cooperativeBrands">
              <h6 :key="val" class="info-data" style="margin-right:10px;">{{val}}</h6>
            </template>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="info-row" type="flex" justify="start" align="middle" :gutter="30">
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">生产大类</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <el-tag v-for="val of formData.categories" class="elTagClass" style="margin-top:0px;color:black;"
              color="#FFD60C" :key="val.code" size="medium">
              {{val.name}}
            </el-tag>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="info-row" type="flex" justify="start" :gutter="30">
        <el-col :span="2">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">优势品类<span style="color: red">*</span></h6>
          </el-row>
        </el-col>
        <el-col :span="18">
          <template v-for="(values,key) in adeptAtCategories">
            <el-row type="flex" align="middle" style="padding-top:10px" :key="key">
              <el-badge :value="values.length" class="item">
                <h6>{{key}}</h6>
              </el-badge>
            </el-row>
            <el-divider :key="key"></el-divider>
            <template v-for="val of values">
              <el-tag class="elTagClass" color="#FFD60C" size="medium" :key="val" style="color:black;">
                {{val}}
              </el-tag>
            </template>
          </template>
        </el-col>
      </el-row>
      <el-row class="info-row" type="flex" justify="start" :gutter="30">
        <el-col :span="2">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">关键词</h6>
          </el-row>
        </el-col>
        <el-col :span="18">
          <template v-for="val in keywords">
            <el-tag class="elTagClass" style="color:black;" effect="plain" color="#FFD60C" :key="val" size="medium">
              {{val}}
            </el-tag>
          </template>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" align="middle">
        <el-col :span="4" style="margin-left: 20px">
          <h6>
            资质荣誉照片：
          </h6>
          <h6 style="color: grey">
            &nbsp;&nbsp;&nbsp;&nbsp;(最多五张)
          </h6>
        </el-col>
        <el-col :span="22">
          <images-upload :limit="5" :slot-data="formData.certificates" :read-only="readOnly" />
          <h6 style="margin-left: 30px;font-size: 10px;color: grey" v-if="!readOnly">只支持.jpg格式</h6>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapMutations
  } = createNamespacedHelpers('FactoriesModule');

  import CategorySelect from '../../../../../components/custom/CategorySelect';
  import TagsOfText from '../../../../../components/custom/TagsOfText';
  import ImagesUpload from '../../../../../components/custom/ImagesUpload';
  export default {
    name: 'FactoryCapacity',
    props: ['formData', 'readOnly'],
    components: {
      ImagesUpload,
      TagsOfText,
      CategorySelect
    },
    computed: {
      ...mapGetters({
        factoryFormVisible: 'factoryFormVisible',
        labels: 'labels'
      }),
      cooperativeBrands: function () {
        if (this.formData.cooperativeBrand == null) {
          return [];
        } else {
          return this.formData.cooperativeBrand.split('，');
        }
      },
      keywords: function () {
        if (this.formData.keyword == null) {
          return [];
        } else {
          return this.formData.keyword.split('，');
        }
      },
    },
    methods: {
      ...mapMutations({
        setLabels: 'setLabels'
      }),
    },
    data() {
      return {
        adeptAtCategories: {},
        factoryDesigns: this.$store.state.EnumsModule.FactoryDesign,
        factoryPatterns: this.$store.state.EnumsModule.FactoryPattern,
        FactoryQualityLevel: this.$store.state.EnumsModule.FactoryQualityLevel,
        cooperationModes: this.$store.state.EnumsModule.cooperationModes
      };
    },
    created() {
      this.formData.adeptAtCategories.forEach(category => {
        if (this.adeptAtCategories[category.parent.name] != null) {
          this.adeptAtCategories[category.parent.name].push(category.name);
        } else {
          this.adeptAtCategories[category.parent.name] = [category.name];
        }
      });
    }
  };

</script>

<style>
  .factory-capacity-form .rowClass {
    margin-top: 20px;
  }

  .factory-capacity-form .titleClass {
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

  .factory-capacity-form .factory-upload {
    margin-left: 80px;
  }

  .factory-capacity-form .factory-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .factory-capacity-form .factory-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .factory-capacity-form .info-input-prepend {
    display: inline-block;
    width: 70px;
    font-weight: bold;
    font-size: 10px;
  }

  .factory-capacity-form .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-size: 12px;
    /*font-weight: bold;*/
  }

  .factory-capacity-form .el-input--mini .el-input__inner {
    width: 100%;
  }

  .el-tag {
    border-color: white;
  }

  .info-data {
    font-size: 12px;
    padding-top: 5px;
    /* padding-bottom: 2px; */
  }

  .info-row {
    margin-bottom: 10px;
  }

</style>
