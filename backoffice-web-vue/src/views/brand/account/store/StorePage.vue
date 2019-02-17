<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <el-form ref="form" label-position="top" :disabled="true">
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
                <el-option v-for="item in scaleRanges" :key="item.code" :label="item.name"
                           :value="item.code"></el-option>
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
                <el-option v-for="item in priceRanges" :key="item.code" :label="item.name"
                           :value="item.code"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="价位段（秋冬）" prop="priceRange2">
              <el-select v-model="slotData.priceRange2s" class="w-100" multiple>
                <el-option v-for="item in priceRanges" :key="item.code" :label="item.name"
                           :value="item.code"></el-option>
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
    </el-card>

    <div class="pt-2"></div>

    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>认证信息</span>
      </div>
      <el-form ref="form" label-position="top" :disabled="true">
        <el-row :gutter="10">
          <el-col :span="8">
            <el-form-item label="注册时间">
              <el-date-picker class="w-100" type="month" placeholder="选择日期"
                              v-model="slotData.registrationDate">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="税号">
              <el-input v-model="slotData.taxNumber"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开户行">
              <el-input v-model="slotData.bankOfDeposit"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="10">
          <el-col :span="24">
            <el-form-item label="认证证件">
              <el-carousel :interval="4000" type="card">
                <el-carousel-item v-for="media in slotData.certificate" :key="media.url">
                  <img style="width:100%;height: 100%" :src="media.url" alt="">
                </el-carousel-item>
              </el-carousel>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import CompanyMixin from "mixins/commerce/CompanyMixin";

  export default {
    name: "StorePage",
    mixins: [CompanyMixin],
    methods: {
      async getStyles() {
        this.styles = await this.$http.get("/djbackoffice/product/style/all");
      },
      async getCategories() {
        this.adeptAtCategories = await this.$http.get("/djbackoffice/product/category/majors");
      },
      async getBrand() {
        this.slotData = await this.$http.get("/djbrand/brand/store");
      }
    },
    data() {
      return {
        slotData: {
          name: "",
          registrationDate: null,
          email: "",
          contactPerson: "",
          contactPhone: "",
          phone: "",
          scaleRange: "",
          styles: [],
          ageRanges: [],
          adeptAtCategories: [],
          priceRange1s: [],
          priceRange2s: [],
          address: "",
          scale: "",
          brand: "",
          cooperativeBrand: "",
          taxNumber: "",
          bankOfDeposit: "",
          certificate: "",
          scaleRanges: []
        },
        name: "",
        registrationDate: null,
        email: "",
        contactPerson: "",
        contactPhone: "",
        phone: "",
        scaleRange: "",
        styles: [],
        adeptAtCategories: [],
        address: "",
        scale: "",
        brand: "",
        cooperativeBrand: "",
        taxNumber: "",
        bankOfDeposit: "",
        certificate: ""
      };
    },
    created() {
      this.getStyles();
      this.getCategories();
      this.getBrand();
    }
  };
</script>
