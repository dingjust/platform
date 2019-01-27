<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入订单编号" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">创建订单</el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe :data="page.content">
        <el-table-column label="订单编号" prop="code" width="250"></el-table-column>
        <el-table-column label="订单状态" prop="status">
          <template slot-scope="scope">
            <span>{{scope.row.status | enumTranslate('OrderStatus')}}</span>
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
  import axios from "axios";
  import {OrderForm, OrderDetailsPage} from "./";

  const DEFAULT_ORDER_TYPE = "SALES_ORDER";

  export default {
    name: "OrderPage",
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onNew() {
        this.fn.openSlider("创建订单", OrderForm, {
          id: null,
          code: "",
          name: "",
          type: DEFAULT_ORDER_TYPE,
          description: "",
          entries: [],
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
          }
        });
      },
      onDetails(item) {
        axios.get("/djbrand/salesOrder/" + item.code)
          .then(response => {
            this.fn.openSlider("订单明细", OrderDetailsPage, response.data);
          })
          .catch(error => {
            console.log(JSON.stringify(error));
            this.$message.error(error.response.data);
          });
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
      _onSearch(page, size) {
        const params = {
          text: this.text,
          page: page,
          size: size
        };

        axios
          .get("/djbrand/salesOrder", {
            params: params
          })
          .then(response => {
            this.page = response.data;
          })
          .catch(error => {
            console.log(JSON.stringify(error));
            this.$message.error(error.response.data);
          });
      }
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
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        }
      };
    }
  };
</script>
