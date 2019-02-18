<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入生产订单编号" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">创建生产订单</el-button>
        </el-button-group>
        <el-popover placement="right" width="600" trigger="click">
          <el-row :gutter="10">
            <el-col :span="12">
              <el-form-item label="生产订单编号">
                <el-input v-model="queryFormData.productionOrderCode"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="需求订单编号">
                <el-input v-model="queryFormData.requirementOrderCode"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="10">
            <el-col :span="12">
              <el-form-item label="供应商商品编号">
                <el-input v-model="queryFormData.skuID"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="商家">
                <el-select class="w-100" filterable remote reserve-keyword clearable
                           placeholder="请输入商家名称查询"
                           v-model="queryFormData.belongTos"
                           :remote-method="onFilterBrands"
                           multiple>
                  <el-option v-for="item in brands"
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
            <el-col :span="12">
              <el-form-item label="工厂">
                <el-select class="w-100" filterable remote reserve-keyword clearable
                           placeholder="请输入工厂名称查询"
                           v-model="queryFormData.factory"
                           :remote-method="onFilterCompanies"
                           multiple>
                  <el-option v-for="item in companies"
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
      <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight">
        <el-table-column label="生产订单编号" prop="code" fixed>
          <template slot-scope="scope">
            <span>{{scope.row.code}}</span>
            <el-tag v-if="scope.row.delayDays !== 0" type="danger">已延期</el-tag>
            <el-tag v-else-if="scope.row.isPostponed" type="warning">已延期</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="生产订单状态" prop="status" fixed>
          <template slot-scope="scope">
            <el-tag><span>{{scope.row.status | enumTranslate('ConsignmentStatus')}}</span></el-tag>
          </template>
        </el-table-column>
        <el-table-column label="订单号" prop="order.code" fixed></el-table-column>
        <el-table-column label="交货日期" prop="namedDeliveryDate">
          <template slot-scope="scope">
            <span>{{scope.row.namedDeliveryDate | formatDate}}</span>
          </template>
        </el-table-column>
        <el-table-column label="指定工厂" prop="assignedTo.name"></el-table-column>
        <el-table-column label="创建时间" prop="createdTs">
          <template slot-scope="scope">
            <span>{{scope.row.createdTs | formatDate}}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">
              明细
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                     @size-change="onPageSizeChanged"
                     @current-change="onCurrentPageChanged"
                     :current-page="page.number + 1"
                     :page-size="page.size"
                     :page-count="page.totalPages"
                     :total="page.totalElements">
      </el-pagination>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('ProductionOrdersModule');

  import autoHeight from 'mixins/autoHeight';
  import {ConsignmentForm, ConsignmentDetailsForm} from './';

  export default {
    name: 'ConsignmentPage',
    mixins: [autoHeight],
    computed: {
      ...mapGetters({
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onSearch() {
        this._onSearch(0);
      },
      onNew() {
        this.fn.openSlider('创建生产订单', ConsignmentForm, this.formData);
      },
      onFilterCompanies(query) {
        this.companies = [];
        if (query && query !== '') {
          setTimeout(() => {
            this.getCompanies(query);
          }, 200);
        }
      },
      async getCompanies(query) {
        if (query !== '') {
          const results = await this.$http.get('/djfactory/factory', {
            text: query.trim()
          });

          this.companies = results.content;
        }
      },
      onFilterBrands(query) {
        this.companies = [];
        if (query && query !== '') {
          setTimeout(() => {
            this.getBrands(query);
          }, 200);
        }
      },
      async getBrands(query) {
        const results = await this.$http.get('/djbrand/brand', {
          text: query.trim()
        });

        this.brands = results.content;
      },
      onAdvancedSearch() {
        this.advancedSearch = true;
        this._onAdvancedSearch(0)
      },
      _onAdvancedSearch(page, size) {
        const query = this.queryFormData;
        this.searchAdvanced({query, page, size});
      },
      async onDetails(item) {
        const result = await this.$http.get('/djbackoffice/consignment/' + item.code);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.fn.openSlider('生产订单明细', ConsignmentDetailsForm, result);
      },
      onPageSizeChanged(val) {
        this.reset();

        if (this.advancedSearch) {
          this._onAdvancedSearch(0, val);
        } else {
          this._onSearch(0, val);
        }
      },
      onCurrentPageChanged(val) {
        if (this.advancedSearch) {
          this._onAdvancedSearch(val - 1);
        } else {
          this._onSearch(val - 1);
        }
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      _onSearch(page, size) {
        const keyword = this.text;
        this.search({keyword, page, size});
      }
    },
    data() {
      return {
        text: this.$store.state.ProductionOrdersModule.keyword,
        statuses: this.$store.state.ProductionOrdersModule.statuses,
        formData: this.$store.state.ProductionOrdersModule.formData,
        queryFormData: this.$store.state.ProductionOrdersModule.queryFormData,
        statusOptions: this.$store.state.ProductionOrdersModule.statusOptions,
        brands: [],
        companies: [],
        advancedSearch: false,
      }
    },
    created() {
      this.onSearch();
    }
  }
</script>
