<template>
  <div class="animated fadeIn">
    <el-table stripe :data="stockLevels">
      <el-table-column label="产品编码" prop="product.code"></el-table-column>
      <el-table-column label="产品名称" prop="product.name"></el-table-column>
      <el-table-column label="产品颜色" prop="color.name"></el-table-column>
      <el-table-column label="产品尺码" prop="size.name"></el-table-column>
      <el-table-column label="可用库存" prop="available"></el-table-column>
      <el-table-column label="虚拟库存" prop="maxPreOrder"></el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'ProductStockLevelsForm',
    props: ['slotData', 'readOnly', 'isNewlyCreated'],
    methods: {
      refresh() {
        if (this.slotData.code) {
          this.doRefresh();
        }
      },
      async doRefresh() {
        const result = await this.$http.get('/djbrand/product/inventories/' + this.slotData.code);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.stockLevels = result;
      }
    },
    data() {
      return {
        stockLevels: []
      };
    },
    created() {
      if (!this.isNewlyCreated) {
        this.doRefresh();
      }
    }
  };
</script>
