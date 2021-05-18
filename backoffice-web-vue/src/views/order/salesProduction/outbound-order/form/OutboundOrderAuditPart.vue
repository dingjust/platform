<template>
  <div class="out-audit-part">
    <el-row>
      <h6>人员设置</h6>
    </el-row>
    <div class="approver-container">
      <el-form-item label="跟单员" prop="merchandiser">
        <personnel-selection :vPerson.sync="formData.merchandiser" :readOnly="true" />
      </el-form-item>
      <el-form-item label="" label-width="10px">
        <el-checkbox v-model="formData.sendAuditNeeded" :disabled="isDisabled">需审核</el-checkbox>
      </el-form-item>
      <template v-for="(item,itemIndex) in formData.sendApprovers">
        <el-form-item :key="'a'+itemIndex" :label="'审批人'+(itemIndex+1)" label-width="80px"
          style="margin-right:10px;" :prop="'sendApprovers.' + itemIndex"
          :rules="{required: formData.sendAuditNeeded, message: '不能为空', trigger: 'change'}">
          <personnal-selection-v2 :vPerson.sync="formData.sendApprovers[itemIndex]"
            :disabled="!formData.sendAuditNeeded" :excludeMySelf="true" style="width: 194px"
            :selectedRow="formData.sendApprovers" />
        </el-form-item>
      </template>
      <el-button-group style="padding-bottom: 26px;">
        <el-button v-if="formData.sendApprovers && formData.sendApprovers.length < 5" style="height: 32px"
          @click="appendApprover">+ 添加审批人</el-button>
        <el-button v-if="formData.sendApprovers && formData.sendApprovers.length > 1" style="height: 32px"
          @click="removeApprover">删除</el-button>
      </el-button-group>
    </div>
    <div style="padding-left: 20px">
      <h6 style="color: #F56C6C">* 审批人将按照你选择的顺序逐级审批</h6>
    </div>
  </div>
</template>

<script>
import {
  PersonnalSelectionV2,
  PersonnelSelection
} from '@/components'

export default {
  name: 'OutboundOrderAuditPart',
  props: ['formData', 'isDisabled'],
  components: {
    PersonnalSelectionV2,
    PersonnelSelection
  },
  methods: {
    appendApprover() {
      this.formData.sendApprovers.push(null);
    },
    removeApprover() {
      this.formData.sendApprovers.splice(this.formData.sendApprovers.length - 1, 1);
    }
  }
}
</script>

<style scoped>
.out-audit-part {
  padding-left: 10px;
}

.approver-container {
  display: flex;
  flex-wrap: wrap;
  padding-left: 10px
}
</style>