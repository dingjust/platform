<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row type="flex" justify="space-between"> 
        <el-col :span="6">
          <div class="purchase-list-title">
            <h6>创建采购单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <div class="basic-row">
        <purchase-order-basic-info ref="basicInfo" :formData="formData" :order="order"/>
        <el-divider></el-divider>
        <el-form ref="form" :model="order" :inline="true">
          <div class="cooperator-container">
            <el-form-item label="供应商" prop="cooperatorName" :rules="[{required: true, validator: validateCooperator, trigger: 'change'}]">
              <el-select v-model="order.cooperatorName" multiple remote reserve-keyword @remove-tag="onRemoveTag"
                v-if="(order.cooperatorName instanceof Array) && order.cooperatorName.length > 0" style="width: 210px">
              </el-select>
              <el-input v-else v-model="order.cooperatorName" style="width: 194px"></el-input>
            </el-form-item>
            <el-button @click="onAdd" v-if="!selectCooperator.id">
              <!-- <i class="el-icon-plus icon-font"></i> -->
              + 添加为供应商
            </el-button>
            <el-button class="select-btn" @click="suppliersSelectVisible=true">选择</el-button>
          </div>
          <purchase-material-table :order="order"/>
          <div style="display: flex;flex-wrap: wrap;padding-left: 20px">
            <el-form-item label="" label-width="10px">
              <el-checkbox v-model="order.auditNeed">需审核</el-checkbox>
            </el-form-item>
            <template v-for="(item,itemIndex) in order.approvers">
              <el-form-item :key="'a'+itemIndex" :label="'审批人'+(itemIndex+1)" label-width="80px"
                style="margin-right:10px;" :prop="'approvers.' + itemIndex"
                :rules="{required: order.auditNeed, message: '不能为空', trigger: 'change'}">
                <personnal-selection-v2 :vPerson.sync="order.approvers[itemIndex]"
                  :disabled="!order.auditNeed" :excludeMySelf="true" style="width: 194px"
                  :selectedRow="order.approvers" />
              </el-form-item>
            </template>
            <el-button-group style="padding-bottom: 26px;">
              <el-button v-if="order.approvers && order.approvers.length < 5" style="height: 32px"
                @click="appendApprover">+ 添加审批人</el-button>
              <el-button v-if="order.approvers && order.approvers.length > 1" style="height: 32px"
                @click="removeApprover">删除</el-button>
            </el-button-group>
          </div>
        </el-form>
      </div>
      <purchase-order-btn-group :formData="formData" :order="order" @onSave="onSave" @onDelete="onDelete" />
    </el-card>
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <supplier-select v-if="suppliersSelectVisible" @onSelect="onSuppliersSelect" />
    </el-dialog>
    <el-dialog :visible.sync="appendVisible" width="80%" append-to-body :close-on-click-modal="false">
      <cooperator-form-page v-if="appendVisible" :cooperatorName="order.cooperatorName" :isFromDialog="true" @callback="callback"/>
    </el-dialog>
  </div>
</template>

<script>
import PurchaseOrderBasicInfo from '../components/PurchaseOrderBasicInfo'
import PurchaseMaterialTable from '../components/PurchaseMaterialTable'
import PurchaseOrderBtnGroup from '../components/PurchaseOrderBtnGroup'
import { PersonnalSelectionV2, SupplierSelect } from '@/components'
import CooperatorFormPage from '@/views/miscs/cooperator/form/CooperatorFormPage'

