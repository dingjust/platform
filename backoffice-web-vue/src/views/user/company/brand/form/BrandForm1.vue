<template>
  <div class="animated fadeIn brand-edit">
    <el-row class="brand-info-title-row">
      <div class="brand-info-title">
        <h6 class="brand-info-title_text">{{readOnly? '公司详情' : '编辑资料'}}</h6>
      </div>
    </el-row>
    <div class="titleCardClass">
      <el-form :model="tranData" ref="brandForm" label-position="left" label-width="75px" :rules="rules" :disabled="readOnly" hide-required-asterisk >
        <el-row>
          <brand-basic-info-form v-if="brandFormVisible" :formData="tranData" :readOnly="readOnly"/>
        </el-row>
        <el-row>
          <brand-capacity-form v-if="brandFormVisible" :formData="tranData" :readOnly="readOnly"/>
        </el-row>
      </el-form>
    </div>
    <el-row type="flex" justify="center">
      <Authorized :permission="['COMPANY_INFO_MODIFY']">
        <el-button v-if="saveShow" class="buttonClass" @click="onSave">
          <h6>保存</h6>
        </el-button>
      </Authorized>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapMutations} = createNamespacedHelpers('BrandsModule');

  import BrandBasicInfoForm from './BrandBasicInfoForm';
  import BrandCapacityForm from './BrandCapacityForm';

  export default {
    name: 'BrandFrom1',
    components: {
      BrandCapacityForm,
      BrandBasicInfoForm
    },
    props: ['formData', 'readOnly', 'slotData'],
    methods: {
      ...mapMutations({
        setBrandFormVisible: 'setBrandFormVisible'
      }),
      onSave () {
        this.$refs['brandForm'].validate((valid) => {
          if (valid) {
            this.$confirm('是否确认保存', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              this.$emit('onSave');
            });
          } else {
            this.$message.error('请完善需求信息');
            return false;
          }
        });
      },
      validateField (name) {
        this.$refs.brandForm.validateField(name);
      }
    },
    computed: {
      ...mapGetters({
        brandFormVisible: 'brandFormVisible'
      }),
      saveShow: function () {
        return !this.readOnly;
      },
      tranData: function () {
        if (this.readOnly) {
          this.setBrandFormVisible(true);
          return this.slotData;
        } else {
          return this.formData;
        }
      }
    },
    watch: {
      'formData.adeptAtCategories': function (n, o) {
        this.validateField('adeptAtCategories');
      },
      'formData.profilePicture': function (n, o) {
        this.validateField('profilePicture');
      }
    },
    data () {
      var cheackEquipment = (rule, value, callback) => {
        if (this.formData.cuttingDepartment.length <= 0 &&
          this.formData.productionWorkshop.length <= 0 &&
          this.formData.lastDepartment.length <= 0) {
          return callback(new Error('请选择设备'));
        } else {
          callback();
        }
      };
      var checkContactPhone = (rule, value, callback) => {
        const patrn = /^[1][3,4,5,6,7,8,9][0-9]{9}$/;
        if (!value) {
          return callback(new Error('请输入手机号码'));
        }
        if (!patrn.test(this.formData.contactPhone)) {
          return callback(new Error('请输入正确的手机号码'));
        } else {
          callback();
        }
      };
      var checkProfilePicture = (rule, value, callback) => {
        if (this.formData.profilePicture == null) {
          return callback(new Error('请上传公司LOGO'));
        } else {
          callback();
        }
      };
      return {
        rules: {
          'contactAddress.region': [
            {required: true, message: '请选择省', type: 'object', trigger: 'change'}
          ],
          'contactAddress.city': [
            {required: true, message: '请选择市', type: 'object', trigger: 'change'}
          ],
          'contactAddress.cityDistrict': [
            {required: true, message: '请选择区', type: 'object', trigger: 'change'}
          ],
          'contactAddress.line1': [
            {required: true, message: '请填写详细地址', trigger: 'blur'}
          ],
          'name': [
            {required: true, message: '请填写公司名称', trigger: 'blur'}
          ],
          'contactPerson': [
            {required: true, message: '请填写联系人', trigger: 'blur'}
          ],
          'contactPhone': [
            {validator: checkContactPhone, type: 'object', trigger: 'blur'}
          ],
          'equipment': [
            {validator: cheackEquipment, type: 'object', trigger: 'change'}
          ],
          'adeptAtCategories': [
            {required: true, message: '请选择品类', type: 'array', trigger: 'change'}
          ],
          'duties': [
            {required: true, message: '请填写职务', trigger: 'change'}
          ],
          'profilePicture': [
            {validator: checkProfilePicture, type: 'object', trigger: 'change'}
          ]
        }
      }
    },
    created () {
    }
  }
</script>
<style scoped>
  .brand-edit .brand-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .brand-edit .brand-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .brand-edit .brand-info-title-row {
    margin-bottom: 20px;
  }

  .brand-edit .buttonClass{
    padding: 10px 120px 0px 120px;
    margin-top: 40px;
    background-color: #ffd60c;
    color: #0b0e0f;
    border-radius: 8px;
  }

  .brand-edit .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }
</style>
