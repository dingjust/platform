<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入员工编码/姓名" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
        </el-button-group>
      </el-form>
      <el-table ref="resultTable" stripe :data="page.content"
                v-if="isHeightComputed" :height="autoHeight">
        <el-table-column label="账户ID" prop="uid"></el-table-column>
        <el-table-column label="姓名" prop="name"></el-table-column>
        <el-table-column label="电话号码" prop="mobileNumber"></el-table-column>
        <el-table-column label="激活状态">
          <template slot-scope="scope">
            <el-switch active-color="#ff4949" inactive-color="#13ce66"
                       v-model="scope.row.loginDisabled"
                       @change="changeActiveStatus(scope.row)">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">
              明细
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pt-2"></div>
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
      <div class="clearfix"></div>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandEmployeesModule');

  import autoHeight from 'mixins/autoHeight';

  import {EmployeeForm} from './';
  import EmployeeDetailsPage from './EmployeeDetailsPage';

  export default {
    name: 'EmployeePage',
    mixins: [autoHeight],
    computed: {
      ...mapGetters({
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search'
      }),
      onSearch() {
        this._onSearch(0);
      },
      onNew() {
        this.fn.openSlider('添加员工', EmployeeForm, this.formData);
      },
      onDetails(item) {
        this.fn.openSlider('员工明细', EmployeeDetailsPage, item);
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
      },
      async changeActiveStatus(row) {
        const result = this.$http.put('/djbrand/user/active', {
          uid: row.uid
        });

        if (result['errors']) {
          this.$message.error('修改失败，原因：' + result['errors'][0].message);
          return;
        }

        this.onSearch();
        this.$message.success('修改成功');
      }
    },
    data() {
      return {
        text: this.$store.state.BrandEmployeesModule.keyword,
        formData: this.$store.state.BrandEmployeesModule.formData
      };
    },
    created() {
      this.search({keyword: '', page: 0});
    }
  };
</script>
