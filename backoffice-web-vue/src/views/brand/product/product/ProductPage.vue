<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入产品编码" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">创建产品</el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onBatchLaunch">批量上架</el-button>
          <el-button type="primary" icon="el-icon-minus" @click="onBatchWithdraw">批量下架</el-button>
        </el-button-group>
        <el-popover placement="bottom" width="800" trigger="click">
          <el-row :gutter="10">
            <el-col :span="12">
              <el-form-item label="供应商商品编号">
                <el-input v-model="query.skuID"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="商品名称">
                <el-input v-model="query.name"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="10">
            <el-col :span="12">
              <el-form-item label="商品状态（上下架）">
                <el-select v-model="query.approvalStatuses" placeholder="请选择"
                           multiple class="w-100">
                  <el-option
                    v-for="item in approvalStatuses"
                    :key="item.code"
                    :label="item.name"
                    :value="item.code">
                  </el-option>
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="产品分类">
                <el-select v-model="query.categories" placeholder="请选择" class="w-100"
                           filterable reserve-keyword clearable
                           multiple>
                  <el-option-group
                    v-for="level1 in categories"
                    :key="level1.code"
                    :label="level1.name">
                    <el-option
                      v-for="level2 in level1.children"
                      :key="level2.code"
                      :label="level2.name"
                      :value="level2.code">
                    </el-option>
                  </el-option-group>
                </el-select>
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
      <el-table ref="resultTable" stripe
                :data="page.content"
                @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="32"></el-table-column>
        <el-table-column label="编码" prop="code" width="160"></el-table-column>
        <el-table-column label="供应商产品编码" prop="skuID"></el-table-column>
        <el-table-column label="名称" prop="name" width="480"></el-table-column>
        <el-table-column label="价格" prop="price"  :formatter="numberFormatter"></el-table-column>
        <el-table-column label="上下架">
          <template slot-scope="scope">
            <el-switch active-color="#13ce66" inactive-color="#ff4949"
                       v-model="scope.row.approvalStatus === 'approved'"
                       @change="changeShelfStatus(scope.row)">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column label="店铺首页推荐">
          <template slot-scope="scope">
            <el-switch active-color="#13ce66" inactive-color="#ff4949"
                       v-model="scope.row.recommended"
                       @change="changeRecommendedStatus(scope.row)">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column label=" 操作" width="120">
          <template slot-scope="scope">
            <div>
              <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">
                明细
              </el-button>
            </div>
          </template>
        </el-table-column>
        <el-table-column label=" 操作" width="120">
          <template slot-scope="scope">
            <div>
              <el-button type="text" icon="el-icon-delete" @click="onDeleted(scope.row)">
                删除
              </el-button>
            </div>
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
        this.advancedSearch = false;
        this._onSearch(0, this.page.size);
      },
      onAdvancedSearch() {
        this.advancedSearch = true;
        this._onAdvancedSearch(0, this.page.size)
      },
      onNew() {
        this.fn.openSlider("创建产品", ProductForm, {
          id: null,
          code: "",
          name: "",
          price: 0.00,
          suggestedPrice: 0.00,
          price1: 0.00,
          price2: 0.00,
          price3: 0.00,
          categories: [],
          staircasePrices: [],
          startingAmount: "",
          skuID: "",
          year: "",
          season: "",
          placeOfOrigin: "",
          brand: "",
          style: {
            id: null,
            code: "",
            name: ""
          },
          material: "",
          content: "",
          belongTo: {
            uid: "",
            name: ""
          },
          postageFree: true,
          gramWeight: 0.0,
          variants: []
        });
      },
      onBatchLaunch() {
        if (this.multipleSelection.length < 1) {
          this.$message.info("请选择产品");

          return;
        }

        axios.put("/djbrand/product/shelf/list", this.codes)
          .then(() => {
            this.$message.success("批量上架成功");

            this.onSearch();
          }).catch(error => {
            this.$message.error("批量上架失败，原因：" + error.response.data);
          }
        );
      },
      onBatchWithdraw() {
        if (this.multipleSelection.length < 1) {
          this.$message.info("请选择产品");

          return;
        }

        axios.post("/djbrand/product/shelf/list", this.codes)
          .then(() => {
            this.$message.success("批量下架成功");

            this.onSearch();
          }).catch(error => {
            this.$message.error("批量下架失败，原因：" + error.response.data);
          }
        );
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

        axios.get("/djbrand/product", {
          params: params
        }).then(response => {
          this.page = response.data;
          console.log(this.page.content);
        }).catch(error => {
            this.$message.error(error.response.data);
          }
        );
      },
      _onAdvancedSearch(page, size) {
        const params = {
          page: page,
          size: size
        };

        axios.post("/djbrand/product/advancedSearch", this.query, {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
            this.$message.error(error.response.data);
          }
        );
      },
      onDeleted(row) {
        this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          axios.put("/djbrand/product/deleted/" + row.code)
            .then(() => {
              this.$message.success("删除产品成功，产品将在30天后彻底删除！");

              this.onSearch();
            }).catch(error => {
            this.$message({
              type: "error",
              message: "失败， 原因：" + error.response.data
            });
          });
        });
      },
      changeShelfStatus(row) {
        let request = axios.put;
        let message = "上架";
        if (row.approvalStatus === "approved") {
          request = axios.post;
          message = "下架";
        }

        request("/djbrand/product/shelf/" + row.code)
          .then(() => {
            this.$message.success(message + "成功");

            this.onSearch();
          }).catch(error => {
            this.$message({
              type: "error",
              message: message + "失败， 原因：" + error.response.data
            });
          }
        );
      },
      changeRecommendedStatus(row) {
        let request = axios.put;
        let message = "推荐";
        console.log(row);
        if (!row.recommended) {
          request = axios.post;
          message = "取消推荐";
        }

        request("/djbrand/product/recommended/" + row.code)
          .then(() => {
            this.$message.success(message + "成功");

            this.onSearch();
          }).catch(error => {
            this.$message({
              type: "error",
              message: message + "失败， 原因：" + error.response.data
            });
          }
        );
      },
      handleSelectionChange(val) {
        this.multipleSelection = val;
      },
      getCategories(query) {
        axios.get("/djbackoffice/product/category/cascaded")
          .then(response => {
            this.categories = response.data;
          }).catch(error => {
            this.$message.error(error.response.data);
          }
        );
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
      // 批量上下架code数组
      codes: function () {
        return this.multipleSelection.map((item, number, any) => {
          return item.code;
        });
      }
    },
    data() {
      return {
        text: "",
        query: {
          skuID: "",
          name: "",
          approvalStatuses: [],
          categories: []
        },
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        },
        advancedSearch: false,
        multipleSelection: [],
        categories: [],
        approvalStatuses: [{
          code: "approved",
          name: "上架"
        }, {
          code: "unapproved",
          name: "下架"
        }]
      };
    },
    created(){
      this.getCategories("");
    }
  };
</script>
