<template>
  <div>
    <el-row class="product-basic-attributes" type="flex" :gutter="50" align="middle">
      <el-col :span="12">
        <el-row type="flex">
          <el-col :span="24">
            <el-row type="flex" align="middle" justify="start" :gutter="10">
              <el-col :span="6">
                <h6 class="attributes-row-label">品牌：</h6>
              </el-col>
              <el-col :span="18">
                <el-input placeholder="请输入品牌" v-model="slotData.brand" size="mini" :disabled="isRead"></el-input>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="12">
        <el-row type="flex">
          <el-col :span="24">
            <el-row type="flex" align="middle" justify="start" :gutter="10">
              <el-col :span="6">
                <h6 class="attributes-row-label" style="">风格<span class="info-title_text-sub">(多选)</span></h6>
              </el-col>
              <el-col :span="18">
                <el-select class="attributes-form-selector" multiple v-model="slotData.attributes.styles"
                  placeholder="请选择">
                  <el-option v-for="item in productStyles" :key="item.code" :label="item.name" :value="item.code">
                  </el-option>
                </el-select>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
      </el-col>
    </el-row>
    <template v-if="showAll">
      <el-row class="product-basic-attributes" type="flex" :gutter="50" align="middle">
        <el-col :span="12">
          <el-row type="flex">
            <el-col :span="24">
              <el-row type="flex" align="middle" justify="start" :gutter="10">
                <el-col :span="6">
                  <h6 class="attributes-row-label" style="">面料成分<span class="info-title_text-sub">(多选)</span></h6>
                </el-col>
                <el-col :span="18">
                  <el-select class="attributes-form-selector" multiple v-model="slotData.attributes.fabricCompositions"
                    placeholder="请选择">
                    <el-option v-for="item in fabricCompositions" :key="item.code" :label="item.name"
                      :value="item.code">
                    </el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
        <el-col :span="12">
          <el-row type="flex">
            <el-col :span="24">
              <el-row type="flex" align="middle" justify="start" :gutter="10">
                <el-col :span="6">
                  <h6 class="attributes-row-label" style="">版型</h6>
                </el-col>
                <el-col :span="18">
                  <el-select class="attributes-form-selector" v-model="slotData.attributes.editionType"
                    placeholder="请选择">
                    <el-option v-for="item in editionTypes" :key="item.code" :label="item.name" :value="item.code">
                    </el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="product-basic-attributes" type="flex" :gutter="50" align="middle">
        <el-col :span="12">
          <el-row type="flex">
            <el-col :span="24">
              <el-row type="flex" align="middle" justify="start" :gutter="10">
                <el-col :span="6">
                  <h6 class="attributes-row-label" style="">款式</h6>
                </el-col>
                <el-col :span="18">
                  <el-select class="attributes-form-selector" v-model="slotData.attributes.pattern" placeholder="请选择">
                    <el-option v-for="item in productPatterns" :key="item.code" :label="item.name" :value="item.code">
                    </el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
        <el-col :span="12">
          <el-row type="flex">
            <el-col :span="24">
              <el-row type="flex" align="middle" justify="start" :gutter="10">
                <el-col :span="6">
                  <h6 class="attributes-row-label" style="">袖型</h6>
                </el-col>
                <el-col :span="18">
                  <el-select class="attributes-form-selector" v-model="slotData.attributes.sleeveType"
                    placeholder="请选择">
                    <el-option v-for="item in sleeveTypes" :key="item.code" :label="item.name" :value="item.code">
                    </el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="product-basic-attributes" type="flex" :gutter="50" align="middle">
        <el-col :span="12">
          <el-row type="flex">
            <el-col :span="24">
              <el-row type="flex" align="middle" justify="start" :gutter="10">
                <el-col :span="6">
                  <h6 class="attributes-row-label" style="">袖长</h6>
                </el-col>
                <el-col :span="18">
                  <el-select class="attributes-form-selector" v-model="slotData.attributes.sleeveLength"
                    placeholder="请选择">
                    <el-option v-for="item in sleeveLengths" :key="item.code" :label="item.name" :value="item.code">
                    </el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
        <el-col :span="12">
          <el-row type="flex">
            <el-col :span="24">
              <el-row type="flex" align="middle" justify="start" :gutter="10">
                <el-col :span="6">
                  <h6 class="attributes-row-label" style="">图案<span class="info-title_text-sub">(多选)</span></h6>
                </el-col>
                <el-col :span="18">
                  <el-select class="attributes-form-selector" multiple v-model="slotData.attributes.decorativePatterns"
                    placeholder="请选择">
                    <el-option v-for="item in decorativePatterns" :key="item.code" :label="item.name"
                      :value="item.code">
                    </el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="product-basic-attributes" type="flex" :gutter="50" align="middle">
        <el-col :span="12">
          <el-row type="flex">
            <el-col :span="24">
              <el-row type="flex" align="middle" justify="start" :gutter="10">
                <el-col :span="6">
                  <h6 class="attributes-row-label" style="">流行元素<span class="info-title_text-sub">(多选)</span></h6>
                </el-col>
                <el-col :span="18">
                  <el-select class="attributes-form-selector" multiple v-model="slotData.attributes.popularElements"
                    placeholder="请选择">
                    <el-option v-for="item in popularElements" :key="item.code" :label="item.name" :value="item.code">
                    </el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
        <el-col :span="12">
          <el-row type="flex">
            <el-col :span="24">
              <el-row type="flex" align="middle" justify="start" :gutter="10">
                <el-col :span="6">
                  <h6 class="attributes-row-label" style="">填充物</h6>
                </el-col>
                <el-col :span="18">
                  <el-select class="attributes-form-selector" v-model="slotData.attributes.filler" placeholder="请选择">
                    <el-option v-for="item in productFillers" :key="item.code" :label="item.name" :value="item.code">
                    </el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="product-basic-attributes" type="flex" :gutter="50" align="middle">
        <el-col :span="12">
          <el-row type="flex">
            <el-col :span="24">
              <el-row type="flex" align="middle" justify="start" :gutter="10">
                <el-col :span="6">
                  <h6 class="attributes-row-label" style="">厚薄</h6>
                </el-col>
                <el-col :span="18">
                  <el-select class="attributes-form-selector" v-model="slotData.attributes.thickness" placeholder="请选择">
                    <el-option v-for="item in productThicknesses" :key="item.code" :label="item.name"
                      :value="item.code">
                    </el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
        <el-col :span="12">
          <el-row type="flex">
            <el-col :span="24">
              <el-row type="flex" align="middle" justify="start" :gutter="10">
                <el-col :span="6">
                  <h6 class="attributes-row-label" style="">季节</h6>
                </el-col>
                <el-col :span="18">
                  <el-select class="attributes-form-selector" v-model="slotData.attributes.season" placeholder="请选择">
                    <el-option v-for="item in productSeasons" :key="item.code" :label="item.name" :value="item.code">
                    </el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="product-basic-attributes" type="flex" :gutter="50" align="middle">
        <el-col :span="12">
          <el-row type="flex">
            <el-col :span="24">
              <el-row type="flex" align="middle" justify="start" :gutter="10">
                <el-col :span="6">
                  <h6 class="attributes-row-label" style="">门襟</h6>
                </el-col>
                <el-col :span="18">
                  <el-select class="attributes-form-selector" v-model="slotData.attributes.placket" placeholder="请选择">
                    <el-option v-for="item in plackets" :key="item.code" :label="item.name" :value="item.code">
                    </el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
        <el-col :span="12">
          <el-row type="flex" align="middle">
            <el-col :span="24">
              <el-form-item class="product-form-item" :rules="[
                { required: true, message: '请输入重量', trigger: 'blur'}]" prop="gramWeight">
                <el-row type="flex" align="middle" justify="start" :gutter="10">
                  <el-col :span="6">
                    <h6 class="attributes-row-label" style="width:80px">重量(KG)</h6>
                  </el-col>
                  <el-col :span="18">
                    <el-input-number v-model="slotData.gramWeight" :precision="3" :min="0" size="mini"
                      :disabled="isRead">
                    </el-input-number>
                  </el-col>
                </el-row>
              </el-form-item>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="product-basic-attributes" type="flex" :gutter="50" align="middle">
        <el-col :span="12">
          <el-row type="flex" align="middle">
            <el-col :span="24">
              <el-row type="flex" align="middle" justify="start" :gutter="10">
                <el-col :span="6">
                  <h6 class="attributes-row-label" style="width:80px">吊牌</h6>
                </el-col>
                <el-col :span="18">
                  <div style="padding-top:10px;">
                    <el-radio-group v-model="slotData.attributes.taggable" text-color="#000000" fill="#ffd60c"
                      :disabled="isRead">
                      <el-radio :label="true" :key="1" class="product-attributes-radio">有</el-radio>
                      <el-radio :label="false" :key="0" class="product-attributes-radio">没有</el-radio>
                    </el-radio-group>
                  </div>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
    </template>
    <el-row class="product-basic-attributes" type="flex" :gutter="50" align="middle" justify="center">
      <!-- <el-row type="flex" justify="center" align="center" class="orders-info-table-btn"> -->
      <i class="iconfont icon_arrow iconfont-btn" v-if="!showAll" @click="showAll=true">&#xe714;&nbsp;展开全部属性</i>
      <i class="iconfont icon_arrow iconfont-btn" v-if="showAll" @click="showAll=false">&#xe713;&nbsp;收回全部属性</i>
      <!-- </el-row> -->
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ApparelProductBasicAttributesForm',
    props: ['slotData', 'readOnly', 'isRead'],
    methods: {

    },
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
        showAll: false
      };
    },
    created() {}
  };

</script>
<style scoped>
  .product-basic-attributes {
    margin-bottom: 20px;
  }

  .attributes-row-label {
    display: inline-block;
    font-size: 12px;
    font-weight: 500;
  }

  .attributes-form-selector {
    width: 100%;
  }

  /deep/ .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 0px;
  }

  .info-title_text-sub {
    font-weight: 500;
    color: #CCCCCC;
    font-size: 12px;
  }

  .iconfont-btn {
    color: dodgerblue;
    cursor: pointer;
  }

</style>