export default {
  name: 'PurchaseOrderForm',
  props: {
    formData: Object,
    order: Object,
    isFormDialog: {
      type: Boolean,
      default: false
    }
  },
  components: {
    PurchaseOrderBasicInfo,
    PurchaseMaterialTable,
    PurchaseOrderBtnGroup,
    PersonnalSelectionV2,
    SupplierSelect,
    CooperatorFormPage
  },
  computed: {
  },
  methods: {
    onAdd () {
      this.appendVisible = true;
    },
    onRemoveTag(tag) {
      this.order.cooperatorName = '';
      this.selectCooperator = '';
    },
    callback (data) {
      this.selectCooperator = data;
      this.order.cooperatorName = [data.name];
      this.appendVisible = false;
    },
    appendApprover() {
      this.order.approvers.push({});
    },
    removeApprover() {
      this.order.approvers.splice(this.order.approvers.length - 1, 1);
    },
    onSuppliersSelect (data) {
      this.selectCooperator = data;
      this.suppliersSelectVisible = false;
      this.order.cooperatorName = [data.name];
    },
    onSave (flag) {
      if (this.$refs.basicInfo.isUploading) {
        this.$message.warning('图片正在上传，请稍后再试！');
        return;
      }
      this.$refs.form.validate(valid => {
        if (valid) {
          this._onSave(flag);
        } else {
          this.$message.error('请完善表单信息！');
          return;
        }
      });
    },
    async _onSave (flag) {
      try {
        this.order.entries.forEach(item => {
          if (!item.orderQuantity || item.orderQuantity === 0) {
            throw new Error('请填写下单数');
          }
          if (!item.price) {
            throw new Error('请填写物料单价');
          }
          if (!item.estimatedRecTime) {
            throw new Error('请填写到料时间');
          }
        })
      } catch (error) {
        this.$message.error(error.message);
        return;
      }

      let form = {
        id: this.order.id ? this.order.id : '',
        attachAgreements: this.order.attachAgreements,
        workOrder: this.order.workOrder,
        entries: this.order.entries.map(item => {
          return {
            id: item.id ? item.id : '',
            spec: item.spec,
            orderQuantity: item.orderQuantity,
            price: item.price,
            totalPrice: item.totalPrice,
            estimatedRecTime: item.estimatedRecTime
          }
        })
      };
      if (this.selectCooperator != '' && this.selectCooperator.id) {
        this.$set(form, 'cooperator', { id: this.selectCooperator.id });
      } else {
        this.$set(form, 'cooperatorName', this.order.cooperatorName);
      }

      if (this.order.auditNeed) {
        form.auditNeed = true;
        form.approvers = this.order.approvers.filter(item => item instanceof Array && item.length > 0).map(item => {
          return {
            id: item[item.length - 1]
          }
        })
      } else {
        form.auditNeed = false;
        form.approvers = null;
      }
      
      const url = this.apis().savePurchaseOrder();
      const result = await this.$http.post(url, form, {
        submit: flag
      });
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.$message.success('创建采购单成功！');
        if (this.isFormDialog) {
          this.$emit('callback');
        } else {
          this.$router.push('/purchase/order');
        }
      } else if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      } else {
        this.$message.success('创建采购单失败！');
      }
    },
    async onDelete () {
      const id = this.order.id;
      
      const url = this.apis().deletePurchaseOrderById(id);
      const result = await this.$http.delete(url);
      
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.$message.success('删除采购单成功！');
        if (this.isFormDialog) {
          this.$emit('callback');
        } else {
          this.$router.push('/purchase/order');
        }
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('删除采购需求失败！');
      }
    },
    validateField (name) {
      this.$refs.form.validateField(name);
    },
    validateCooperator (rule, value, callback) {
      if (this.order.cooperatorName === '') {
        callback(new Error('请填写或选择合作商'));
      } else {
        callback();
      }
    }
  },
  data () {
    return {
      suppliersSelectVisible: false,
      selectCooperator: '',
      appendVisible: false
    }
  },
  watch: {
    'order.approvers': function (nval, oval) {
      if (!this.order.auditNeed) {
        return;
      }
      this.order.approvers.forEach((item, index) => {
        this.validateField('approvers.' + index);
      })
    },
    'order.cooperatorName': function (nval, oval) {
      this.validateField('cooperatorName');
    }
  }, 
  created () {
    if (!this.formData || !this.order) {
      this.$router.push('/purchase/order');
    }
  } 
}
</script>

<style scoped>
  .purchase-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-row {
    margin: 0px 0px 10px 20px;
  }

  .select-btn {
    width: 80px;
    color: #606266;
    background: #FFD60C;
  }

  /deep/ .el-form-item {
    margin-bottom: 0px;
  }

  button {
    outline:none;
  }

  .icon-font {
    font-size: 24px;
    font-weight: 500;
  }

  .cooperator-container {
    display: flex;
    align-items: flex-start;
  }
</style>