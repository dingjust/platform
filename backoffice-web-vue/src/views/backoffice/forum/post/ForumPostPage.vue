<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="">
          <el-input placeholder="请输入标题查询" v-model="text"></el-input>
        </el-form-item>
        <el-button-group>
          <el-button type="primary" icon="el-icon-search" @click="onSearch"></el-button>
        </el-button-group>
      </el-form>
      <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
        <el-table-column label="标题" prop="title"></el-table-column>
        <el-table-column label="帖子类别" prop="category.name"></el-table-column>
        <el-table-column label="帖子状态" prop="status">
          <template slot-scope="scope">
            <span>{{scope.row.status | enumTranslate('ForumPostStatus')}}</span>
          </template>
        </el-table-column>
        <el-table-column label="发布人" prop="user.name"></el-table-column>
        <el-table-column label="发布时间" prop="publishDate">
          <template slot-scope="scope">
            <span>{{scope.row.publishDate | formatDate}}</span>
          </template>
        </el-table-column>
        <el-table-column label="是否置顶" prop="topped">
          <template slot-scope="scope">
            <el-switch disabled
                       v-model="scope.row.topped"
                       active-color="#13ce66"
                       inactive-color="#ff4949">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column label="是否精华帖" prop="distillated">
          <template slot-scope="scope">
            <el-switch disabled
                       v-model="scope.row.distillated"
                       active-color="#13ce66"
                       inactive-color="#ff4949">
            </el-switch>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope ">
            <el-button type="text " icon="el-icon-edit " @click="onDetails(scope.row)">
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
  import axios from "axios";
  import autoHeight from 'mixins/autoHeight'
  import ForumPostDetailsPage from "./ForumPostDetailsPage";

  export default {
    name: "ForumPostPage",
    mixins: [autoHeight],
    components: {},
    methods: {
      onSearch() {
        this._onSearch(0, this.page.size);
      },
      onDetails(item) {
        this.fn.openSlider("帖子明细", ForumPostDetailsPage, item);
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
        axios.get("/djforum/post", {
          params: params
        }).then(response => {
          this.page = response.data;
        }).catch(error => {
          this.$message.error("获取数据失败，原因：" + error.response.data);
        });
      }
    },
    computed: {},
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
