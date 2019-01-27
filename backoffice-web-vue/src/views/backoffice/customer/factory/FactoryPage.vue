<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入名称" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
        </el-button-group>
      </el-form>
      <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
        <el-table-column label="UID" prop="uid"></el-table-column>
        <el-table-column label="名称" prop="name"></el-table-column>
        <el-table-column label="联系电话" prop="contactPhone"></el-table-column>
        <el-table-column label="联系人" prop="contactPerson"></el-table-column>
        <el-table-column label="是否激活" prop="active">
          <template slot-scope="scope">
            <el-switch v-model="scope.row.active"
                       active-color="#13ce66"
                       inactive-color="#ff4949"
                       @change="changeActiveStatus(scope.row)">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">明细</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper" @size-change="onPageSizeChanged"
                      @current-change="onCurrentPageChanged" :current-page="page.number + 1" :page-size="page.size"
                      :page-count="page.totalPages" :total="page.totalElements">
      </el-pagination>
    </el-card>
  </div>
</template>

<script>
  import axios from "axios";
  import autoHeight from 'mixins/autoHeight'
  import {Bus} from "common";
  import ApprovalStatus from "components/custom/ApprovalStatus.vue";
  import {FactoryForm} from "./";
  import FactoryDetailsPage from "./FactoryDetailsPage";

  export default {
    name: "FactoryPage",
    mixins: [autoHeight],
    components: {FactoryForm, ApprovalStatus},
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onNew() {
        this.fn.openSlider("添加工厂", FactoryForm, {
          address: "",
          adeptAtCategories: [],
          contactPerson: "",
          contactPhone: "",
          id: null,
          latheQuantity: "",
          scaleRange: "",
          monthlyCapacityRange: "",
          cooperationModes: [],
          name: "",
          registrationDate: null,
          uid: "",
          taxNumber: "",
          bankOfDeposit: "",
          phone: "",
          cooperativeBrand: ""
        });
      },
      onDetails(item) {
        console.log(item);
        this.fn.openSlider("工厂明细", FactoryDetailsPage, item);
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
          .get("/djfactory/factory", {
            params: params
          })
          .then(response => {
            console.log(response.data);
            this.page = response.data;
          })
          .catch(error => {
            this.$message.error("获取数据失败");
          });
      },
      changeActiveStatus(row) {
        axios
          .delete("/djfactory/factory/" + row.uid)
          .then(response => {
            if (row.active) {
              this.$message({
                type: "success",
                message: "激活成功"
              });
            } else {
              this.$message({
                type: "success",
                message: "禁用成功"
              });
            }
          })
          .catch(error => {
            row.active = !row.active;
            if (row.active) {
              this.$message({
                type: "error",
                message: "激活失败"
              });
            } else {
              this.$message({
                type: "error",
                message: "禁用失败"
              });
            }
          });
      }
    },
    mounted: function () {
      this.$nextTick(function () {
        this._onSearch(0, this.page.size);
        Bus.$on("refreshVal", data => {
          this._onSearch(0, this.page.size);
        });
      });
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
