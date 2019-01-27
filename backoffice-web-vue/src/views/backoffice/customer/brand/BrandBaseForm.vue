<template>
  <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
    <el-row :gutter="10">
      <el-col :span="6">
        <el-form-item label="公司名称" prop="name">
          <el-input v-model="slotData.name"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="经营地址" prop="address">
          <el-input v-model="slotData.address"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="联系人" prop="contactPerson">
          <el-input v-model="slotData.contactPerson" placeholder="联系人"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="手机号" prop="contactPhone">
          <el-input v-model="slotData.contactPhone" placeholder="手机号"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="10">
      <el-col :span="6">
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="slotData.email"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="座机" prop="phone">
          <el-input v-model="slotData.phone"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="产值规模" prop="scale">
          <el-select v-model="slotData.scaleRange" class="w-100">
            <el-option v-for="item in scaleRanges" :key="item.code" :label="item.name" :value="item.code"></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="设计风格" prop="style">
          <el-select class="w-100" placeholder="请选择" v-model="slotData.styles" multiple>
            <el-option v-for="style in styles"
                       :key="style.code"
                       :label="style.name"
                       :value="style.code">
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
        <el-form-item label="年龄段" prop="ageRange">
          <el-select v-model="slotData.ageRanges" class="w-100" multiple>
            <el-option v-for="item in ageRanges" :key="item.code" :label="item.name" :value="item.code"></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="价位段（春夏）" prop="priceRange1">
          <el-select v-model="slotData.priceRange1s" class="w-100" multiple>
            <el-option v-for="item in priceRanges" :key="item.code" :label="item.name" :value="item.code"></el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="价位段（秋冬）" prop="priceRange2">
          <el-select v-model="slotData.priceRange2s" class="w-100" multiple>
            <el-option v-for="item in priceRanges" :key="item.code" :label="item.name" :value="item.code"></el-option>
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="10">
      <el-col :span="6">
        <el-form-item label="优势品类" prop="adeptAtCategories">
          <el-checkbox-group v-model="slotData.adeptAtCategories">
            <el-checkbox v-for="item in adeptAtCategories" :label="item.code" :key="item.code">
              {{item.name}}
            </el-checkbox>
          </el-checkbox-group>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="合作品牌" prop="cooperativeBrand">
          <el-input v-model="slotData.cooperativeBrand"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  import axios from "axios";

  import {CompanyMixin} from "mixins";

  export default {
    name: "BrandBaseForm",
    props: ["slotData", "isNewlyCreated", "readOnly"],
    mixins: [CompanyMixin],
    methods: {
      validate(callback) {
        return this.$refs["form"].validate(callback);
      },
      getValue() {
        let baseData = {};
        baseData.uid = this.slotData.uid;
        baseData.name = this.slotData.name;
        baseData.email = this.slotData.email;
        baseData.phone = this.slotData.phone;
        baseData.scaleRange = this.slotData.scaleRange;
        baseData.address = this.slotData.address;
        baseData.styles = this.slotData.styles;
        baseData.brand = this.slotData.brand;
        baseData.adeptAtCategories = this.slotData.adeptAtCategories;
        baseData.ageRanges = this.slotData.ageRanges;
        baseData.priceRange1s = this.slotData.priceRange1s;
        baseData.priceRange2s = this.slotData.priceRange2s;
        baseData.contactPhone = this.slotData.contactPhone;
        baseData.contactPerson = this.slotData.contactPerson;
        baseData.cooperativeBrand = this.slotData.cooperativeBrand;
        return baseData;
      },
      getStyles() {
        axios.get("/djbackoffice/product/style/all")
          .then(response => {
            this.styles = response.data;
          }).catch(error => {
          this.$message.error(error.response.data);
        })
      },
      getCategories() {
        axios
          .get("/djbackoffice/product/category/majors")
          .then(response => {
            this.adeptAtCategories = response.data;
          })
          .catch(error => {
            this.$message.error(error.response.statusText);
          });
      }
    },
    computed: {},
    data() {
      return {
        styles: [],
        adeptAtCategories: [],
        rules: {
          name: [{required: true, message: "必填", trigger: "blur"}],
          address: [{required: true, message: "请输入经营地址", trigger: "blur"}],
          contactPerson: [{required: true, message: "请输入联系人", trigger: "blur"}],
          email: [
            {
              message: '邮箱格式不正确',
              trigger: 'blur',
              pattern: /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/
            }
          ],
          contactPhone: [
            {required: true, message: '手机号码不正确', trigger: 'blur', pattern: 11 && /^((13|14|15|17|18)[0-9]{1}\d{8})$/}
          ]
        }
      };
    },
    created() {
      this.getStyles();
      this.getCategories();
    }
  };
</script>
