<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" row-key="id" default-expand-all
              @selection-change="handleSelectionChange" @row-click="clickRow">
      <el-table-column type="selection" width="55" :reserve-selection="true" :selectable="selectable"/>
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
    name: 'MaterialDialogList',
    props: ['page'],
    data () {
      return {
        selectMaterialList: this.$store.state.MaterialModule.selectMaterialList
      }
    },
    methods: {
      handleSelectionChange (selection) {
        this.$emit('getSelectMaterial', selection);
      },
      clickRow (row) {
        if (this.selectMaterialList.findIndex(val => val.id == row.id) > -1) {
          return;
        }
        this.$refs.resultTable.toggleRowSelection(row);
      },
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
      },
      // 判断当前行是否可以勾选
      selectable (row, index) {
        return this.selectMaterialList.findIndex(val => val.id == row.id) < 0;
      },
      // 回显
      initMaterialList () {
        // // 数据一致根据对象回显
        // this.selectMaterialList.forEach(row => {
        //   this.$refs.resultTable.toggleRowSelection(row, true);
        // })

        // 数据不一致根据id回显,监听page,跳页需再次执行回显
        let index;
        this.page.content.forEach(val => {
          index = this.selectMaterialList.findIndex(item => {
            return item.id == val.id;
          });
          if (index > -1) {
            this.$refs.resultTable.toggleRowSelection(val, true);
          }
        })
      }
    },
    watch: {
      page: function () {
        this.initMaterialList();
      }
    },
    created () {
      this.$nextTick(() => {
        this.initMaterialList();
      })
    }
  }
</script>

<style scoped>

</style>
