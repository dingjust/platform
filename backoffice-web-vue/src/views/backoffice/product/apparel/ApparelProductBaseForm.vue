<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :disabled="readOnly" :rules="rules">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="商品货号" prop="skuID">
            <el-input v-model="slotData.skuID"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="商品名称" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="商品类目" prop="categories">
            <el-select v-model="slotData.categories" placeholder="请选择" class="w-100" multiple>
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
          <el-form-item label="品牌" prop="brand">
            <el-input v-model="slotData.brand"></el-input>
          </el-form-item>
        </el-col>
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
          <el-form-item label="重量（KG）" prop="gramWeight">
            <el-input-number class="w-100"
                             v-model="slotData.gramWeight"
                             :precision="3"
                             :min="0">
            </el-input-number>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'ApparelProductBaseForm',
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
        const result = await this.$http.get('/b2b/brands/approved', {
          keyword: query.trim()
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.companies = result.content;
      },
      async getStyles() {
        const result = await this.$http.get('/djwebservices/styles/all');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.styles = result;
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
