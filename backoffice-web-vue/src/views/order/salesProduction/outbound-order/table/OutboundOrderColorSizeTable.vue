<template>
  <div style="margin-bottom: 10px">
    <el-row type="flex" justify="start">
      <el-col :span="3" :offset="1">
        <img :src="product.thumbnail ? product.thumbnail.url : 'static/img/nopicture.png'" style="width: 100px;height: 100px;border-radius: 8px;"/>
      </el-col>
      <el-col :span="12">
        <el-table ref="resultTable" :data="getColorSizeTableData" border>
          <el-table-column label="颜色" prop="colorName"></el-table-column>
          <template v-for="(val, index) in getSizeList">
            <el-table-column :label="val.name" :prop="val.name"></el-table-column>
          </template>
        </el-table>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'OutboundOrderColorSizeTable',
    props: ['product'],
    computed: {
      getColorSizeTableData: function () {
        let row = {};
        let data = [];
        let index;
        this.product.colorSizeEntries.forEach(val => {
          index = data.findIndex(item => item.colorName == val.color.name);
          if (index > -1) {
            data[index][val.size.name] = val.quantity;
          } else {
            row.colorName = val.color.name;
            row[val.size.name] = val.quantity;
            data.push(row);
            row = {};
          }
        })
        return data;
      },
      getSizeList: function () {
        let data = [];
        let index;
        this.product.colorSizeEntries.forEach(item => {
          index = data.findIndex(val => val.code == item.size.code);
          if (index < 0) {
            data.push(item.size);
          }
        })
        return data;
      }
    }
  }
</script>

<style scoped>
  /deep/ .el-table--enable-row-hover .el-table__body tr:hover>td {
    background-color: #FFFFFF !important;
  }
</style>
