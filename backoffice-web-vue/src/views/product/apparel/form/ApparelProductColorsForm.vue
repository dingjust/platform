<template>
  <div>
    <el-row class="info-title-row" type="flex" align="center">
      <h6 class="info-title_text">选择颜色：</h6>
      <el-tag v-for="(color,index) in slotData.colors" :key="color" closable @close="handleClose(index)" type="info"
        class="colors-form-tag">
        {{colorMap[color]}}
      </el-tag>
    </el-row>
    <el-checkbox-group v-model="slotData.colors">
      <template v-for="color in showingColors">
        <dj-checkbox class="colors-dj-checkbox" :label="color.code" :width="40" :colorCode="color.colorCode">
          {{color.name}}
        </dj-checkbox>
      </template>
    </el-checkbox-group>
    <el-row type="flex" justify="start" align="center" class="orders-info-table-btn">
      <i class="iconfont icon_arrow" v-if="!showAllColor" @click="onClickshowAllColor">&#xe714;&nbsp;展开全部颜色</i>
      <i class="iconfont icon_arrow" v-if="showAllColor" @click="onClickshowAllColor">&#xe713;&nbsp;收回</i>
    </el-row>
  </div>
</template>

<script>
  import DjCheckbox from '@/components/custom/DjCheckbox';

  export default {
    name: "ApparelProductColorsForm",
    props: ["slotData", "readOnly"],
    components: {
      DjCheckbox,
    },
    computed: {
      showingColors: function () {
        if (this.showAllColor) {
          return this.colors;
        } else {
          return this.colors.slice(0, 9);
        }
      }
    },
    methods: {
      async getAllColors() {
        const url = this.apis().getAllColors();
        this.colors = await this.$http.get(url);
        this.generateColorMap();
      },
      handleClose(index) {
        this.slotData.colors.splice(index, 1);
      },
      generateColorMap() {
        this.colors.forEach(color => {
          this.colorMap[color.code] = color.name;
        });
      },
      onClickshowAllColor() {
        this.showAllColor = !this.showAllColor;
      }
    },
    data() {
      return {
        colors: [],
        colorMap: {},
        showAllColor: false,

      };
    },
    created() {
      this.getAllColors();
    }
  };

</script>
<style>
  .product-form-item small.el-form-item {
    margin-bottom: 0px !important;
  }

  .product-form-item .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 0px !important;
  }

  .product-form-item .el-form-item__error {
    padding-left: 70px !important;
  }

  .product-form-row {
    margin-bottom: 15px;
  }

  .product-categories-form-tab .el-tabs__active-bar {
    background-color: #ffd60c;
  }

  .product-categories-form-tab .el-tabs__item.is-active {
    color: #ffd60c;
  }

  .product-categories-form-tab .el-tabs__item:hover {
    color: #ffd60c;
    cursor: pointer;
  }

  .product-categories-form-tab .el-radio-button--small .el-radio-button__inner {
    margin-left: 5px;
    margin-right: 5px;
    border: 0px;
  }

  .colors-dj-checkbox {
    margin-right: 65px;
  }

  .colors-form-tag {
    margin-left: 10px;
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

  .orders-info-table-btn {
    margin-top: 20px;
  }

</style>
