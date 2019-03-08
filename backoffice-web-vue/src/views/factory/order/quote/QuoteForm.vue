<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>需求信息</span>
      </div>
      <requirement-order-request-form :read-only="true" :slot-data="slotData.requirementOrder"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>报价明细</span>
      </div>
      <quote-request-form ref="requestForm" :read-only="false" :slot-data="slotData"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>附件</span>
      </div>
      <quote-attachments-form :read-only="false" :slot-data="slotData"/>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" size="mini" type="primary" @click="onSubmit()">提交</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('FactoryQuotesModule');

  import RequirementOrderRequestForm from '@/views/factory/order/requirement/RequirementOrderRequestForm';
  import QuoteRequestForm from './QuoteRequestForm';
  import QuoteAttachmentsForm from './QuoteAttachmentsForm';

  export default {
    name: 'QuoteOrderFrom',
    components: {
      QuoteRequestForm,
      QuoteAttachmentsForm,
      RequirementOrderRequestForm
    },
    props: ['slotData'],
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onSubmit() {
        this.$refs['requestForm'].validate((valid) => {
            if (!valid) {
              return false;
            }

            this._onSubmit();

            return true;
          }
        );
      },
      onCancel() {
        this.fn.closeSlider();
      },
      async _onSubmit() {
        let formData = this.slotData;
        delete formData.requirementOrder;
        // console.log(JSON.stringify(formData))
        const result = await this.$http.post('/b2b/orders/quote/create', formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('发布需求成功，订单编号： ' + result);
        this.$set(this.slotData, 'code', result);
        this.refresh();
        this.fn.closeSlider(true);
      }
    },
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
