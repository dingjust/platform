<template>
  <div>
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="会员UID" prop="customerUid"></el-table-column>
      <el-table-column label="会员名称" prop="customerName"></el-table-column>
      <el-table-column label="单位UID" prop="unitUid"></el-table-column>
      <el-table-column label="单位名称" prop="unitName"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="success" plain @click="onApprove(scope.row)">同意</el-button>
          <el-button type="danger" plain @click="onReject(scope.row)">拒绝</el-button>
        </template>
      </el-table-column>
    </el-table>
     <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper" @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged " :current-page="page.number + 1" :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
import axios from "axios";
import autoHeight from 'mixins/autoHeight'
import Bus from "common/js/bus.js";

export default {
  name: "ApplicationList",
  mixins: [autoHeight],
  methods: {
    onApprove(row) {
      // 调用审核通过接口
      this.$confirm("确认会员申请, 是否继续?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(() => {
        axios
          .post("/djbackoffice/memberRequest/approve", {
            customerUid: row.customerUid,
            unitUid: row.unitUid
          })
          .then(response => {
            this.$message({
              type: "success",
              message: "确认成功"
            });
            this._onSearch(0, this.page.size);
            Bus.$emit("refreshVal", "");
          })
          .catch(error => {
            this.$message({
              type: "error",
              message: "通过失败"
            });
          });
      });
    },
    onReject(row) {
      //调用审核拒绝接口
      this.$prompt("请输入拒绝原因", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消"
      }).then(({ value }) => {
        axios
          .put("/djbackoffice/memberRequest/reject", {
            customerUid: row.customerUid,
            unitUid: row.unitUid,
            message: value
          })
          .then(response => {
            this.$message({
              type: "success",
              message: "拒绝成功"
            });
            this._onSearch(0, this.page.size);
            Bus.$emit("refreshVal", "");
          })
          .catch(error => {
            this.$message({
              type: "error",
              message: "拒绝失败"
            });
          });
      });
    },
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
      axios
        .get("/djbackoffice/memberRequest", {
          params: params
        })
        .then(response => {
          this.page = response.data;
        })
        .catch(error => {
          this.$message.error("获取数据失败");
        });
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
  },
  mounted: function() {
    this.$nextTick(function() {
      this._onSearch(0, this.page.size);
    });
  }
};
</script>

