<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入生产订单编号" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
        </el-button-group>
        <el-popover placement="right" width="600" trigger="click">
          <el-row :gutter="10">
            <el-col :span="12">
              <el-form-item label="生产订单编号">
                <el-input v-model="query.productionOrderCode"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="需求订单编号">
                <el-input v-model="query.requirementOrderCode"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="10">
            <el-col :span="12">
              <el-form-item label="供应商商品编号">
                <el-input v-model="query.skuID"></el-input>
              </el-form-item>
            </el-col>
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
      <el-table ref="resultTable" stripe :data="page.content">
        <el-table-column label="生产订单编号" prop="code">
          <template slot-scope="scope">
          <span>{{scope.row.code}}</span>
          <el-tag v-if="scope.row.delayDays !== 0" type="danger">已延期</el-tag>
          <el-tag v-else-if="scope.row.isPostponed" type="warning">已延期</el-tag>
        </template>
        </el-table-column>
        <el-table-column label="生产订单状态" prop="status">
          <template slot-scope="scope">
            <el-tag><span>{{scope.row.status | enumTranslate('ConsignmentStatus')}}</span></el-tag>
          </template>
        </el-table-column>
        <el-table-column label="订单号" prop="order.code"></el-table-column>
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
  import axios from 'axios';
  import {ConsignmentForm, ConsignmentDetailsForm} from './';

  export default {
    name: 'ConsignmentPage',
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onNew() {
        this.fn.openSlider('创建生产订单', ConsignmentForm, {
          id: null,
          code: '',
          order: {
            id: '',
            code: '',
            entries: []
          },
          assignedTo: {
            uid: '',
            name: ''
          },
          shippingAddress: {
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
          consignmentEntries: []
        });
      },
      onFilterBrands(query) {
        this.companies = [];
        if (query && query !== "") {
          setTimeout(() => {
            this.getBrands(query);
          }, 200);
        }
      },
      getBrands(query) {
        axios.get("/djbrand/brand", {
          params: {
            text: query.trim()
          }
        }).then(response => {
          this.brands = response.data.content;
        }).catch(error => {
          this.$message.error(error.response.data);
        });
      },
      onAdvancedSearch() {
        this.advancedSearch = true;
        this._onAdvancedSearch(0, this.page.size)
      },
      _onAdvancedSearch(page, size) {
        const params = {
          page: page,
          size: size
        };

        axios.post("/djfactory/consignment/advancedSearch", this.query, {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
            this.$message.error(error.response.data);
          }
        );
      },
      onDetails(item) {
        axios.get("/djfactory/consignment/" + item.code)
          .then(response => {
            this.fn.openSlider("生产订单明细", ConsignmentDetailsForm, response.data);
          })
          .catch(error => {
            console.log(JSON.stringify(error));
            this.$message.error(error.response.data);
          });
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
      onCurrentPageChanged(val) {
        if (this.advancedSearch) {
          this._onAdvancedSearch(val - 1, this.page.size);
        } else {
          this._onSearch(val - 1, this.page.size);
        }
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      _onSearch(page, size) {
        const params = {
          text: this.text,
          page: page,
          size: size
        };
        console.log('params', JSON.stringify(params));
        axios.get('/djfactory/consignment', {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
          console.log(JSON.stringify(error));
          this.$message.error(error.response.data);
        });
      }
    },
    watch: {
      '$store.state.sideSliderState': function (value) {
        if (!value) {
          this.onSearch();
        }
      }
    },
    data() {
      return {
        text: '',
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        },
        query: {
          productionOrderCode: "",
          requirementOrderCode:"",
          skuID: "",
          statuses: [],
          expectedDeliveryDateFrom: null,
          expectedDeliveryDateTo: null,
          createdDateFrom: null,
          createdDateTo: null,
          belongTos:[],
        },
        brands:[],
        companies: [],
        advancedSearch: false,
        statuses: [
          {text: '待分配', value: 'WAIT_FOR_ALLOCATION'},
          {text: '备料中', value: 'WAIT_FOR_PURCHASE'},
          {text: '待裁剪', value: 'PENDING_CUTTING'},
          {text: '裁剪中', value: 'CUTTING'},
          {text: '车缝中', value: 'STITCHING'},
          {text: '待验货', value: 'QC'},
          {text: '待发货', value: 'PENDING_DELIVERY'},
          {text: '已发货', value: 'DELIVERING'},
          {text: '已完成', value: 'DELIVERY_COMPLETED'}
        ],
      }
    }
  }
</script>
