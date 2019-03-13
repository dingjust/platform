<template>
  <div class="animated fadeIn">
    <ul class="list-group">
      <li class="list-group-item">
        <h6>风格：</h6>
        <el-checkbox-group v-model="slotData.attributes.styles">
          <el-checkbox v-for="item in productStyles" :value="item.code" :label="item.code">{{item.name}}</el-checkbox>
        </el-checkbox-group>
      </li>
      <li class="list-group-item">
        <h6>面料：</h6>
        <el-radio-group v-model="slotData.attributes.fabricComposition">
          <el-radio v-for="item in fabricCompositions" :value="item.code" :label="item.code">{{item.name}}</el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>版型：</h6>
        <el-radio-group v-model="slotData.attributes.editionType">
          <el-radio v-for="item in editionTypes" :value="item.code" :label="item.code">{{item.name}}</el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>款式：</h6>
        <el-radio-group v-model="slotData.attributes.pattern">
          <el-radio v-for="item in productPatterns" :value="item.code" :label="item.code">{{item.name}}</el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>袖型：</h6>
        <el-radio-group v-model="slotData.attributes.sleeveType">
          <el-radio v-for="item in sleeveTypes" :value="item.code" :label="item.code">{{item.name}}</el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>袖长/裤长：</h6>
        <el-radio-group v-model="slotData.attributes.sleeveLength">
          <el-radio v-for="item in sleeveLengths" :value="item.code" :label="item.code">{{item.name}}</el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>图案：</h6>
        <el-checkbox-group v-model="slotData.attributes.decorativePatterns">
          <el-checkbox v-for="item in decorativePatterns" :value="item.code" :label="item.code">{{item.name}}</el-checkbox>
        </el-checkbox-group>
      </li>
      <li class="list-group-item">
        <h6>流行元素：</h6>
        <el-checkbox-group v-model="slotData.attributes.popularElements">
          <el-checkbox v-for="item in popularElements" :value="item.code" :label="item.code">{{item.name}}</el-checkbox>
        </el-checkbox-group>
      </li>
      <li class="list-group-item">
        <h6>填充物：</h6>
        <el-radio-group v-model="slotData.attributes.filler">
          <el-radio v-for="item in productFillers" :value="item.code" :label="item.code">{{item.name}}</el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>厚薄：</h6>
        <el-radio-group v-model="slotData.attributes.thickness">
          <el-radio v-for="item in productThicknesses" :value="item.code" :label="item.code">{{item.name}}</el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>季节：</h6>
        <el-radio-group v-model="slotData.attributes.season">
          <el-radio v-for="item in productSeasons" :value="item.code" :label="item.code">{{item.name}}</el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>吊牌：</h6>
        <el-radio-group v-model="slotData.attributes.taggable">
          <el-radio :label="true">有</el-radio>
          <el-radio :label="false">没有</el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>门襟；</h6>
        <el-radio-group v-model="slotData.attributes.placket">
          <el-radio v-for="item in plackets" :value="item.code" :label="item.code">{{item.name}}</el-radio>
        </el-radio-group>
      </li>
    </ul>
  </div>
</template>

<script>
  export default {
    name: 'ApparelProductAttributesForm',
    props: ['slotData', 'readOnly', 'isNewlyCreated'],
    methods: {},
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
