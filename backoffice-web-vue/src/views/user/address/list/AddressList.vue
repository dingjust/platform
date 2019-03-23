<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column label="联系人" prop="fullname"></el-table-column>
      <el-table-column label="联系电话" prop="cellphone"></el-table-column>
      <el-table-column label="联系地址">
        <template slot-scope="scope">
          <full-address :slot-data="scope.row"/>
        </template>
      </el-table-column>
      <el-table-column label="是否默认" prop="defaultAddress"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onSetDefault(scope.row)">设置为默认</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right"
                   layout="total, sizes, prev, pager, next, jumper"
                   @size-change="onPageSizeChanged"
                   @current-change="onCurrentPageChanged"
                   :current-page="page.number + 1"
                   :page-size="page.size"
                   :page-count="page.totalPages"
                   :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
  import FullAddress from "@/views/shared/user/address/FullAddress";

  export default {
    name: 'AddressList',
    components: {FullAddress},
    props: ["page"],
    computed: {},
    methods: {
      onPageSizeChanged(val) {
        this._reset();

        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged(val) {
        this.$emit('onSearch', val - 1);
      },
      _reset() {
        this.$refs.resultTable.clearSort();
        this.$refs.resultTable.clearFilter();
        this.$refs.resultTable.clearSelection();
      },
      onSetDefault(row) {
        row['defaultAddress'] = true;
        this.$emit('onSetDefault', row);
      },
    },
    data() {
      return {}
    }
  }
</script>
