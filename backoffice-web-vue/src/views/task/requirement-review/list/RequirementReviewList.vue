<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="需求订单号" prop="code"></el-table-column>
      <el-table-column label="标题" prop="details.productName" width="200" header-align="center"></el-table-column>
      <el-table-column label="产品" width="260" header-align="center">
        <template slot-scope="scope">
          <el-row type="flex" align="middle" :gutter="10">
            <el-col :span="8">
              <img width="70px" height="70px"
                   :src="scope.row.details.pictures != null && scope.row.details.pictures.length > 0 ?
                   scope.row.details.pictures[0].url : 'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <h6 style="font-size: 12px">品类：{{scope.row.details.category.parent.name}}-{{scope.row.details.category.name}}</h6>
              <h6 style="font-size: 12px">货号：{{scope.row.details.productSkuID}}</h6>
              <h6 style="font-size: 12px">数量：{{scope.row.details.expectedMachiningQuantity}}</h6>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="发布人" prop="user">
        <template slot-scope="scope">
          <span>
            {{scope.row.user.name}}
            <span v-if="scope.row.publishType === 'PUBLISH_BY_OTHERS'" style="color: #F56C6C">(代发)</span>
          </span>
        </template>
      </el-table-column>
      <el-table-column label="发布日期" prop="createdTs">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="审阅状态">
        <template slot-scope="scope">
          <span>{{ getEnum('FactoryReviewState', scope.row.reviewState) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作"  header-align="center" align="center" width="150">
        <template slot-scope="scope">
          <el-button type="text" @click="onView(scope.row)">查看</el-button>
          <el-button type="text" @click="onPass(scope.row)">通过</el-button>
          <el-button type="text" @click="onReject(scope.row)">驳回</el-button>
          <el-button type="text" @click="onShow(scope.row)">{{ scope.row.enableShow ? '隐藏' : '展示'}}</el-button>
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
    <el-dialog :visible.sync="viewVisible" append-to-body width="80%" :close-on-click-modal="false">
      <requirement-review-detail v-if="viewVisible" :row="selectionRow"/>
    </el-dialog>
  </div>
</template>

<script>
import RequirementReviewDetail from '../detail/RequirementReviewDetail'
export default {
  name: 'RequirementReviewList',
  components: {RequirementReviewDetail},
  props: ['page'],
  methods: {
    onView (row) {
      this.selectionRow = row
      this.viewVisible = true
    },
    onPass (row) {
      this.$confirm('是否通过审阅?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(async () => {
        let url;
        if (row.creationtime === row.modifiedtime) {
          url = this.apis().reviewRequirementOrder(row.code, true)
        } else {
          const modifiedtime = await this.getBackup(row)
          url = this.apis().passRequirementOrder(row.code, modifiedtime)
        }
        this._onPass(url)
      });
    },
    async _onPass(url) {
      const result = await this.$http.put(url)

      if (result === 1) {
        this.$emit('onAdvancedSearch');
      }
    },
    onReject (row) {
      this.$prompt('请输入驳回原因', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
      }).then(async ({ value }) => {
        let url;
        if (row.creationtime === row.modifiedtime) {
          url = this.apis().reviewRequirementOrder(row.code, false)
        } else {
          const modifiedtime = await this.getBackup(row)
          url = this.apis().rejectRequirementOrder(row.code, modifiedtime)
        }
        this._onReject(url, value)
      })
    },
    async _onReject(url, reason) {
      const result = await this.$http.put(url, {
        reason: reason
      })

      if (result === 1) {
        this.$emit('onAdvancedSearch');
      }
    },
    onShow (row) {
      this.$confirm('是否改变此需求的显示状态?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onShow(row)
      });
    },
    async _onShow(row) {
      const url = this.apis().showOrHideRequirementOrder(row.code, !row.enableShow)
      const result = await this.$http.put(url)

      if (result === 1) {
        this.$emit('onAdvancedSearch');
      }
    },
    async getBackup (row) {
      const url = this.apis().getRequirementOrderBackUp(row.code);
      const result = await this.$http.get(url);
      
      return JSON.parse(result.data).modifiedtime
    },
    onPageSizeChanged (val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged (val) {
      this.$emit('onAdvancedSearch', val - 1);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    }
  },
  data () {
    return {
      viewVisible: false,
      selectionRow: null
    }
  }
}
</script>
