<template>
  <el-card class="box-card">
    <el-table stripe :data="pageContent" border>
      <el-table-column label="工厂ID" prop="uid"></el-table-column>
      <el-table-column label="工厂名称" prop="name"></el-table-column>
    </el-table>
    <el-pagination class="pagination-right" layout="prev, pager, next"
                    :total="totalElements"
                    :page-size="this.page.size"
                    @current-change="onCurrentPageChanged">
    </el-pagination>
  </el-card>
</template>

<script>
  export default {
    name: "FactoryMemberDetail",
    props: ["slotData"],
    methods: {
      onCurrentPageChanged(val) {
        this.page.number = val;
      },
      reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      }
    },
    computed: {
      // 总页数
      totalPages: function () {
        return (this.slotData.length + this.page.size - 1) / this.page.size;
      },
      // 总数目数
      totalElements: function () {
        return this.slotData.length;
      },
      pageContent: function () {
        let start = (this.page.number - 1) * this.page.size;
        let end = start + this.page.size;
        if (end >= this.slotData.length) {
          return this.slotData.slice(start);
        }
        return this.slotData.slice(start, end);
      }
    },
    data() {
      return {
        text: "",
        page: {
          number: 1, // 当前页，从0开始
          size: 10 // 每页显示条数
        }
      };
    }
  };
</script>

