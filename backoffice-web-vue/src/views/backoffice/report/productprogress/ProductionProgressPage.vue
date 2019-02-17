<template>
  <div class="animated fadeIn content">
    <el-card>
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
      <div class="pt-2"></div>
      <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
        <el-table-column label="需求订单号" prop="requirementOrderCode" width="160" fixed></el-table-column>
        <el-table-column label="生产订单号" prop="productionOrderCode" width="160" fixed></el-table-column>
        <el-table-column label="客户" prop="brand" width="120" fixed></el-table-column>
        <el-table-column label="工厂" prop="factory" width="160" fixed></el-table-column>
        <el-table-column label="供应商商品编号" prop="productSkuID" width="120"></el-table-column>
        <el-table-column label="生产订单状态" prop="status" width="100">
          <template slot-scope="scope">
            <el-tag
              :type="scope.row.status === 'DELIVERY_COMPLETED' ? 'success' : ''"
              disable-transitions>{{scope.row.status|enumTranslate('ConsignmentStatus')}}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="是否延期" prop="isDelay">
          <template slot-scope="scope">
            <el-tag :type="scope.row.isDelay === 'true' ? 'success' : 'danger'" disable-transitions>
              {{scope.row.isDelay|enumTranslate('DelayStatus')}}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="生产订单创建时间" prop="productOrderCreationTime" width="120">
          <template slot-scope="scope">
            <span>{{scope.row.productOrderCreationTime | formatDate}}</span>
          </template>
        </el-table-column>
        <el-table-column label="品类" prop="productCategories"></el-table-column>
        <el-table-column label="品名" prop="productName" width="160"></el-table-column>
        <el-table-column label="商品明细" prop="items" width="160">
          <template slot-scope="scope" v-if="scope.row.items">
            <span v-for="item in scope.row.items">{{item.color}}/{{item.size}}/{{item.amount}}<br></span>
          </template>
        </el-table-column>
        <el-table-column label="合计" prop="productSum" width="80"></el-table-column>
        <el-table-column label="客户交期" prop="expectedDeliveryDate" width="120">
          <template slot-scope="scope">
            <span>{{scope.row.expectedDeliveryDate | formatDate}}</span>
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
  import autoHeight from '@/mixins/autoHeight'
  import {ExcelExportMixin} from '@/mixins';

  export default {
    name: 'ProductionProgressPage',
    components: {},
    mixins: [autoHeight, ExcelExportMixin],
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onDetails(item) {
        console.log(item);
        // this.fn.openSlider('图片详情', CollectionsDetailsPage, item);
      },
      onPageSizeChanged(val) {
        this.reset();
        this.page.size = val;
        this._onSearch(0, val);
      },
      onCurrentPageChanged(val) {
        this._onSearch(val - 1, this.page.size);
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      async _onSearch(page, size) {
        const params = {
          requirementOrderCode: this.query.requirementOrderCode,
          productionOrderCode: this.query.productionOrderCode,
          brand: this.query.brand,
          factory: this.query.factory,
          isDelay: this.query.isDelay,
          status: this.query.status,
          expectedDeliveryDateFrom: this.query.expectedDeliveryDateFrom,
          expectedDeliveryDateTo: this.query.expectedDeliveryDateTo,
          createdDateFrom: this.query.createdDateFrom,
          createdDateTo: this.query.createdDateTo,
          page: page,
          size: size,
        };
        const result = await this.$http.post('/djbackoffice/report/production/progress/search', params);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        const data = result.content;
        const newData = [];
        for (let i = 0; i < data.length; i++) {
          if (data[i].isDelay === params.isDelay) {
            newData.push(data[i]);
          }
        }
        this.page.content = newData;
        this.page.totalElements = newData.length;
      },
      async getBrands() {
        const result = await this.$http.get('/djbrand/brand', {
          text: '',
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.brands = result.content;
      },
      async getFactories() {
        const result = await this.$http.get('/djfactory/factory', {
          text: '',
        });

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.factories = result.content;
      },
      findBrand(item) {
        this.query.brand = item;
      },
      findFactory(item) {
        this.query.factory = item;
      },
      findStatus(item) {
        this.query.status = item;
      },
    },
    computed: {
      data: function () {
        return {
          format: this.slotData.format.value,
          files: this.files
        };
      },
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
        URLS: {
          exportUrl: '/djbackoffice/report/production/progress/export',
        },
        excelExportTemplateName: '生产进度报表' + new Date().getTime() + '.xlsx',
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        },
        query: {
          requirementOrderCode: '',
          productionOrderCode: '',
          brand: null,
          factory: null,
          isDelay: true,
          status: [],
          expectedDeliveryDateFrom: null,
          expectedDeliveryDateTo: null,
          createdDateFrom: null,
          createdDateTo: null,
        },
        brands: [],
        factories: [],
        value: '',
        statuses: [
          {code: 'WAIT_FOR_ALLOCATION', name: '待分配'},
          {code: 'WAIT_FOR_PURCHASE', name: '备料中'},
          {code: 'PENDING_CUTTING', name: '待裁剪'},
          {code: 'CUTTING', name: '裁剪中'},
          {code: 'STITCHING', name: '车缝中'},
          {code: 'QC', name: '待验货'},
          {code: 'PENDING_DELIVERY', name: '待发货'},
          {code: 'DELIVERING', name: '已发货'},
          {code: 'DELIVERY_COMPLETED', name: '已完成'},
        ]
      }
    },
  }
</script>
