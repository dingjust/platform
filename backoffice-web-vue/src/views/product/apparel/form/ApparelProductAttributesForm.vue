<template>
  <div class="animated fadeIn product-attributes">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">产品属性</h6>
      </div>
    </el-row>
    <template v-if="show">
      <el-row>
        <el-col :span="3">
          <h6 class="info-title_text product-attributes-title">风格<span class="info-title_text-sub">(可多选)</span>：</h6>
        </el-col>
        <el-col :span="20">
          <el-checkbox-group v-model="slotData.attributes.styles" text-color="#000000" fill="#ffd60c">
            <template v-for="item in productStyles">
              <el-checkbox-button :label="item.code">{{item.name}}</el-checkbox-button>
            </template>
          </el-checkbox-group>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="3">
          <h6 class="info-title_text product-attributes-title">面料成分<span class="info-title_text-sub">(可多选)</span>：</h6>
        </el-col>
        <el-col :span="20">
          <el-checkbox-group v-model="slotData.attributes.fabricCompositions" text-color="#000000" fill="#ffd60c">
            <template v-for="item in fabricCompositions">
              <el-checkbox-button :label="item.code">{{item.name}}</el-checkbox-button>
            </template>
          </el-checkbox-group>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="3">
          <h6 class="info-title_text product-attributes-title">版型：</h6>
        </el-col>
        <el-col :span="20">
          <el-radio-group v-model="slotData.attributes.editionType" text-color="#000000" fill="#ffd60c">
            <template v-for="item in editionTypes">
              <el-radio-button :label="item.code">{{item.name}}</el-radio-button>
            </template>
          </el-radio-group>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="3">
          <h6 class="info-title_text product-attributes-title">款式：</h6>
        </el-col>
        <el-col :span="20">
          <el-radio-group v-model="slotData.attributes.pattern" text-color="#000000" fill="#ffd60c">
            <template v-for="item in productPatterns">
              <el-radio-button :label="item.code">{{item.name}}</el-radio-button>
            </template>
          </el-radio-group>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="3">
          <h6 class="info-title_text product-attributes-title">袖型：</h6>
        </el-col>
        <el-col :span="20">
          <el-radio-group v-model="slotData.attributes.sleeveType" text-color="#000000" fill="#ffd60c">
            <template v-for="item in sleeveTypes">
              <el-radio-button :label="item.code">{{item.name}}</el-radio-button>
            </template>
          </el-radio-group>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="3">
          <h6 class="info-title_text product-attributes-title">袖长：</h6>
        </el-col>
        <el-col :span="20">
          <el-radio-group v-model="slotData.attributes.sleeveLength" text-color="#000000" fill="#ffd60c">
            <template v-for="item in sleeveLengths">
              <el-radio-button :label="item.code">{{item.name}}</el-radio-button>
            </template>
          </el-radio-group>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="3">
          <h6 class="info-title_text product-attributes-title">图案：</h6>
        </el-col>
        <el-col :span="20">
          <el-checkbox-group v-model="slotData.attributes.decorativePatterns" :max="1" text-color="#000000"
            fill="#ffd60c">
            <template v-for="item in decorativePatterns">
              <el-checkbox-button :label="item.code">{{item.name}}</el-checkbox-button>
            </template>
          </el-checkbox-group>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="3">
          <h6 class="info-title_text product-attributes-title">流行元素：</h6>
        </el-col>
        <el-col :span="20">
          <el-checkbox-group v-model="slotData.attributes.popularElements" text-color="#000000" fill="#ffd60c">
            <template v-for="item in popularElements">
              <el-checkbox-button :max="1" :label="item.code">{{item.name}}</el-checkbox-button>
            </template>
          </el-checkbox-group>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="3">
          <h6 class="info-title_text product-attributes-title">填充物：</h6>
        </el-col>
        <el-col :span="20">
          <el-radio-group v-model="slotData.attributes.filler" text-color="#000000" fill="#ffd60c">
            <template v-for="item in productFillers">
              <el-radio-button :label="item.code">{{item.name}}</el-radio-button>
            </template>
          </el-radio-group>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="3">
          <h6 class="info-title_text product-attributes-title">厚薄：</h6>
        </el-col>
        <el-col :span="20">
          <el-radio-group v-model="slotData.attributes.thickness" text-color="#000000" fill="#ffd60c">
            <template v-for="item in productThicknesses">
              <el-radio-button :label="item.code">{{item.name}}</el-radio-button>
            </template>
          </el-radio-group>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="3">
          <h6 class="info-title_text product-attributes-title">季节：</h6>
        </el-col>
        <el-col :span="20">
          <el-radio-group v-model="slotData.attributes.season" text-color="#000000" fill="#ffd60c">
            <template v-for="item in productSeasons">
              <el-radio-button :label="item.code">{{item.name}}</el-radio-button>
            </template>
          </el-radio-group>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="3">
          <h6 class="info-title_text product-attributes-title">门襟：</h6>
        </el-col>
        <el-col :span="20">
          <el-radio-group v-model="slotData.attributes.placket" text-color="#000000" fill="#ffd60c">
            <template v-for="item in plackets">
              <el-radio-button :label="item.code">{{item.name}}</el-radio-button>
            </template>
          </el-radio-group>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="3">
          <h6 class="info-title_text product-attributes-title">吊牌：</h6>
        </el-col>
        <el-col :span="20">
          <el-radio-group class="product-attributes-radio-group" v-model="slotData.attributes.taggable"
            text-color="#000000" fill="#ffd60c">
            <el-radio :label="true" :key="1" class="product-attributes-radio">有</el-radio>
            <el-radio :label="false" :key="0" class="product-attributes-radio">没有</el-radio>
          </el-radio-group>
        </el-col>
      </el-row>
    </template>
    <el-row type="flex" justify="center" align="center" class="orders-info-table-btn">
      <i class="iconfont icon_arrow" v-if="!show" @click="show=true">&#xe714;&nbsp;展开全部属性</i>
      <i class="iconfont icon_arrow" v-if="show" @click="show=false">&#xe713;&nbsp;收回</i>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ApparelProductAttributesForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        this.$refs.form.validate(callback);
      },
    },
    computed: {},
    data() {
      return {
        productStyles: this.$store.state.EnumsModule.productStyles,
        fabricCompositions: this.$store.state.EnumsModule.fabricCompositions,
        editionTypes: this.$store.state.EnumsModule.editionTypes,
        productPatterns: this.$store.state.EnumsModule.productPatterns,
        sleeveTypes: this.$store.state.EnumsModule.sleeveTypes,
        sleeveLengths: this.$store.state.EnumsModule.sleeveLengths,
        decorativePatterns: this.$store.state.EnumsModule.decorativePatterns,
        popularElements: this.$store.state.EnumsModule.popularElements,
        productFillers: this.$store.state.EnumsModule.productFillers,
        productThicknesses: this.$store.state.EnumsModule.productThicknesses,
        productSeasons: this.$store.state.EnumsModule.productSeasons,
        plackets: this.$store.state.EnumsModule.plackets,
        show: false,
      };
    },
    created() {}
  };

</script>
<style>
  .product-attributes .el-checkbox-button--small .el-checkbox-button__inner {
    margin-left: 5px;
    margin-right: 5px;
    border: 0px;
    color: rgb(0, 0, 1, 0.45);
  }

  .product-attributes .el-radio-button--small .el-radio-button__inner {
    margin-left: 5px;
    margin-right: 5px;
    border: 0px;
    color: rgb(0, 0, 1, 0.45);
  }

  .product-attributes-title {
    padding-top: 9px;
    font-weight: 500;
  }

  .product-attributes-radio {
    color: rgb(0, 0, 1, 0.45);

  }

  .product-attributes-radio-group {
    margin-left: 25px;
  }

  .icon_arrow {
    font-family: "iconfont" !important;
    font-size: 12px;
    /* font-weight: 400; */
    color: #FF7A7A;
    font-style: normal;
    -webkit-font-smoothing: antialiased;
    -webkit-text-stroke-width: 0.2px;
    -moz-osx-font-smoothing: grayscale;
    cursor: pointer;
  }

</style>
