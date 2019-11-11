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
                  <h6 class="titleTextClass">打板</h6>
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
          <el-form-item prop="cooperativeBrand">
            <template slot="label">
              <h6 class="titleTextClass">合作商</h6>
            </template>
            <tags-of-text @remove="onRemoveCooperativeBrand" @add="onAddCooperativeBrand" :textData="formData.cooperativeBrand" :symbol="'，'"></tags-of-text>
          </el-form-item>
          <el-form-item prop="adeptAtCategories">
            <template slot="label">
              <h6 class="titleTextClass">选择品类<span style="color: red">*</span></h6>
            </template>
            <category-select v-if="factoryFormVisible"  :selectDatas="formData.adeptAtCategories"></category-select>
          </el-form-item>
          <el-form-item prop="keyword">
            <template slot="label">
              <h6 class="titleTextClass">关键词</h6>
            </template>
            <tags-of-text @remove="onRemoveKeyword" @add="onAddKeyword" :textData="formData.keyword" :symbol="'，'"></tags-of-text>
          </el-form-item>
        </div>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters} = createNamespacedHelpers('FactoriesModule');

  import CategorySelect from '../../../../../components/custom/CategorySelect';
  import TagsOfText from '../../../../../components/custom/TagsOfText';
  export default {
    name: 'FactoryCapacityForm',
    props: ['formData'],
    components: {TagsOfText, CategorySelect},
    computed: {
      ...mapGetters({
        factoryFormVisible: 'factoryFormVisible'
      })
    },
    methods: {
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
      }
    },
    data () {
      return {
        categories: [],
        factoryDesigns: this.$store.state.EnumsModule.FactoryDesign,
        factoryPatterns: this.$store.state.EnumsModule.FactoryPattern
      };
    },
    created () {
      this.getCategories()
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
    font-size: 10px;
    font-weight: bold;
  }

  .factory-capacity-form .el-input--mini .el-input__inner{
    width: 100%;
  }

</style>
