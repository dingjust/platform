<!--
* @Description: 需求-抢订单表单
* @Date 2021/07/09 14:55
* @Author L.G.Y
-->
<template>
  <div class="requirement-form">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">填写需求信息</h6>
      </div>
    </el-row>
    <el-form ref="form" :model="formData" :rules="rules" label-position="left" label-width="88px" hide-required-asterisk>
      <el-form-item prop="belongTo" v-if="isTenant()">
        <template slot="label">
          <h6 class="titleTextClass">所属公司<span style="color: red">*</span></h6>
        </template>
        <el-input v-model="formData.belongTo.name" :disabled="true" style="width: 300px">
        </el-input>
        <el-button @click="companyDialogVisible = true">选择公司</el-button>
      </el-form-item>
      <el-form-item prop="certificates" v-if="isTenant()">
        <template slot="label">
          <h6 class="titleTextClass">凭证</h6>
        </template>
        <images-upload :limit="5" :slot-data="formData.details.certificates" />
      </el-form-item>
      <el-form-item prop="details.productName">
        <template slot="label">
          <h6 class="titleTextClass">标题<span style="color: red">*</span></h6>
        </template>
        <el-input v-model="formData.details.productName" placeholder="请填写" style="width: 50%"></el-input>
      </el-form-item>
      <el-form-item prop="details.majorCategory">
        <template slot="label">
          <h6 class="titleTextClass">选择类别<span style="color: red">*</span></h6>
        </template>
        <el-tag v-for="item of majorCategories" class="elTagClass" :key="item.id"
          :color="formData.details.majorCategory && formData.details.majorCategory.code === item.code ? '#FFD60C' : '#ffffff'"
          @click="handleTagClick(item)" size="medium">
          {{item.name}}
        </el-tag>
      </el-form-item>
      <el-row type="flex" justify="space-between">
        <el-form-item prop="details.contactPerson">
          <template slot="label">
            <h6 class="titleTextClass">联系人<span style="color: red">*</span></h6>
          </template>
          <el-input v-model="formData.details.contactPerson" placeholder="请填写"></el-input>
        </el-form-item>
        <el-form-item prop="details.contactPhone">
          <template slot="label">
            <h6 class="titleTextClass">联系方式<span style="color: red">*</span></h6>
          </template>
          <el-input v-model="formData.details.contactPhone" placeholder="请填写"></el-input>
        </el-form-item>
        <el-form-item >
          <template slot="label">
            <h6 class="titleTextClass">微信号</h6>
          </template>
          <el-input v-model="formData.details.contactWeChatNo" placeholder="请填写"></el-input>
        </el-form-item>
      </el-row>
      <el-form-item>
        <template slot="label">
          <h6 class="titleTextClass">参考图片</h6>
        </template>
        <images-upload :limit="5" :slot-data="formData.details.pictures" />
      </el-form-item>
      <el-form-item prop="remarks">
        <template slot="label">
          <h6 class="titleTextClass">备注</h6>
        </template>
        <el-input type="textarea" :autosize="{minRows:4,maxRows: 8}" v-model="formData.remarks" />
      </el-form-item>
    </el-form>
    <el-row type="flex" justify="center" align="center">
      <el-button type="primary" size="medium" @click="onSave">{{isCreated ? '需求发出' : '编辑需求'}}</el-button>
    </el-row>
    <el-dialog :visible.sync="companyDialogVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <company-select v-if="companyDialogVisible" @onSubmit="onCompanySelect" />
    </el-dialog>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex';
const { mapGetters, mapMutations } = createNamespacedHelpers('RequirementOrdersModule');

import ImagesUpload from '@/components/custom/ImagesUpload'
import CompanySelect from '@/components/custom/order-form/CompanySelect'

