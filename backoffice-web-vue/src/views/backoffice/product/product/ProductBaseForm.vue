<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :disabled="readOnly" :rules="rules">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="产品编码" prop="code">
            <el-input v-model="slotData.code" disabled placeholder="系统自动生成"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="产品名称" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="产品分类" prop="categories">
            <el-select v-model="slotData.categories" placeholder="请选择" class="w-100"
                       multiple>
              <el-option-group
                v-for="level1 in categories"
                :key="level1.code"
                :label="level1.name">
                <el-option
                  v-for="level2 in level1.children"
                  :key="level2.code"
                  :label="level2.name"
                  :value="level2.code">
                </el-option>
              </el-option-group>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="商家" prop="belongTo">
            <el-select class="w-100" filterable remote reserve-keyword clearable
                       placeholder="请输入商家名称查询"
                       v-model="slotData.belongTo.uid"
                       :remote-method="onFilterCompanies">
              <el-option v-for="item in companies"
                         :key="item.uid"
                         :label="item.name"
                         :value="item.uid">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="主面料" prop="material">
            <el-input v-model="slotData.material"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="主面料成分含量" prop="content">
            <el-input class="w-100" v-model="slotData.content"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="供应商商品编号" prop="skuID">
            <el-input v-model="slotData.skuID"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="年份" prop="year">
            <el-input-number class="w-100" :min="2000" :max="9999"
                             v-model="slotData.year">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="季节" prop="season">
            <el-input v-model="slotData.season"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="产地" prop="placeOfOrigin">
            <el-input v-model="slotData.placeOfOrigin"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="品牌" prop="brand">
            <el-input v-model="slotData.brand"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="供货价" prop="price">
            <el-input-number class="w-100"
                             @change="checkAndSetData(slotData.price)"
                             v-model="slotData.price"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="风格" prop="style">
            <el-select class="w-100" placeholder="请选择" v-model="slotData.style.code">
              <el-option v-for="style in styles"
                         :key="style.code"
                         :label="style.name"
                         :value="style.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="是否免邮" prop="postageFree">
            <el-radio-group v-model="slotData.postageFree">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
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
      </el-row>
      <hr/>
      <el-row :gutter="15">
        <el-col :span="6">
          <el-form-item label="建议零售价" prop="suggestedPrice">
            <el-input-number class="w-100"
                             v-model="slotData.suggestedPrice"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="会员价(A)" prop="price1">
            <el-input-number class="w-100"
                             v-model="slotData.price1"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="会员价(B)" prop="price2">
            <el-input-number class="w-100"
                             v-model="slotData.price2"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="会员价(C)" prop="price3">
            <el-input-number class="w-100"
                             v-model="slotData.price3"
                             :precision="2"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="15">
        <product-prices-entries-form ref="ProductPricesEntriesForm" :slot-data="slotData" :read-only="readOnly"
                                     :rules="rules"/>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import ProductMediaEntryUploadForm from './ProductMediaEntryUploadForm';
  import ProductPricesEntriesForm from './ProductPricesEntriesForm';

  export default {
    name: 'ProductBaseForm',
    components: {ProductPricesEntriesForm, ProductMediaEntryUploadForm},
    props: ['slotData', 'readOnly', 'isNewlyCreated'],
    methods: {
      checkAndSetData(value) {
        if (this.slotData.suggestedPrice <= 0) {
          this.slotData.suggestedPrice = value;
        }
        if (this.slotData.price1 <= 0) {
          this.slotData.price1 = value;
        }
        if (this.slotData.price2 <= 0) {
          this.slotData.price2 = value;
        }
        if (this.slotData.price3 <= 0) {
          this.slotData.price3 = value;
        }
      },
      validate(callback) {
        this.$refs.form.validate(callback);
      },
      getValue() {
        return this.slotData;
      },
      onFilterCategories(query) {
        this.categories = [];
        if (query && query !== '') {
          this.loading = true;
          setTimeout(() => {
            this.loading = false;
            this.getCategories(query);
          }, 200);
        }
      },
      async getCategories(query) {
        const result = await this.$http.get('/b2b/categories/cascaded');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.categories = result;
      },
      onFilterCompanies(query) {
        this.companies = [];
        if (query && query !== '') {
          setTimeout(() => {
            this.getCompanies(query);
          }, 200);
        }
      },
      async getCompanies(query) {
        const result = await this.$http.get('/djbrand/brand', {
          text: query.trim()
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.companies = result.content;
      },
      async getStyles() {
        const result = await this.$http.get('/djbackoffice/product/style/all');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.styles = result;
      },
      onClickRadio(val) {
        alert(val);
      }
    },
    data() {
      return {
        loading: false,
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
          skuID: [{required: true, message: '必填', trigger: 'blur'}],
          categories: [{required: true, message: '必填', trigger: 'blur'}],
          material: [{required: true, message: '必填', trigger: 'blur'}],
          content: [{required: true, message: '必填', trigger: 'blur'}],
          minQuantity: [{required: true, message: '必填', trigger: 'blur'}],
          maxQuantity: [{required: true, message: '必填', trigger: 'blur'}],
          price: [{required: true, message: '必填', trigger: 'blur'}]
        },
        categories: [],
        companies: [],
        styles: [],
        categoryProps: {
          label: 'name',
          value: 'code',
          children: 'children'
        }
      };
    },
    created() {
      this.getCategories('');
      this.getCompanies('');
      this.getStyles();
    }
  };
</script>
