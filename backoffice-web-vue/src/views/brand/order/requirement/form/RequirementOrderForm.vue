<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>需求信息</span>
      </div>
      <requirement-order-request-form ref="requestForm"
                                      :slot-data="slotData"
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

  export default {
    name: 'RequirementOrderFrom',
    components: {
      RequirementOrderRequestForm,
      RequirementOrderAttachmentsForm,
    },
    props: ['slotData', 'readOnly'],
    methods: {},
    computed: {},
    data() {
      return {}
    }
  }
</script>
