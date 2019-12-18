<template>
  <div class="animated fadeIn factory-capacity-form">
        <el-row>
          <div class="titleClass">
            <h6>工厂能力</h6>
          </div>
        </el-row>
        <div style="margin: 20px 20px 40px 40px">
          <el-row type="flex" align="middle" :gutter="20">
            <el-col :span="8">
              <el-form-item prop="design">
                <template slot="label">
                  <h6 class="titleTextClass">设计</h6>
                </template>
                <el-select v-model="formData.design" size="mini" placeholder="请选择" style="width: 100%;">
                  <el-option
                    v-for="item in factoryDesigns"
                    :key="item.code"
                    :label="item.name"
                    :value="item.code">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item prop="pattern">
                <template slot="label">
                  <h6 class="titleTextClass">免费打板</h6>
                </template>
                <el-select v-model="formData.pattern" size="mini" placeholder="请选择" style="width: 100%;">
                  <el-option
                    v-for="item in factoryPatterns"
                    :key="item.code"
                    :label="item.name"
                    :value="item.code">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item prop="coverageArea">
                <template slot="label">
                  <h6 class="titleTextClass">覆盖范围</h6>
                </template>
                <el-input placeholder="请填写覆盖范围" v-model="formData.coverageArea" size="mini"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" align="middle" :gutter="20">
            <el-col :span="8">
              <el-form-item prop="cooperationModes">
                <template slot="label">
                  <h6 class="titleTextClass">合作方式<span style="color: red">*</span></h6>
                </template>
                <el-select v-model="formData.cooperationModes" multiple placeholder="请选择" size="mini" style="width: 100%;">
                  <el-option
                    v-for="item in cooperationModes"
                    :key="item.code"
                    :label="item.name"
                    :value="item.code">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="8">
