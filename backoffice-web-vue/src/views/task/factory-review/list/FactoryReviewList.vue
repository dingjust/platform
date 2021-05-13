<template>
  <div class="review-list">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="商家编号" prop="uid" min-width="110"></el-table-column>
      <el-table-column label="商家名称" prop="name" min-width="200"></el-table-column>
      <el-table-column label="登录账号" prop="contactUid" min-width="110"></el-table-column>
      <el-table-column label="联系人" prop="contactPerson" min-width="110"></el-table-column>
      <el-table-column label="积分" prop="points"></el-table-column>
      <el-table-column label="注册时间" prop="creationTime" min-width="120">
        <template slot-scope="scope">
          <span>{{scope.row.creationTime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="标签" prop="labels" min-width="150">
        <template slot-scope="scope">
          <el-tag size="mini" class="disableTagClass" :disable-transitions="true" v-if="scope.row.loginDisabled">
            已禁用
          </el-tag>
          <el-tag v-for="(item, index) of showLabels(scope.row.labels, scope.row.approvalStatus)" size="mini"
            class="elTagClass" :disable-transitions="true" :key="index">
            {{item}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="120">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">查看</el-button>
          <!-- <el-button type="text" @click="onPass(scope.row)">通过</el-button>
          <el-button type="text" @click="onReject(scope.row)">驳回</el-button> -->
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-dialog :visible.sync="detailVisible" width="80%"  class="purchase-dialog" :close-on-click-modal="false">
      <factory-form v-if="detailVisible && detailsData.id" :slotData="detailsData" 
                    :readOnly="true" :showPassAndReject="showPassAndReject" @closeDialog="closeDialog"/>
    </el-dialog>
  </div>
</template>

<script>
import FactoryForm from '@/views/user/company/factory/form/FactoryForm'

export default {
  name: 'FactoryReview',
  props: ['page'],
  components: {
    FactoryForm
  },
  computed: {
    showPassAndReject: function () {
      return this.isTenant();
    }
  },
  methods: {
    async onDetail (row) {
      const url = this.apis().getFactoryBackups(row.uid);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }

      this.detailsData = JSON.parse(result.data);
      if (this.detailsData.profilePicture) {
        this.detailsData.profilePicture.convertedMedias = [];
      }
      if (this.detailsData.certificates && this.detailsData.certificates.length > 0) {
        this.detailsData.certificates.forEach(item => item.convertedMedias = []);
      }
      this.detailVisible = true;
    },
    closeDialog () {
      this.detailVisible = false;
      const size = this.page.size;
      const page = this.page.content.length <= 1 ? this.page.number - 1 : this.page.number; 
      this.$emit('onAdvancedSearch', page, size);
    },
    // onPass (row) {
    //   this.$confirm('是否通过工厂：' + row.name + ' 的修改?', '提示', {
    //     confirmButtonText: '是',
    //     cancelButtonText: '否',
    //     type: 'warning'
    //   }).then(() => {
    //     this._onPass(row);
    //   });
    // },
    // async _onPass (row) {
    //   const url = this.apis().FactoryReviewPass(row.uid);
    //   const result = await this.$http.put(url, {}, {
    //     versionNo: row.modifiedTime
    //   })
    //   if (result['errors']) {
    //     this.$message.error(result['errors'][0]);
    //     rerutn;
    //   }
    //   if (result.code === 0) {
    //     this.$message.error(result.msg);
    //     return;
    //   }

    //   this.$message.success('操作成功');
    //   this.$emit('onAdvancedSearch')
    // },
    // onReject (row) {
    //   this.$prompt('是否驳回工厂：' + row.name + ' 的修改', '提示', {
    //     confirmButtonText: '确定',
    //     cancelButtonText: '取消',
    //     inputPattern: /^[\s\S]*.*[^\s][\s\S]*$/,
    //     inputErrorMessage: '请输入原因',
    //     closeOnClickModal: false,
    //     closeOnPressEscape: false
    //   }).then(({ value }) => {
    //     this._onReject(row, value);
    //   })
    // },
    // async _onReject (row, message) {
    //   const url = this.apis().FactoryReviewReject(row.uid);
    //   const result = await this.$http.put(url, {
    //     reason: message
    //   }, {
    //     versionNo: row.modifiedTime
    //   })
    //   if (result['errors']) {
    //     this.$message.error(result['errors'][0]);
    //     rerutn;
    //   }
    //   if (result.code === 0) {
    //     this.$message.error(result.msg);
    //     return;
    //   }

    //   this.$message.success('操作成功');
    //   this.$emit('onAdvancedSearch')
    // },
    showLabels (arr, approvalStatus) {
      let arr1 = [];
      if (approvalStatus != undefined && approvalStatus == 'approved') {
        arr1[0] = '已认证';
      } else {
        arr1[0] = '未认证';
      }
      for (let i = 0; i < arr.length; i++) {
        arr1[i + 1] = arr[i].name;
      }
      return arr1;
    },
    onPageSizeChanged (val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0;
      })
    },
    onCurrentPageChanged (val) {
      this.$emit('onAdvancedSearch', val - 1);
      
      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0;
      })
    },
  },
  data () {
    return {
      detailVisible: false,
      detailsData: {}
    }
  }
}
</script>

<style scoped>
  .disableTagClass{
    color: #0b0e0f;
    margin-right: 10px;
    margin-bottom: 10px;
    cursor:pointer;
    background-color: #F2F6FC;
  }
  .elTagClass{
    color: #0b0e0f;
    margin-right: 10px;
    cursor:pointer;
    background-color: #FFD60C;
  }
  .el-tag {
    border-color: #FFD60C;
  }
</style>
