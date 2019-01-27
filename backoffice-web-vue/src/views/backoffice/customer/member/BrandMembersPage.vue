<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" height="480">
      <el-table-column type="expand">
        <template slot-scope="scope">
          <brand-member-detail :slotData="scope.row.customers"/>
        </template>
      </el-table-column>
      <el-table-column label="品牌UID" prop="uid"></el-table-column>
      <el-table-column label="品牌名称" prop="name"></el-table-column>
    </el-table>
     <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                    @size-change="onPageSizeChanged"
                    @current-change="onCurrentPageChanged"
                    :current-page="page.number + 1"
                    :page-size="page.size"
                    :page-count="page.totalPages"
                    :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  import axios from "axios";
  import Bus from "common/js/bus.js";
  import BrandMemberDetail from "./BrandMemberDetail.vue";

  export default {
    name: "BrandMember",
    components: {
      BrandMemberDetail
    },
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
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
          name: this.text,
          page: page,
          size: size
        };
        axios.get("/djbrand/membership", {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
          this.$message.error("获取数据失败");
        });
      }
    },
    mounted: function () {
      this.$nextTick(function () {
        this._onSearch(0, this.page.size);
        Bus.$on("refreshVal", data => {
          this._onSearch(0, this.page.size);
        });
      });
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

