<!--
* @Description: 渠道码选择页面（ FactoryPage选择使用（单选）
* @Date 2021/05/21 09:36
* @Author L.G.Y
-->
<template>
  <div class="recommend-code">
    <el-row>
      <div class="recommend-code-title">
        <h6>渠道码</h6>
      </div>
    </el-row>
    <div class="pt-2"></div>
    <recommend-code-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch" @onCreate="onCreate"/>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" current-row-key="id"  highlight-current-row @current-change="handleCurrentChange">
      <el-table-column label="标题" prop="title"></el-table-column>
      <el-table-column label="备注" prop="remark"></el-table-column>
      <el-table-column label="url" prop="url"></el-table-column>
      <el-table-column label="编号" prop="code"></el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-row type="flex" justify="center">
      <el-button type="primary" size="medium" @click="onConfirm">确定</el-button>
    </el-row>
    <el-dialog :title="dialogTitle" :visible.sync="appendVisible" width="400px" append-to-body :close-on-click-modal="false">
      <recommend-code-form v-if="appendVisible" :id="editId" @closeDialog="appendVisible=false" @callback="callback"/>
    </el-dialog>
  </div>
</template>

<script>
import RecommendCodeToolbar from '../toolbar/RecommendCodeToolbar'
import RecommendCodeForm from '../form/RecommendCodeForm'

export default {
  name: 'RecommendCodeSelectPage',
  components: { RecommendCodeToolbar, RecommendCodeForm },
  methods: {
    async onAdvancedSearch(page, size) {
      const query = this.queryFormData;
      
      const url = this.apis().searchRecommendCode();
      const result = await this.$http.post(url, query, {
        page: page,
        size: size
      });

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      this.page = result;
    },
    onPageSizeChanged(val) {
      this.onAdvancedSearch(0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged(val) {
      this.onAdvancedSearch(val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCreate () {
      this.dialogTitle = '新增渠道码';
      this.editId = null;
      this.appendVisible = true;
    },
    callback () {
      this.onAdvancedSearch();
      this.appendVisible = false;
    },
    handleCurrentChange (val) {
      this.currentRow = val;
    },
    onConfirm () {
      this.$emit('setRecommend', this.currentRow);
    }
  },
  data () {
    return {
      page: {
        number: 0, // 当前页，从0开始
        size: 10, // 每页显示条数
        totalPages: 1, // 总页数
        totalElements: 0, // 总数目数
        content: [] // 当前页数据
      },
      queryFormData: {
        keyword: ''
      },
      appendVisible: false,
      dialogTitle: '',
      currentRow: null
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>
.recommend-code-title {
  border-left: 2px solid #ffd60c;
  padding-left: 10px;
}
</style>