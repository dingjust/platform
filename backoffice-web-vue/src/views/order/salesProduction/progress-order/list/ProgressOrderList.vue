<template>
  <div class="animated fadeIn">
    <el-table v-if="isHeightComputed" ref="resultTable" stripe :data="page.content" :height="autoHeight">
      <el-table-column>
        <template slot-scope="scope">
          <progress-order-simple-detail :slotData="scope.row"/>
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
  import ProgressOrderSimpleDetail from '../details/ProgressOrderSimpleDetail';
  export default {
    name: 'ProgressOrderList',
    components: {ProgressOrderSimpleDetail},
    props: ['page'],
    computed: {

    },
    methods: {
      onPageSizeChanged (val) {
        this.$emit('onAdvancedSearch', 0, val);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onCurrentPageChanged (val) {
        this.$emit('onAdvancedSearch', val - 1);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      }
    },
    data () {
      return {
        checked: true,
        active: 0
      }
    },
    created () {

    },
    mounted () {

    }
  }
</script>

<style scoped>
  .border-container {
    border: 1px solid #DCDFE6;
    padding: 10px;
    border-radius: 5px;
    /*background-color: #F5F5F5;*/
  }

  .list-btn {
    width: 80px;
  }
</style>
