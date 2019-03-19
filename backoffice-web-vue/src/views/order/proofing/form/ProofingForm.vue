<template>
  <div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <proofing-basic-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>待打样产品</span>
      </div>
      <proofing-entries-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card" v-if="!hideOnNew">
      <div slot="header" class="clearfix">
        <span>送货地址</span>
      </div>
      <proofing-delivery-address-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
  </div>
</template>

<script>
  import ProofingBasicForm from "./ProofingBasicForm";
  import ProofingBelongToForm from "./ProofingBelongToForm";
  import ProofingDeliveryAddressForm from "./ProofingDeliveryAddressForm";
  import ProofingEntriesForm from "./ProofingEntriesForm";

  export default {
    name: 'ProofingForm',
    props: ['slotData', 'readOnly'],
    components: {
      ProofingBasicForm,
      ProofingBelongToForm,
      ProofingDeliveryAddressForm,
      ProofingEntriesForm,
    },
    computed: {
      // 创建时，工厂不维护地址；由品牌维护
      hideOnNew: function () {
        return !this.readOnly && this.isFactory();
      }
    },
    methods: {},
    data() {
      return {}
    },
    created() {
    }
  }
</script>
