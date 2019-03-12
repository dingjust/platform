<template>
  <div class="animated fadeIn">
    <ul class="list-group">
      <li class="list-group-item">
        <h6>风格：</h6>
        <el-checkbox-group>
          <el-checkbox v-for="item in productStyles" :key="item.code" :label="item.name"></el-checkbox>
        </el-checkbox-group>
      </li>
      <li class="list-group-item">
        <h6>面料：</h6>
        <el-radio-group>
          <el-radio v-for="item in fabricCompositions" :key="item.code" :label="item.name"></el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>版型：</h6>
        <el-radio-group>
          <el-radio v-for="item in editionTypes" :key="item.code" :label="item.name"></el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>款式：</h6>
        <el-radio-group>
          <el-radio v-for="item in productPatterns" :key="item.code" :label="item.name"></el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>袖型：</h6>
        <el-radio-group>
          <el-radio v-for="item in sleeveTypes" :key="item.code" :label="item.name"></el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>袖长/裤长：</h6>
        <el-radio-group>
          <el-radio v-for="item in sleeveLengths" :key="item.code" :label="item.name"></el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>图案：</h6>
        <el-checkbox-group>
          <el-checkbox v-for="item in decorativePatterns" :key="item.code" :label="item.name"></el-checkbox>
        </el-checkbox-group>
      </li>
      <li class="list-group-item">
        <h6>流行元素：</h6>
        <el-checkbox-group>
          <el-checkbox v-for="item in popularElements" :key="item.code" :label="item.name"></el-checkbox>
        </el-checkbox-group>
      </li>
      <li class="list-group-item">
        <h6>填充物：</h6>
        <el-radio-group>
          <el-radio v-for="item in productFillers" :key="item.code" :label="item.name"></el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>厚薄：</h6>
        <el-radio-group>
          <el-radio v-for="item in productThicknesses" :key="item.code" :label="item.name"></el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>季节：</h6>
        <el-radio-group>
          <el-radio v-for="item in productSeasons" :key="item.code" :label="item.name"></el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>吊牌：</h6>
        <el-radio-group>
          <el-radio :label="1">有</el-radio>
          <el-radio :label="0">没有</el-radio>
        </el-radio-group>
      </li>
      <li class="list-group-item">
        <h6>门襟；</h6>
        <el-radio-group>
          <el-radio v-for="item in plackets" :key="item.code" :label="item.name"></el-radio>
        </el-radio-group>
      </li>
    </ul>
  </div>
</template>

<script>
  export default {
    name: 'ApparelProductAttributesForm',
    props: ['slotData', 'readOnly', 'isNewlyCreated'],
    methods: {
      onClose(item, attrName) {

      }
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
