<template>
  <div class="animated fadeIn">
    <el-table stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight">
      <el-table-column label="会员名称" prop="customer.name"></el-table-column>
      <el-table-column label="手机号码" prop="customer.mobileNumber"></el-table-column>
      <el-table-column label="电子邮箱" prop="customer.email"></el-table-column>
      <el-table-column label="会员等级" prop="level"></el-table-column>
      <el-table-column label="生效日期">
        <template slot-scope="scope">
          <span>{{scope.row.effectiveDate | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="失效日期">
        <template slot-scope="scope" v-if="!scope.row.expiredDate === null">
          <span>{{scope.row.expiredDate | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="danger" plain @click="onRelieve(scope.row)">移除会员</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <div class="float-right">
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

  const {mapGetters, mapActions} = createNamespacedHelpers('BrandMembersModule');

  import autoHeight from 'mixins/autoHeight';

  export default {
    name: "MembersPage",
    props: ["slotData"],
    mixins: [autoHeight],
    computed: {
      ...mapGetters({
        page: "page"
      })
    },
    methods: {
      ...mapActions({
        search: "search"
      }),
      onPageSizeChanged(val) {
        this.reset();

        this._onSearch(0, val);
      },
      onCurrentPageChanged(val) {
        this._onSearch(val - 1);
      },
      _onSearch(page, size) {
        const keyword = "";
        this.search({keyword, page, size});
      },
      onRelieve(row) {
        // 调用审核拒绝接口
        this.$confirm("确认移除会员, 是否继续?", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }).then(() => this._onRelieve(row));
      },
      async _onRelieve(row) {
        const result = await this.$http.delete("/djbrand/membership", {
          customerUid: row.customer.uid
        });

        if (result["errors"]) {
          this.$message.error("移除失败，原因：" + result["errors"][0].message);
          return;
        }

        this.$message.success("移除成功");
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
    }
  };
</script>
