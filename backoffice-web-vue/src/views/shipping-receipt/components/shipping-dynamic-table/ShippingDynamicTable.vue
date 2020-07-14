<template>
  <div class="shipping-order-list-container">
    <el-table ref="resultTable" stripe :data="page.content" row-key="id" @selection-change="handleSelectionChange"
      @row-click="rowClick">
      <el-table-column type="selection" width="55" v-show="hasSelection" fixed key="1"></el-table-column>
      <shipping-dynamic-table-list :columns="columns" />
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements"></el-pagination>
  </div>
</template>

<script>
  import {
    ShippingDynamicTableList
  } from "./shipping-dynamic-table-list";

  export default {
    name: "ShippingDynamicTable",
    props: {
      page: {
        type: Object,
        required: true
      },
      columns: {
        type: Array,
        default: () => {
          return ["发货单号", "产品名称", "关联订单"];
        }
      },
    },
    components: {
      ShippingDynamicTableList
    },
    computed: {
      //是否有多选项
      hasSelection: function () {
        let index = this.columns.filter(element => element.key != null).findIndex(element => element.key == '多选');
        return index != -1;
      }
    },
    methods: {
      onDetail(row) {
        this.$emit("onDetail", row);
      },
      onPageSizeChanged(val) {
        this.$emit("onAdvancedSearch", 0, val);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0;
        });
      },
      onCurrentPageChanged(val) {
        this.$emit("onAdvancedSearch", val - 1);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0;
        });
      },
      handleSelectionChange(val) {
        // 限制单选
        if (val.length > 1) {
          this.$refs.resultTable.toggleRowSelection(val[0], false);
          this.selectionRow = val[val.length - 1];
        } else if (val.length == 1) {
          this.selectionRow = val[val.length - 1];
        } else if (val.length == 0) {
          this.selectionRow = "";
        }
        this.$emit('onSelect', this.selectionRow);
      },
      rowClick(row) {
        if (this.selectionRow == "") {
          this.$refs.resultTable.toggleRowSelection(row, true);
        } else {
          if (this.selectionRow.id == row.id) {
            this.$refs.resultTable.toggleRowSelection(row, false);
          } else {
            this.$refs.resultTable.toggleRowSelection(this.selectionRow, false);
            this.$refs.resultTable.toggleRowSelection(row, true);
          }
        }
      },
    },
    data() {
      return {
        selectionRow: ""
      };
    },
    create() {}
  };

</script>

<style scoped>
  .shipping-order-list-container>>>.el-table th>.cell .el-checkbox {
    display: none;
  }

</style>
