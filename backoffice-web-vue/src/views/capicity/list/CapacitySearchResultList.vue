<template>
  <div class="capacity-list-container">
    <!-- <div class="float-right"> -->
    <!-- <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>-->
    <!-- </div> -->
    <template v-for="(row,rowIndex) in dataRowList">
      <el-row :key="rowIndex" type="flex" justify="space-between" class="capacity-list-row">
        <template v-for="(item,index) in row">
          <el-col :span="11" :key="index">
            <capicity-item :slotData="item" @refresh="onRefresh" />
          </el-col>
        </template>
      </el-row>
    </template>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from "vuex";
  import CapicityItem from "../components/CapicityItem";

  const {
    mapActions
  } = createNamespacedHelpers("CapacityModule");

  export default {
    name: "CapacitySearchResultList",
    props: ["page"],
    components: {
      CapicityItem
    },
    computed: {
      //数据两个一行
      dataRowList: function () {
        var rowNum = 2;
        var data = [];
        for (var i = 0; i < this.page.content.length; i += rowNum) {
          data.push(this.page.content.slice(i, i + rowNum));
        }
        return data;
      }
    },
    methods: {
      ...mapActions({
        refresh: "refresh"
      }),
      onPageSizeChanged(val) {
        this._reset();

        if (this.$store.state.PurchaseOrdersModule.isAdvancedSearch) {
          this.$emit("onAdvancedSearch", val);
          return;
        }

        this.$emit("onSearch", 0, val);
      },
      onCurrentPageChanged(val) {
        if (this.$store.state.PurchaseOrdersModule.isAdvancedSearch) {
          this.$emit("onAdvancedSearch", val - 1);
          return;
        }

        this.$emit("onSearch", val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onDetails(row) {
        this.$emit("onDetails", row);
      },
      onRefresh() {
        this.$emit("onSearch");
      }
    },
    data() {
      return {};
    }
  };

</script>
<style scoped>
  .capacity-list-row {
    margin-bottom: 50px;
  }

</style>>
