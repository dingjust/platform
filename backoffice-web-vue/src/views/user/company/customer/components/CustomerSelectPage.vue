<!--
* @Description: 更新渠道码使用的选择用户页面
* @Date 2021/05/22 17:54
* @Author L.G.Y
-->
<template>
  <div>
    <el-row>
      <div class="orders-list-title">
        <h6>用户列表</h6>
      </div>
    </el-row>
    <div class="pt-2"></div>
    <customer-toolbar :queryFormData="queryFormData" @onAdvancedSearch="onAdvancedSearch"/>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" highlight-current-row
      current-row-key="id" @current-change="handleCurrentChange">
      <el-table-column label="名称" prop="name">
        <template slot-scope="scope">
          <span>{{scope.row.name}}<span v-if="scope.row.root" style="color: #F56C6C"> (主账号)</span></span>
        </template>
      </el-table-column>
      <el-table-column label="id" prop="id"></el-table-column>
      <el-table-column label="uid" prop="uid"></el-table-column>
      <el-table-column label="联系方式" prop="contactPhone"></el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <div class="pt-2"></div>
    <el-row type="flex" justify="center" align="middle">
      <el-button type="primary" @click="onSelect">选择</el-button>
    </el-row>
  </div>
</template>

<script>
import CustomerToolbar from '../toolbar/CustomerToolbar.vue'

export default {
  name: 'CustomerSelectPage',
  components: { CustomerToolbar },
  methods: {
    async onAdvancedSearch (page, size) {
      const query = this.queryFormData;

      const url = this.apis().searchCustomerList();
      const result = await this.$http.post(url, query, {
        page: page,
        size: size
      })

      if (!result['errors']) {
        this.$set(this, 'page', result);
      }
    },
    onPageSizeChanged(val) {
      this.onAdvancedSearch(0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged(val) {
      this.onAdvancedSearch(val - 1, this.page.size);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    handleCurrentChange(val) {
      this.currentRow = val;
    },
    onSelect () {
      this.$emit('setRecommendCode', this.currentRow);
    }
  },
  data () {
    return {
      queryFormData: {
        keyword: ''
      },
      page: {
        number: 0, // 当前页，从0开始
        size: 10, // 每页显示条数
        totalPages: 1, // 总页数
        totalElements: 0, // 总数目数
        content: [] // 当前页数据
      },
      currentRow: null
    }
  },
  created () {
    this.onAdvancedSearch(0, 10);
  }
}
</script>

<style scoped>

</style>