<template>
  <div class="back-temp-list">
    <el-table ref="resultTable" :data="page.content" stripe :height="autoHeight">
      <el-table-column label="模板名称" prop="title" />
      <el-table-column label="模板类型">
        <template slot-scope="scope">
          {{getEnum('TemplateType', scope.row.type)}}
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="available" >
        <template slot-scope="scope">
          <span>{{scope.row.available ? '可用' : '不可用'}}</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="创建时间" >
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column> -->
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">查看</el-button>
          <el-button type="text" @click="onEdit(scope.row)">编辑</el-button>
          <!-- <el-button type="text" @click="onDelete(scope.row)">删除</el-button> -->
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged"
      @current-change="onCurrentPageChanged"
      :current-page="page.number + 1"
      :page-size="page.size"
      :page-count="page.totalPages"
      :total="page.totalElements">
    </el-pagination>
    <el-dialog :title="dialogTitle" :visible.sync="tempVisible" width="80%" append-to-body
      :close-on-click-modal="false">
      <template v-if="showContent === 'DETAIL'">
        <contract-back-temp-detail v-if="detail.id" :detail="detail"/>
      </template>  
      <template v-else>
        <contract-back-temp-form v-if="detail.id" :detail="detail" @callback="onDetail"/>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import ContractBackTempDetail from '../detail/ContractBackTempDetail'
import ContractBackTempForm from '../form/ContractBackTempForm'

export default {
  name: 'ContractBackTempList',
  props: ['page'],
  components: {
    ContractBackTempDetail,
    ContractBackTempForm
  },
  data () {
    return {
      detail: {},
      dialogTitle: '',
      showContent: 'DETAIL',
      tempVisible: false
    }
  },
  methods: {
    async getDetail (code) {
      const url = this.apis().getContractTempOnPlatform(code);
      const result = await this.$http.get(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }

      this.detail = result.data;
      if (!result.data.content) {
        this.detail.content = '';
      }
    },
     onDetail (row) {
      this.detail = {};
      this.getDetail(row.code)

      this.dialogTitle = row.title + '模板';
      this.showContent = 'DETAIL';
      this.tempVisible = true;
    },
    onEdit (row) {
      this.detail = {};
      this.getDetail(row.code)

      this.dialogTitle = '修改' + row.title + '模板';
      this.showContent = 'FORM';
      this.tempVisible = true;
    },
    async onDelete (row) {
      const url = this.apis().deleteContractTempOnPlatform(row.code);
      const result = await this.$http.get(url);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }

      this.$emit('onSearch');
    },
    onPageSizeChanged (size) {
      this.$emit('onSearch', 0, size);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      })
    },
    onCurrentPageChanged (page) {
      this.$emit('onSearch', page);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      })
    }
  }
}
</script>

<style scoped>

</style>