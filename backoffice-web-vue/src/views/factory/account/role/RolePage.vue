<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入名称查询" v-model="keyword"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe :data="page.content">
        <el-table-column label="UID" prop="uid"></el-table-column>
        <el-table-column label="名称" prop="name"></el-table-column>
        <el-table-column label="描述" prop="description"></el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope ">
            <el-button type="text " icon="el-icon-edit " @click="onDetails(scope.row) ">
              明细
            </el-button>
          </template>
        </el-table-column>
      </el-table>
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
    </el-card>
  </div>
</template>

<script>
  import axios from "axios";
  import RoleForm from "./RoleForm";
  import RoleDetailsPage from "./RoleDetailsPage";

  export default {
    name: "RolePage",
    components: {},
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onNew() {
        this.fn.openSlider("创建角色", RoleForm, {
          id: null,
          uid: "",
          name: "",
          description: ""
        });
      },
      onDetails(item) {
        axios.get("/djfactory/role/" + item.uid + "/perms")
          .then(response => {
            this.$set(item, "perms", response.data);
            /*this.$set(item, "perms", [{
              id: null,
              code: "PM00010203",
              name: "生产订单",
              children: []
            }]);*/

            this.fn.openSlider("角色明细", RoleDetailsPage, item);
          }).catch(error => {
            this.$message.error("获取数据失败，原因：" + error.response.data);
          }
        );
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
          text: this.keyword,
          page: page,
          size: size
        };
        axios.get("/djfactory/role", {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
          this.$message.error("获取数据失败，原因：" + error.response.data);
        });
      }
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
        keyword: "",
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
