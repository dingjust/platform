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
        <el-form :model="formData" :inline="true" :hide-required-asterisk="true" label-width="80px" label-position="left">
          <el-row type="flex" justify="start" >
            <el-col :span="7">
              <el-form-item label="系统单号">
                <el-input placeholder="系统生成" :disabled="true"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="10">
              <el-form-item label="关联订单" prop="code" :rules="[{ required: true, message: '请选择关联订单', trigger: 'blur' }]">
                <el-input v-model="formData.code" :disabled="true"></el-input>
              </el-form-item>
              <el-button class="purchase-btn" @click="onSelect">选择</el-button>
            </el-col>
            <el-col :span="7">
              <el-form-item label="关联款号">
                <el-input v-model="formData.skuId" :disabled="true"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" >
            <h6 class="purchase-label">采购需求</h6>
          </el-row>
          <el-row type="flex" justify="start" >
            <div>
              <el-form-item label="是否含税">
                <el-radio :label="true" v-model="formData.invoice">含税</el-radio>
                <el-radio :label="false" v-model="formData.invoice">不含税</el-radio>
              </el-form-item>
            </div>
            <div v-if="formData.invoice" style="margin-left: 20px">
              <el-form-item label="税点" label-width="40px">
                <el-select v-model="formData.invoicePercent" placeholder="请选择" style="width: 100px;">
                  <el-option v-for="item in invoicePercent" :key="item.value" :label="item.label" :value="item.value" />
                </el-select>
              </el-form-item>
            </div>
            <div style="margin-left: 20px">
              <el-form-item label="品质要求" prop="qualityRequirement" :rules="[{ required: true, message: '请选择品质要求', trigger: 'change' }]">
                <el-select v-model="formData.qualityRequirement" placeholder="请选择">
                  <el-option v-for="item in QualityRequirementStatus" :key="item.code" :label="item.name" :value="item.code" />
                </el-select>
              </el-form-item>
            </div>
          </el-row>
          <div style="display: flex;flex-wrap: wrap;">
            <el-form-item label="采购人" prop="merchandiser" >
              <personnal-selection-v2 :vPerson.sync="formData.purchaser" />
            </el-form-item>
            <el-form-item label="" label-width="10px" >
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
      <el-row type="flex" justify="center" align="middle" style="margin-top: 25px;">
        <div>
          <el-button class="sumbit-btn" style="margin-right: 80px;" @click="onSumbit(false)">保存</el-button>
          <el-button class="sumbit-btn" @click="onSumbit(true)">创建并提交</el-button>
        </div>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import { PersonnalSelectionV2, MyAddressForm } from '@/components'
import PurchaseRequirementTable from '../components/PurchaseRequirementTable'
export default {
  name: 'PurchaseRequirementForm',
  components: {
    PersonnalSelectionV2,
    MyAddressForm,
    PurchaseRequirementTable
  },
  methods: {
    onSelect () {
      this.$message('--------------------选择工单------------------------------');
    },
    appendApprover () {
      this.formData.approvers.push({});
    },
    removeApprover () {
      this.formData.approvers.splice(this.formData.approvers.length - 1, 1);
    },
    onSumbit (flag) {

    }
  },
  data () {
    return {
      invoicePercent: [{
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
      QualityRequirementStatus: [{
          code: '1',
          name: '一等品'
        }, {
          code: '2',
          name: '二等品'
        }, {
          code: '3',
          name: '合格品'
        }, {
          code: '4',
          name: '同样品'
      }],
      formData: {
        code: '',
        skuID: '',
        invoice: false,
        invoicePercent: {
          label: '3%税点',
          value: 0.03
        },
        qualityRequirement: '',
        purchaser: '',
        auditNeeded: true,
        approvers: [{}],
        shippingAddress: {},
        materialEntities: []
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