<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入名称" v-model="keyword"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
      <el-button type="primary" icon="el-icon-plus" @click="onNew">提现</el-button>
    </el-button-group>
    <el-popover placement="bottom" width="800" trigger="click">
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="流水来源">
            <el-select v-model="queryFormData.flowSources" placeholder="请选择"
                       multiple class="w-100">
              <el-option
                v-for="item in flowSources"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="资金流水类型">
            <el-select v-model="queryFormData.amountFlowTypes" placeholder="请选择"
                       multiple class="w-100">
              <el-option
                v-for="item in amountFlowTypes"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="资金状态">
            <el-select v-model="queryFormData.amountStatuses" placeholder="请选择"
                       multiple class="w-100">
              <el-option
                v-for="item in amountStatuses"
                :key="item.code"
                :label="item.name"
                :value="item.code">
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
              value-format="timestamp"
              type="date"
              placeholder="请选择生产订单创建时间">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="创建时间到">
            <el-date-picker
              v-model="queryFormData.createdDateTo"
              value-format="timestamp"
              type="date"
              placeholder="请选择生产订单创建时间">
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
  </el-form>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapMutations} = createNamespacedHelpers('WalletModule');

  export default {
    name: 'WalletModuleToolbar',
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
      onNew() {
        this.$emit('onNew');
      },
    },
    data() {
      return {
        flowSources: this.$store.state.EnumsModule.flowSources,
        amountFlowTypes: this.$store.state.EnumsModule.amountFlowTypes,
        amountStatuses: this.$store.state.EnumsModule.amountStatuses,
        keyword: '',
        formData: this.$store.state.WalletModule.formData,
        categories: [],
      }
    }
  }
</script>
