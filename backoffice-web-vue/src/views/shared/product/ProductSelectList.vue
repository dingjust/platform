<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content"
              highlight-current-row
              @current-change="handleCurrentChange"
              @selection-change="handleSelectionChange">
      <el-table-column v-if="multipleSelection" type="selection" width="55"></el-table-column>
      <el-table-column label="商品货号" prop="skuID"></el-table-column>
      <el-table-column label="商品名称" prop="name"></el-table-column>
      <el-table-column label="商品价格" prop="price"></el-table-column>
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
  </div>
</template>

<script>
  export default {
    name: 'ProductSelectList',
    props: ['page', 'multipleSelection'],
    mixins: [],
    computed: {},
    methods: {
      handleCurrentChange(current) {
        this.$emit('onSelected', current);
      },
      handleSelectionChange(current) {
        this.$emit('onSelected', current);
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onPageSizeChanged(val) {
        this.reset();
        this.$emit('onPageSizeChanged', val);
      },
      onCurrentPageChanged(val) {
        this.$emit('onCurrentPageChanged', val)
      }
    },
    data() {
      return {}
    },
    created() {
    }
  }
</script>
