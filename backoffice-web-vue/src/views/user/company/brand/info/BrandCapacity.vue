<template>
  <div class="animated fadeIn brand-capacity-form">
    <el-row>
      <div class="titleClass">
        <h6>品牌信息</h6>
      </div>
    </el-row>
    <div style="margin: 20px 20px 40px 40px">
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
      <el-row class="info-row" type="flex" justify="start" align="bottom" :gutter="30">
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">产值规模</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex">
            <h6 :key="val" class="info-data">{{getEnum('scaleRanges',formData.scaleRange)}}</h6>
          </el-row>
        </el-col>
        <el-col :span="2" style="background-color:#80808029;">
          <el-row type="flex" justify="center" align="middle">
            <h6 class="info-data">主营市场</h6>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex">
            <template v-for="val in formData.salesMarket">
              <h6 :key="val" class="info-data" style="margin-right:10px;">{{getEnum('SalesMarkets',val)}}</h6>
            </template>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="info-row" type="flex" justify="start" :gutter="30">
        <el-col :span="2">
          <h6 class="titleTextClass">优势品类<span style="color: red">*</span></h6>
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
          <h6 class="titleTextClass">风格</h6>
        </el-col>
        <el-col :span="18">
          <el-tag v-for="val of styles" :key="val.code" class="elTagClass" color="#FFD60C" v-if="isSelected(val)" size="medium">
            {{val.name}}
          </el-tag>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
  import TagsOfText from '../../../../../components/custom/TagsOfText';
  import EnumSelect from '../../../../../components/custom/EnumSelect';
  import CategorySelect from '../../../../../components/custom/CategorySelect';

  export default {
    name: 'BrandCapacity',
    components: {
      EnumSelect,
      CategorySelect,
      TagsOfText
    },
    props: ['formData', 'readOnly'],
    computed: {
      cooperativeBrands: function () {
        if (this.formData.cooperativeBrand == null) {
          return [];
        } else {
          return this.formData.cooperativeBrand.split('，');
        }
      },
    },
    data() {
      return {
        adeptAtCategories: {},
        styles: this.$store.state.EnumsModule.productStyles,
        categories: [],
        scaleRanges: this.$store.state.EnumsModule.scaleRanges,
        SalesMarkets: this.$store.state.EnumsModule.SalesMarkets,
        selectCodes: []
      }
    },
    methods: {
      isSelected(val) {
        var index = this.formData.styles.indexOf(val.code);
        if (index > -1) {
          return true;
        } else {
          return false;
        }
      },
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
  }

</script>

<style scoped>
  .brand-capacity-form .rowClass {
    margin-top: 20px;
  }

  .brand-capacity-form .titleClass {
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

  .brand-capacity-form .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 57px;
    font-size: 12px;
    /*font-weight: bold;*/
  }

  .brand-capacity-form .el-input--mini .el-input__inner {
    width: 100%;
  }

  .elTagClass {
    color: #0b0e0f;
    margin-right: 20px;
    margin-bottom: 10px;
    cursor: pointer;
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
