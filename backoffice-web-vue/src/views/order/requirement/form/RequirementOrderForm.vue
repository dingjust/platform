<template>
  <div class="animated fadeIn requirement-form">
    <el-row class="requirement-info-title-row">
      <div class="requirement-info-title">
        <h6 class="requirement-info-title_text">填写需求信息</h6>
      </div>
    </el-row>
    <div>
      <el-form ref="requirementForm" :model="formData" :rules="rules" label-position="left" label-width="88px" hide-required-asterisk>
        <el-form-item prop="details.majorCategory">
          <template slot="label">
            <h6 class="titleTextClass">选择类别<span style="color: red">*</span></h6>
          </template>
          <el-tag
            v-for="item of majorCategories"
            class="elTagClass"
            :color="formData.details.majorCategory && formData.details.majorCategory.code === item.code ? '#FFD60C' : '#ffffff'"
            @click="handleTagClick(item)"
            size="medium">
            {{item.name}}
          </el-tag>
        </el-form-item>
        <el-form-item prop="details.category">
          <template slot="label">
            <h6 class="titleTextClass">选择品类<span style="color: red">*</span></h6>
          </template>
          <category-select :listData="categories" :selectDatas="selectDatas" :multiple="false"></category-select>
        </el-form-item>
        <el-form-item prop="details.productiveOrientations">
          <template slot="label">
            <h6 class="titleTextClass">选择地区<span style="color: red">*</span></h6>
          </template>
          <el-row type="flex" align="middle">
            <el-radio-group v-model="isCountryWide" @change="radioChanged">
              <el-radio border :label="true">全国</el-radio>
              <el-radio border :label="false">自定义</el-radio>
            </el-radio-group>
            <el-select
              v-if="isCountryWide == false"
              v-model="formData.details.productiveOrientations"
              value-key="isocode"
              multiple
              placeholder="请选择"
              style="width: 300px;margin-bottom: 7px">
              <el-option
                v-for="item in regions"
                :key="item.isocode"
                :label="item.name"
                :value="item">
              </el-option>
            </el-select>
          </el-row>
        </el-form-item>
        <el-form-item prop="details.productName">
          <template slot="label">
            <h6 class="titleTextClass">标题<span style="color: red">*</span></h6>
          </template>
          <el-input v-model="formData.details.productName"  placeholder="请填写" style="width: 50%"></el-input>
        </el-form-item>
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item prop="details.maxExpectedPrice">
              <template slot="label">
                <h6 class="titleTextClass">期望价格<span style="color: red">*</span></h6>
              </template>
              <el-input :min="0" type="number" v-model.number="formData.details.maxExpectedPrice" placeholder="请填写" ></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item prop="details.expectedMachiningQuantity">
              <template slot="label">
                <h6 class="titleTextClass">加工数量<span style="color: red">*</span></h6>
              </template>
              <el-input :min="0" type="number" v-model.number="formData.details.expectedMachiningQuantity" placeholder="请填写" ></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item prop="details.expectedDeliveryDate">
              <template slot="label">
                <h6 class="titleTextClass">交货日期<span style="color: red">*</span></h6>
              </template>
              <el-date-picker
                v-model="formData.details.expectedDeliveryDate"
                type="date"
                style="width: 100%"
                :picker-options="pickerOptions"
                placeholder="选择日期">
              </el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item prop="details.salesMarket">
              <template slot="label">
                <h6 class="titleTextClass">销售市场<span style="color: red">*</span></h6>
              </template>
              <el-select v-model="formData.details.salesMarket" multiple placeholder="请选择" style="width: 100%">
                <el-option
                  v-for="item in salesMarkets"
                  :key="item.code"
                  :label="item.name"
                  :value="item.code">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item prop="details.contactPerson">
              <template slot="label">
                <h6 class="titleTextClass">联系人<span style="color: red">*</span></h6>
              </template>
              <el-input v-model="formData.details.contactPerson" placeholder="请填写" ></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item prop="details.contactPhone">
              <template slot="label">
                <h6 class="titleTextClass">联系方式<span style="color: red">*</span></h6>
              </template>
              <el-input v-model="formData.details.contactPhone" placeholder="请填写" ></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item prop="details.machiningType">
              <template slot="label">
                <h6 class="titleTextClass">加工类型</h6>
              </template>
              <el-radio-group v-model="formData.details.machiningType">
                <el-radio v-for="item of machiningTypes" border :label="item.code">{{item.name}}</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item prop="details.proofingNeeded">
              <template slot="label">
                <h6 class="titleTextClass">是否打样</h6>
              </template>
              <el-radio-group v-model="formData.details.proofingNeeded">
                <el-radio border :label="true">是</el-radio>
                <el-radio border :label="false">否</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item prop="details.invoiceNeeded">
              <template slot="label">
                <h6 class="titleTextClass">是否开发票</h6>
              </template>
              <el-radio-group v-model="formData.details.invoiceNeeded">
                <el-radio border :label="true">是</el-radio>
                <el-radio border :label="false">否</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex">
          <el-col :span="12">
            <el-form-item prop="details.publishingMode">
              <template slot="label">
                <h6 class="titleTextClass">发布方式</h6>
              </template>
              <el-radio-group v-model="formData.details.publishingMode" style="margin-top: 7px;margin-right: 10px">
                <el-radio label="PUBLIC">公开发布</el-radio>
                <el-radio label="PRIVATE">私密发布</el-radio>
              </el-radio-group>
              <el-button
                v-if="formData.details.publishingMode == 'PRIVATE'"
                @click="publishingModeChanged">选择发布对象
              </el-button>
              <h6 v-if="formData.details.publishingMode == 'PRIVATE'" style="margin-left: 210px">
                已选择<span style="color: red">{{selectUids.length}}</span>个工厂
              </h6>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item prop="details.effectiveDays">
              <template slot="label">
                <h6 class="titleTextClass">有效期限</h6>
              </template>
              <el-select v-model="formData.details.effectiveDays" placeholder="请选择" style="width: 240px">
                <el-option
                  v-for="item in effectiveDays"
                  :key="item.code"
                  :label="item.name"
                  :value="item.code">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item prop="attachments">
          <template slot="label">
            <h6 class="titleTextClass">附件</h6>
          </template>
          <images-upload :limit="5" :slot-data="formData.attachments" />
        </el-form-item>
        <el-form-item prop="remarks">
          <template slot="label">
            <h6 class="titleTextClass">备注</h6>
          </template>
          <el-input type="textarea" :autosize="{minRows:4,maxRows: 8}" v-model="formData.remarks">

          </el-input>
        </el-form-item>
      </el-form>
    </div>

    <el-row type="flex" justify="center">
      <el-button class="buttonClass" @click="onSave">
        <h6>确认发布</h6>
      </el-button>
    </el-row>

    <el-dialog :visible.sync="dialogVisible" width="80%"  class="purchase-dialog" append-to-body>
      <factory-cooperator-transfer-form
        v-if="dialogVisible"
        :selectFactories="selectFactories"
        :selectCooperators="selectCooperators"
        :selectUids="selectUids"
        :selectCooperatorIds="selectCooperatorIds"
        :selectFactoryUids="selectFactoryUids"
        :selectPhoneNumbers="selectPhoneNumbers">

      </factory-cooperator-transfer-form>
    </el-dialog>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  import CategorySelect from '../../../../components/custom/CategorySelect';
  import TemplateDetail from '../../../contract/template/detail/TemplateDetail';
  import ImagesUpload from '../../../../components/custom/ImagesUpload';
  import FactoryCooperatorTransferForm from './FactoryCooperatorTransferForm';

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('RequirementOrdersModule');

  export default {
    name: 'RequirementOrderForm',
    components: {
      FactoryCooperatorTransferForm,
      ImagesUpload,
      TemplateDetail,
      CategorySelect
    },
    computed: {
      ...mapGetters({
        categories: 'categories',
        majorCategories: 'majorCategories',
        regions: 'regions'
      })
    },
    props: ['formData'],
    methods: {
      ...mapMutations({
        setCategories: 'categories',
        setMajorCategories: 'majorCategories',
        setRegions: 'regions'
      }),
      ...mapActions({
        clearFactoryQueryFormData: 'clearFactoryQueryFormData',
        clearCooperatorQueryFormData: 'clearCooperatorQueryFormData'
      }),
      onSave () {
        this.$refs['requirementForm'].validate((valid) => {
          if (valid) {
            this.$confirm('是否确认发布!', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              if (this.formData.publishingMode === 'PUBLIC') {
                this.selectUids = [];
              }
              this.$emit('onSave', this.selectUids, this.selectPhoneNumbers);
            });
          } else {
            this.$message.error('请完善需求信息');
            return false;
          }
        });

      },
      async getCategories () {
        const url = this.apis().getMajorCategories();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setMajorCategories(result);
      },
      async getMinorCategories () {
        const url = this.apis().getMinorCategories();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setCategories(result);
      },
      handleTagClick (item) {
        this.formData.details.majorCategory = item;
        // this.$refs['requirementForm'].validateField('details.majorCategory');
      },
      async getRegions () {
        const url = this.apis().getRegions();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.setRegions(result);
      },
      radioChanged (val) {
        if (val) {
          // 'CN-10'代表全国
          this.formData.details.productiveOrientations = [{
            isocode: 'CN-10'
          }];
        } else {
          this.formData.details.productiveOrientations = [];
        }
        this.$refs['requirementForm'].validateField('details.productiveOrientations');
      },
      publishingModeChanged () {
        this.dialogVisible = !this.dialogVisible;
      }
    },
    watch: {
      'selectDatas': function (n, o) {
        if (n != null && n.length > 0) {
          this.formData.details.category = n[0];
        } else {
          this.formData.details.category = null;
        }
        this.$refs['requirementForm'].validateField('details.category');
      },
      'formData.details.majorCategory': function (n, o) {
        console.log(n);
        this.$refs['requirementForm'].validateField('details.majorCategory');
      }
    },
    data () {
      var checkCategory = (rule, value, callback) => {
        if (!value) {
          return callback(new Error('请选择品类'));
        } else {
          callback();
        }
      };
      var checkMajorCategory = (rule, value, callback) => {
        if (!value) {
          return callback(new Error('请选择类别'));
        } else {
          callback();
        }
      };
      var checkProductiveOrientations = (rule, value, callback) => {
        if (value.length <= 0) {
          return callback(new Error('请选择地区'));
        } else {
          callback();
        }
      };
      return {
        selectDatas: [],
        pickerOptions: {
          disabledDate (time) {
            var date = new Date();
            date.setDate(date.getDate() - 1);
            return time.getTime() < date;
          }
        },
        salesMarkets: this.$store.state.EnumsModule.SalesMarkets,
        machiningTypes: this.$store.state.EnumsModule.machiningTypes,
        effectiveDays: this.$store.state.EnumsModule.EffectiveDays,
        isCountryWide: null,
        dialogVisible: false,
        selectUids: [],
        selectFactoryUids: [],
        selectCooperatorIds: [],
        selectPhoneNumbers: [],
        selectFactories: [],
        selectCooperators: [],
        rules: {
          'details.maxExpectedPrice': [
            { required: true, message: '请填写期望价格', trigger: 'blur' }
          ],
          'details.productName': [
            { required: true, message: '请填写标题', trigger: 'blur' }
          ],
          'details.expectedMachiningQuantity': [
            { required: true, message: '请填写加工数量', trigger: 'blur' }
          ],
          'details.contactPerson': [
            { required: true, message: '请填写联系人', trigger: 'blur' }
          ],
          'details.contactPhone': [
            { required: true, message: '请填写联系方式', trigger: 'blur' }
          ],
          'details.expectedDeliveryDate': [
            { type: 'date', required: true, message: '请选择交货日期', trigger: 'change' }
          ],
          'details.salesMarket': [
            { required: true, message: '请选择销售市场', trigger: 'change' }
          ],
          'details.category': [
            { type: 'object', validator: checkCategory, trigger: 'change' }
          ],
          'details.majorCategory': [
            { type: 'object', validator: checkMajorCategory, trigger: 'change' }
          ],
          'details.productiveOrientations': [
            { type: 'array', validator: checkProductiveOrientations, trigger: 'change' }
          ]
        }
      }
    },
    created () {
      if (this.categories <= 0) {
        this.getMinorCategories();
      }
      if (this.majorCategories <= 0) {
        this.getCategories();
      }
      if (this.regions <= 0) {
        this.getRegions();
      }
    }
  }
</script>

<style>
  .requirement-form .rowClass{
    margin-top:20px;
  }
  .requirement-form .requirement-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .requirement-form .requirement-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .requirement-form .requirement-info-title-row {
    margin-bottom: 20px;
  }

  .requirement-form .buttonClass{
    padding: 10px 120px 0px 120px;
    margin-top: 40px;
    background-color: #ffd60c;
    color: #0b0e0f;
    border-radius: 8px;
  }

  .requirement-form .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }

  .requirement-form .elTagClass{
    color: #0b0e0f;
    margin-right: 20px;
    margin-bottom: 10px;
    cursor:pointer;
  }

  .requirement-form .titleTextClass{
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 63px;
    font-weight: bold;
  }

  .requirement-form .contentTextClass{
    color: #A9A9A9;
    font-weight: 400;
  }

</style>
