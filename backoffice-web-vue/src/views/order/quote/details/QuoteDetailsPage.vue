<template>
  <div class="animated fadeIn">
    <quote-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <div class="pt-2"></div>
    <quote-form :slot-data="slotData" :read-only="!isNewlyCreated"/>
    <div class="pt-2"></div>
    <quote-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('QuotesModule');

  import QuoteFormToolbar from "../toolbar/QuoteFormToolbar";
  import QuoteForm from '../form/QuoteForm';

  export default {
    name: 'QuoteDetailsPage',
    props: ['slotData', 'readOnly'],
    components: {QuoteFormToolbar, QuoteForm},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      async onSubmit() {

        if (this.compareDate(new Date(), new Date(this.slotData.expectedDeliveryDate))) {
          this.$message.error('确认交货时间不能小于当前时间');

          return false;
        }
        const url = this.apis().createQuote();
        const result = await this.$http.post(url, this.slotData);
        if (result['errors']) {
          this.$message.error('获取数据失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('报价单创建成功，订单号：' + result);

        this.refresh();

        this.fn.closeSlider();
      },
      onCancel() {
        this.fn.closeSlider();
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
