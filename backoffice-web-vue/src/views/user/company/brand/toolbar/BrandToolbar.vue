<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入名称" v-model="keyword"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
      <el-button v-if="!hideCreationButton" type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
    </el-button-group>
    <el-popover placement="bottom" width="800" trigger="click" v-model="visible">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="关键字">
            <el-input placeholder="请输入关键字" v-model="queryFormData.keyword"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="创建时间从">
            <el-date-picker
              v-model="queryFormData.creationTimeFrom"
              value-format="timestamp"
              type="date"
              placeholder="请选择工厂创建时间">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="创建时间到">
            <el-date-picker
              v-model="queryFormData.creationTimeTo"
              value-format="timestamp"
              type="date"
              placeholder="请选择工厂创建时间">
            </el-date-picker>
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

  const {mapMutations} = createNamespacedHelpers('BrandsModule');

  export default {
    name: 'BrandToolbar',
    props: ['hideCreationButton'],
    components: {},
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword',
        setQueryFormData: 'queryFormData',
      }),
      onAdvancedSearch() {
        this.setQueryFormData(this.queryFormData);
        console.log(this.queryFormData);
        this.visible = false;
        this.$emit('onAdvancedSearch', 0);
      },
      onSearch() {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
      onNew() {
        let formData = {};
        Object.assign(formData, this.formData);

        this.$emit('onNew', formData);
      },
    },
    data() {
      return {
        visible: false,
        keyword: '',
        formData: this.$store.state.BrandsModule.formData,
        queryFormData: this.$store.state.BrandsModule.queryFormData,
        categories: [],
      }
    }
  }
</script>
