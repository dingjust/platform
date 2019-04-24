<template>
  <div>
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="公司名称" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="经营地址" prop="contactAddress">
            <el-input v-model="address" :disabled="true">
              <el-button slot="append" icon="el-icon-search" @click="onAddressInput"></el-button>
            </el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="联系人" prop="contactPerson">
            <el-input v-model="slotData.contactPerson" placeholder="联系人"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="联系电话" prop="contactPhone">
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
              <el-option v-for="style in productStyles"
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
            <el-select class="w-100"
                       placeholder="请选择"
                       v-model="slotData.adeptAtCategories"
                       value-key="code" multiple>
              <el-option-group
                v-for="group in adeptAtCategories"
                :key="group.code"
                :label="group.name">
                <el-option
                  v-for="item in group.children"
                  :key="item.code"
                  :label="item.name"
                  :value="item">
                </el-option>
              </el-option-group>
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
    <el-dialog title="地址" :modal="false" :visible.sync="addressDialogVisible"
               :show-close="false" append-to-body width="50%">
      <address-form ref="addressForm" :slot-data="addressFormData" :isCompany = "true"/>
      <span slot="footer" class="dialog-footer">
        <el-button @click="onAddressInputCanceled">取 消</el-button>
        <el-button type="primary" @click="onAddressInputConfirmed">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
  import AddressForm from "@/views/shared/user/address/AddressForm";

  export default {
    name: 'BrandBasicForm',
    props: ['slotData', 'readOnly'],
    components: {AddressForm},
    computed: {
      address: function () {
        const region = this.addressFormData.region;
        const city = this.addressFormData.city;
        const cityDistrict = this.addressFormData.cityDistrict;
        const line1 = this.addressFormData.line1;

        // 省份和城市相同的情况
        if (region.name === city.name) {
          return region.name + cityDistrict.name + line1;
        }

        return region.name + city.name + cityDistrict.name + line1;
      }
    },
    methods: {
      validate() {
        this.$refs['form'].validate(valid => {
          if (!valid) {
            this.$message.error('验证失败');
            return false;
          }

          return true;
        });
      },
      onAddressInput() {
        this._copyContactAddress();
        this.addressDialogVisible = true;
      },
      onAddressInputCanceled() {
        this.addressDialogVisible = false;
      },
      onAddressInputConfirmed() {
        if (this.$refs['addressForm'].validate()) {
          this.$set(this.slotData, 'contactAddress', this.addressFormData);
          if(this.addressFormData.longitude){
            this.slotData.longitude = this.addressFormData.longitude;
            this.slotData.latitude = this.addressFormData.latitude;
          }

          this.addressDialogVisible = false;
        }
      },
      async getCategories() {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.adeptAtCategories = result;
      },
      _copyContactAddress() {
        this.addressFormData = Object.assign({}, this.slotData.contactAddress);
      }
    },
    data() {
      return {
        adeptAtCategories: [],
        addressFormData: this.$store.state.BrandsModule.addressFormData,
        addressDialogVisible: false,
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
          contactPerson: [{required: true, message: '必填', trigger: 'blur'}],
          contactPhone: [
            {required: true, message: '手机号码不正确', trigger: 'blur', pattern: 11 && /^((13|14|15|17|18)[0-9]{1}\d{8})$/}
          ],
          contactAddress: [{required: true, message: '必填', trigger: 'blur'}],
          email: [
            {
              message: '邮箱格式不正确',
              trigger: 'blur',
              pattern: /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/
            }
          ]
        },
        scaleRanges: this.$store.state.EnumsModule.scaleRanges,
        productStyles: this.$store.state.EnumsModule.productStyles,
        ageRanges: this.$store.state.EnumsModule.ageRanges,
        priceRanges: this.$store.state.EnumsModule.priceRanges,
      };
    },
    created() {
      this.getCategories();
      this._copyContactAddress();
    }
  };
</script>
