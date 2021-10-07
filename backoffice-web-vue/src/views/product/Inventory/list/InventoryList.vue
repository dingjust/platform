<template>
  <div class="inventory-list">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="产品编号" prop="code"></el-table-column>
      <el-table-column label="款号" prop="skuID"></el-table-column>
      <el-table-column label="库存数量">
        <template slot-scope="scope">
          <span>{{inventoryQuantity(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{ scope.row.creationtime | formatDate }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onModify(scope.row)" >修改</el-button>
          <el-button type="text" @click="onDelete(scope.row)" >删除</el-button>
        </template>
      </el-table-column>
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
  name: 'InventoryList',
  props: ['page'],
  methods: {
    inventoryQuantity (row) {
      let count = 0
      if (row.variants && row.variants.length > 0) {
        row.variants.forEach(item => count += item.quality)
      }
      return count;
    },
    onPageSizeChanged (val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged (val) {
      this.$emit('onAdvancedSearch', val, this.page.size);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onModify (row) {
      this.$router.push('/product/inventory/modify/' + row.id)
    },
    onDelete (row) {
      const count = this.inventoryQuantity(row)

      let msg = (count > 0 ? ('此产品还有' + count + '件库存，') : '') + '是否删除此产品？'

      this.$confirm(msg, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this._onDelete(row)
      })
    },
    async _onDelete (row) {
      const url = this.apis().deleteInventory(row.id)
      const result = await this.$http.delete(url)

      if (result['errors']) {
        this.$message.error(result['errors'][0].message)
        return
      }

      this.$message.success('操作成功！')
      this.$emit('onAdvancedSearch');
    }
  }
}
</script>

<style scoped>
</style>