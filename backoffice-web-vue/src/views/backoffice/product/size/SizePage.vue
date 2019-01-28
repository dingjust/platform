<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
          <el-button type="primary" icon="el-icon-plus" @click="onNew">新增</el-button>
        </el-button-group>
      </el-form>
      <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
        <el-table-column prop="code" label="编码"></el-table-column>
        <el-table-column prop="name" label="名称"></el-table-column>
        <el-table-column prop="active" label="是否启用">
          <template slot-scope="scope">
            <el-switch active-color="#13ce66"
                       inactive-color="#ff4949"
                       v-model="scope.row.active"
                       @change="onUpdate(scope.row)">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column prop="sequence" label="序列值">
          <template slot-scope="scope">
            <el-input-number v-model="scope.row.sequence"
                             :precision="0"
                             :min="0"
                             @change="onUpdate(scope.row)">
            </el-input-number>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">明细</el-button>
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
  import axios from "axios";
  import autoHeight from 'mixins/autoHeight'
  import SizeForm from "./SizeForm";
  import SizeDetailsPage from "./SizeDetailsPage";

  export default {
    name: "SizePage",
    mixins: [autoHeight],
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onNew() {
        this.fn.openSlider('新增', SizeForm, {
          id: null,
          code: "",
          name: "",
          description: "",
          sequence: 0,
          active: true
        });
      },
      onDetails(item) {
        this.fn.openSlider('明细', SizeDetailsPage, item);
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

        axios.get("/djbackoffice/product/size", {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
          this.$message.error(error.response.data);
        });
      },
      onUpdate(item) {
        axios.put("/djbackoffice/product/size", item)
          .then(() => {
            this.$message.success("保存成功");
          }).catch(error => {
            this.$message.error(error.response.data);
          }
        );
      }
    },
    watch: {
      '$store.state.sideSliderState': function (value) {
        if (!value) {
          this.onSearch();
        }
      }
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
      }
    }
  }
</script>
