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
      <el-table stripe :data="page.content">
        <el-table-column label="会员名称" prop="name"></el-table-column>
        <el-table-column label="手机号码" prop="mobileNumber"></el-table-column>
        <el-table-column label="电子邮箱" prop="email"></el-table-column>
      </el-table>
      <div class="pt-2"></div>
      <div class="float-right">
        <el-pagination layout="total, sizes, prev, pager, next, jumper" @size-change="onPageSizeChanged"
                       @current-change="onCurrentPageChanged" :current-page="page.number + 1" :page-size="page.size"
                       :page-count="page.totalPages" :total="page.totalElements">
        </el-pagination>
      </div>
      <div class="clearfix"></div>
    </el-card>
  </div>
</template>

<script>
  import axios from "axios";

  export default {
    name: "MyFollowersPage",
    props: [],
    components: {},
    computed: {},
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      _onSearch(page, size) {
        const params = {
          text: this.text,
          page: page,
          size: size
        };
        axios.get("/djbrand/follower", {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
          this.$message.error("获取数据失败");
        });
      }
    },
    created() {
      this._onSearch(0, this.page.size);
    },
    data() {
      return {
        text:"",
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
