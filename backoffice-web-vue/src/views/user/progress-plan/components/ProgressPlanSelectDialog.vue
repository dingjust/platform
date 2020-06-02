<template>
  <div class="animated fadeIn">
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <el-col :span="20">
          <el-form-item label="">
            <el-input placeholder="方案名称" v-model="queryFormData.keyword"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button type="primary" class="toolbar-search_input" @click="onSearch">搜索</el-button>
            <el-button native-type="reset" @click="queryFormData.keyword=''">重置</el-button>
          </el-button-group>
          <el-button type="primary" class="toolbar-search_input" @click="onNew">新建节点</el-button>
        </el-col>
        <el-col :span="4">
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
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                   :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-dialog :visible.sync="appendVisible" class="purchase-dialog" width="80%" append-to-body :close-on-click-modal="false">
      <progress-plan-form-info v-if="appendVisible" ref="infoForm" @onSubmit="onSubmit"
                               :form-data="formData" :fromDialog="true"/>
    </el-dialog>
  </div>
</template>

<script>
  import ProgressPlanFormInfo from '../form/ProgressPlanFormInfo';
  export default {
    name: 'ProgressPlanSelectDialog',
    components: {ProgressPlanFormInfo},
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
      },
      onNew () {
        this.appendVisible = true;
      },
      onSubmit () {
        this.$refs['infoForm'].$refs['form'].validate(valid => {
          if (valid) {
            this._onSubmit();
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      async _onSubmit () {
        const data = {
          id: this.formData.id ? this.formData.id : null,
          name: this.formData.name,
          remarks: this.formData.remarks,
          productionProgresses: this.formData.productionProgresses
        }
        const url = this.apis().createProgressPlan();
        const result = await this.$http.post(url, data);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success(this.formData.id ? '添加节点成功' : '编辑节点成功');
        this.appendVisible = false;
        await this.onSearch();
      }
    },
    data () {
      return {
        appendVisible: false,
        multipleSelection: '',
        page: {},
        queryFormData: {
          keyword: ''
        },
        formData: {
          name: '',
          remarks: '',
          productionProgresses: []
        }
      }
    },
    created () {
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
