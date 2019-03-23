<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <address-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
  </div>
</template>

<script>
  import {AddressForm} from "@/views/shared/";

  export default {
    name: 'AddressFrom',
    components: {
      AddressForm,
    },
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        // TODO: validation
        return true;
        // return this.$refs['basicForm'].validate(callback);
      }
    },
    computed: {},
    data() {
      return {}
    }
  }
</script>