export default {
  name: 'RequirementWithFindOrderForm',
  components: { CompanySelect, ImagesUpload },
  props: {
    slotData: Object,
    isCreated: {
      type: Boolean,
      default: true
    }
  },
  computed: {
    ...mapGetters({
      majorCategories: 'majorCategories'
    })
  },
  methods: {
    ...mapMutations({
      setMajorCategories: 'majorCategories',
    }),
    onCompanySelect (val) {
      if (val) {
        this.formData.belongTo.id = val.id;
        this.formData.belongTo.name = val.name;
      }

      this.companyDialogVisible = false
    },
    handleTagClick(item) {
      this.formData.details.majorCategory = item;
    },
    async getCategories() {
      const url = this.apis().getMajorCategories();
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.setMajorCategories(result);
    },
    onSave () {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.$confirm(this.isCreated ? '是否确认发布!' : '是否确认修改', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            if (this.isCreated) {
              this._onSave()
            } else {
              this._onEdit()
            }
          });
        } else {
          this.$message.error('请完善需求信息')
        }
      })
    },
    async _onSave () {
      var form = Object.assign({}, this.formData)

      var url;
      if (this.isTenant()) {
        form.publishType = 'PUBLISH_BY_OTHERS';
        url = this.apis().createPublishByPlatform();
      } else {
        form.publishType = 'DEFAULT';
          url = this.apis().createRequirementOrderNewByType();
      }

      const result = await this.$http.post(url, form, {});

      if (result.code === 0) {
        this.$message.error(result.msg)
        return
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.$message.success('需求订单创建成功，订单编号： ' + result);
      this.$emit('callback')
    },
    async _onEdit () {
      var form = Object.assign({}, this.formData)

      let url;
      if (this.isTenant()) {
        url = this.apis().updateRequirementOrderByPlatform();
      } else {
        this.$set(form, 'reviewState', 'REVIEWING')
        url = this.apis().updateRequirementOrderNewByType();
      }

      const result = await this.$http.put(url, form, {});

      if (result.code === 0) {
        this.$message.error(result.msg)
        return
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }

      this.$message.success('需求订单修改成功');
      this.$emit('callback')
    }
  },
  data () {
    var checkReplaceCompany = (rule, value, callback) => {
      if (value.id) {
        callback();
      } else {
        return callback(new Error('请选择需求所属公司'));
      }
    };
    var checkMajorCategory = (rule, value, callback) => {
      if (!value) {
        return callback(new Error('请选择类别'));
      } else {
        callback();
      }
    };
    return {
      companyDialogVisible: false,
      formData: {
        orderType: 'FINDING_ORDER',
        publishType: "DEFAULT",
        belongTo: {},
        remarks: '',
        details: {
          publishingMode: 'PUBLIC',
          productName: '',
          majorCategory: null,
          certificates: [],
          pictures: [],
          contactPerson: '',
          contactPhone: '',
          contactWeChatNo: ''
        }
      },
      rules: {
        'details.productName': [{
          required: true,
          message: '请填写标题',
          trigger: 'blur'
        }],
        'details.contactPerson': [{
          required: true,
          message: '请填写联系人',
          trigger: 'blur'
        }],
        'details.contactPhone': [{
          required: true,
          message: '请填写联系方式',
          trigger: 'blur'
        }],
        'details.majorCategory': [{
          type: 'object',
          validator: checkMajorCategory,
          trigger: 'change'
        }],
        'belongTo': [{
          required: true,
          validator: checkReplaceCompany,
          trigger: 'change'
        }]
      }
    }
  },
  watch: {
    'formData.details.majorCategory': function (n, o) {
      this.$refs['form'].validateField('details.majorCategory');
    }
  },
  created () {
    if (this.majorCategories <= 0) {
      this.getCategories();
    }
    if (!this.isCreated) {
      this.formData = this.slotData
    }
  }
}
</script>

<style scoped>
  .elTagClass {
    color: #0b0e0f;
    margin-right: 20px;
    margin-bottom: 10px;
    cursor: pointer;
  }

  .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 63px;
    font-weight: bold;
  }

  .info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .info-title-row {
    margin-bottom: 20px;
  }
</style>