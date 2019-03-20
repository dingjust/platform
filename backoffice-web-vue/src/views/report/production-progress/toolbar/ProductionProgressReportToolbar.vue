<template>
  <div>
    <el-button-group>
      <el-popover ref="searchPopover" placement="right" width="800" trigger="click">
        <el-form :inline="false">
          <el-row :gutter="10">
            <el-col :span="6">
              <el-form-item label="需求订单号">
                <el-input placeholder="请输入需求订单号" v-model="query.requirementOrderCode"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item label="需求订单号">
                <el-input placeholder="请输入生产订单号" v-model="query.productionOrderCode"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item label="客户">
                <el-select v-model="query.brand" placeholder="请选择客户" filterable @visible-change="getBrands"
                           @change="findBrand" class="w-100">
                  <el-option
                    v-for="item in brands"
                    :key="item.id"
                    :label="item.name"
                    :value="item.id">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item label="工厂">
                <el-select v-model="query.factory" placeholder="请选择工厂" filterable @visible-change="getFactories"
                           @change="findFactory" class="w-100">
                  <el-option
                    v-for="item in factories"
                    :key="item.id"
                    :label="item.name"
                    :value="item.id">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
          </el-row>
          <div class="pt-2"></div>
          <el-row :gutter="10">
            <el-col :span="6">
              <el-form-item label="创建时间从">
                <el-date-picker
                  v-model="query.createdDateFrom"
                  :value-format="defaultDateValueFormat"
                  type="date"
                  class="w-100"
                  placeholder="请选择创建时间">
                </el-date-picker>
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item label="创建时间到">
                <el-date-picker
                  v-model="query.createdDateTo"
                  :value-format="defaultDateValueFormat"
                  type="date"
                  class="w-100"
                  placeholder="请选择生产订单创建时间">
                </el-date-picker>
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item label="客户交期从">
                <el-date-picker
                  v-model="query.expectedDeliveryDateFrom"
                  :value-format="defaultDateValueFormat"
                  type="date"
                  class="w-100"
                  placeholder="请选择客户交期">
                </el-date-picker>
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item label="客户交期到">
                <el-date-picker
                  v-model="query.expectedDeliveryDateTo"
                  :value-format="defaultDateValueFormat"
                  type="date"
                  class="w-100"
                  placeholder="请选择客户交期">
                </el-date-picker>
              </el-form-item>
            </el-col>
          </el-row>
          <div class="pt-2"></div>
          <el-row :gutter="10">
            <el-col :span="6">
              <el-select v-model="query.status" placeholder="请选择生产订单状态" multiple filterable
                         @change="findStatus"
                         class="w-100">
                <el-option
                  v-for="item in statuses"
                  :key="item.code"
                  :label="item.name"
                  :value="item.code">
                </el-option>
              </el-select>
            </el-col>
            <el-col :span="6">
              <span class="el-form-item__label">是否延期</span>
              <el-switch active-color="#13ce66"
                         inactive-color="#ff4949"
                         v-model="query.isDelay">
              </el-switch>
            </el-col>
          </el-row>
          <el-row :gutter="10">
            <el-col :span="6">
              <el-button type="primary" icon="el-icon-search" @click="onSearch">查询</el-button>
            </el-col>
          </el-row>
        </el-form>
        <el-button type="primary" slot="reference" icon="el-icon-search">查询...</el-button>
      </el-popover>
    </el-button-group>
    <el-button-group>
      <el-button type="primary" icon="el-icon-upload" @click="onExport">导出</el-button>
    </el-button-group>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapMutations} = createNamespacedHelpers('ProductionProgressReportsModule');

  export default {
    name: 'ProductionProgressReportToolbar',
    components: {},
    computed: {},
    methods: {
      ...mapMutations({
        setKeyword: 'keyword'
      }),
      onSearch() {
        this.setKeyword(this.keyword);
        this.$emit('onSearch', 0);
      },
    },
    data() {
      return {
        keyword: '',
        categories: [],
      }
    }
  }
</script>
