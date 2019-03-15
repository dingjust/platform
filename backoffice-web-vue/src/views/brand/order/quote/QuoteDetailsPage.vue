<template>
  <div class="animated fadeIn">
    <!--<div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <quote-base-form :slot-data="slotData" :read-only="true"></quote-base-form>
    </el-card>
    <div class="pt-2"></div>-->
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>报价明细</span>
      </div>
      <quote-request-form :slot-data="slotData" :read-only="true"></quote-request-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>附件</span>
      </div>
      <quote-attachments-form :slot-data="slotData" :read-only="true"></quote-attachments-form>
    </el-card>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import QuoteBaseForm from './QuoteBaseForm';
  import QuoteRequestForm from './QuoteRequestForm';
  import QuoteAttachmentsForm from './QuoteAttachmentsForm';

  export default {
    name: 'QuoteDetailsPage',
    props: ['slotData', 'readOnly'],
    components: {QuoteBaseForm, QuoteRequestForm, QuoteAttachmentsForm},
    methods: {},
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {}
    }
  }
</script>
