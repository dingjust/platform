<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="物料图片" width="120">
        <template slot-scope="scope">
            <img width="54px" height="54px"
                 :src="scope.row.thumbnail!=null&&scope.row.thumbnail.length!=0?scope.row.thumbnail.url:'static/img/nopicture.png'">
        </template>
      </el-table-column>
      <el-table-column label="物料名称" prop="name"></el-table-column>
      <el-table-column label="物料编号" prop="code"></el-table-column>
      <el-table-column label="物料类型" prop="materialsType">
        <template slot-scope="scope">
          <span>{{getEnum('MaterialsType',scope.row.materialsType)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetails(scope.row)">编辑</el-button>
          <el-divider direction="vertical"></el-divider>
          <el-button type="text">更多</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
                   :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  export default {
    name: 'MaterialList',
    props: ['page'],
    methods: {
      onDetails (row) {
        this.$emit('onDetails', row);
      },
      onPageSizeChanged (val) {
        this._reset();

        // if (this.$store.state.ApparelProductsModule.isAdvancedSearch) {
        //   this.$emit('onAdvancedSearch', val);
        //   return;
        // }

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        // if (this.$store.state.ApparelProductsModule.isAdvancedSearch) {
        //   this.$emit('onAdvancedSearch', val - 1);
        //   return;
        // }

        this.$emit('onSearch', val - 1);
      }
    }
  }
</script>

<style scoped>

</style>
