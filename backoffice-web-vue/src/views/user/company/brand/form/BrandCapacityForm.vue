<template>
  <div class="animated fadeIn brand-capacity-form">
    <el-row>
      <div class="titleClass">
        <h6>品牌信息</h6>
      </div>
    </el-row>
    <div style="margin: 20px 20px 40px 40px">
      <el-form-item prop="cooperativeBrand">
        <template slot="label">
          <h6 class="titleTextClass">合作商</h6>
        </template>
        <tags-of-text :label="'合作商'" @remove="onRemoveCooperativeBrand" @add="onAddCooperativeBrand" :textData="formData.cooperativeBrand" :symbol="'，'"></tags-of-text>
      </el-form-item>
      <el-row type="flex" align="middle"  :gutter="20">
        <el-col :span="8">
          <el-form-item prop="scaleRange">
            <template slot="label">
              <h6 class="titleTextClass">产值规模</h6>
            </template>
            <el-row type="flex">
              <el-select v-model="formData.scaleRange" placeholder="请选择" size="mini" style="width: 100%;">
                <el-option
                  v-for="item in scaleRanges"
                  :key="item.code"
                  :label="item.name"
                  :value="item.code">
                </el-option>
              </el-select>
            </el-row>
          </el-form-item>
        </el-col>
        <el-col :span="8">
<!--          <el-form-item prop="salesMarket">-->
<!--            <template slot="label">-->
<!--              <h6 class="titleTextClass">主营市场</h6>-->
<!--            </template>-->
<!--            <el-select v-model="formData.qualityLevel" placeholder="请选择" size="mini" style="width: 100%;">-->
<!--              <el-option-->
<!--                v-for="item in factoryQualityLevels"-->
<!--                :key="item.code"-->
<!--                :label="item.name"-->
<!--                :value="item.code">-->
<!--              </el-option>-->
<!--            </el-select>-->
<!--          </el-form-item>-->
          <el-form-item prop="salesMarket">
            <template slot="label">
              <h6 class="titleTextClass">主营市场</h6>
            </template>
            <el-select v-model="formData.salesMarket" multiple placeholder="请选择" style="width: 100%">
              <el-option v-for="item in SalesMarkets" :key="item.code" :label="item.name" :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-form-item prop="adeptAtCategories">
        <template slot="label">
          <h6 class="titleTextClass">优势品类</h6>
        </template>
        <category-select :listData="categories" :selectDatas="formData.adeptAtCategories"></category-select>
      </el-form-item>
      <el-form-item prop="style">
        <template slot="label">
          <h6 class="titleTextClass">风格</h6>
        </template>
        <el-tag v-for="val of styles" class="elTagClass" :color="isSelected(val) ? '#FFD60C' : '#ffffff'"
                @click="handleTagClick(val)" size="medium">
                {{val.name}}
        </el-tag>
      </el-form-item>
    </div>
  </div>
</template>

<script>
    import TagsOfText from '../../../../../components/custom/TagsOfText';
    import EnumSelect from '../../../../../components/custom/EnumSelect';
    import CategorySelect from '../../../../../components/custom/CategorySelect';

    export default {
      name: 'BrandCapacityForm',
      components: {EnumSelect, CategorySelect, TagsOfText},
      props: ['formData'],
      data () {
        return {
          styles: this.$store.state.EnumsModule.productStyles,
          categories: [],
          scaleRanges: this.$store.state.EnumsModule.scaleRanges,
          SalesMarkets: this.$store.state.EnumsModule.SalesMarkets,
          selectCodes: []
        }
      },
      methods: {
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
        async getCategories () {
          const url = this.apis().getMinorCategories();
          const result = await this.$http.get(url);
          if (result['errors']) {
            this.$message.error(result['errors'][0].message);
            return;
          }
          this.categories = result;
          console.log(this.categories);
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
          var mapIndex = this.formData.styles.indexOf(val.code);
          if (mapIndex > -1) {
            this.formData.styles.splice(mapIndex, 1);
          } else {
            this.formData.styles.push(val.code);
          }

          var index = this.selectCodes.indexOf(val.code);
          if (index > -1) {
            this.selectCodes.splice(index, 1);
          } else {
            this.selectCodes.push(val.code);
          }
        },
        initStyles () {
          for (let i = 0; i < this.formData.styles.length; i++) {
            this.selectCodes.push(this.formData.styles[i])
          }
        }
      },
      created () {
        this.getCategories();
        this.initStyles();
      }
    }
</script>

<style scoped>
  .brand-capacity-form .rowClass{
    margin-top:20px;
  }

  .brand-capacity-form .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #DCDCDC;
  }

  .brand-capacity-form .brand-upload {
    margin-left: 80px;
  }

  .brand-capacity-form .brand-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .brand-capacity-form .brand-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

  .brand-capacity-form .info-input-prepend {
    display: inline-block;
    width: 70px;
    font-weight: bold;
    font-size: 10px;
  }

  .brand-capacity-form .titleTextClass{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-size: 12px;
    /*font-weight: bold;*/
  }

  .brand-capacity-form .el-input--mini .el-input__inner{
    width: 100%;
  }

  .elTagClass{
    color: #0b0e0f;
    margin-right: 20px;
    margin-bottom: 10px;
    cursor:pointer;
  }
  .el-tag{
    border-color: white;
  }
</style>
