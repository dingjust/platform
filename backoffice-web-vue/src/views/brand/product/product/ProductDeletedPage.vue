<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入产品编码" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe
                :data="page.content"
                @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="32"></el-table-column>
        <el-table-column label="编码" prop="code" width="160"></el-table-column>
        <el-table-column label="名称" prop="name" width="480"></el-table-column>
        <el-table-column label="价格" prop="price"  :formatter="numberFormatter"></el-table-column>
        <el-table-column label=" 操作" width="120">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">
              明细
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pt-2 "></div>
      <div class="float-right ">
        <el-pagination layout="total, sizes, prev, pager, next, jumper"
                       @size-change="onPageSizeChanged"
                       @current-change="onCurrentPageChanged"
                       :current-page="page.number + 1"
                       :page-size="page.size"
                       :page-count="page.totalPages"
                       :total="page.totalElements">
        </el-pagination>
      </div>
      <div class="clearfix "></div>
    </el-card>
  </div>
</template>

<script>
  import axios from "axios";

  import {ProductForm, ProductDetailsPage} from "./";

  export default {
    name: "ProductPage",
    methods: {
      numberFormatter(val){
        if(val.price !== null && val.price !== '' && val.price !== 'undefined'){
          let prices = parseFloat(val.price).toFixed(2);
          return prices;
        }else{
          return ;
        }
      },
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onDetails(item) {
        axios.get("/djbrand/product/details/" + item.code)
          .then(response => {
            // console.log(response.data);
            this.fn.openSlider("产品明细", ProductDetailsPage, response.data);
          })
          .catch(error => {
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

        axios.get("/djbrand/product/deleteds", {
          params: params
        }).then(response => {
          this.page = response.data;
          console.log(this.page.content);
        }).catch(error => {
            this.$message.error(error.response.data);
          }
        );
      },
      handleSelectionChange(val) {
        this.multipleSelection = val;
      }
    },
    watch: {
      "$store.state.sideSliderState": function (value) {
        if (!value) {
          this.onSearch();
        }
      }
    },
    computed: {
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
        },
      };
    }
  };
</script>
