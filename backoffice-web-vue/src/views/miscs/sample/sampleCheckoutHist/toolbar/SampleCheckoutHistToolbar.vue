<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入样衣编号" v-model="keyword"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
      <el-button type="primary" icon="el-icon-plus" @click="onNew">创建样衣借还记录</el-button>
    </el-button-group>
    <el-popover placement="bottom" width="800" trigger="click">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="样衣编号">
            <el-input v-model="queryFormData.code" clearable></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="样衣名称">
            <el-input v-model="queryFormData.name" clearable></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="关联人">
            <el-input v-model="queryFormData.relatedParty" clearable></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="联系方式">
            <el-input v-model="queryFormData.contact" clearable></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="类型">
            <el-select v-model="queryFormData.type" placeholder="请选择"
                       class="w-100" clearable>
              <el-option
                v-for="item in sampleCheckoutTypes"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="状态">
            <el-select v-model="queryFormData.state" placeholder="请选择"
                       class="w-100" clearable>
              <el-option
                v-for="item in returnStates"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>

      <el-row :gutter="10">
        <el-col :span="6">
          <el-button type="primary" icon="el-icon-search" @click="onAdvancedSearch">查询</el-button>
        </el-col>
      </el-row>
      <el-button-group slot="reference">
        <el-button type="primary">高级查询</el-button>
      </el-button-group>
    </el-popover>
  </el-form>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapMutations} = createNamespacedHelpers('SampleCheckoutHistModule');

  export default {
    name: 'SampleCheckoutHistToolbar',
    props: [],
    mixins: [],
    components: {},
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setQueryFormData:'queryFormData',
      }),
      onSearch() {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch() {
        this.setQueryFormData(this.queryFormData);
        console.log(this.queryFormData);
        this.$emit('onAdvancedSearch', 0);
      },
      onNew() {
        let formData = {};
        Object.assign(formData, this.formData);

        this.$emit('onNew', formData);
      }
    },
    data() {
      return {
        keyword: '',
        formData: this.$store.state.SampleCheckoutHistModule.formData,
        queryFormData: this.$store.state.SampleCheckoutHistModule.queryFormData,
        sampleCheckoutTypes: this.$store.state.EnumsModule.sampleCheckoutTypes,
        returnStates: this.$store.state.EnumsModule.returnStates,
      }
    }
  }
</script>
