<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入订单编号" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
        </el-button-group>
        <el-popover placement="bottom" width="800" trigger="click">
          <el-row :gutter="10">
            <el-col :span="6">
              <el-form-item label="订单编号">
                <el-input v-model="queryFormData.code"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item label="供应商商品编号">
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
      <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange"
                v-if="isHeightComputed" :height="autoHeight">
        <el-table-column type="expand">
          <template slot-scope="props">
            <requirement-order-form :read-only="true" :slot-data="props.row"/>
          </template>
        </el-table-column>
        <el-table-column label="需求编号" prop="code" width="250">
          <template slot-scope="scope">
            <span>{{scope.row.code}}</span>
          </template>
        </el-table-column>
        <el-table-column label="需求状态" prop="status" :column-key="'status'"
                         :filters="statuses">
          <template slot-scope="scope">
            <el-tag
              :type="scope.row.status === 'COMPLETED' ? 'success' : ''"
              disable-transitions>{{getEnum('requirementOrderStatuses', scope.row.status)}}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="发布品牌" prop="user">
          <template slot-scope="scope">
            <span>{{scope.row.belongTo.name}}</span>
          </template>
        </el-table-column>
        <el-table-column label="发布人" prop="user">
          <template slot-scope="scope">
            <span>{{scope.row.user.name}}</span>
          </template>
        </el-table-column>
        <el-table-column label="发布时间" prop="createdTs">
          <template slot-scope="scope">
            <span>{{scope.row.creationtime | formatDate}}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
            <!--<el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">
               明细
             </el-button>-->
            <el-button type="text" icon="el-icon-edit" :disabled="!isPendingQuote(scope.row)"
                       @click="onQuoting(scope.row)">
              报价
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pt-2"></div>
      <div class="float-right">
        <el-pagination layout="total, sizes, prev, pager, next, jumper"
                       @size-change="onPageSizeChanged"
                       @current-change="onCurrentPageChanged"
                       :current-page="page.number + 1"
                       :page-size="page.size"
                       :page-count="page.totalPages"
                       :total="page.totalElements">
        </el-pagination>
      </div>
      <div class="clearfix"></div>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('FactoryRequirementOrdersModule');

  import autoHeight from 'mixins/autoHeight';

  import QuoteForm from '@/views/factory/order/quote/QuoteForm';

  import RequirementOrderDetailsPage from './RequirementOrderDetailsPage'

  export default {
    name: 'RequirementOrderPage',
    mixins: [autoHeight],
    components: {QuoteForm},
    computed: {
      ...mapGetters({
        page: 'page'
      }),
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      async onQuoting(row) {
        // console.log('报价: ' + JSON.stringify(row));
        // TODO: 转到报价页面
        Object.assign(this.quoteFormData.requirementOrder, JSON.parse(JSON.stringify(row)));

        // console.log(JSON.stringify(this.quoteFormData));
        this.quoteFormData.requirementOrderRef = row.code;
        this.fn.openSlider('填写报价单，需求编号：' + row.code, QuoteForm, this.quoteFormData);
      },
      isPendingQuote: function (row) {
        return row.status === 'PENDING_QUOTE';
      },
      handleFilterChange(val) {
        this.statuses = val.status;
        this.onSearch();
      },
      //如只需当前页面筛选不需调后台查询的使用该方法！
      filterTag(value, row) {
        //   return row.status === value;
      },
      onSearch() {
        this._onSearch(0);
      },
      onAdvancedSearch() {
        this.advancedSearch = true;
        this._onAdvancedSearch(0)
      },
      _onSearch(page, size) {
        const keyword = this.text;
        const statuses = this.statuses;
        this.search({keyword, statuses, page, size});
      },
      _onAdvancedSearch(page, size) {
        const query = this.queryFormData;
        this.searchAdvanced({query, page, size});
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      async onDetails(item) {
        const result = await this.$http.get('/b2b/orders/requirement/' + item.code);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('需求订单：' + item.code, RequirementOrderDetailsPage, result);
      },
      onCurrentPageChanged(val) {
        if (this.advancedSearch) {
          this._onAdvancedSearch(val - 1);
        } else {
          this._onSearch(val - 1);
        }
      },
      onPageSizeChanged(val) {
        this.reset();
        if (this.advancedSearch) {
          this._onAdvancedSearch(0, val);
        } else {
          this._onSearch(0, val);
        }
      },
    },
    data() {
      return {
        text: this.$store.state.FactoryRequirementOrdersModule.keyword,
        statuses: this.$store.state.FactoryRequirementOrdersModule.statuses,
        formData: this.$store.state.FactoryRequirementOrdersModule.formData,
        queryFormData: this.$store.state.FactoryRequirementOrdersModule.queryFormData,
        statusOptions: this.$store.state.FactoryRequirementOrdersModule.statusOptions,
        advancedSearch: false,
        quoteFormData: {
          requirementOrderRef: '',
          requirementOrder: {
            id: null,
            code: '',
            details: {
              productImage: '',
              productSkuID: '',
              productName: '',
              category: {
                code: '',
                name: ''
              },
              majorCategory: {
                code: '',
                name: ''
              },
            }
          },
          expectedDeliveryDate: null,
          unitPriceOfFabric: 0.00,
          unitPriceOfExcipients: 0.00,
          unitPriceOfProcessing: 0.00,
          costOfOther: 0.00,
          costOfSamples: 0.00,
          attachments: [],
          remarks: '',
        },
      };
    },
    created() {
      this.onSearch();
    }
  };
</script>
