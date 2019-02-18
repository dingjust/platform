<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <el-form ref="form" label-position="top" :disabled="true">
        <el-row :gutter="10">
          <el-col :span="6">
            <el-form-item label="品牌编号" prop="uid">
              <el-input :disabled="!isNewlyCreated" v-model="slotData.uid"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="公司名称" prop="name">
              <el-input v-model="slotData.name"></el-input>
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
            <el-form-item label="经营地址" prop="address">
              <el-input v-model="slotData.address"></el-input>
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
            <el-form-item label="产值规模" prop="scale">
              <el-select v-model="slotData.scaleRange" class="w-100">
                <el-option v-for="item in scaleRanges" :key="item.code" :label="item.name"
                           :value="item.code"></el-option>
              </el-select>
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
                              v-model="slotData.registrationDate"
                              :value-format="defaultDateValueFormat">
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
          <el-col :span="8">
            <el-form-item label="认证证件">
              <img v-model="slotData.certificate"></img>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" type="primary" size="mini" @click="onApprove">
          同意
        </el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" size="mini" @click="onReject">
          拒绝
        </el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('AuditBrandsModule');

  import CompanyMixin from 'mixins/commerce/CompanyMixin';

  export default {
    name: 'BrandAuditDetailsPage',
    props: ['slotData', 'isNewlyCreated'],
    components: {},
    mixins: [CompanyMixin],
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onApprove() {
        //调用审核通过接口
        this.$confirm('确认账号审核通过, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => this._onApprove());
      },
      async _onApprove() {
        const result = await this.$http.put('/djbackoffice/b2bUnit/approve', {
          uid: this.slotData.uid
        });

        if (result['errors']) {
          this.$message.error('通过失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('确认成功');
        this.refresh();
        this.fn.closeSlider(true);
      },
      onReject() {
        //调用审核拒绝接口
        this.$prompt('请输认不通过原因', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消'
        }).then(({value}) => this._onReject(value));
      },
      async _onReject(value) {
        const result = await this.$http.put('/djbackoffice/b2bUnit/reject', {
          uid: this.slotData.uid,
          comment: value
        });

        if (result['errors']) {
          this.$message.error('拒绝失败');
          return;
        }
        this.$message.success('拒绝成功');
        this.refresh();
        this.fn.closeSlider(true);
      },
      async getStyles() {
        this.styles = await this.$http.get('/djbackoffice/product/style/all');
      },
      async getCategories() {
        this.adeptAtCategories = await this.$http.get('/djbackoffice/product/category/majors');
      }
    },
    data() {
      return {
        styles: [],
        adeptAtCategories: [],
      };
    },
    created() {
      this.getStyles();
      this.getCategories();
    }
  };
</script>
