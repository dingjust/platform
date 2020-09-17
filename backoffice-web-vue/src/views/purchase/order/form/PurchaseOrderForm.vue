<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row type="flex" justify="space-between"> 
        <el-col :span="6">
          <div class="purchase-list-title">
            <h6>创建采购工单</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>状态/标签：{{'待采购'}}</h6>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <div class="basic-row">
        <purchase-order-basic-info :formData="formData"/>
        <el-divider></el-divider>
        <el-form :model="formData" :inline="true">
          <el-row type="flex" justify="start">
            <el-col>
              <el-form-item label="供应商">
                <el-input v-model="formData.operator" :disabled="true"></el-input>
              </el-form-item>
              <el-button class="select-btn" @click="suppliersSelectVisible=true">选择</el-button>
            </el-col>
          </el-row>
          <purchase-material-table :formData="formData"/>
          <div style="display: flex;flex-wrap: wrap;padding-left: 20px">
            <el-form-item label="" label-width="10px">
              <el-checkbox v-model="formData.auditNeeded">需审核</el-checkbox>
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
            <el-button-group style="padding-bottom: 26px;">
              <el-button v-if="formData.approvers && formData.approvers.length < 5" style="height: 32px"
                @click="appendApprover">+ 添加审批人</el-button>
              <el-button v-if="formData.approvers && formData.approvers.length > 1" style="height: 32px"
                @click="removeApprover">删除</el-button>
            </el-button-group>
          </div>
        </el-form>
      </div>
      <purchase-order-btn-group @onSave="onSave" @onDelete="onDelete" @onReturn="onReturn"/>
    </el-card>
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <supplier-select @onSelect="onSuppliersSelect" />
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
  components: {
    PurchaseOrderBasicInfo,
    PurchaseMaterialTable,
    PurchaseOrderBtnGroup,
    PersonnalSelectionV2,
    SupplierSelect
  },
  methods: {
    appendApprover() {
      this.formData.approvers.push({});
    },
    removeApprover() {
      this.formData.approvers.splice(this.formData.approvers.length - 1, 1);
    },
    onSuppliersSelect () {

    },
    onSave (flag) {
      this.$message('----------------onSave-----------------')
    },
    onDelete (flag) {
      this.$message('----------------onDelete-----------------')
    },
    onReturn (flag) {
      this.$message('----------------onReturn-----------------')
    },
  },
  data () {
    return {
      suppliersSelectVisible: false,
      formData: {
        contract: [],
        auditNeeded: true,
        approvers: [null],
        operator: '',
        entries: [{
            name: '物料名称1',
            color: '白色',
            spec: '40cm',
            guige: '50kg',
            unitQuantity: 12,
            lossQuantity: 0.12,
            totalQuantity: 13.44,
            orderCount: 2000,
            spaceDiff: 100,
            needQuantity: 2000,
            materialPrice: '',
            totalPrice: '',
            emptionQuantity: '',
            time: ''
        }]
      }
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
</style>