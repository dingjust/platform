<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入描述查询" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
        </el-button-group>
      </el-form>
      <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
        <el-table-column label="图片" prop="url">
          <template slot-scope="scope">
            <img :src="scope.row.url" width="60" height="60"></img>
          </template>
        </el-table-column>
        <el-table-column label="url" prop="url" width="800"></el-table-column>
        <el-table-column label="描述" prop="description"></el-table-column>
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

  export default {
    name: "SystemMediaPage",
    mixins: [autoHeight],
    components: {},
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onPageSizeChanged(val) {
        //this.reset();
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
        axios.get("/djbackoffice/system/media", {
          params: params
        }).then(response => {
          console.log(response.data);
          this.page = response.data;
        }).catch(error => {
          this.$message.error("获取数据失败");
        });
      },

    },
    created(){
      this.onSearch();
    },
    computed: {
    },
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
        },
      }
    }
  }
</script>
