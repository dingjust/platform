<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row type="flex" justify="space-between"> 
        <el-col :span="6">
          <div class="purchase-list-title">
            <h6>创建采购单</h6>
          </div>
        </el-col>
        <!-- <el-col :span="6">
          <h6>状态/标签：{{'待采购'}}</h6>
        </el-col> -->
      </el-row>
      <div class="pt-2"></div>
      <div class="basic-row">
        <purchase-order-basic-info :formData="formData" :order="order"/>
        <el-divider></el-divider>
        <el-form ref="form" :model="order" :inline="true">
          <el-row type="flex" justify="start">
            <el-col>
              <el-form-item label="供应商" prop="cooperatorName" :rules="[{required: true, message: '请选择供应商', trigger: 'change'}]">
                <el-input v-model="order.cooperatorName"></el-input>
              </el-form-item>
              <el-button class="select-btn" @click="suppliersSelectVisible=true">选择</el-button>
            </el-col>
          </el-row>
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
      <purchase-order-btn-group @onSave="onSave" @onDelete="onDelete" @onReturn="onReturn"/>
    </el-card>
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <supplier-select v-if="suppliersSelectVisible" @onSelect="onSuppliersSelect" />
    </el-dialog>
  </div>
</template>

<script>
import PurchaseOrderBasicInfo from '../components/PurchaseOrderBasicInfo'
import PurchaseMaterialTable from '../components/PurchaseMaterialTable'
import PurchaseOrderBtnGroup from '../components/PurchaseOrderBtnGroup'
import { PersonnalSelectionV2, SupplierSelect } from '@/components'

export default {
  name: 'PurchaseOrderForm',
  props: ['formData', 'order'],
  components: {
    PurchaseOrderBasicInfo,
    PurchaseMaterialTable,
    PurchaseOrderBtnGroup,
    PersonnalSelectionV2,
    SupplierSelect
  },
  computed: {
  },
  methods: {
    appendApprover() {
      this.order.approvers.push({});
    },
    removeApprover() {
      this.order.approvers.splice(this.order.approvers.length - 1, 1);
    },
    onSuppliersSelect (data) {
      this.suppliersSelectVisible = false;
      this.order.cooperatorName = data.name;
      this.order.cooperator = {
        id: data.id
      }
    },
    onSave (flag) {
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
      let form = {
        attachAgreements: this.order.attachAgreements,
        workOrder: this.order.workOrder,
        entries: this.order.entries.map(item => {
          return {
            spec: item.spec,
            orderQuantity: item.orderQuantity,
            price: item.price,
            totalPrice: item.totalPrice,
            estimatedRecTime: item.estimatedRecTime
          }
        })
      };
      if (this.order.cooperator.id) {
        form.cooperator = this.order.cooperator;
      } else {
        form.cooperatorName = this.order.cooperatorName;
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
        this.$emit('callback');
      } else if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }
    },
    onDelete (flag) {
      this.$message('----------------onDelete-----------------')
    },
    onReturn (flag) {
      this.$message('----------------onReturn-----------------')
    },
    validateField (name) {
      this.$refs.form.validateField(name);
    },
  },
  data () {
    return {
      suppliersSelectVisible: false,
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
    }
  },  
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
</style>