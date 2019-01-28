<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入名称查询" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
        </el-button-group>
      </el-form>
      <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
        <el-table-column label="店铺编码" prop="company"></el-table-column>
        <el-table-column label="类型" prop="type"></el-table-column>
        <el-table-column label="分组" prop="group"></el-table-column>
        <el-table-column label="产品数" prop="amount"></el-table-column>
        <el-table-column label="操作" prop="operation">
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

  export default {
    name: "BrandProductsPage",
    mixins: [autoHeight],
    components: {},
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onDetails(item) {
        console.log(item);
        // this.fn.openSlider("图片详情", CollectionsDetailsPage, item);
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
          group: "G01",
          type: "PRODUCT_VOLUME_BY_BRAND",
          text: this.text,
          page: page,
          size: size,
        };
        axios.get("/djbackoffice/report/statistics/type",{
          params: params,
        })
          .then(response => {
          this.page = response.data;
          console.log(this.page.content);
        }).catch(error => {
          this.$message.error("获取数据失败：" + error.response.data);
        });
      },
    },
    computed: {},
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
        items: [],
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        }
      }
    }
  }
</script>
