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
  import { createNamespacedHelpers } from 'vuex';
  const { mapGetters, mapActions } = createNamespacedHelpers('StylesModule');

  import axios from "axios";
  import autoHeight from 'mixins/autoHeight'
  import StyleForm from "./StyleForm";
  import StyleDetailsPage from "./StyleDetailsPage";

  export default {
    name: "StylePage",
    mixins: [autoHeight],
    methods: {
      ...mapActions({
        search: "search"
      }),
      onSearch() {
        this._onSearch(0);
      },
      onNew() {
        this.fn.openSlider('新增', StyleForm, {
          id: null,
          code: "",
          name: "",
          description: "",
          sequence: 0,
          active: true
        });
      },
      onDetails(item) {
        this.fn.openSlider('明细', StyleDetailsPage, item);
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
      onUpdate(item) {
        axios.put("/djbackoffice/product/style", item)
          .then(() => {
            this.$message.success("保存成功");
          }).catch(error => {
            this.$message.error(error.response.data);
          }
        );
      }
    },
    computed: {
      ...mapGetters({
        page: "page",
      }),
    },
    data() {
      return {
        text: this.$store.state.StylesModule.keyword,
      }
    }
  }
</script>
