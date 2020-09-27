<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="6">
          <div class="purchase-list-title">
            <h6>创建采购需求</h6>
          </div>
        </el-col>
      </el-row>
      <div class="purchase-form-row">
        <el-form ref="form" :model="formData" :inline="true" :hide-required-asterisk="true" label-width="80px" label-position="left">
          <el-row type="flex" justify="start" >
            <el-col :span="7">
              <el-form-item label="系统单号">
                <el-input placeholder="系统生成" v-model="formData.code" :disabled="true"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="10">
              <el-form-item label="关联订单" prop="productionTask.code" :rules="[{ required: true, message: '请选择关联订单', trigger: 'change' }]">
                <el-input v-model="formData.productionTask.code" :disabled="true"></el-input>
              </el-form-item>
              <el-button class="purchase-btn" @click="taskDialogVisible=true">选择</el-button>
            </el-col>
            <el-col :span="7">
              <el-form-item label="关联款号">
                <el-input v-model="formData.productionTask.product.skuID" :disabled="true"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" >
            <h6 class="purchase-label">采购需求</h6>
          </el-row>
          <el-row type="flex" justify="start" >
            <div>
              <el-form-item label="是否含税">
                <el-radio :label="true" v-model="formData.includeTax">含税</el-radio>
                <el-radio :label="false" v-model="formData.includeTax">不含税</el-radio>
              </el-form-item>
            </div>
            <div v-if="formData.includeTax" style="margin-left: 20px">
              <el-form-item label="税点" label-width="40px">
                <el-select v-model="formData.taxPoint" placeholder="请选择" style="width: 100px;">
                  <el-option v-for="item in TaxPointState" :key="item.value" :label="item.label" :value="item.value" />
                </el-select>
              </el-form-item>
            </div>
            <div style="margin-left: 20px">
              <el-form-item label="品质要求" prop="qualityRequirement" :rules="[{ required: true, message: '不能为空', trigger: 'change' }]">
                <el-select v-model="formData.qualityRequirement" placeholder="请选择">
                  <el-option v-for="item in QualityRequirementType" :key="item.code" :label="item.name" :value="item.code" />
                </el-select>
              </el-form-item>
            </div>
          </el-row>
          <div style="display: flex;flex-wrap: wrap;">
            <el-form-item label="采购人" prop="merchandiser" :rules="[{ required: true, message: '不能为空', trigger: 'change' }]">
              <personnal-selection-v2 :vPerson.sync="formData.merchandiser" />
            </el-form-item>
            <el-form-item label="" label-width="10px" >
              <el-checkbox v-model="formData.auditNeeded" @change="handleClick">需审核</el-checkbox>
            </el-form-item>
            <template v-for="(item,itemIndex) in formData.approvers">
              <el-form-item :key="'a'+itemIndex" :label="'审批人'+(itemIndex+1)" label-width="80px"
                style="margin-right:10px;" :prop="'approvers.' + itemIndex"
                :rules="{required: formData.auditNeeded, message: '不能为空', trigger: 'change'}">
                <personnal-selection-v2 :vPerson.sync="formData.approvers[itemIndex]"
                  :disabled="!formData.auditNeeded" :excludeMySelf="true" style="width: 194px"
                  :selectedRow="formData.approvers" />
              </el-form-item>
            </template>
            <el-button-group style="padding-bottom: 26px">
              <el-button v-if="formData.approvers && formData.approvers.length < 5" style="height: 32px"
                @click="appendApprover">+ 添加审批人</el-button>
              <el-button v-if="formData.approvers && formData.approvers.length > 1" style="height: 32px"
                @click="removeApprover">删除</el-button>
            </el-button-group>
          </div>
          <div>
            <h6 style="color: #F56C6C">* 审批人将按照你选择的顺序逐级审批</h6>
          </div>
          <el-row type="flex" justify="start">
            <my-address-form :vAddress.sync="formData.shippingAddress" ref="addressForm" />
          </el-row>
        </el-form>
        <el-divider></el-divider>
        <purchase-requirement-table :formData="formData"/>
      </div>
      <div style="margin-top: 30px">
        <purchase-requirement-btn-group :formData="formData" @onSave="onSave" @onDelete="onDelete" />
      </div>
    </el-card>
    <el-dialog :visible.sync="taskDialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <production-task-select-dialog v-if="taskDialogVisible" @onSelectTask="onSelectTask" :isSingleChoice="true"/>
    </el-dialog>
  </div>
