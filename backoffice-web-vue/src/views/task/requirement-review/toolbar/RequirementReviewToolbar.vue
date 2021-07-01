<template>
  <div class="requirement-toolbar">
    <el-form :inline="true" size="mini">
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">需求订单信息</h6>
        </template>
        <el-input style="width: 200px" placeholder="输入需求订单号、产品号或货号" v-model="queryFormData.keyword"></el-input>
      </el-form-item>
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">品类</h6>
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
          <h6 class="formLabel">发布人</h6>
        </template>
        <el-input style="width: 116px" placeholder="输入发布人姓名" v-model="queryFormData.username"></el-input>
      </el-form-item>
      <el-form-item>
        <template slot="label">
          <h6 class="formLabel">发布日期</h6>
        </template>
        <el-date-picker
        v-model="queryFormData.createdDateFrom"
        type="date"
        style="width: 130px"
        value-format="timestamp"
        placeholder="开始日期">
        </el-date-picker>
        <el-date-picker
        v-model="queryFormData.createdDateTo"
        type="date"
        style="width: 130px"
        value-format="timestamp"
        placeholder="截止日期">
        </el-date-picker>
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
const {mapGetters} = createNamespacedHelpers('RequirementOrdersModule');

export default {
  name: 'RequirementReviewToolbar',
  props: ['queryFormData'],
  components: {},
  computed: {
    ...mapGetters({
      categories: 'categories'
    })
  },
  methods: {
    onAdvancedSearch() {
      this.$emit('onAdvancedSearch', 0);
    },
    onReset() {
      this.queryFormData.keyword = ''
      this.queryFormData.categories = []
      this.queryFormData.username = ''
      this.queryFormData.createdDateFrom = null
      this.queryFormData.createdDateTo = null
    }
  }
}
</script>

<style scoped>
  .requirement-toolbar .formLabel {
    font-size: 12px;display: inline-block;
  }

  .requirement-toolbar .el-range-editor--mini .el-range-separator{
    width: 30px;
  }

  .requirement-toolbar >>> .el-form-item {
    margin-bottom: 0px;
  }
</style>
