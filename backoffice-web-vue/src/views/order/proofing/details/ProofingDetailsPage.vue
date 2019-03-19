<template>
  <div class="animated fadeIn">
    <proofing-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <div class="pt-2"></div>
    <proofing-form :slot-data="slotData" :read-only="!isNewlyCreated"/>
    <div class="pt-2"></div>
    <proofing-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
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
        console.log("submitted data: " + JSON.stringify(this.slotData));

        const deliveryAddress = this.slotData.deliveryAddress;
        // 地址信息未填时，清除deliveryAddress节点
        if (!deliveryAddress.region || !deliveryAddress.region.isocode) {
          delete this.slotData.deliveryAddress;
        }

        const url = this.apis().createProofing();
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
