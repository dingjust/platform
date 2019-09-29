<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="风格" prop="styles">
            <el-select v-model="slotData.attributes.styles" class="w-100" multiple placeholder="请选择">
              <el-option
                v-for="item in productStyles"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="面料" prop="fabricComposition">
            <el-select v-model="slotData.attributes.fabricCompositions" class="w-100" multiple placeholder="请选择">
              <el-option
                v-for="item in fabricCompositions"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="版型" prop="editionType">
            <el-select v-model="slotData.attributes.editionType" class="w-100" placeholder="请选择">
              <el-option
                v-for="item in editionTypes"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="款式" prop="pattern">
            <el-select v-model="slotData.attributes.pattern" class="w-100" placeholder="请选择">
              <el-option
                v-for="item in productPatterns"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="袖型" prop="sleeveType">
            <el-select v-model="slotData.attributes.sleeveType" class="w-100" placeholder="请选择">
              <el-option
                v-for="item in sleeveTypes"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="袖型" prop="sleeveType">
            <el-select v-model="slotData.attributes.sleeveLength" class="w-100" placeholder="请选择">
              <el-option
                v-for="item in sleeveLengths"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="图案" prop="decorativePatterns">
            <el-select v-model="slotData.attributes.decorativePatterns" class="w-100" multiple placeholder="请选择">
              <el-option
                v-for="item in decorativePatterns"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="流行元素" prop="popularElements">
            <el-select v-model="slotData.attributes.popularElements" class="w-100" multiple placeholder="请选择">
              <el-option
                v-for="item in popularElements"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="填充物" prop="filler">
            <el-select v-model="slotData.attributes.filler" class="w-100" placeholder="请选择">
              <el-option
                v-for="item in productFillers"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="厚薄" prop="thickness">
            <el-select v-model="slotData.attributes.thickness" class="w-100" placeholder="请选择">
              <el-option
                v-for="item in productThicknesses"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="季节" prop="season">
            <el-select v-model="slotData.attributes.season" class="w-100" placeholder="请选择">
              <el-option
                v-for="item in productSeasons"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="门襟" prop="placket">
            <el-select v-model="slotData.attributes.placket" class="w-100" placeholder="请选择">
              <el-option
                v-for="item in plackets"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="吊牌" prop="taggable">
            <el-radio-group v-model="slotData.attributes.taggable">
              <el-radio :label="true" :key="1">有</el-radio>
              <el-radio :label="false" :key="0">没有</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
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
        plackets: this.$store.state.EnumsModule.plackets
      };
    },
    created() {
    }
  };
</script>
