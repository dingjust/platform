<template>
  <div class="animated fadeIn">
    <proofing-form-toolbar :slot-data="slotData" :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <div class="pt-2"></div>
    <proofing-form :slot-data="slotData" :read-only="!isNewlyCreated"/>
    <div class="pt-2"></div>
    <proofing-form-toolbar :slot-data="slotData" :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('ProofingsModule');

  import ProofingFormToolbar from "../toolbar/ProofingFormToolbar";
  import ProofingForm from '../form/ProofingForm';

  export default {
    name: 'ProofingDetailsPage',
    props: ['slotData'],
    components: {ProofingFormToolbar, ProofingForm},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      async onSubmit() {
        const quoteRef = this.slotData.quoteRef;
        const url = this.apis().createProofing(quoteRef);
        const result = await this.$http.post(url, this.slotData);
        if (result['errors']) {
          this.$message.error('获取数据失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('打样订单创建成功，订单号：' + result);

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
