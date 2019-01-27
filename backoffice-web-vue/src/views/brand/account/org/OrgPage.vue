<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入名称查询" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe :data="page.content">
        <el-table-column label="UID" prop="uid"></el-table-column>
        <el-table-column label="名称" prop="name"></el-table-column>
        <el-table-column label="描述" prop="comment"></el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope ">
            <el-button type="text " icon="el-icon-edit " @click="onDetails(scope.row) ">
              明细
            </el-button>
            <el-button type="text " icon="el-icon-edit " @click="onAddChrild(scope.row) ">
              添加子部门
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
  import OrgForm from "./OrgForm";
  import OrgDetailsPage from "./OrgDetailsPage";

  export default {
    name: "OrgPage",
    components: {},
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onNew() {
        this.fn.openSlider("创建部门", OrgForm, {
          uid: "",
          name: "",
          comment: "",
          active: true
        });
      },
      onDetails(item) {
        console.log(item);
        this.fn.openSlider("部门明细", OrgDetailsPage, item);
      },
      onAddChrild(item) {
        this.fn.openSlider("创建部门", OrgForm, {
          uid: "",
          name: "",
          comment: "",
          active: true,
          path: item.path,
          parent: item.name
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
        axios.get("/djbrand/org", {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
          this.$message.error("获取数据失败");
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
