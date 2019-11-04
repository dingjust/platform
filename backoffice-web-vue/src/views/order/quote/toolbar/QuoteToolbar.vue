<template>
  <div class="quote-toolbar">
    <el-form :inline="true" size="mini">
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">报价单号</h6>
        </template>
        <el-input style="width: 200px" placeholder="输入报价单号" v-model="queryFormData.code"></el-input>
      </el-form-item>
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">需求订单号</h6>
        </template>
        <el-input style="width: 200px" placeholder="输入需求订单号" v-model="queryFormData.requirementOrderRef"></el-input>
      </el-form-item>
      <el-form-item v-if="isFactory()">
        <template slot="label">
          <h6 class="formLabel">品牌</h6>
        </template>
        <el-input style="width: 200px" placeholder="输入品牌名称" v-model="queryFormData.brandName"></el-input>
      </el-form-item>
      <el-form-item v-if="isBrand()">
        <template slot="label">
          <h6 class="formLabel">工厂</h6>
        </template>
        <el-input style="width: 200px" placeholder="输入工厂名称" v-model="queryFormData.factoryName"></el-input>
      </el-form-item>
      <el-button-group>
        <el-button style="background-color: #FFD60C" @click="onAdvancedSearch">搜索</el-button>
        <el-button @click="onReset">重置</el-button>
      </el-button-group>
    </el-form>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapMutations} = createNamespacedHelpers('QuotesModule');
  export default {
    name: 'QuoteToolbar',
    components: {},
    computed: {
      ...mapGetters({
        queryFormData: 'queryFormData',
      })
    },
    methods: {
      ...mapMutations({
        setQueryFormData: 'queryFormData',
      }),
      onSearch() {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch() {
        this.setQueryFormData(this.queryFormData);
        this.$emit('onAdvancedSearch', 0);
      },
      onNew() {
        let formData = {};
        Object.assign(formData, this.formData);

        this.$emit('onNew', formData);
      },
      onReset() {
        this.$emit('clearQueryFormData');
      },
    },
    data() {
      return {
        keyword: '',
        formData: this.$store.state.QuotesModule.formData,
      }
    }
  }
</script>

<style>
  .quote-toolbar .formLabel {
    font-size: 12px;display: inline-block;
  }
</style>
