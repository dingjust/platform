<template>
  <div>
    <el-tabs v-model="selectIndex" class="product-categories-form-tab">
      <template v-for="(item,index) in categories">
        <el-tab-pane :label="item.name" :name="''+index">
          <el-radio-group v-model="slotData.category.code" text-color="#000000" fill="#ffd60c">
            <template v-for="category in categories[selectIndex].children">
              <el-radio-button :label="category.code">{{category.name}}</el-radio-button>
            </template>
          </el-radio-group>
        </el-tab-pane>
      </template>
    </el-tabs>
  </div>
</template>

<script>
  export default {
    name: "ApparelProductCategoriesForm",
    props: ["slotData", "readOnly"],
    methods: {
      async getCategories() {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.categories = result;
      }
    },
    data() {
      return {
        categories: [],
        selectIndex: "0",
      };
    },
    created() {
      this.getCategories();
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

</style>
