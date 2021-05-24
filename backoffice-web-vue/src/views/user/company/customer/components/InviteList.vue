<!--
* @Description: 用户邀约列表
* @Date 2021/05/22 17:39
* @Author L.G.Y
-->
<template>
  <div>
    <el-row>
      <div class="orders-list-title">
        <h6>邀约列表</h6>
      </div>
    </el-row>
    <div class="pt-2"></div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="名称" prop="name">
        <template slot-scope="scope">
          <span>{{scope.row.name}}<span v-if="scope.row.root" style="color: #F56C6C"> (主账号)</span></span>
        </template>
      </el-table-column>
      <el-table-column label="uid" prop="uid"></el-table-column>
      <el-table-column label="联系方式" prop="contactPhone"></el-table-column>
      <el-table-column label="渠道" prop=""></el-table-column>
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
  name: 'InviteList',
  props: ['uid'],
  methods: {
    search () {
      const url = this.apis().searchCustomerListByRecommend();
      const result = this.$http.post(url, {
        channelCode: this.uid
      });

      if (!result['errors']) {
        this.page = result;
      }
    },
    onPageSizeChanged(val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged(val) {
      this.$emit('onAdvancedSearch', val - 1);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
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
    }
  },
  created () {
    this.search();
  }
}
</script>

<style>

</style>