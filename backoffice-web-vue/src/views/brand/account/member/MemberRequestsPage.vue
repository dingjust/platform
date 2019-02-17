<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight">
      <el-table-column label="会员UID" prop="customer.uid"></el-table-column>
      <el-table-column label="会员名称" prop="customer.name"></el-table-column>
      <el-table-column label="会员手机号" prop="customer.mobileNumber"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="success" plain @click="onApprove(scope.row)">同意</el-button>
          <el-button type="danger" plain @click="onReject(scope.row)">拒绝</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class=" pt-2 "></div>
    <div class="float-right ">
      <el-pagination layout="total, sizes, prev, pager, next, jumper"
                     @size-change="onPageSizeChanged"
                     @current-change="onCurrentPageChanged"
                     :current-page="page.number + 1"
                     :page-size="page.size"
                     :page-count="page.totalPages"
                     :total="page.totalElements">
      </el-pagination>
    </div>
    <div class="clearfix"></div>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandMemberRequestsModule');

  import autoHeight from 'mixins/autoHeight';

  export default {
    name: 'MemberRequestPage',
    props: ['slotData'],
    mixins: [autoHeight],
    computed: {
      ...mapGetters({
        page: 'page'
      })
    },
    methods: {
      ...mapActions({
        search: 'search'
      }),
      onSearch() {
        this._onSearch(0);
      },
      onPageSizeChanged(val) {
        this.reset();
        this._onSearch(0, val);
      },
      onCurrentPageChanged(val) {
        this._onSearch(val - 1);
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      _onSearch(page, size) {
        const keyword = '';
        this.search({keyword, page, size});
      },
      onApprove(row) {
        // 调用审核通过接口
        this.$confirm('确认会员申请, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => this._onApprove(row));
      },
      async _onApprove(row) {
        const result = await this.$http.put('/djbrand/memberRequest/approve', {
          customer: {uid: row.customer.uid},
          company: {uid: row.company.uid}
        });

        if (result['errors']) {
          this.$message.error('通过失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('确认成功');
        this._onSearch(0);
      },
      onReject(row) {
        //调用审核拒绝接口
        this.$prompt('请输入拒绝原因', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消'
        }).then(() => this._onReject(row));
      },
      async _onReject(row) {
        const result = await this.$http.put('/djbrand/memberRequest/reject', {
          customer: {uid: row.customer.uid},
          company: {uid: row.company.uid},
          remarks: value
        });

        if (result['errors']) {
          this.$message.error('拒绝失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('拒绝成功');
        this._onSearch(0);
      }
    },
    mounted: function () {
      this.$nextTick(function () {
        this._onSearch(0);
      });
    },
    data() {
      return {};
    },
  };
</script>

