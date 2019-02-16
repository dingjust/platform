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
      <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
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
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('UserGroupsModule');

  import autoHeight from 'mixins/autoHeight'

  import GroupForm from "./GroupForm";
  import GroupDetailsPage from "./GroupDetailsPage";

  export default {
    name: "GroupPage",
    mixins: [autoHeight],
    computed: {
      ...mapGetters({
        page: "page"
      })
    },
    methods: {
      ...mapActions({
        search: "search"
      }),
      onSearch() {
        this._onSearch(0);
      },
      onNew() {
        this.fn.openSlider("创建用户组", GroupForm, this.formData);
      },
      onDetails(item) {
        this.fn.openSlider("用户组明细", GroupDetailsPage, item);
      },
      onPageSizeChanged(val) {
        this.reset();
        this._onSearch(0, val);
      },
      onCurrentPageChanged(val) {
        this._onSearch(val - 1);
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      _onSearch(page, size) {
        const keyword = this.text;
        this.search({keyword, page, size});
      }
    },
    data() {
      return {
        text: this.$store.state.UserGroupsModule.keyword,
        formData: this.$store.state.UserGroupsModule.formData,
      }
    },
    created() {
      this.onSearch();
    },
  }
</script>
