<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>需求信息</span>
      </div>
      <requirement-order-request-form :read-only="readOnly" :slot-data="slotData.requirementOrder"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>报价明细</span>
      </div>
      <quote-request-form ref="requestForm" :read-only="readOnly" :slot-data="slotData"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>附件</span>
      </div>
      <quote-attachments-form :read-only="readOnly" :slot-data="slotData"/>
    </el-card>
  </div>
</template>

<script>
  import RequirementOrderRequestForm from '@/views/order/requirement/form/RequirementOrderRequestForm';

  import QuoteRequestForm from './QuoteRequestForm';
  import QuoteAttachmentsForm from './QuoteAttachmentsForm';

  export default {
    name: 'QuoteOrderFrom',
    components: {
      RequirementOrderRequestForm,
      QuoteRequestForm,
      QuoteAttachmentsForm,
    },
    props: ['slotData', 'readOnly'],
    methods: {},
    computed: {},
    data() {
      return {}
    }
  }
</script>
