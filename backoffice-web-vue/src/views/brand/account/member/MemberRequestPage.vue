<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content">
      <el-table-column label="会员UID" prop="customer.uid"></el-table-column>
      <el-table-column label="会员名称" prop="customer.name"></el-table-column>
      <el-table-column label="会员手机号" prop="customer.mobileNumber"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="success" plain @click="onApprove(scope.row)">同意</el-button>
          <el-button type="danger" plain @click="onReject(scope.row)">拒绝</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class=" pt-2 "></div>
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
    <div class="clearfix"></div>
  </div>
</template>

<script>
  import axios from "axios";

  export default {
    name: "MemberRequestPage",
    props: ["slotData"],
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
          page: page,
          size: size
        };
        axios.get("/djbrand/memberRequest", {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(() => {
          this.$message.error("获取数据失败");
        });
      },
      onApprove(row) {
        // 调用审核通过接口
        this.$confirm("确认会员申请, 是否继续?", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }).then(() => {
          axios.put("/djbrand/memberRequest/approve", {
            customer: {uid: row.customer.uid},
            company: {uid: row.company.uid}
          }).then(() => {
            this.$message.success("确认成功");
            this._onSearch(0, this.page.size);
          }).catch(() => {
            this.$message.error("通过失败");
          });
        });
      },
      onReject(row) {
        //调用审核拒绝接口
        this.$prompt("请输入拒绝原因", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消"
        }).then(({value}) => {
          axios.put("/djbrand/memberRequest/reject", {
            customer: {uid: row.customer.uid},
            company: {uid: row.company.uid},
            remarks: value
          }).then(response => {
            this.$message.success("拒绝成功");
            this._onSearch(0, this.page.size);
          }).catch(() => {
            this.$message.error("拒绝失败");
          });
        });
      }
    },
    mounted: function () {
      this.$nextTick(function () {
        this._onSearch(0, this.page.size);
      });
    }
  };
</script>

