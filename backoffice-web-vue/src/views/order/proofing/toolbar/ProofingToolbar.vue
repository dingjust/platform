<template>
  <div class="proofing-toolbar">
    <el-form :inline="true" size="mini">
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">订单信息</h6>
        </template>
        <el-input style="width: 200px" placeholder="输入订单号、产品号或货号" v-model="queryFormData.keyword"></el-input>
      </el-form-item>
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">跟单员</h6>
        </template>
        <el-input v-if="isBrand()" style="width: 200px" placeholder="输入跟单员姓名" v-model="queryFormData.brandOperatorName"></el-input>
        <el-input v-if="isFactory()" style="width: 200px" placeholder="输入跟单员姓名" v-model="queryFormData.factoryOperatorName"></el-input>
      </el-form-item>
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">分类</h6>
        </template>
        <el-cascader
          style="width: 115px"
          v-model="queryFormData.categories"
          placeholder="点击选择"
          clearable
          :options="categories"
          :props="{ expandTrigger: 'hover' ,value:'code',label:'name'}"
          :show-all-levels="false">

        </el-cascader>
      </el-form-item>
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">合作商</h6>
        </template>
        <el-input v-if="isFactory()" style="width: 200px" placeholder="输入合作商名称" v-model="queryFormData.brandReferenceName"></el-input>
        <el-input v-if="isBrand()" style="width: 200px" placeholder="输入合作商名称" v-model="queryFormData.factoryReferenceName"></el-input>
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

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('ProofingsModule');

  export default {
    name: 'PurchaseOrderToolbar',
    props: [],
    mixins: [],
    components: {},
    computed: {
      ...mapGetters({
        queryFormData: 'queryFormData',
        categories: 'categories'
      })
    },
    methods: {
      ...mapMutations({
        setQueryFormData: 'queryFormData',
      }),
      ...mapActions({
        clearQueryFormData: 'clearQueryFormData'
      }),
      onSearch() {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch() {
        this.setQueryFormData(this.queryFormData);
        this.$emit('onAdvancedSearch', 0);
      },
      onReset() {
        this.$emit('clearQueryFormData');
      },
    },
    data() {
      return {
      }
    }
  }
</script>

<style>
  .proofing-toolbar .formLabel {
    font-size: 12px;display: inline-block;
  }
</style>
