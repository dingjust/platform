<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="工厂名称" prop="name">
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
            <el-input v-model="slotData.contactPerson"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="联系电话" prop="contactPhone">
            <el-input v-model="slotData.contactPhone"></el-input>
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
          <el-form-item label="开发能力" prop="developmentCapacity">
            <el-radio-group v-model="slotData.developmentCapacity">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
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
              <el-option v-for="item in scaleRanges" :key="item.code" :label="item.name" :value="item.code"></el-option>
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
          <el-form-item label="优势品类" prop="adeptAtCategories">
            <el-checkbox-group v-model="slotData.adeptAtCategories">
              <el-checkbox v-for="item in adeptAtCategories" :label="item.code" :key="item.code">
                {{item.name}}
              </el-checkbox>
            </el-checkbox-group>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
    <el-dialog title="地址" :modal="false" :visible.sync="addressDialogVisible"
               :show-close="false" append-to-body width="50%">
      <address-form ref="addressForm" :slot-data="addressFormData"/>
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
    name: 'FactoryBasicForm',
    props: ['slotData', 'readOnly'],
    components: {AddressForm},
    computed: {
      address: function () {
        if (!this.addressFormData) {
          return '';
        }
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
          this.addressDialogVisible = false;
        }
      },
      async getCategories() {
        const url = this.apis().getMajorCategories();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.adeptAtCategories = result;
      },
      _copyContactAddress() {
        if (this.slotData.contactAddress) {
          this.addressFormData = Object.assign({}, this.slotData.contactAddress);
        } else {
          this.addressFormData = this.$store.state.FactoriesModule.addressFormData;
        }
      }
    },
    data() {
      return {
        adeptAtCategories: [],
        addressFormData: this.$store.state.FactoriesModule.addressFormData,
        addressDialogVisible: false,
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
          contactPerson: [{required: true, message: '必填', trigger: 'blur'}],
          contactPhone: [
            {required: false, message: '手机号码不正确', trigger: 'blur', pattern: 11 && /^((13|14|15|17|18)[0-9]{1}\d{8})$/}
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
        cooperationModes: this.$store.state.EnumsModule.cooperationModes,
        scaleRanges: this.$store.state.EnumsModule.scaleRanges,
        monthlyCapacityRanges: this.$store.state.EnumsModule.monthlyCapacityRanges,
      };
    },
    created() {
      this.getCategories();
      this._copyContactAddress();
    }
  };
</script>
