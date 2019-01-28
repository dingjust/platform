<template>
  <div class="animated fadeIn">
    <el-table stripe :data="page.content">
      <el-table-column label="会员名称" prop="customer.name"></el-table-column>
      <el-table-column label="手机号码" prop="customer.mobileNumber"></el-table-column>
      <el-table-column label="电子邮箱" prop="customer.email"></el-table-column>
      <el-table-column label="会员等级" prop="level"></el-table-column>
      <el-table-column label="生效日期">
        <template slot-scope="scope">
          <span>{{scope.row.effectiveDate | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="失效日期">
        <template slot-scope="scope" v-if="!scope.row.expiredDate === null">
          <span>{{scope.row.expiredDate | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="danger" plain @click="onRelieve(scope.row)">移除会员</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <div class="float-right">
      <el-pagination layout="total, sizes, prev, pager, next, jumper" @size-change="onPageSizeChanged"
                     @current-change="onCurrentPageChanged" :current-page="page.number + 1" :page-size="page.size"
                     :page-count="page.totalPages" :total="page.totalElements">
      </el-pagination>
    </div>
    <div class="clearfix"></div>
  </div>
</template>

<script>
  import axios from "axios";

  export default {
    name: "MembersPage",
    props: ["slotData"],
    methods: {
      onPageSizeChanged(val) {
        this.reset();

        this.page.size = val;
        this._onSearch(0, val);
      },
      onCurrentPageChanged(val) {
        this._onSearch(val - 1, this.page.size);
      },
      _onSearch(page, size) {
        const params = {
          text: "",
          page: page,
          size: size
        };
        axios.get("/djbrand/membership", {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
          this.$message.error(error.response.data);
        });
      },
      onRelieve(row) {
        // 调用审核拒绝接口
        this.$confirm("确认移除会员, 是否继续?", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }).then(() => {
          axios
            .delete("/djbrand/membership", {
              params: {
                customerUid: row.customer.uid
              }
            })
            .then(response => {
              this.$message({
                type: "success",
                message: "移除成功"
              });
              this._onSearch(0, this.page.size);
            })
            .catch(error => {
              this.$message({
                type: "error",
                message: "移除失败"
              });
            });
        });
      }
    },
    data() {
      return {
        page: {
          number: 0, // 当前页，从0开始
          size: 10, // 每页显示条数
          totalPages: 1, // 总页数
          totalElements: 0, // 总数目数
          content: [] // 当前页数据
        }
      };
    },
    mounted: function () {
      this.$nextTick(function () {
        this._onSearch(0, this.page.size);
      });
    }
  };
</script>
