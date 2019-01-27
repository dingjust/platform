<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入订单编号" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">创建需求订单</el-button>
        </el-button-group>
        <el-popover placement="right" width="600" trigger="click">
          <el-row :gutter="10">
            <el-col :span="12">
              <el-form-item label="订单编号">
                <el-input v-model="query.code"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="供应商商品编号">
                <el-input v-model="query.skuID"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="10">
            <el-col :span="12">
              <el-form-item label="状态">
                <el-select v-model="query.statuses" placeholder="请选择"
                           multiple class="w-100">
                  <el-option
                    v-for="item in statuses"
                    :key="item.value"
                    :label="item.text"
                    :value="item.value">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="商家">
                <el-select class="w-100" filterable remote reserve-keyword clearable
                           placeholder="请输入商家名称查询"
                           v-model="query.belongTos"
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
                  v-model="query.createdDateFrom"
                  value-format="yyyy-MM-dd"
                  type="date"
                  placeholder="请选择生产订单创建时间">
                </el-date-picker>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="创建时间到">
                <el-date-picker
                  v-model="query.createdDateTo"
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
                  v-model="query.expectedDeliveryDateFrom"
                  value-format="yyyy-MM-dd"
                  type="date"
                  placeholder="请选择客户交期">
                </el-date-picker>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="交货时间到">
                <el-date-picker
                  v-model="query.expectedDeliveryDateTo"
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
      <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange" :height="autoHeight">
        <el-table-column label="订单编号" prop="code" width="250" fixed>
          <template slot-scope="scope">
            <span>{{scope.row.code}}</span>
            <el-tag v-show="scope.row.delayDays !== 0" type="danger">已延期 {{scope.row.delayDays}}天</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="订单状态" prop="status" :column-key="'status'"
                         :filters="statuses" fixed>
          <template slot-scope="scope">
            <el-tag
              :type="scope.row.status === 'COMPLETED' ? 'success' : ''"
              disable-transitions>{{scope.row.status|enumTranslate('OrderStatus')}}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="创建用户" prop="user">
          <template slot-scope="scope">
            <span>{{scope.row.user.name}}</span>
          </template>
        </el-table-column>
        <el-table-column label="创建时间" prop="createdTs">
          <template slot-scope="scope">
            <span>{{scope.row.createdTs | formatDate}}</span>
          </template>
        </el-table-column>
        <el-table-column label="商家" prop="belongTo.name"></el-table-column>
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
  import axios from "axios";
  import autoHeight from 'mixins/autoHeight'
  import RequirementOrderForm from './RequirementOrderForm';
  import RequirementOrderDetailsPage from "./RequirementOrderDetailsPage"

  const DEFAULT_ORDER_TYPE = "REQUIREMENT_ORDER";
  export default {
    name: "RequirementOrderPage",
    mixins: [autoHeight],
    methods: {
      handleFilterChange(val) {
        this.orderStatus = val.status;
        this.onSearch();
      },
      //如只需当前页面筛选不需调后台查询的使用该方法！
      filterTag(value, row) {
      //   return row.status === value;
      },
      onSearch() {
        this.advancedSearch = false;
        this._onSearch(0, this.page.size);
      },
      onAdvancedSearch() {
        this.advancedSearch = true;
        this._onAdvancedSearch(0, this.page.size)
      },
      _onSearch(page, size) {
        const params = {
          page: page,
          size: size
        };
        axios.post("/djbackoffice/requirementOrder", {
          code: this.text,
          statuses: this.orderStatus
        }, {params: params}).then(response => {
          this.page = response.data;
        }).catch(error => {
            this.$message.error(error.response.data);
          });
      },
      _onAdvancedSearch(page, size) {
        const params = {
          page: page,
          size: size
        };

        axios.post("/djbackoffice/requirementOrder/advancedSearch", this.query, {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
            this.$message.error(error.response.data);
          }
        );
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(item) {
        axios.get("/djbackoffice/requirementOrder/" + item.code)
          .then(response => {
            this.fn.openSlider("需求订单明细", RequirementOrderDetailsPage, response.data);
          })
          .catch(error => {
            console.log(JSON.stringify(error));
            this.$message.error(error.response.data);
          });
      },
      onNew() {
        this.fn.openSlider("创建需求订单", RequirementOrderForm, {
          id: null,
          code: "",
          name: "",
          description: "",
          depositPaid: false,
          depositAmount: 0,
          retainagePaid: false,
          retainageAmount: 0,
          entries: [],
          contracts: [],
          deliveryAddress: {
            fullname: "",
            title: {
              code: "",
              name: ""
            },
            region: {
              isocode: "",
              name: ""
            },
            city: {
              code: "",
              name: ""
            },
            cityDistrict: {
              code: "",
              name: ""
            },
            line1: "",
            remarks: ""
          },
          details: {
            minorCategories: [],
            category: {
              code: "",
              name: ""
            },
            majorCategory: {
              code: "",
              name: ""
            },
            expectedMachiningQuantity: 0,
            machiningType: null,
            expectedDeliveryDate: null,
            maxExpectedPrice: 0,
            invoiceNeeded: false,
            samplesNeeded: false,
            contactPerson: "",
            contactPhone: ""
          },
          belongTo: {
            uid: "",
            name: ""
          }
        });
      },
      onCurrentPageChanged(val) {
        if (this.advancedSearch) {
          this._onAdvancedSearch(val - 1, this.page.size);
        } else {
          this._onSearch(val - 1, this.page.size);
        }
      },
      onPageSizeChanged(val) {
        this.reset();
        this.page.size = val;
        if (this.advancedSearch) {
          this._onAdvancedSearch(0, val);
        } else {
          this._onSearch(0, val);
        }
      },
      onFilterCompanies(query) {
        this.companies = [];
        if (query && query !== "") {
          setTimeout(() => {
            this.getCompanies(query);
          }, 200);
        }
      },
      getCompanies(query) {
        axios.get("/djbrand/brand", {
          params: {
            text: query.trim()
          }
        }).then(response => {
          this.companies = response.data.content;
        }).catch(error => {
          this.$message.error(error.response.data);
        });
      },
    },
    watch: {
      "$store.state.sideSliderState": function (value) {
        if (!value) {
          this.onSearch();
        }
      }
    },
    data() {
      return {
        text: "",
        query: {
          code: "",
          skuID: "",
          statuses: [],
          belongTos: [],
          expectedDeliveryDateFrom: null,
          expectedDeliveryDateTo: null,
          createdDateFrom: null,
          createdDateTo: null,
        },
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        },
        advancedSearch: false,
        orderStatus: [],
        statuses: [
          {text: '待处理', value: 'WAIT_FOR_PROCESSING'},
          {text: '待确认', value: 'PENDING_APPROVAL'},
          {text: '已确认', value: 'APPROVED'},
          {text: '待分配', value: 'WAIT_FOR_ALLOCATION'},
          {text: '待出库', value: 'WAIT_FOR_OUT_OF_STORE'},
          {text: '已出库', value: 'OUT_OF_STORE'},
          {text: '已签收', value: 'COMPLETED'}
        ],
        companies: [],
      };
    },
    created(){
      this.getCompanies("");
    }
  };
</script>
