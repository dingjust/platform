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
            <el-tag v-for="val of formData.categories" class="elTagClass" style="margin-top:10px;" color="#FFD60C"
              :key="val.code" size="medium">
              {{val.name}}
            </el-tag>
          </el-row>
        </el-col>
      </el-row>
      <el-form-item prop="adeptAtCategories">
        <template slot="label">
          <h6 class="titleTextClass">优势品类<span style="color: red">*</span></h6>
        </template>
        <template v-for="(values,key) in adeptAtCategories">
          <el-row type="flex" align="middle" style="padding-top:10px" :key="key">
            <el-badge :value="values.length" class="item">
              <h6>{{key}}</h6>
            </el-badge>
          </el-row>
          <el-divider :key="key"></el-divider>
          <template v-for="val of values">
            <el-tag class="elTagClass" color="#FFD60C" size="medium" :key="val">
              {{val}}
            </el-tag>
          </template>
        </template>
        <category-select v-if="factoryFormVisible" :listData="categories" :selectDatas="formData.adeptAtCategories"
          :readOnly="readOnly"></category-select>
      </el-form-item>
      <el-form-item prop="keyword">
        <template slot="label">
          <h6 class="titleTextClass">关键词</h6>
        </template>
        <el-row type="flex">
          <template v-for="val in keywords">
            <el-tag class="elTagClass" style="margin-top:10px;" color="#FFD60C" :key="val" size="medium">
              {{val}}
            </el-tag>
          </template>
        </el-row>
        <span style="font-size: 10px;color: #F56C6C">{{readOnly? '您可以通过关键词搜索到此公司' : '品牌用户可以通过关键词搜索到您'}}</span>
      </el-form-item>
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
        return this.formData.cooperativeBrand.split('，');
      },
      keywords: function () {
        var a = 'asdsad';
        a.sp
        return this.formData.keyword.split('，');
      },
    },
    methods: {
      ...mapMutations({
        setLabels: 'setLabels'
      }),
      async getCategories() {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.categories = result;
      },
      onRemoveKeyword(word) {
        if (this.readOnly) {
          return;
        }
        var keywords = this.formData.keyword.split('，');
        var index = keywords.indexOf(word);
        keywords.splice(index, 1);
        var text = '';
        for (let keyword of keywords) {
          text += keyword;
          text += '，';
        }

        if (text.length > 0) {
          text = text.slice(0, text.lastIndexOf('，'));
        }

        this.formData.keyword = text;
      },
      onAddKeyword(word) {
        if (this.formData.keyword == null || this.formData.keyword === '') {
          this.formData.keyword = word;
          this.$forceUpdate();
          return;
        }
        var keywords = this.formData.keyword.split('，');
        if (keywords.length >= 10) {
          this.$message.error('最多添加10个关键词');
          return;
        }

        var index = this.formData.keyword.indexOf(word);
        if (index !== -1) {
          this.$message.error('该关键词已存在');
          return;
        }

        if (this.formData.keyword != null && this.formData.keyword.length > 0) {
          this.formData.keyword += '，';
          this.formData.keyword += word;
        } else {
          this.formData.keyword = word;
        }

        this.$forceUpdate();
      },
      onRemoveCooperativeBrand(word) {
        if (this.readOnly) {
          return;
        }
        var keywords = this.formData.cooperativeBrand.split('，');
        var index = keywords.indexOf(word);
        keywords.splice(index, 1);
        var text = '';
        for (let keyword of keywords) {
          text += keyword;
          text += '，';
        }

        if (text.length > 0) {
          text = text.slice(0, text.lastIndexOf('，'));
        }

        this.formData.cooperativeBrand = text;
      },
      onAddCooperativeBrand(word) {
        if (this.formData.cooperativeBrand == null || this.formData.cooperativeBrand === '') {
          this.formData.cooperativeBrand = word;
          return;
        }
        var keywords = this.formData.cooperativeBrand.split('，');
        if (keywords.length >= 10) {
          this.$message.error('最多添加10个关键词');
          return;
        }

        var index = this.formData.cooperativeBrand.indexOf(word);
        if (index !== -1) {
          this.$message.error('该关键词已存在');
          return;
        }

        if (this.formData.cooperativeBrand != null && this.formData.cooperativeBrand.length > 0) {
          this.formData.cooperativeBrand += '，';
          this.formData.cooperativeBrand += word;
        } else {
          this.formData.cooperativeBrand = word;
        }
      },
      async getMajorCategories() {
        const url1 = this.apis().getMajorCategories();
        const result1 = await this.$http.get(url1);
        if (result1['errors']) {
          this.$message.error(result1['errors'][0].message);
          return;
        }

        this.majorCategories = result1;
      },
      isSelected(val) {
        var index = this.selectCodes.indexOf(val.code);
        if (index > -1) {
          return true;
        } else {
          return false;
        }
      },
      handleTagClick(val) {
        if (this.readOnly) {
          return;
        }
        var mapIndex = -1;
        for (let i = 0; i < this.formData.categories.length; i++) {
          if (this.formData.categories[i].code == val.code) {
            mapIndex = i;
          }
        }
        if (mapIndex > -1) {
          this.formData.categories.splice(mapIndex, 1);
        } else {
          this.formData.categories.push(val);
        }

        var index = this.selectCodes.indexOf(val.code);
        if (index > -1) {
          this.selectCodes.splice(index, 1);
        } else {
          this.selectCodes.push(val.code);
        }
      },
      initShowMajorCategories() {
        for (let i = 0; i < this.formData.categories.length; i++) {
          this.selectCodes.push(this.formData.categories[i].code);
        }
        console.log(this.selectCodes);
      }
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
