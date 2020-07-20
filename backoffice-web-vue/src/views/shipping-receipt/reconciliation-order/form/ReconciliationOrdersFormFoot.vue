<template>
  <div class="form-foot">
    <el-form :model="formData" ref="footForm">
      <template v-for="(item, index) in formData.deductions">
        <el-row type="flex" align="middle" :key="'ar'+index" style="margin-top:5px">
          <el-col :span="1" v-if="index == 0 && !readOnly">
            <el-button icon="el-icon-plus" class="circle-btn" circle @click="addReduceRow">
            </el-button>
          </el-col>
          <el-col :span="1" v-if="index != 0 && !readOnly">
            <el-button icon="el-icon-minus" class="circle-btn" circle @click="removeDeductionsRow(index)">
            </el-button>
          </el-col>
          <el-col :span="8">
            <el-form-item label="扣款金额" :prop="'deductions.'+index+'.amount'"
              :rules="{ required: true, message: '请输入金额', trigger: 'blur' }">
              <el-input v-model="item.amount" :disabled="readOnly" v-number-input.float="{ min: 0 ,decimal:2}">
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="14">
            <el-form-item label="扣款原因">
              <el-input v-model="item.remarks" :disabled="readOnly"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </template>
      <div class="pt-4"></div>
      <template v-for="(item, index) in formData.increases">
        <el-row type="flex" align="middle" :key="'ad'+index">
          <el-col :span="1" v-if="index == 0 && !readOnly">
            <el-button icon="el-icon-plus" class="circle-btn" circle @click="addIncreaseRow"></el-button>
          </el-col>
          <el-col :span="1" v-if="index != 0 && !readOnly">
            <el-button icon="el-icon-minus" class="circle-btn" circle @click="removeIncreaseRow(index)">
            </el-button>
          </el-col>
          <el-col :span="8">
            <el-form-item label="增款金额" :prop="'increases.'+index+'.amount'"
              :rules="{ required: true, message: '请输入金额', trigger: 'blur' }">
              <el-input v-model="item.amount" :disabled="readOnly" v-number-input.float="{ min: 0 ,decimal:2}">
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="14">
            <el-form-item label="增款原因">
              <el-input v-model="item.remarks" :disabled="readOnly"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </template>
      <!-- 创建方 -->
      <template v-if="isShipPart||isForm">
        <el-row type="flex" v-if="!readOnly" style="margin-top:20px">
          <el-col :span="2">
            <el-form-item label="" label-width="5px">
              <el-checkbox v-model="formData.isApproval" @change="onIsApprovalChange">需审核</el-checkbox>
            </el-form-item>
          </el-col>
          <el-col :span="20" v-if="formData.isApproval">
            <template v-for="(item,itemIndex) in formData.approvers">
              <el-form-item :key="'a'+itemIndex" :label="'审批人'" label-width="100px" :prop="'approvers.' + itemIndex"
                :rules="{required: true, message: '不能为空', trigger: 'change'}">
                <personnel-selection :vPerson.sync="formData.approvers[itemIndex]" />
              </el-form-item>
            </template>
          </el-col>
        </el-row>
        <el-row type="flex" v-else>
          <el-col :span="2"><span>审核人:</span></el-col>
          <el-col :span="20" v-if="formData.auditWorkOrder&&formData.approvers">
            <template v-for="(item,itemIndex) in formData.approvers">
              <span :key="'a'+itemIndex">{{item.name}}</span>
            </template>
          </el-col>
        </el-row>
      </template>
      <!-- 收货方 -->
      <template v-if="isReceiptPart">
        <template v-if="showReceApproverSelect">
          <!-- TODO: 限制跟单员-->
          <el-row type="flex" style="margin-top:20px">
            <el-col :span="2">
              <el-form-item label="" label-width="5px">
                <el-checkbox v-model="formData.isOriginApproval" @change="onIsOriginApprovalChange">需审核</el-checkbox>
              </el-form-item>
            </el-col>
            <el-col :span="20" v-if="formData.isOriginApproval">
              <template v-for="(item,itemIndex) in formData.originApprovers">
                <el-form-item :key="'a'+itemIndex" :label="'审批人'" label-width="100px"
                  :prop="'originApprovers.' + itemIndex" :rules="{required: true, message: '不能为空', trigger: 'change'}">
                  <personnel-selection :vPerson.sync="formData.originApprovers[itemIndex]" />
                </el-form-item>
              </template>
            </el-col>
          </el-row>
        </template>
        <template v-else>
          <el-row type="flex">
            <el-col :span="2"><span>审核人:</span></el-col>
            <el-col :span="20" v-if="formData.isOriginApproval">
              <template v-for="(item,itemIndex) in formData.originApprovers">
                <span :key="'a'+itemIndex">{{item.name}}</span>
              </template>
            </el-col>
          </el-row>
        </template>
      </template>
    </el-form>
  </div>
</template>

<script>
  import {
    PersonnelSelection
  } from '@/components/'

  export default {
    name: 'ReconciliationOrdersFormFoot',
    props: {
      formData: {
        type: Object,
        required: true
      },
      readOnly: {
        type: Boolean,
        default: false
      },
      isForm:{
        type:Boolean,
        default:true
      }
    },
    components: {
      PersonnelSelection
    },
    computed: {
      //发货方
      isShipPart: function () {
        if (this.formData.shipParty) {
          return this.currentUser.companyCode == this.formData.shipParty.uid;
        } else {
          return false;
        }
      },
      //收货方
      isReceiptPart: function () {
        if (this.formData.receiveParty) {
          return this.currentUser.companyCode == this.formData.receiveParty.uid;
        } else {
          return false;
        }
      },
      //收货方跟单员
      isReceiptCreator: function () {
        return true;
      },
      //收货方显示审核人员选择项
      showReceApproverSelect: function () {
        if (this.formData.state == 'PENDING_CONFIRM' && this.isReceiptCreator) {
          return this.formData.originAuditWorkOrder == null || this.formData.originAuditWorkOrder.state ==
            'AUDITED_FAILED';
        }
        return false;
      }
    },
    methods: {
      addReduceRow() {
        this.formData.deductions.push({
          amount: null,
          remarks: null
        })
      },
      addIncreaseRow() {
        this.formData.increases.push({
          amount: null,
          remarks: null
        })
      },
      removeDeductionsRow(index) {
        this.formData.deductions.splice(index, 1);
      },
      removeIncreaseRow(index) {
        this.formData.increases.splice(index, 1);
      },
      onIsApprovalChange(val) {
        if (val) {
          if (this.formData.approvers == null || this.formData.approvers.length == 0) {
            this.$set(this.formData, 'approvers', [null]);
          }
        }
      },
      onIsOriginApprovalChange(val) {
        if (val) {
          if (this.formData.originApprovers == null || this.formData.originApprovers.length == 0) {
            this.$set(this.formData, 'originApprovers', [null]);
          }
        }
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
      }
    },
    created() {

    }
  }

</script>

<style scoped>
  .form-foot>>>.el-form-item {
    margin-bottom: 0px;
  }

  .circle-btn {
    outline: none;
    background-color: #333;
    color: white;
    margin-bottom: 0.5rem;
    transform: scale(0.8, 0.8);
  }

</style>
