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
      <el-table ref="resultTable" stripe :data="page.content">
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
  import axios from 'axios';

  import {EmployeeForm} from './';
  import EmployeeDetailsPage from './EmployeeDetailsPage';

  export default {
    name: 'EmployeePage',
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onNew() {
        this.fn.openSlider('添加员工', EmployeeForm, {
          id: null,
          uid: '',
          name: '',
          mobileNumber: '',
          password: '',
          confirmPassword: '',
          roles: []
        });
      },
      onDetails(item) {
        this.fn.openSlider('员工明细', EmployeeDetailsPage, item);
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
        axios.get('/djfactory/employee', {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
          this.$message.error('获取数据失败');
        });
      },
      changeActiveStatus(row) {
        axios.put('/djfactory/user/active', {
          uid: row.uid
        }).then(() => {
          this.onSearch();
          this.$message.success('修改成功');
        }).catch(error => {
          this.$message.error('修改失败，原因：' + error.response.data);
        });
      }
    },
    watch: {
      '$store.state.sideSliderState': function (value) {
        if (!value) {
          this.onSearch();
        }
      }
    },
    mounted: function () {
      this.$nextTick(function () {
        this._onSearch(0, this.page.size);
      });
    },
    data() {
      return {
        text: '',
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
