<template>
  <div>
    <el-form ref="form" :model="formData" :inline="true" :hide-required-asterisk="true">
      <div class="base-container">
        <el-form-item label="系统单号" class="form-item">
          <el-input placeholder="系统生成" v-model="formData.code" :disabled="true"></el-input>
        </el-form-item>
        <el-form-item label="关联信息" class="form-item">
          <el-input v-model="formData.profitLossAnalysisEntry.name" :disabled="true"></el-input>
        </el-form-item>
      </div>
      <el-row type="flex" justify="start" >
        <h6 class="purchase-label">采购要求</h6>
      </el-row>
      <div class="base-container require-container">
        <el-form-item label="是否含税" class="form-item">
          <el-radio :label="true" v-model="formData.includeTax">含税</el-radio>
          <el-radio :label="false" v-model="formData.includeTax">不含税</el-radio>
        </el-form-item>
        <el-form-item v-if="formData.includeTax" label="税点" label-width="40px" class="form-item">
          <el-select v-model="formData.taxPoint" placeholder="请选择" style="width: 100px;">
            <el-option v-for="item in TaxPointState" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="品质要求" prop="qualityRequirement" class="form-item"
            :rules="[{ required: true, message: '不能为空', trigger: 'change' }]">
          <el-select v-model="formData.qualityRequirement" placeholder="请选择">
            <el-option v-for="item in qualityRequirementType" :key="item.code" :label="item.name" :value="item.code" />
          </el-select>
        </el-form-item>
      </div>
      <div class="base-container require-container">
        <el-form-item label="采购人" prop="merchandiser" :rules="[{ required: true, message: '不能为空', trigger: 'change' }]">
          <personnal-selection-v2 :vPerson.sync="formData.merchandiser" />
        </el-form-item>
        <el-form-item label="" label-width="10px" >
          <el-checkbox v-model="formData.auditNeeded" @change="handleClick">需审核</el-checkbox>
        </el-form-item>
        <template v-for="(item,itemIndex) in formData.approvers">
          <el-form-item :key="'a'+itemIndex" :label="'审批人'+(itemIndex+1)"
            style="margin-right:10px;" :prop="'approvers.' + itemIndex"
            :rules="{required: formData.auditNeeded, message: '不能为空', trigger: 'change'}">
            <personnal-selection-v2 :vPerson.sync="formData.approvers[itemIndex]"
              :disabled="!formData.auditNeeded" :excludeMySelf="true" style="width: 194px"
              :selectedRow="formData.approvers" />
          </el-form-item>
        </template>
        <el-button-group>
          <el-button v-if="formData.approvers && formData.approvers.length < 5" style="height: 32px"
            @click="appendApprover">+ 添加审批人</el-button>
          <el-button v-if="formData.approvers && formData.approvers.length > 1" style="height: 32px"
            @click="removeApprover">删除</el-button>
        </el-button-group>
      </div>
      <h6 class="tip-title">* 审批人将按照你选择的顺序逐级审批</h6>
    </el-form>
  </div>
</template>

<script>
import { PersonnalSelectionV2 } from '@/components'

export default {
  name: 'PurchaseRequirementBaseInfo',
  props: ['formData'],
  components: {
    PersonnalSelectionV2
  },
  data () {
    return {
      qualityRequirementType: this.$store.state.EnumsModule.QualityRequirementType,
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
    }
  },
  methods: {
    handleClick (value) {
      if (!value) {
        this.formData.approvers.forEach((val, index) => {
          this.$refs.form.clearValidate('approvers.' + index);
        })
      }
    },
    appendApprover () {
      this.formData.approvers.push({});
    },
    removeApprover () {
      this.formData.approvers.splice(this.formData.approvers.length - 1, 1);
    },
    validateField (name) {
      this.$refs.form.validateField(name);
    }
  },
  watch: {
    'formData.merchandiser': function (nval, oval) {
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
  }
}
</script>

<style scoped>
  .purchase-label {
    font-size: 14px;
    color: #606266;
  }

  .base-container {
    display: flex;
    flex-wrap: wrap;
  }

  .require-container {
    margin-left: 28px;
  }

  .form-item {
    margin-right: 20px;
  }

  .tip-title {
    color: #F56C6C;
    margin-left: 28px;
  }
</style>