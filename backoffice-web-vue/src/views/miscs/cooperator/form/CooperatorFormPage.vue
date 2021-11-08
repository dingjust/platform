<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div class="animated fadeIn">
        <el-form :model="formData" ref="form" label-position="left" :rules="rules">
          <div class="cooperator-info-order-body">
            <el-row class="cooperator-info-title-row">
              <div class="cooperator-info-title">
                <h6 class="cooperator-info-title_text">添加合作商</h6>
              </div>
            </el-row>
            <el-row type="flex" class="row-title">
              <form-label label="基本信息" />
            </el-row>
            <el-row type="flex" justify="start" align="top" :gutter="10">
              <el-col :span="9">
                <el-form-item prop="name" label="合作商名称" label-width="100px">
                  <el-select v-model="formData.name" multiple remote reserve-keyword @remove-tag="onRemoveTag"
                    v-if="(formData.name instanceof Array)&&formData.name.length>0" style="width:100%">
                  </el-select>
                  <el-input v-else v-model="formData.name" :disabled="!isUpdate"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="3">
                <el-button v-if="!isUpdate" class="form-btn_select" @click="companyDialogVisible = true">选择平台用户
                </el-button>
              </el-col>
              <el-col :span="6">
                <el-form-item prop="contactPerson" label="联系人" label-width="80px">
                  <el-input placeholder="姓名" v-model="formData.contactPerson" size="mini">
                  </el-input>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item prop="contactPhone" label="联系方式" label-width="80px">
                  <el-input placeholder="电话号码" v-model="formData.contactPhone" size="mini">
                  </el-input>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row type="flex" align="middle" :gutter="10">
              <el-col :span="12">
                <el-form-item label="身份类型" prop="category" label-width="80px">
                  <el-radio-group v-model="formData.category" style="padding-top:5px">
                    <el-radio v-for="item in cooperatorCategorys" :label="item.code" :key="item.code">{{item.name}}
                    </el-radio>
                  </el-radio-group>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item prop="remarks" label="备注" label-width="80px">
                  <el-row type="flex" align="middle">
                    <el-input v-model="formData.remarks" size="mini">
                    </el-input>
                  </el-row>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row type="flex">
              <h6 class="item-label form-required">所在区域</h6>
              <address-form ref="addressForm" :vAddress.sync="formData.address" />
            </el-row>
            <el-row class="row-title">
              <form-label label="公账信息" />
            </el-row>
            <el-row :gutter="10" type="flex" align="middle">
              <el-col :span="12">
                <el-form-item prop="taxNumber" label="户名" label-width="80px">
                  <el-input placeholder="户名" v-model="formData.accountName" size="mini">
                  </el-input>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item prop="taxNumber" label="税号" label-width="80px">
                  <el-input placeholder="税号" v-model="formData.taxNumber" size="mini">
                  </el-input>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row type="flex" justify="start" align="middle" :gutter="10">
              <el-col :span="12">
                <el-form-item prop="bankOfDeposit" label="开户行" label-width="80px">
                  <el-input placeholder="开户行" v-model="formData.bankOfDeposit" size="mini">
                  </el-input>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item prop="bankAccount" label="银行账号" label-width="80px">
                  <el-input placeholder="银行账号" v-model="formData.bankAccount" size="mini">
                  </el-input>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row type="flex" class="row-title">
              <form-label label="关联方案" />
            </el-row>
            <el-row type="flex" justify="start" align="middle" :gutter="10">
              <el-col :span="8">
                <el-input placeholder="" :value="formData.payPlan != null ? formData.payPlan.name : ''" size="mini"
                  :disabled="false">
                  <template slot="prepend">绑定财务方案</template>
                  <el-button slot="append" @click="payPlanSelectDialogVisible = true">选择
                  </el-button>
                </el-input>
              </el-col>
              <el-col :span="8">
                <el-input placeholder="" :value="formData.progressPlan != null ? formData.progressPlan.name : ''"
                  size="mini" :disabled="false">
                  <template slot="prepend">绑定节点方案</template>
                  <el-button slot="append" @click="progressPlanVisible = true">选择
                  </el-button>
                </el-input>
              </el-col>
              <el-col :span="8">
                <el-input placeholder="" :value="formData.reconciliationPlan != null ? formData.reconciliationPlan.name : ''" size="mini"
                  :disabled="false">
                  <template slot="prepend">绑定对账方案</template>
                  <el-button slot="append" @click="reconciliationVisible=true">选择
                  </el-button>
                </el-input>
              </el-col>
            </el-row>
            <el-row type="flex" class="row-title" style="margin-top: 20px">
              <form-label label="附件" />
            </el-row>
            <el-row type="flex" justify="start">
              <files-upload ref="filesUpload" :slotData="formData.attachments" :limit="20"/>
            </el-row>
            <el-row type="flex" justify="center">
              <el-button class="cooperator-info-order-submit" v-if="isUpdate" @click="onSave">
                保存</el-button>
              <el-button class="cooperator-info-order-submit" v-else @click="onSubmit">确认创建</el-button>
            </el-row>
          </div>
        </el-form>
      </div>
    </el-card>
    <el-dialog :visible.sync="payPlanSelectDialogVisible" width="50%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <pay-plan-select @onSelect="onSelect" v-if="payPlanSelectDialogVisible" />
    </el-dialog>
    <el-dialog :visible.sync="companyDialogVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <company-select @onSubmit="onCompanySelect" />
    </el-dialog>
    <el-dialog :visible.sync="progressPlanVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <progress-plan-select-dialog v-if="progressPlanVisible" @getProgressPlan="getProgressPlan" />
    </el-dialog>
    <el-dialog :visible.sync="reconciliationVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <reconciliation-plan-selector v-if="reconciliationVisible" @onSelect="onReconciliationSelect" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';
  const {
    mapGetters,
    mapActions,
    mapMutations
  } = createNamespacedHelpers('CooperatorModule');

  // import {
  //   AddressForm,
  //   FormLabel,
  //   PayPlanSelect,
  //   CompanySelect
  // } from '@/components/'

  import AddressForm from '@/components/custom/order-form/AddressForm'
  import PayPlanSelect from '@/components/custom/PayPlanSelect'
  import CompanySelect from '@/components/custom/order-form/CompanySelect'

  import ProgressPlanSelectDialog from '@/views/user/progress-plan/components/ProgressPlanSelectDialog';
  import ReconciliationPlanSelector from '@/views/user/reconciliation-plan/components/ReconciliationPlanSelector';
  import FilesUpload from '@/components/custom/FilesUpload'
  import FormLabel from '@/components/custom/FormLabel'

  export default {
    name: 'CooperatorFormPage',
    props: {
      isFromDialog: {
        type: Boolean,
        default: false
      },
      cooperatorName: {
        type: String,
        default: ''
      }
    },
    components: {
      FormLabel,
      PayPlanSelect,
      AddressForm,
      CompanySelect,
      ReconciliationPlanSelector,
      ProgressPlanSelectDialog,
      FilesUpload
    },
    computed: {
      ...mapGetters({
        formData: 'formData'
      }),
      isUpdate: function () {
        return this.formData.id != null && this.formData.id != '';
      }
    },
    methods: {
      async onSubmit() {
        if (this.$refs.filesUpload.isUploading()) {
          this.$message.warning('文件正在上传，请稍等...')
          return;
        }

        //校验表单
        let validated = await this.validateForms();

        if (!validated) {
          return null;
        }
        const url = this.apis().createCooperator();

        //表单数据处理
        let form = Object.assign({}, this.formData);
        //名称处理
        if (form.name instanceof Array) {
          form.name = form.name[0];
        }

        const result = await this.$http.post(url, form);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$emit('添加合作商成功！');
        if (this.isFromDialog) {
          this.$emit('callback', result.data);
          return;
        }
        this.$router.push('/account/cooperator');
      },
      async onSave() {
        if (this.$refs.filesUpload.isUploading()) {
          this.$message.warning('文件正在上传，请稍等...')
          return;
        }
        
        //校验表单
        let validated = await this.validateForms();

        if (!validated) {
          return null;
        }
        const url = this.apis().updateCooperator();

        //表单数据处理
        let form = Object.assign({}, this.formData);
        //名称处理
        // if (form.name instanceof Array) {
        //   form.name = form.name[0];
        // }

        const result = await this.$http.put(url, form);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$emit('保存合作商成功！');
        if (this.isFromDialog) {
          this.$emit('callback', result.data);
          return;
        }
        this.$router.push('/account/cooperator');
      },
      onSelect(item) {
        if (item != null && item != '') {
          this.formData.payPlan = item;
        }
        this.payPlanSelectDialogVisible = false;
      },
      //名称标签移除
      onRemoveTag(tag) {
        this.formData.name = '';
        this.formData.partner = null;
      },
      onCompanySelect(val) {
        this.companyDialogVisible = false;
        this.formData.name = [val.name];
        this.formData.partner = val;
      },
      //封装校验Promise
      getFormPromise(form) {
        return new Promise(resolve => {
          form.validate(res => {
            resolve(res);
          })
        });
      },
      async validateForms() {
        let forms = [this.$refs.form, this.$refs.addressForm.$refs.address];
        let res = await Promise.all(forms.map(this.getFormPromise));
        return res.every(item => !!item);
      },
      getProgressPlan(val) {
        if (val) {
          this.formData.progressPlan = val;
        }
        this.progressPlanVisible = false;
      },
      //节点方案值拷贝
      copyProgressPlan(val) {
        let row = {
          name: val.name,
          remarks: val.remarks,
          productionProgresses: []
        }
        val.productionProgresses.forEach(item => {
          row.productionProgresses.push({
            progressPhase: item.progressPhase,
            warningDays: item.warningDays,
            medias: item.medias,
            completeAmount: item.completeAmount,
            productionProgressOrders: item.productionProgressOrders,
            quantity: item.quantity,
            sequence: item.sequence,
            isCannotRemove: true
          })
        })
        return row;
      },
      //对账方案选择
      onReconciliationSelect(val) {
        this.reconciliationVisible=false;
        this.formData.reconciliationPlan=val;
      }
    },
    data() {
      return {
        payPlanSelectDialogVisible: false,
        companyDialogVisible: false,
        progressPlanVisible: false,
        reconciliationVisible: false,
        cooperatorCategorys: this.$store.state.EnumsModule.CooperatorCategory,
        companies: [],
        payPlans: [],
        keyword: '',
        pageNumber: 0,
        isScrollEnd: false,
        options: [],
        rules: {
          name: [{
            required: true,
            message: '请输入合作商名称',
            trigger: 'change'
          }, ],
          contactPerson: [{
            required: true,
            message: '请输入联系人',
            trigger: 'blur'
          }],
          contactPhone: [{
            required: true,
            message: '请输入联系方式',
            trigger: 'blur'
          }],
          category: [{
            required: true,
            message: '请输入选择类型',
            trigger: 'change'
          }],
        }
      };
    },
    mounted () {
      if (this.cooperatorName != '') {
        this.formData.name = this.cooperatorName;
      }
    },
    created() {
      if (!this.formData.attachments) {
        this.formData.attachments = []
      }
    },
  };

</script>

<style scoped>
  .cooperator-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .cooperator-info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 60px;
    font-weight: bold;
    font-size: 10px;
  }

  .cooperator-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .cooperator-info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .cooperator-info-title-row {
    margin-bottom: 20px;
  }


  .cooperator-info-order-body {
    width: 100%;
    /*padding: 10px 60px;*/
  }

  .el-input.is-disabled .el-input__inner {
    cursor: pointer;
    background-color: #fff;
  }

  .cooperator-info-order-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
    margin-top: 30px;
  }

  .form-btn_select {
    background-color: #FFD60C;
    border-color: #FFD60C;
    /* margin-bottom: 25px; */
    color: #000;
  }

  .item-label {
    width: 80px;
    padding-top: 5px;
  }

  .row-title {
    margin-bottom: 20px
  }

  .form-required::before {
    content: '*';
    color: #F56C6C;
    margin-right: 4px;
  }

</style>
