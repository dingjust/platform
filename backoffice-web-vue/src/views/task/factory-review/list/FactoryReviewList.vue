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
      <el-table-column label="标签" prop="labels" min-width="160">
        <template slot-scope="scope">
          <div class="tag-container">
            <el-tag type="danger" class="tag-item" v-if="scope.row.loginDisabled">
              已禁用
            </el-tag>
            <el-tag :type="Certified(scope.row) ? 'success' : 'warning'" class="tag-item">
              {{Certified(scope.row) ? '已认证' : '未认证'}}
            </el-tag>
            <el-tag v-for="item of scope.row.labels" class="tag-item" type="primary" :key="item.id">
              {{item.name}}
            </el-tag>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="120">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">查看</el-button>
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

      if (this.detailsData.contactAddress && !this.detailsData.contactAddress.id) {
        this.detailsData.contactAddress.id = 1
      }

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
    Certified (row) {
      if (row.approvalStatus && row.approvalStatus === 'approved') {
        return true;
      }
      return false;
    },
    showLabels (arr) {
      return arr.map(item => item.name);
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
  .tag-item {
    margin-right: 10px;
    margin-bottom: 10px;
  }
  
  .tag-container {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
  }
</style>
