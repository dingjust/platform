<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :disabled="readOnly" :rules="rules">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="产品货号" prop="skuID">
            <el-input v-model="slotData.skuID"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="产品名称" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="产品类目" prop="category">
            <el-select v-model="slotData.category.code" placeholder="请选择" class="w-100">
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
          <el-form-item label="品牌" prop="brand">
            <el-input v-model="slotData.brand"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
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
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'ApparelProductBaseForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        this.$refs.form.validate(callback);
      },
      async getCategories() {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.categories = result;
      },
    },
    data() {
      return {
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
          skuID: [{required: true, message: '必填', trigger: 'blur'}],
          category: [{required: true, message: '必填', trigger: 'blur'}],
          price: [{required: true, message: '必填', trigger: 'blur'}]
        },
        categories: [],
        companies: []
      };
    },
    created() {
      this.getCategories();
    }
  };
</script>