<!--              <el-form-item prop="qualityLevel">-->
<!--                <template slot="label">-->
<!--                  <h6 class="titleTextClass">质量等级<span style="color: red">*</span></h6>-->
<!--                </template>-->
<!--                <el-select v-model="formData.qualityLevel" placeholder="请选择" size="mini" style="width: 100%;">-->
<!--                  <el-option-->
<!--                    v-for="item in factoryQualityLevels"-->
<!--                    :key="item.code"-->
<!--                    :label="item.name"-->
<!--                    :value="item.code">-->
<!--                  </el-option>-->
<!--                </el-select>-->
<!--              </el-form-item>-->
              <el-form-item prop="qualityLevels">
                <template slot="label">
                  <h6 class="titleTextClass">质量等级<span style="color: red">*</span></h6>
                </template>
                <el-select v-model="formData.qualityLevels" multiple placeholder="请选择" style="width: 100%">
                  <el-option v-for="item in FactoryQualityLevel" :key="item.code" :label="item.name" :value="item.code">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="8">
              <el-form-item prop="labels">
                <template slot="label">
                  <h6 class="titleTextClass">工厂标签</h6>
                </template>
                <el-select v-model="formData.labels" multiple value-key="id" size="mini" placeholder="请选择" style="width: 100%;">
                  <el-option
                    v-for="item in labels"
                    :key="item.id"
                    :label="item.name"
                    :value="item">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>
          <el-form-item prop="cooperativeBrand">
            <template slot="label">
              <h6 class="titleTextClass">合作商</h6>
            </template>
            <tags-of-text :label="'合作商'" @remove="onRemoveCooperativeBrand" @add="onAddCooperativeBrand" :textData="formData.cooperativeBrand" :symbol="'，'"></tags-of-text>
          </el-form-item>
          <el-form-item prop="categories">
            <template slot="label">
              <h6 class="titleTextClass">生产大类<span style="color: red">*</span></h6>
            </template>
            <el-tag v-for="val of majorCategories" class="elTagClass" :color="isSelected(val) ? '#FFD60C' : '#ffffff'"
                    @click="handleTagClick(val)" size="medium">
              {{val.name}}
            </el-tag>
          </el-form-item>
          <el-form-item prop="adeptAtCategories">
            <template slot="label">
              <h6 class="titleTextClass">优势品类<span style="color: red">*</span></h6>
            </template>
            <category-select v-if="factoryFormVisible" :listData="categories" :selectDatas="formData.adeptAtCategories"></category-select>
          </el-form-item>
          <el-form-item prop="keyword">
            <template slot="label">
              <h6 class="titleTextClass">关键词</h6>
            </template>
            <tags-of-text :label="'关键词'" @remove="onRemoveKeyword" @add="onAddKeyword" :textData="formData.keyword" :symbol="'，'"></tags-of-text>
            <span style="font-size: 10px;color: #F56C6C">品牌用户可以通过关键词搜索到您</span>
          </el-form-item>
          <el-row type="flex" justify="start" align="middle">
            <el-col :span="4" style="margin-left: 20px">
              <h6>
                上传资质荣誉照片：
              </h6>
              <h6 style="color: grey">
                &nbsp;&nbsp;&nbsp;&nbsp;(最多五张)
              </h6>
            </el-col>
            <el-col :span="22">
              <images-upload :limit="5" :slot-data="formData.certificates" />
              <h6 style="margin-left: 30px;font-size: 10px;color: grey">只支持.jpg格式</h6>
            </el-col>
          </el-row>
        </div>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapMutations} = createNamespacedHelpers('FactoriesModule');

  import CategorySelect from '../../../../../components/custom/CategorySelect';
  import TagsOfText from '../../../../../components/custom/TagsOfText';
  import ImagesUpload from '../../../../../components/custom/ImagesUpload';
  export default {
    name: 'FactoryCapacityForm',
    props: ['formData'],
    components: {ImagesUpload, TagsOfText, CategorySelect},
    computed: {
      ...mapGetters({
        factoryFormVisible: 'factoryFormVisible',
        labels: 'labels'
      })
    },
    methods: {
      ...mapMutations({
        setLabels: 'setLabels'
      }),
      async getLabels () {
        const url = this.apis().getGroupLabels('FACTORY');
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setLabels(result);
      },
      async getCategories () {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.categories = result;
      },
      onRemoveKeyword (word) {
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
      onAddKeyword (word) {
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
      onRemoveCooperativeBrand (word) {
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
      onAddCooperativeBrand (word) {
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
      async getMajorCategories () {
        const url1 = this.apis().getMajorCategories();
        const result1 = await this.$http.get(url1);
        if (result1['errors']) {
          this.$message.error(result1['errors'][0].message);
          return;
        }

        this.majorCategories = result1;
      },
      isSelected (val) {
        var index = this.selectCodes.indexOf(val.code);
        if (index > -1) {
          return true;
        } else {
          return false;
        }
      },
      handleTagClick (val) {
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
      initShowMajorCategories () {
        for (let i = 0; i < this.formData.categories.length; i++) {
          this.selectCodes.push(this.formData.categories[i].code);
        }
        console.log(this.selectCodes);
      }
    },
    data () {
      return {
        categories: [],
        majorCategories: [],
        selectCodes: [],
        factoryDesigns: this.$store.state.EnumsModule.FactoryDesign,
        factoryPatterns: this.$store.state.EnumsModule.FactoryPattern,
        FactoryQualityLevel: this.$store.state.EnumsModule.FactoryQualityLevel,
        cooperationModes: this.$store.state.EnumsModule.cooperationModes
      };
    },
    created () {
      this.getCategories();
      this.getMajorCategories();
      this.initShowMajorCategories();
    }
  };
</script>

<style>
  .factory-capacity-form .rowClass{
    margin-top:20px;
  }

  .factory-capacity-form .titleClass{
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

  .factory-capacity-form .titleTextClass{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-size: 12px;
    /*font-weight: bold;*/
  }

  .factory-capacity-form .el-input--mini .el-input__inner{
    width: 100%;
  }
  .el-tag{
    border-color: white;
  }
</style>
