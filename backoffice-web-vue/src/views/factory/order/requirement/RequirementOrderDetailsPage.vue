<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>需求信息</span>
      </div>
      <requirement-order-request-form ref="requestForm"
                                      :slot-data="slotData"
                                      :read-only="true">
      </requirement-order-request-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>附件</span>
      </div>
      <requirement-order-attachments-form ref="attachmentsForm"
                                          :slot-data="slotData"
                                          :read-only="true">
      </requirement-order-attachments-form>
    </el-card>
    <div class="pt-2"></div>
    <el-row v-show="isPendingQuote" :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" type="primary" size="mini" @click="onQuoting">参与报价</el-button>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import RequirementOrderBaseForm from './RequirementOrderBaseForm';
  import RequirementOrderRequestForm from './RequirementOrderRequestForm';
  import RequirementOrderAttachmentsForm from './RequirementOrderAttachmentsForm';

  export default {
    name: 'RequirementOrderDetailsPage',
    props: ['slotData'],
    components: {
      RequirementOrderBaseForm,
      RequirementOrderRequestForm,
      RequirementOrderAttachmentsForm,
    },
    methods: {
      onQuoting() {
        console.log('TODO: 报价');
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      },
      isPendingQuote: function () {
        return this.slotData.status === 'PENDING_QUOTE';
      }
    },
    data() {
      return {}
    }
  }
</script>
