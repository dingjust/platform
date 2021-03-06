<template>
  <div class="animated fadeIn factory-edit">
    <el-row type="flex" justify="space-between">
      <div class="factory-info-title">
        <h6 class="factory-info-title_text">{{readOnly? '公司详情' : '编辑资料'}}</h6>
      </div>
      <h6 v-if="tranData.reviewState === 'REVIEWING'" style="color:#F56C6c;width: 145px">修改资料正在审核中</h6>
      <div v-if="tranData.reviewState === 'REVIEW_REJECTED'" style="display:flex;align-items: flex-start">
        <h6 style="color:#F56C6c;width: max-content;">修改资料已被驳回</h6>
        <el-button type="text" style="padding: 0" @click="onReviewReason(tranData.reviewReasons)">点击查看详情</el-button>
      </div>
    </el-row>
    <div class="titleCardClass">
      <el-form :model="tranData" ref="factoryForm" label-position="left" label-width="75px" :rules="rules" hide-required-asterisk :disabled="readOnly">
        <el-row>
          <factory-basic-form v-if="factoryFormVisible" :form-data="tranData" @onSaveProfiles="onSaveProfiles" :readOnly="readOnly"></factory-basic-form>
        </el-row>
<!--        <el-row>-->
<!--          <factory-contact-form :form-data="formData"></factory-contact-form>-->
<!--        </el-row>-->
        <el-row>
          <factory-scale-form :form-data="tranData" @validateField="validateField" :readOnly="readOnly"></factory-scale-form>
        </el-row>
        <el-row>
          <factory-capacity-form v-if="factoryFormVisible" :form-data="tranData" :readOnly="readOnly"></factory-capacity-form>
        </el-row>
<!--        <el-row>-->
<!--          <factory-service-form :form-data="formData"></factory-service-form>-->
<!--        </el-row>-->
      </el-form>
    </div>

    <el-row type="flex" justify="center">
      <Authorized :permission="['COMPANY_INFO_MODIFY']">
        <el-button v-if="!readOnly && !isEditing" class="buttonClass" @click="onEdit">
          <h6>编辑</h6>
        </el-button>
      </Authorized>
    </el-row>
    <el-row type="flex" justify="center">
      <Authorized :permission="['COMPANY_INFO_MODIFY']">
        <el-button v-if="saveShow" class="buttonClass" @click="onSave">
          <h6>保存</h6>
        </el-button>
      </Authorized>
    </el-row>
    <el-row type="flex" justify="center" v-if="showPassAndReject">
      <el-button type="text" @click="onPass">通过</el-button>
      <el-button type="text" @click="onReject">驳回</el-button>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapMutations} = createNamespacedHelpers('FactoriesModule');
  import FactoryBasicForm from './FactoryBasicForm';
  import FactoryCertificateForm from './FactoryCertificateForm';
  import FactoryContactForm from './FactoryContactForm';
  import FactoryScaleForm from './FactoryScaleForm';
  import FactoryCapacityForm from './FactoryCapacityForm';
  import FactoryServiceForm from './FactoryServiceForm';

  export default {
    name: 'FactoryFrom',
    props: ['formData', 'slotData', 'readOnly', 'showPassAndReject', 'isEditing'],
    components: {
      FactoryServiceForm,
      FactoryCapacityForm,
      FactoryScaleForm,
      FactoryContactForm,
      FactoryBasicForm,
      FactoryCertificateForm
    },
    computed: {
      ...mapGetters({
        factoryFormVisible: 'factoryFormVisible'
      }),
      saveShow: function () {
        return !this.readOnly && this.isEditing;
      },
      tranData: function () {
        if (this.readOnly) {
          this.setFactoryFormVisible(true);
          return this.slotData;
        } else {
          return this.formData;
        }
      }
    },
    methods: {
      ...mapMutations({
        setFactoryFormVisible: 'setFactoryFormVisible',
      }),
      onReviewReason (message) {
        this.$alert(message, '驳回原因', {
          confirmButtonText: '确定'
        });
      },
      onSave () {
        this.$refs['factoryForm'].validate((valid) => {
          if (valid) {
            this.$confirm('修改公司资料需要提交平台审核，是否确认提交？(资料审核中时，再次提交保存将会覆盖上次提交的信息)', '提示', {
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
        this.$refs.factoryForm.validateField(name);
      },
      onSaveProfiles () {
        this.$emit('onSaveProfiles')
      },
      onPass () {
        this.$confirm('是否通过工厂：' + this.tranData.name + ' 的修改?', '提示', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this._onPass();
        });
      },
      async _onPass () {
        const url = this.apis().FactoryReviewPass(this.tranData.uid);
        const result = await this.$http.put(url, {}, {
          versionNo: this.tranData.modifiedTime
        })
        if (result['errors']) {
          this.$message.error(result['errors'][0]);
          rerutn;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }

        this.$message.success('操作成功');
        this.$emit('closeDialog')
      },
      onReject () {
        this.$prompt('是否驳回工厂：' + this.tranData.name + ' 的修改', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          inputPattern: /^[\s\S]*.*[^\s][\s\S]*$/,
          inputErrorMessage: '请输入原因',
          closeOnClickModal: false,
          closeOnPressEscape: false
        }).then(({ value }) => {
          this._onReject(value);
        })
      },
      async _onReject (message) {
        const url = this.apis().FactoryReviewReject(this.tranData.uid);
        const result = await this.$http.put(url, {
          reason: message
        }, {
          versionNo: this.tranData.modifiedTime
        })
        if (result['errors']) {
          this.$message.error(result['errors'][0]);
          rerutn;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }

        this.$message.success('操作成功');
        this.$emit('closeDialog')
      },
      onEdit () {
        this.$emit('onEdit');
      }
    },
    watch: {
      'formData.adeptAtCategories': function (n, o) {
        this.validateField('adeptAtCategories');
      },
      'formData.profilePicture': function (n, o) {
        this.validateField('profilePicture');
      },
      'formData.categories': function (n, o) {
        this.validateField('categories');
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
      var checkCategories = (rule, value, callback) => {
        if (this.formData.categories.length <= 0) {
          return callback(new Error('请选择大类'));
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
          'categories': [
            {validator: checkCategories, type: 'object', trigger: 'change'}
          ],
          'profilePicture': [
            {validator: checkProfilePicture, type: 'object', trigger: 'change'}
          ],
          'duties': [
            {required: true, message: '请填写职务', trigger: 'blur'}
          ],
          'populationScale': [
            {required: true, message: '请选择工厂人数', trigger: 'change'}
          ],
          'cooperationModes': [
            {required: true, message: '请选择合作方式', trigger: 'change'}
          ],
          'qualityLevels': [
            {required: true, message: '请选择质量等级', trigger: 'change'}
          ]
        }
      }
    },
    created () {
    }
  }
</script>

<style>
  .factory-edit .factory-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .factory-edit .factory-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .factory-edit .factory-info-title-row {
    margin-bottom: 20px;
  }

  .factory-edit .buttonClass{
    padding: 10px 120px 0px 120px;
    margin-top: 40px;
    background-color: #ffd60c;
    color: #0b0e0f;
    border-radius: 8px;
  }

  .factory-edit .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }

</style>
