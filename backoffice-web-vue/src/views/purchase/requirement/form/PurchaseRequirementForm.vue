<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="start">
        <div class="purchase-list-title">
          <h6>创建采购需求</h6>
        </div>
      </el-row>
      <div class="pt-2"></div>
      <div class="purchase-form-row">
        <purchase-requirement-base-info ref="basicForm" :formData="formData"/>
        <div class="basic-container">
          <my-address-form ref="addressForm" :vAddress.sync="formData.shippingAddress" />
        </div>
        <el-divider></el-divider>
        <purchase-requirement-table :formData="formData"/>
      </div>
      <purchase-requirement-btn-group class="form-btn" :formData="formData" @onSave="onSave" @onDelete="onDelete" />
    </el-card>
  </div>
</template>

<script>
import { MyAddressForm } from '@/components'
import PurchaseRequirementTable from '../components/PurchaseRequirementTable'
import PurchaseRequirementBtnGroup from '../components/PurchaseRequirementBtnGroup'
import PurchaseRequirementBaseInfo from './PurchaseRequirementBaseInfo'

export default {
  name: 'PurchaseRequirementForm',
  components: {
    MyAddressForm,
    PurchaseRequirementTable,
    PurchaseRequirementBtnGroup,
    PurchaseRequirementBaseInfo
  },
  methods: {
    async validateForms() {
      const formArr = [
        this.$refs.basicForm.$refs.form,
        this.$refs.addressForm.$refs.address
      ];
      // 使用Promise.all 并行去校验结果
      let res = await Promise.all(formArr.map(this.getFormPromise));

      return res.every(item => !!item);
    },
    //封装Promise对象
    getFormPromise(form) {
      return new Promise(resolve => {
        form.validate(res => {
          resolve(res);
        })
      })
    },
    async onSave (flag) {
      let validate = await this.validateForms();

      if (this.formData.workOrders.length <= 0) {
        this.$message.error('请先添加物料！');
        return;
      }

      if (validate) {
        this.$confirm('是否执行'+(flag ? '创建' : '保存')+'操作?', '', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          const data = this.handleData();
          this._onSave(data, flag);
        });
      } else {
        this.$message.error('请完善信息');
      }
    },
    handleData () {
      let workOrders = []
      this.formData.workOrders.forEach(item => {
        workOrders.push({
          id: item.id ? item.id : '',
          cooperatorName: item.cooperatorName,
          materials: {
            id: item.materialsId ? item.materialsId : null,
            name: item.name,
            code: item.code,
            unit: item.unit,
            materialsType: item.materialsType,
            specList: [{
              id: item.specListId,
              unitQuantity: item.unitQuantity,
              specName: item.specName,
              colorName: item.colorName,
              modelName: item.modelName,
              emptySent: item.emptySent,
              requiredAmount: item.requiredAmount,
              estimatedLoss: item.estimatedLoss,
              estimatedUsage: item.estimatedUsage,
              orderCount: item.orderCount,
              price: item.price,
              totalPrice: item.totalPrice,
              estimatedRecTime: item.estimatedRecTime
            }]
          }
        })
      })

      let data = {
        id: this.formData.id,
        profitLossAnalysisEntry: { 
          id: this.formData.profitLossAnalysisEntry.id 
        },
        includeTax: this.formData.includeTax,
        taxPoint: this.formData.includeTax ? this.formData.taxPoint : null,
        qualityRequirement: this.formData.qualityRequirement,
        merchandiser: {
          id: this.formData.merchandiser[this.formData.merchandiser.length - 1]
        },
        auditNeeded: this.formData.auditNeeded,
        approvers: this.formData.auditNeeded ? this.formData.approvers.filter(item => item instanceof Array && item.length > 0).map(item => {
          return {
            id: item[item.length - 1]
          }
        }) : null,
        shippingAddress: this.formData.shippingAddress,
        workOrders: workOrders
      }

      return data;
    },
    async _onSave (data, flag) {
      const url = this.apis().savePurchaseTask();
      const result = await this.$http.post(url, data, {
        submit: flag
      });
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.$message.success('添加采购需求成功！');
        this.$router.push('/purchase/requirement/' + result.data.id);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('添加采购需求失败！');
      }
    },
    onDelete () {
      this.$confirm('是否执行删除操作?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onDelete();
      });
    },
    async _onDelete () {
      const id = this.formData.id;
      
      const url = this.apis().deletePurchaseTaskById(id);
      const result = await this.$http.delete(url);
      
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.$message.success('删除采购需求成功！');
        this.$router.push('/purchase/requirement');
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('删除采购需求失败！');
      }
    },
    init () {
      const params = Object.assign({}, this.$route.params);
      // 创建采购，带入盈亏分析行
      if (params.row) {
        this.formData.profitLossAnalysisEntry = {
          id: params.row.id,
          name: params.row.name
        };
        this.formData.workOrders = params.row.workOrders
      } 
      // 编辑采购需求
      if (params.formData) {
        Object.assign(this.formData, params.formData);
        this.formData.profitLossAnalysisEntry.name = 
            params.formData.profitLossAnalysisEntry.skuID + ' / ' + params.formData.profitLossAnalysisEntry.colors.map(item => item.name).toString();
      }
    }
  },
  data () {
    return {
      formData: {
        id: null,
        code: '',
        profitLossAnalysisEntry: {
          id: null
        },
        includeTax: false,
        taxPoint: 0.03,
        qualityRequirement: '',
        auditNeeded: true,
        merchandiser: {},
        approvers: [null],
        shippingAddress: {},
        workOrders: [],
      }
    }
  },
  created () {
    if (this.$route.params) {
      this.init();
    }
  }  
}
</script>

<style scoped>
  .purchase-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .purchase-form-row {
    margin-left: 20px;
  }

  .basic-container {
    margin-left: 28px;
  }

  .form-btn {
    margin-top: 30px;
  }

  .purchase-form-row >>> .el-divider--horizontal {
    display: block;
    height: 1px;
    width: 100%;
    margin: 0 0 24px 0;
  }
</style>