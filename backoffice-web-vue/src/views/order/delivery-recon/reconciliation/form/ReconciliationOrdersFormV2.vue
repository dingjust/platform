<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <div class="reconcilication-order-title">
          <h6>创建对账单</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <el-row type="flex" justify="start">
        <h6 style="color: #F56C6C;margin-left: 20px">注明：只有完成实名认证才可以使用电子对账单签署功能</h6>
      </el-row>
      <el-form ref="form" :model="formData" :inline="true" class="form-container" label-width="65px" label-position="left">
        <reconciliation-orders-form-v2-header :formData="formData" />
        <reconciliation-info-table :formData="formData" :tableCol="tableCol" :isCreate="true"/>
        <reconciliation-additional :formData="formData"/>
        <reconciliation-approvers-part :formData="formData"/>
        <reconciliation-upload-part ref="uploadPart" :formData="formData" :isAllApproval="isAllApproval"/>
      </el-form>
      <el-row type="flex" justify="center">
        <el-button class="sumbit-btn" @click="onCreate">创建</el-button>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import ReconciliationOrdersFormV2Header from './ReconciliationOrdersFormV2Header'
import ReconciliationInfoTable from './ReconciliationInfoTable'
import ReconciliationApproversPart from './ReconciliationApproversPart'
import ReconciliationUploadPart from './ReconciliationUploadPart'
import ReconciliationAdditional from './ReconciliationAdditional.vue'

export default {
  name: 'ReconciliationOrdersFormV2',
  components: {
    ReconciliationOrdersFormV2Header,
    ReconciliationInfoTable,
    ReconciliationApproversPart,
    ReconciliationUploadPart,
    ReconciliationAdditional
  },
  computed: {
    // 判断自身所属公司有没认证
    authenticated: function () {
      if (this.authenticationInfo == null) {
        return false;
      } else {
        if (
          this.authenticationInfo.companyState != null &&
          this.authenticationInfo.companyState == "SUCCESS"
        ) {
          return true;
        } else if (
          this.authenticationInfo.personalState != null &&
          this.authenticationInfo.personalState == "SUCCESS"
        ) {
          return true;
        } else {
          return false;
        }
      }
    },
    // 判断合作商双方是否都认证
    isAllApproval: function () {
      return this.authenticated && this.formData.cooperator.approvalStatus === 'approved';
    }
  },
  data () {
    return {
      authenticationInfo: this.$store.getters.authenticationInfo,
      electronTip: '正在新创建电子对账单，双方将使用在线电子签章系统签署，是否继续?',
      paperTip: '正在把已签署的对账单文件扫描件上传到订单附件中作为备份，是否继续',
      formData: {
        type: 'shippingSheets',
        title: '',
        shippingSheets: [],
        fastShippingSheets: [],
        cooperator: '',
        entries: [],
        isApproval: true,
        approvers: [null],
        paperSheetMedias: [],
        medias: [],
        colNames: [],
        remarks: '',
        additionalCharges: [],
        belongRoleType: 'PARTYA'
      },
      tableCol: this.$store.state.ReconciliationOrdersV2Module.tableCol
    }
  },
  methods: {
    validateField (name) {
      this.$refs.form.validateField(name);
    },
    onCreate () {
      if (this.$refs.uploadPart.$refs.imageUpload.isUploading() || 
          this.$refs.uploadPart.$refs.filesUpload.isUploading()) {
        this.$message.warning('文件正在上传，请稍等...');
        return;
      }

      this.$refs.form.validate((valid) => {
        if (valid) {
          if (!this.isAllApproval && this.formData.paperSheetMedias.length <= 0) {
            this.$message.error('合作商双方有其中一方未认证时，需上传已签署的对账单');
            return;
          }

          if (this.isAllApproval && this.formData.entries.length <= 0 && this.formData.paperSheetMedias.length <= 0) {
            this.$message.error('请填写对账信息！');
            return;
          }

          if (this.formData.entries.some(item => item.product.id === '')) {
            this.$message.error('存在对账内容没有产品，请先进行处理');
            return;
          }

          this.$confirm(this.formData.paperSheetMedias.length <= 0 ? this.electronTip : this.paperTip, '', {
            confirmButtonText: '是',
            cancelButtonText: '否',
            type: 'warning'
          }).then(() => {
            this._onCreate();
          });
        } else {
          this.$message.error('请完善表单信息！');
        }
      })
    },
    async _onCreate () {
      let data = JSON.parse(JSON.stringify(this.formData));

      this.$delete(data, 'type');
      
      // 人员设置数据处理
      if (!this.formData.isApproval) {
        data.approvers = [];
      } else {
        // 处理级联选择数据
        data.approvers = [];
        this.formData.approvers.forEach(item => {
          if (item instanceof Array && item.length > 0) {
            data.approvers.push({
              id: item[item.length - 1]
            });
          }
        })
      }

      data.entries.forEach(item => {
        item.customColumns = [];
        data.colNames.forEach(val => {
          item.customColumns.push({
            id: item[val.id].id !== '' ? item[val.id].id : null, 
            name: val.value,
            value: item[val.id].value
          })
          this.$delete(item, val.id);
        })

        // 将非必须字段都转换为自定义字段
        for (const key in this.tableCol) {
          const element = this.tableCol[key];
          if (element.have) {
            item.customColumns.push({
              name: element.name,
              value: item[key]
            })
          }
          this.$delete(item, key);
        }
      });

      data.colNames = this.formData.colNames.map(item => item.value);

      for (const key in this.tableCol) {
        if (this.tableCol[key].have) {
          data.colNames.push(this.tableCol[key].name);
        }
      }

      data.fastShippingSheets = this.formData.fastShippingSheets.map(item => {
        return {id: item.id}
      });
      data.shippingSheets = this.formData.shippingSheets.map(item => {
        return {id: item.id}
      });

      const url = this.apis().createReconciliationV2();
      const result = await this.$http.post(url, data);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }

      this.$message.success('创建成功！');
      this.$router.push('/order/delivery-Reconciliation');
    }
  },
  watch: {
    'formData.paperSheetMedias': function (nval, oval) {
      this.validateField('paperSheetMedias');
    },
    'formData.cooperator': function (nval, oval) {
      if (!this.isAllApproval) {
        this.$refs.form.clearValidate('paperSheetMedias');
      }
    },
    'formData.approvers': function (nval, oval) {
      this.formData.approvers.forEach((item, index) => {
        this.validateField('approvers.' + index);
      })
    },
    'formData.isApproval': function (nval, oval) {
      this.formData.approvers.forEach((item, index) => {
        this.$refs.form.clearValidate('approvers.' + index);
      })
    }
  },
  created () {
    if (this.$route.params.order) {
      this.formData.fastShippingSheets[0].id = this.$route.params.order.id;
      this.formData.fastShippingSheets[0].code = this.$route.params.order.code;
      
      this.formData.cooperator = {
        id: this.$route.params.order.cooperator.id,
        name: this.$route.params.order.cooperator.type === 'ONLINE' ? 
              this.$route.params.order.cooperator.partner.name : 
              this.$route.params.order.cooperator.name,
        approvalStatus: this.$route.params.order.cooperator.type === 'ONLINE' ? 
              this.$route.params.order.cooperator.partner.approvalStatus : ''
      }
    }
  }
}
</script>

<style scoped>
  .reconcilication-order-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .form-container {
    margin: 0 0 0 20px;
  }

  .sumbit-btn {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #606266;
    width: 80px;
  }
</style>
