<template>
  <div class="animated fadeIn">
    <el-row class="basic-form-row" type="flex" align="middle">
      <el-col :span="2">
        <h6 class="info-input-prepend">标题</h6>
      </el-col>
      <el-col :span="20">
        <el-form-item  :rules="[
                { required: true, message: '请输入产品标题', trigger: 'blur'}]" prop="name">
          <el-input placeholder="输入产品标题" v-model="slotData.name" size="mini" :disabled="isRead" maxlength="40" show-word-limit>
          </el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row class="basic-form-row" type="flex" align="middle">
      <el-col :span="2">
        <h6 class="info-input-prepend">品类<span style="color:red;">*</span></h6>
      </el-col>
      <el-col :span="20">
        <el-form-item :rules="[{
            type: 'object',
            validator: checkCategory,
            trigger: 'change'
          }]" prop="category">
          <el-cascader class="product-category-cascader" v-model="slotData.category" :options="cascaderCategories"></el-cascader>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row class="basic-form-row" type="flex" align="top">
      <el-col :span="2">
        <h6 class="info-input-prepend">商品属性</h6>
      </el-col>
      <el-col :span="20">
        <div class="basic-form-attribute">
          <apparel-product-basic-attributes-form :slot-data="slotData"/>
        </div>
      </el-col>
    </el-row>
    <!--<el-row :gutter="10" class="product-form-row">-->
      <!--<el-col :span="6">-->
        <!--<el-form-item class="product-form-item" :rules="[-->
                <!--{ required: true, message: '请输入货号', trigger: 'blur'}]" prop="skuID">-->
          <!--<el-row type="flex" align="middle" justify="start">-->
            <!--<div style="width:50px">-->
              <!--<h6 class="info-input-prepend">货号：</h6>-->
            <!--</div>-->
            <!--<el-input placeholder="请输入货号" v-model="slotData.skuID" size="mini" :disabled="isRead"></el-input>-->
          <!--</el-row>-->
        <!--</el-form-item>-->
      <!--</el-col>-->
      <!--<el-col :span="6">-->
        <!--<el-form-item class="product-form-item" prop="brand">-->
          <!--<el-row type="flex" align="middle">-->
            <!--<div style="width:50px">-->
              <!--<h6 class="info-input-prepend">品牌：</h6>-->
            <!--</div>-->
            <!--<el-input placeholder="请输入品牌" v-model="slotData.brand" size="mini" :disabled="isRead"></el-input>-->
          <!--</el-row>-->
        <!--</el-form-item>-->
      <!--</el-col>-->
      <!--<el-col :span="6">-->
        <!--<el-form-item class="product-form-item" :rules="[-->
                <!--{ required: true, message: '请输入重量', trigger: 'blur'}]" prop="gramWeight">-->
          <!--<el-row type="flex" align="middle">-->
            <!--<div style="width:80px">-->
              <!--<h6 class="info-input-prepend" style="width:80px">重量（KG）：</h6>-->
            <!--</div>-->
            <!--<el-input-number v-model="slotData.gramWeight" :precision="3" :min="0" size="mini" :disabled="isRead">-->
            <!--</el-input-number>-->
          <!--</el-row>-->
        <!--</el-form-item>-->
      <!--</el-col>-->
      <!--&lt;!&ndash; <el-col :span="6">-->
          <!--<el-form-item label="标题" prop="name">-->
            <!--<el-input v-model="slotData.name"></el-input>-->
          <!--</el-form-item>-->
        <!--</el-col>-->
        <!--<el-col :span="6">-->
          <!--<el-form-item label="产品类目" prop="category">-->
            <!--<el-select v-model="slotData.category.code" placeholder="请选择" class="w-100">-->
              <!--<el-option-group v-for="level1 in categories" :key="level1.code" :label="level1.name">-->
                <!--<el-option v-for="level2 in level1.children" :key="level2.code" :label="level2.name"-->
                  <!--:value="level2.code">-->
                <!--</el-option>-->
              <!--</el-option-group>-->
            <!--</el-select>-->
          <!--</el-form-item>-->
      <!--</el-col>&ndash;&gt;-->
    <!--</el-row>-->
    <!-- <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="供货价" prop="price">
            <el-input-number class="w-100"
                             v-model="slotData.price"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="生产单价（最小值）" prop="minPrice">
            <el-input-number class="w-100"
                             v-model="slotData.minPrice"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="生产单价（最大值）" prop="maxPrice">
            <el-input-number class="w-100"
                             v-model="slotData.maxPrice"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="重量（KG）" prop="gramWeight">
            <el-input-number class="w-100"
                             v-model="slotData.gramWeight"
                             :precision="3"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
    </el-row>-->
    <!-- </el-form> -->
  </div>
</template>

<script>
  import ApparelProductBasicAttributesForm from './ApparelProductBasicAttributesForm';

  export default {
    name: 'ApparelProductBaseForm',
    props: ['slotData', 'readOnly', 'isRead'],
    components: {
      ApparelProductBasicAttributesForm
    },
    methods: {
      checkCategory  (rule, value, callback) {
        console.log(value);
        if (!value) {
          return callback(new Error('请选择品类'));
        } else {
          callback();
        }
      },
      validate (callback) {
        this.$refs.form.validate(callback);
      },
      async getCategories () {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.categories = result;

        //
        this.categories.forEach(val => {});
        this.cascaderCategories = this.categories.map(val => {
          let children = val.children.map(item => {
            return {
              value: item.code,
              label: item.name
            };
          });
          return {
            // 'value': val.code,
            label: val.name,
            children: children
          };
        });
      },
    },
    data () {
      return {
        categories: [],
        cascaderCategories: [],
        companies: [],
      };
    },
    created () {
      this.getCategories();
      if (this.slotData.category != null) {
        this.slotData.category = [undefined, this.slotData.category.code];
      }
    }
  };
</script>
<style scoped>
  /deep/ .product-form-item small.el-form-item {
    margin-bottom: 0px !important;
  }

  /deep/ .product-form-item .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 0px !important;
  }

  /*/deep/ .product-form-item .el-form-item__error {*/
    /*padding-left: 70px !important;*/
  /*}*/

  .product-form-row {
    margin-bottom: 15px;
  }

  .basic-form-row {
    padding-left: 30px;
    margin-bottom: 20px;
  }

  .product-category-cascader {
    width: 100%;
  }

  .basic-form-attribute{
    border: 1px solid #DCDFE6;
    padding:10px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    /* margin-top: 5px; */
    width: 60px;
    font-size: 12px;
    font-weight: 500;
  }
</style>
