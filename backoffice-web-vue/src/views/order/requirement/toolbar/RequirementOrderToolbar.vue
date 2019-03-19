<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入订单编号" v-model="keyword"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
      <el-button type="primary" icon="el-icon-plus" @click="onSimpleNew">急速发布需求</el-button>
      <el-button type="primary" icon="el-icon-plus" @click="onNew">发布需求</el-button>
    </el-button-group>
    <el-popover placement="bottom" width="800" trigger="click">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="订单编号">
            <el-input v-model="queryFormData.code"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="产品货号">
            <el-input v-model="queryFormData.skuID"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="状态">
            <el-select v-model="queryFormData.statuses" placeholder="请选择"
                       multiple class="w-100">
              <el-option
                v-for="item in statusOptions"
                :key="item.value"
                :label="item.text"
                :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="创建时间从">
            <el-date-picker
              v-model="queryFormData.createdDateFrom"
              value-format="yyyy-MM-dd"
              type="date"
              placeholder="请选择生产订单创建时间">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="创建时间到">
            <el-date-picker
              v-model="queryFormData.createdDateTo"
              value-format="yyyy-MM-dd"
              type="date"
              placeholder="请选择生产订单创建时间">
            </el-date-picker>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="交货时间从">
            <el-date-picker
              v-model="queryFormData.expectedDeliveryDateFrom"
              value-format="yyyy-MM-dd"
              type="date"
              placeholder="请选择客户交期">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="交货时间到">
            <el-date-picker
              v-model="queryFormData.expectedDeliveryDateTo"
              value-format="yyyy-MM-dd"
              type="date"
              placeholder="请选择客户交期">
            </el-date-picker>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-button type="primary" icon="el-icon-search" @click="onAdvancedSearch">查询</el-button>
        </el-col>
      </el-row>
      <el-button type="primary" slot="reference">高级查询</el-button>
    </el-popover>
  </el-form>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters} = createNamespacedHelpers('RequirementOrdersModule');

  export default {
    name: 'RequirementOrderToolbar',
    components: {},
    computed: {},
    methods: {
      onSearch() {
        this.$emit('onSearch', 0);
      },
      onAdvancedSearch() {
        this.$emit('onAdvancedSearch', 0);
      },
      onNew() {
        let formData = {};
        Object.assign(formData, this.formData);

        this.$emit('onNew', formData);
      },
      onSimpleNew() {
        let formData = {};
        Object.assign(formData, this.formData);

        this.$emit('onSimpleNew', formData);
      }
    },
    data() {
      return {
        keyword: this.$store.state.RequirementOrdersModule.keyword,
        formData: this.$store.state.RequirementOrdersModule.formData,
        queryFormData: this.$store.state.RequirementOrdersModule.queryFormData,
        statusOptions: this.$store.state.RequirementOrdersModule.statusOptions,
      }
    }
  }
</script>
