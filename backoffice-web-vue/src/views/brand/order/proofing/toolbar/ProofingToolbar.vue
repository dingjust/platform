<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入订单编号" v-model="keyword"></el-input>
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
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch() {
        this.$emit('onAdvancedSearch', 0);
      },
    },
    data() {
      return {
        keyword: this.$store.state.BrandProofingsModule.keyword,
        formData: this.$store.state.BrandProofingsModule.formData,
      }
    }
  }
</script>
