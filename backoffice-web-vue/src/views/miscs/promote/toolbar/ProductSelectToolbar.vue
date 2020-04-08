<template>
  <div class="animated fadeIn">
    <el-form :inline="true">
      <el-form-item label="产品名">
        <el-input placeholder="输入产品名" v-model="queryFormData.name" size="mini"></el-input>
      </el-form-item>
      <el-form-item label="款号">
        <el-input placeholder="输入款号" v-model="queryFormData.skuID" size="mini"></el-input>
      </el-form-item>
      <el-form-item label="编号">
        <el-input placeholder="输入编号" v-model="queryFormData.code"></el-input>
      </el-form-item>
      <el-form-item v-if="isTenant()" label="所属公司">
        <el-input placeholder="输入公司名称" v-model="queryFormData.belongToName"></el-input>
      </el-form-item>
      <el-form-item label="品类">
        <el-select v-model="queryFormData.categories" placeholder="请选择" class="w-80"
                   filterable reserve-keyword clearable collapse-tags size="mini"
                   multiple>
          <el-option-group
            v-for="level1 in categories"
            :key="level1.code"
            :label="level1.name">
            <el-option
              v-for="level2 in level1.children"
              :key="level2.code"
              :label="level2.name"
              :value="level2.code">
            </el-option>
          </el-option-group>
        </el-select>
      </el-form-item>
      <el-button type="primary" class="toolbar-search_input" @click="onAdvancedSearch" size="mini">搜索</el-button>
      <el-button native-type="reset" @click="onReset" size="mini">重置</el-button>
    </el-form>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapMutations} = createNamespacedHelpers('ApparelProductsModule');

  export default {
    name: 'ProductSelectToolbar',
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setQueryFormData: 'queryFormData'
      }),
      async getCategories () {
        const url = this.apis().getMinorCategories();
        const results = await this.$http.get(url);
        if (!results['errors']) {
          this.categories = results;
        }
      },
      onAdvancedSearch () {
        this.queryFormData.approvalStatuses = 'approved';
        this.setQueryFormData(this.queryFormData);
        this.$emit('onAdvancedSearch', 0);
      },
      onReset () {
        this.queryFormData.name = '';
        this.queryFormData.skuID = '';
        this.queryFormData.categories = '';
        this.queryFormData.approvalStatuses = '';
        this.queryFormData.belongToName = '';
      }
    },
    data() {
      return {
        queryFormData: this.$store.state.ApparelProductsModule.queryFormData,
        categories: []
      }
    },
    created() {
      this.getCategories();
    }
  }
</script>

<style scoped>
  .toolbar-search_input {
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
</style>