</template>

<script>
import { PersonnalSelectionV2, MyAddressForm } from '@/components'
import PurchaseRequirementTable from '../components/PurchaseRequirementTable'
import PurchaseRequirementBtnGroup from '../components/PurchaseRequirementBtnGroup'
import ProductionTaskSelectDialog from '@/views/order/salesProduction/production-task/components/ProductionTaskSelectDialog'

export default {
  name: 'PurchaseRequirementForm',
  components: {
    PersonnalSelectionV2,
    MyAddressForm,
    PurchaseRequirementTable,
    PurchaseRequirementBtnGroup,
    ProductionTaskSelectDialog
  },
  methods: {
    onSelectTask (data) {
      this.formData.productionTask = {
        id: data[0].id,
        code: data[0].code,
        product: {
          skuID: data[0].product.skuID
        }
      };
      this.taskDialogVisible = false;
    },
    appendApprover () {
      this.formData.approvers.push({});
    },
    removeApprover () {
      this.formData.approvers.splice(this.formData.approvers.length - 1, 1);
    },
    handleClick (value) {
      if (!value) {
        this.formData.approvers.forEach((val, index) => {
          this.$refs.form.clearValidate('approvers.' + index);
        })
      }
    },
    async validateForms() {
      const formArr = [
        this.$refs.form,
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
      if (validate) {
        this._onSave(flag);
      } else {
        this.$message.error('请完善信息');
      }
    },
    _onSave (flag) {
      if (this.formData.workOrders.length <= 0) {
        this.$message.error('请先添加物料！');
        return;
      }
      // 整理提交数据
      let data = Object.assign({}, this.formData);
      data.productionTask = {
        id: this.formData.productionTask.id
      }
      if (!this.formData.includeTax) {
        data.taxPoint = null;
      }
      if (this.formData.auditNeeded) {
        data.approvers = this.formData.approvers.filter(item => item instanceof Array && item.length > 0).map(item => {
          return {
            id: item[item.length - 1]
          }
        })
      } else {
        data.approvers = null;
      }
      data.merchandiser = {
        id: this.formData.merchandiser[this.formData.merchandiser.length - 1]
      }
      let workOrders = [];
      this.formData.workOrders.forEach(item => {
        let index = workOrders.findIndex(val => 
          val.cooperatorName === item.cooperatorName && 
          val.materials.name === item.name &&
          val.materials.code === item.code &&
          val.materials.unit === item.unit &&
          val.materials.materialsType === item.materialsType);
        if (index <= -1) {
          workOrders.push({
            id: item.id ? item.id : '',
            cooperatorName: item.cooperatorName.trim(),
            materials: {
              id: item.materialsId ? item.materialsId : '',
              name: item.name.trim(),
              code: item.code.trim(),
              unit: item.unit,
              materialsType: item.materialsType,
              specList: [{
                id: item.specListId,
                unitQuantity: item.unitQuantity,
                specName: item.specName.trim(),
                colorName: item.colorName.trim(),
                modelName: item.modelName.trim(),
                emptySent: item.emptySent,
                requiredAmount: item.requiredAmount,
                estimatedLoss: Number.parseFloat(item.estimatedLoss) / 100,
                estimatedUsage: item.estimatedUsage,
                orderCount: item.orderCount,
                // auditColor: item.auditColor,
                price: item.price,
                totalPrice: item.totalPrice,
                estimatedRecTime: item.estimatedRecTime
              }]
            }
          })
        } else {
          if (!workOrders[index].id && item.id) {
            workOrders[index].id = item.id;
          }
          if (!workOrders[index].materials.id && item.materialsId) {
            workOrders[index].materials.id = item.materialsId;
          }
          workOrders[index].materials.specList.push({
            id: item.specListId ? item.specListId : '',
            unitQuantity: item.unitQuantity,
            specName: item.specName.trim(),
            colorName: item.colorName.trim(),
            modelName: item.modelName.trim(),
            emptySent: item.emptySent,
            requiredAmount: item.requiredAmount,
            estimatedLoss: Number.parseFloat(item.estimatedLoss) / 100,
            estimatedUsage: item.estimatedUsage,
            orderCount: item.orderCount,
            auditColor: item.auditColor,
            price: item.price,
            totalPrice: item.totalPrice,
            estimatedRecTime: item.estimatedRecTime
          })
        }
      })
      data.workOrders = workOrders;
      this.__onSave(data, flag);
    },
    async __onSave (data, flag) {
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
        this.$router.go(-1); 
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('添加采购需求失败！');
      }
    },
    async onDelete () {
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
    validateField (name) {
      this.$refs.form.validateField(name);
    },
    async getDetail (id) {
      const url = this.apis().getPurchaseTask(id);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.initData(result.data);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      }
    },
    initData (resultData) {
      let workOrders = []; 
      let data = Object.assign({}, resultData);
      resultData.workOrders.forEach(row => {
        if (row.materials && row.materials.specList && row.materials.specList.length > 0) {
          workOrders = workOrders.concat(row.materials.specList.map(item => {
            return {
              id: row.id,
              materialsId: row.materials.id,
              specListId: item.id,
              name: row.materials.name,
              code: row.materials.code,
              unit: row.materials.unit,
              materialsType: row.materials.materialsType,
              unitQuantity: item.unitQuantity,
              specName: item.specName,
              colorName: item.colorName,
              modelName: item.modelName,
              emptySent: item.emptySent,
              requiredAmount: item.requiredAmount,
              estimatedLoss: item.estimatedLoss,
              estimatedUsage: item.estimatedUsage,
              orderCount: item.orderCount,
              auditColor: item.auditColor,
              estimatedRecTime: item.estimatedRecTime,
              cooperatorName: row.cooperatorName,
              price: item.price,
              totalPrice: item.totalPrice
            }
          }));
        }
      })
      data.workOrders = workOrders;
      if (!data.approvers) {
        data.approvers = [null];
        data.auditNeeded = false
      } else {
        data.auditNeeded = true;
      }
      this.formData = Object.assign({}, data);
      this.$refs.addressForm.getCities(data.shippingAddress.region);
      this.$refs.addressForm.onCityChanged(data.shippingAddress.city);
    }
  },
  data () {
    return {
      taskDialogVisible: false,
      TaxPointState: [{
          label: '3%税点',
          value: 0.03
        },
        {
          label: '6%税点',
          value: 0.06
        },
        {
          label: '13%税点',
          value: 0.13
        }
      ],
      QualityRequirementType: this.$store.state.EnumsModule.QualityRequirementType,
      formData: {
        code: '',
        includeTax: false,
        taxPoint: 0.03,
        qualityRequirement: '',
        productionTask: {
          id: '',
          code: '',
          product: {
            skuID: ''
          }
        },
        workOrders: [],
        auditNeeded: true,
        merchandiser: null,
        approvers: [null],
        shippingAddress: {},
      }
    }
  },
  watch: {
    'formData.merchandiser': function (nval, oval) {
      console.log('======================================')
      this.validateField('merchandiser');
    },
    'formData.approvers': function (nval, oval) {
      if (!this.formData.auditNeeded) {
        return;
      }
      this.formData.approvers.forEach((item, index) => {
        this.validateField('approvers.' + index);
      })
    }
  },
  created () {
    if (this.$route.params.id) {
      this.getDetail(this.$route.params.id);
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

  .purchase-label {
    font-size: 14px;
    color: #606266;
  }

  .purchase-btn {
    width: 70px;
    color: #606266;
    background-color: #ffd60c;
  }

  .sumbit-btn {
    width: 100px;
    color: #606266;
    background-color: #ffd60c;
  }

</style>