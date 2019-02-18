<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <el-form ref="form" label-position="top" :model="slotData" :disabled="true">
        <el-row :gutter="10">
          <el-col :span="6">
            <el-form-item label="工厂名称" prop="name">
              <el-input v-model="slotData.name"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系人" prop="contactPerson">
              <el-input v-model="slotData.contactPerson"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="手机号" prop="contactPhone">
              <el-input v-model="slotData.contactPhone"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="经营地址" prop="address">
              <el-input v-model="slotData.address"></el-input>
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
            <el-form-item label="合作品牌" prop="cooperativeBrand">
              <el-input v-model="slotData.cooperativeBrand"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="优势品类" prop="adeptAtCategories">
              <el-checkbox-group v-model="slotData.adeptAtCategories">
                <el-checkbox v-for="item in categories" :label="item.code" :key="item.code">
                  {{item.name}}
                </el-checkbox>
              </el-checkbox-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="10">
          <el-col :span="6">
            <el-form-item label="月均产能" prop="monthlyCapacityRange">
              <el-select v-model="slotData.monthlyCapacityRange" class="w-100">
                <el-option v-for="item in monthlyCapacityRanges" :key="item.code" :label="item.name"
                           :value="item.code"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="产值规模" prop="scaleRange">
              <el-select v-model="slotData.scaleRange" class="w-100">
                <el-option v-for="item in scaleRanges" :key="item.code" :label="item.name"
                           :value="item.code"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="合作方式" prop="cooperationModes">
              <el-select v-model="slotData.cooperationModes" class="w-100" multiple>
                <el-option v-for="item in cooperationModes" :key="item.code" :label="item.name"
                           :value="item.code"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="车位数量" prop="latheQuantity">
              <el-input-number class="w-100" v-model="slotData.latheQuantity" :min="0"></el-input-number>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="10">
          <el-col :span="6">
            <el-form-item label="开发能力" prop="developmentCapacity">
              <el-radio-group v-model="slotData.developmentCapacity">
                <el-radio :label="true">是</el-radio>
                <el-radio :label="false">否</el-radio>
              </el-radio-group>
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
      <el-form ref="form" label-position="top" :model="slotData" :disabled="true">
        <el-row :gutter="10">
          <el-col :span="8">
            <el-form-item label="注册时间" prop="registrationDate">
              <el-date-picker class="w-100" type="month" placeholder="选择日期"
                              v-model="slotData.registrationDate">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="税号" prop="taxNumber">
              <el-input v-model="slotData.taxNumber"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="开户行" prop="bankOfDeposit">
              <el-input v-model="slotData.bankOfDeposit"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="10">
          <el-col :span="24">
            <el-form-item label="认证证件" prop="certificate">
              <el-carousel :interval="4000" type="card">
                <el-carousel-item v-for="media in slotData.certificate" :key="media.url">
                  <img style="width:100%;height: 100%" :src="media.url">
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
  import CompanyMixin from 'mixins/commerce/CompanyMixin';

  export default {
    name: 'FactoryPage',
    props: [],
    mixins: [CompanyMixin],
    components: {},
    methods: {
      async getCategories() {
        this.categories = await this.$http.get('/djbackoffice/product/category/majors');
      },
      async getFactory() {
        this.slotData = await this.$http.get('/djfactory/factory/findByUid');
      }
    },
    data() {
      return {
        slotData: {
          address: '',
          adeptAtCategories: [],
          contactPerson: '',
          contactPhone: '',
          id: null,
          latheQuantity: '',
          scaleRange: '',
          monthlyCapacityRange: '',
          cooperationModes: [],
          name: '',
          registrationDate: null,
          uid: '',
          taxNumber: '',
          bankOfDeposit: '',
          phone: '',
          cooperativeBrand: ''
        },
        categories: []
      };
    },
    created() {
      this.getCategories();
      this.getFactory();
    }
  };
</script>
