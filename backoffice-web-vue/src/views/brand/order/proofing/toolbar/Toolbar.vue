<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入需求订单编号" v-model="requirementOrderRef"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
    </el-button-group>
  </el-form>
</template>

<script>
  import ProofingAdvancedSearchForm from '../form/ProofingAdvancedSearchForm';

  export default {
    name: 'PurchaseOrderToolbar',
    props: [],
    mixins: [],
    components: {
      ProofingAdvancedSearchForm
    },
    computed: {},
    methods: {
      onSearch() {
        this.$emit('onSearch',this.requirementOrderRef);
      },
    },
    data() {
      return {
        requirementOrderRef: this.$store.state.BrandProofingsModule.requirementOrderRef,
        formData: this.$store.state.BrandProofingsModule.formData,
      }
    }
  }
</script>
