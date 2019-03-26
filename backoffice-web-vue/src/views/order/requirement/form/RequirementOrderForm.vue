<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <requirement-order-basic-form ref="basicForm"
                                    :slot-data="slotData"
                                    :read-only="readOnly">
      </requirement-order-basic-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>需求信息</span>
      </div>
      <requirement-order-request-form ref="requestForm"
                                      :slot-data="slotData.details"
                                      :read-only="readOnly">
      </requirement-order-request-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>附件</span>
      </div>
      <requirement-order-attachments-form :slot-data="slotData"
                                          :read-only="readOnly">
      </requirement-order-attachments-form>
    </el-card>
  </div>
</template>

<script>
  import RequirementOrderRequestForm from './RequirementOrderRequestForm';
  import RequirementOrderAttachmentsForm from './RequirementOrderAttachmentsForm';
  import RequirementOrderBasicForm from "./RequirementOrderBasicForm";

  export default {
    name: 'RequirementOrderFrom',
    components: {
      RequirementOrderBasicForm,
      RequirementOrderRequestForm,
      RequirementOrderAttachmentsForm,
    },
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        return this.$refs['requestForm'].validate(callback);
      }
    },
    computed: {},
    data() {
      return {}
    }
  }
</script>
