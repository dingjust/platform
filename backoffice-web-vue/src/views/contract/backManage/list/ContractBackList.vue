<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="合同名称" prop="title" show-overflow-tooltip min-width="130"/>
      <el-table-column label="合同编号" prop="code" min-width="120"></el-table-column>
      <el-table-column label="甲方" prop="partyA.name" show-overflow-tooltip min-width="180"></el-table-column>
      <el-table-column label="乙方" prop="partyB.name" show-overflow-tooltip min-width="180"></el-table-column>
      <el-table-column label="创建时间" min-width="80">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="合同类型" min-width="90">
        <template slot-scope="scope">
          <span>{{getEnum('TemplateType', scope.row.type)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="当前状态" min-width="90">
        <template slot-scope="scope">
          {{getEnum('contractStates', scope.row.state)}}
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="120px">
        <template slot-scope="scope">
          <el-button type="text" @click="previewPdf(scope.row,'')">查看</el-button>
          <el-button type="text" @click="onRefresh(scope.row)">重新下载</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-dialog :visible.sync="pdfVisible" :show-close="true" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <contract-preview-pdf :fileUrl="fileUrl" :slotData="thisContract" @closePdfVisible="pdfVisible=false" @onSearch="onSearch"/>
    </el-dialog>
  </div>  
</template>

<script>
import ContractPreviewPdf from '../../manage/components/ContractPreviewPdf'
export default {
  name: 'ContractBackList',
  props: ['page'],
  components: {
    ContractPreviewPdf
  },
  data () {
    return {
      isMore: true,
      pdfVisible: false,
      fileUrl: '',
      thisContract: '',
    }
  },
  methods: {
    isShowMore(codes) {
      if (codes.length > 5) {
        return true;
      } else {
        return false;
      }
    },
    turnIsMore() {
      this.isMore = !this.isMore;
    },
    async previewPdf (val, code) {
      this.thisContract = val;
      let queryCode = '';
      if (code != null && code != '') {
        queryCode = code;
      } else {
        queryCode = val.code;
      }
      const url = this.apis().downContract(queryCode);
      const result = await this.$http.get(url);

      const aa = '/b2b/user/agreement/download/' + result.data;

      this.fileUrl = encodeURIComponent(aa)
      this.pdfVisible = true;
    },
    onRefresh (row) {
      this.$confirm('是否要重新下载合同?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onRefresh(row);
      });
    },
    async _onRefresh (row) {
      const url = this.apis().onRefreshDownloadContract();
      const result = await this.$http.get(url, {
        pk: row.id,
        errorCode: 'DOWNLOAD',
        module: 'UserAgreement',
        companyCode: row.partyA.uid
      });

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.$message.success('操作成功！');
        this.onSearch();
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败！');
      }
    },
    onPageSizeChanged(val) {
      this.$emit('onAdvancedSearch', 0, val);
      
      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      })
    },
    onCurrentPageChanged(val) {
      this.$emit('onAdvancedSearch', val - 1, 10);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      })
    },
    onSearch () {
      this.$emit('onAdvancedSearch', this.page.number, this.page.size);
    }
  }
}
</script>

<style scoped>

</style>