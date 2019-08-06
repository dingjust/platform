<template>
  <el-form :inline="true">
    <el-form-item label="">
      <el-input placeholder="请输入生产订单编号" v-model="keyword"></el-input>
    </el-form-item>
    <el-button-group>
      <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
      <el-button v-if="!isTenant()" type="primary" icon="el-icon-plus" @click="onNew">创建手工单</el-button>
    </el-button-group>
    <el-popover placement="bottom" width="800" trigger="click">
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="订单编号">
            <el-input v-model="queryFormData.code"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="状态">
            <el-select v-model="queryFormData.statuses" placeholder="请选择"
                       multiple class="w-100">
              <el-option
                v-for="item in purchaseOrderStatuses"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10" v-if="isTenant()">
        <el-col :span="12">
          <el-form-item label="工厂">
            <el-select v-model="queryFormData.belongTos" placeholder="请选择"
                       multiple class="w-100"
                       filterable
                       remote
                       :remote-method="getFactories">
              <el-option
                v-for="item in factories"
                :key="item.uid"
                :label="item.name"
                :value="item.uid">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="品牌">
            <el-select v-model="queryFormData.purchasers" placeholder="请选择"
                       multiple class="w-100"
                       filterable
                       remote
                       :remote-method="getBrands">
              <el-option
                v-for="item in brands"
                :key="item.uid"
                :label="item.name"
                :value="item.uid">
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
      <el-button-group slot="reference">
        <el-button type="primary">高级查询</el-button>
      </el-button-group>
    </el-popover>
  </el-form>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapMutations} = createNamespacedHelpers('PurchaseOrdersModule');

  export default {
    name: 'ProductionToolbar',
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
        this.$emit('onAdvancedSearch', 0);
      },
      onNew() {
        let formData = {};
        Object.assign(formData, this.formData);

        this.$emit('onNew', formData);
      },
      async getFactories(query) {
        const url = this.apis().getFactories();
        const result = await this.$http.post(url,{keyword:query},{
          page: 0,
          size: 10
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.factories = result.content;
      },
      async getBrands(query) {
        const url = this.apis().getBrands();
        const result = await this.$http.post(url,{keyword:query},{
          page: 0,
          size: 10
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.brands = result.content;
      },
    },
    data() {
      return {
        factories:[],
        brands:[],
        keyword: this.$store.state.PurchaseOrdersModule.keyword,
        formData: this.$store.state.PurchaseOrdersModule.formData,
        queryFormData: this.$store.state.PurchaseOrdersModule.queryFormData,
        purchaseOrderStatuses: this.$store.state.EnumsModule.purchaseOrderStatuses,
      }
    },
    created() {
      if (this.isTenant()) {
        this.getFactories();
        this.getBrands();
      }
    }
  }
</script>
