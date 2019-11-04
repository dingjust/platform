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
          placeholder="分类"
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
        placeholder="结束日期">
        </el-date-picker>
        <!--<el-date-picker-->
          <!--v-model="dates"-->
          <!--type="daterange"-->
          <!--style="width: 301px"-->
          <!--align="right"-->
          <!--unlink-panels-->
          <!--range-separator="至"-->
          <!--start-placeholder="开始日期"-->
          <!--end-placeholder="结束日期"-->
          <!--@change="onPick"-->
          <!--:picker-options="pickerOptions">-->
        <!--</el-date-picker>-->
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

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('RequirementOrdersModule');

  export default {
    name: 'RequirementOrderToolbar',
    components: {},
    computed: {
      ...mapGetters({
        queryFormData: 'queryFormData',
        categories: 'categories'
      })
    },
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
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
      onNew() {
        let formData = Object.assign({}, this.formData);

        this.$emit('onNew', formData);
      },
      onSimpleNew() {
        let formData = Object.assign({}, this.formData);

        this.$emit('onSimpleNew', formData);
      },
      onReset() {
        this.clearQueryFormData();
      },
      onPick(){
        console.log(this.dates);

        this.queryFormData.createdDateFrom = this.dates[0];
      }
    },
    data() {
      return {
        keyword: this.$store.state.RequirementOrdersModule.keyword,
        formData: this.$store.state.RequirementOrdersModule.formData,
        requirementOrderStatuses: this.$store.state.EnumsModule.requirementOrderStatuses,
        dates: []
      }
    }
  }
</script>

<style>
  .requirement-toolbar .formLabel {
    font-size: 12px;display: inline-block;
  }

  .requirement-toolbar .el-range-editor--mini .el-range-separator{
    width: 30px;
  }
</style>
