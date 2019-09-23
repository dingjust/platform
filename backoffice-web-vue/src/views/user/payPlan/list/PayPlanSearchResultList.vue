<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" @filter-change="handleFilterChange"
      :height="autoHeight">
      <el-table-column label="方案名称" prop="name">
      </el-table-column>
      <el-table-column label="类型" prop="payPlanType">
        <template slot-scope="scope">
          <span v-if="scope.row.isHaveDeposit">定金 +</span>
          <span> {{getEnum('PayPlanType',scope.row.payPlanType)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" prop="creationtime">
        <template slot-scope="scope">
          <span> {{scope.row.creationtime | formatDateWithSecond}}</span>
        </template>
      </el-table-column>
      <el-table-column label="备注" prop="remarks">
      </el-table-column>
      <!--<el-table-column label="合作次数" v-if="!isFactory()" prop="belongTo.name">-->
        <!--<template slot-scope="scope">-->
          <!--<span v-if="scope.row.belongTo">{{scope.row.belongTo.name}}</span>-->
        <!--</template>-->
      <!--</el-table-column>-->
      <el-table-column label="操作" min-width="100">
        <template slot-scope="scope">
          <el-row>
            <el-button type="text" @click="onDetails(scope.row)" class="cooperator-list-button">明细</el-button>
            <el-divider direction="vertical"></el-divider>
            <el-button type="text" @click="onEdit(scope.row)" class="cooperator-list-button">编辑</el-button>
            <el-divider direction="vertical"></el-divider>
            <el-button type="text" @click="onDelete(scope.row)" class="cooperator-list-button">删除</el-button>
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <!-- <div class="float-right"> -->
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
     :page-sizes="[8,10,20]" :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <!-- </div> -->
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions
  } = createNamespacedHelpers('PayPlanModule');

  export default {
    name: 'PayPlanSearchResultList',
    props: ["page"],
    components: {},
    computed: {},
    methods: {
      ...mapActions({
      }),
      handleFilterChange(val) {
        this.statuses = val.status;

        this.$emit('onSearch', 0);
      },
      onPageSizeChanged(val) {
        this._reset();

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        this.$emit('onSearch', val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(row) {
        this.$emit('onDetails', row);
      },
      onEdit(row) {
        this.$emit('onEdit', row);
      },
      onDelete(row) {
        this.$confirm('此操作将永久删除改账务方案, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$emit('onDelete', row);
        })
      },
    },
    data() {
      return {
        statuses: this.$store.state.PayPlanModule.statuses,
      }
    }
  }

</script>
<style>
  .cooperator-list-button {
    color: #FFA403;
  }

</style>
