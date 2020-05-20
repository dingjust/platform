<template>
  <div class="animated fadeIn">
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <el-col :span="18">
          <el-form-item label="">
            <el-input placeholder="方案名称" v-model="queryFormData.keyword"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
            <el-button native-type="reset" @click="queryFormData.keyword=''">重置</el-button>
          </el-button-group>
        </el-col>
        <el-col :span="6">
          <el-button type="primary" class="toolbar-search_input" @click="onSure">确定</el-button>
        </el-col>
      </el-row>
    </el-form>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" highlight-current-row
              @current-change="handleCurrentChange" :row-key="getRowKeys">
      <el-table-column label="方案名称" prop="name"></el-table-column>
      <el-table-column label="节点数" prop="payPlanType">
        <template slot-scope="scope">
          <span>{{scope.row.productionProgresses.length}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" prop="creationtime">
        <template slot-scope="scope">
          <span> {{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{scope.row.eable ? '启用' : '禁用'}}</span>
        </template>
      </el-table-column>
<!--      <el-table-column label="操作" min-width="100">-->
<!--        <template slot-scope="scope">-->
<!--          <el-row>-->
<!--            &lt;!&ndash;            <el-button type="text" @click="onDetail(scope.row)" class="cooperator-list-button">查看</el-button>&ndash;&gt;-->
<!--            &lt;!&ndash;              <el-divider direction="vertical"></el-divider>&ndash;&gt;-->
<!--            <el-button type="text" @click="onEdit(scope.row)" class="cooperator-list-button">编辑</el-button>-->
<!--            <el-divider direction="vertical"></el-divider>-->
<!--            <el-button type="text" @click="onEnable(scope.row)" class="cooperator-list-button">-->
<!--              {{scope.row.eable ? '禁用' : '启用'}}-->
<!--            </el-button>-->
<!--            <el-divider direction="vertical"></el-divider>-->
<!--            <el-button type="text" @click="onDelete(scope.row)" class="cooperator-list-button">删除</el-button>-->
<!--          </el-row>-->
<!--        </template>-->
<!--      </el-table-column>-->
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                   :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  export default {
    name: 'ProgressPlanSelectDialog',
    methods: {
      async onSearch (page, size) {
        const url = this.apis().getProgressPlan();
        const result = await this.$http.post(url, this.queryFormData, {
          page: page,
          size: size
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.page = result;
      },
      createNode () {
        this.$router.push('/account/setting/progress-plan/create');
      },
      onPageSizeChanged (val) {
        this.onSearch(0, val);
      },
      onCurrentPageChanged (val) {
        this.onSearch(val - 1);
      },
      getRowKeys (row) {
        return row.id;
      },
      handleCurrentChange (newRow, oldRow) {
        this.multipleSelection = newRow;
      },
      onSure () {
        this.$emit('getProgressPlan', this.multipleSelection);
      }
    },
    data () {
      return {
        multipleSelection: '',
        page: {},
        queryFormData: {
          keyword: ''
        }
      }
    },
    created() {
      this.onSearch();
    }
  }
</script>

<style scoped>
  .toolbar-search_input{
    background-color: #ffd60c;
    border-color: #ffd60c;
  }
</style>
