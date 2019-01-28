<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe :data="page.content">
        <el-table-column label="品牌商" prop="company.name"></el-table-column>
        <el-table-column label="会员名称" prop="customer.name"></el-table-column>
        <el-table-column label="手机号码" prop="customer.cellphone"></el-table-column>
        <el-table-column label="电子邮箱" prop="customer.email"></el-table-column>
        <el-table-column label="会员等级">
          <template slot-scope="scope">
            <span>{{scope.row.level | enumTranslate('MemberRating')}}</span>
          </template>
        </el-table-column>
        <el-table-column label="生效日期">
          <template slot-scope="scope">
            <span>{{scope.row.effectiveDate | formatDate}}</span>
          </template>
        </el-table-column>
        <el-table-column label="失效日期">
          <template slot-scope="scope" v-if="!scope.row.expiredDate===null">
            <span>{{scope.row.expiredDate | formatDate}}</span>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper" @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1" :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
      </el-pagination>
    </el-card>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "MembershipPage",
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
        text: this.text,
        page: page,
        size: size
      };

      axios
        .get("/djbackoffice/membership", {
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
