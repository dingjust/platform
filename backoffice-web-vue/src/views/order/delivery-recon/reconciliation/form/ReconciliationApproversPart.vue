<template>
  <div>
    <div class="form-block-content">
      <div>
        <el-form-item label="" label-width="10px">
          <el-checkbox v-model="formData.isApproval" :disabled="isDisabled">需审核</el-checkbox>
        </el-form-item>
      </div>
      <div style="display: flex;flex-wrap: wrap;">
        <template v-for="(item,itemIndex) in formData.approvers">
          <el-form-item :key="'a'+itemIndex" :label="'审批人'+(itemIndex+1)" label-width="72px" style="margin-right:10px;"
            :prop="'approvers.' + itemIndex" :rules="{required: formData.isApproval, message: '不能为空', trigger: 'change'}">
            <personnal-selection-v2 :vPerson.sync="formData.approvers[itemIndex]" 
                                    :excludeMySelf="true" style="width: 194px" :selectedRow="formData.approvers"/>
          </el-form-item>
        </template>
        <el-button-group style="padding-bottom: 26px;">
          <el-button v-if="formData.approvers && formData.approvers.length < 5" style="height: 32px" @click="appendApprover">+ 添加审批人</el-button>
          <el-button v-if="formData.approvers && formData.approvers.length > 1" style="height: 32px" @click="removeApprover">删除</el-button>
        </el-button-group>
      </div>
    </div>
    <div>
      <h6 style="color: #F56C6C">* 审批人将按照你选择的顺序逐级审批</h6>
    </div>
  </div>
</template>

<script>
import { PersonnalSelectionV2 } from '@/components'
import { checkAuditFree } from '@/auth/auth'

export default {
  name: 'ReconciliationApproversPart',
  props: ['formData'],
  components: {
    PersonnalSelectionV2
  },
  computed: {
    isDisabled: function () {
      return !checkAuditFree('FAST_RECONCILIATION_SHEET_NO_AUDIT');
    }
  },
  methods: {
    appendApprover () {
      this.formData.approvers.push({});
    },
    removeApprover () {
      this.formData.approvers.splice(this.formData.approvers.length - 1, 1);
    },
  },
  mounted () {
    if (checkAuditFree('FAST_RECONCILIATION_SHEET_NO_AUDIT')) {
      this.formData.isApproval = false;
    } else {
      this.formData.isApproval = true;
    }
  }
}
</script>

<style scoped>
  .form-block-content {
    margin-top: 20px;
    display: flex;
  }
</style>