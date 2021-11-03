<template>
  <div class="inventory-toolbar">
    <el-form label-width="auto">
      <el-row type="flex" justify="end">
        <!-- <el-row type="flex">
          <el-form-item label="">
            <el-input v-model="queryFormData.keyword" placeholder="渠道码信息"></el-input>
          </el-form-item>
          <el-button-group>
            <el-button class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button @click="onReset">重置</el-button>
          </el-button-group>
        </el-row> -->
        <div>
          <el-button type="primary" @click="onImport">导出数据</el-button>
          <el-button type="primary" @click="toScan">扫码录入</el-button>
        </div>
      </el-row>
    </el-form>
  </div>
</template>

<script>
export default {
  name: 'InventoryToolbar',
  props: [],
  methods: {
    onAdvancedSearch () {
      this.$emit('onAdvancedSearch');
    },
    onReset () {
      this.queryFormData.keyword = '';
    },
    toScan () {
      this.$router.push('/product/scan')
    },
    onImport () {
      this.$emit('onImport')
    }
  }
}
</script>

<style scoped>
.inventory-toolbar >>> .el-form-item {
    margin-bottom: 0px;
}

.toolbar-search_input {
  background-color: #ffd60c;
  border-color: #ffd60c;
}
</style>