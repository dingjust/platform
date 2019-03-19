<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" v-if="isHeightComputed" :height="autoHeight">
      <el-table-column label="样衣编码" prop="code"></el-table-column>
      <el-table-column label="样衣名称" prop="name"></el-table-column>
      <el-table-column label="数量" prop="quantity"></el-table-column>
      <el-table-column label="预计归还时间" prop="expectedReturningDate">
        <template slot-scope="scope">
          {{scope.row.expectedReturningDate | formatDate}}
        </template>
      </el-table-column>
      <el-table-column label="关联人" prop="relatedParty"></el-table-column>
      <el-table-column label="类型" prop="type">
        <template slot-scope="scope">
          {{getEnum('sampleCheckoutTypes', scope.row.type)}}
        </template>
      </el-table-column>

      <el-table-column label="状态" prop="state">
        <template slot-scope="scope">
          {{getEnum('returnStates', scope.row.state)}}
        </template>
      </el-table-column>

      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" icon="el-icon-edit" @click="onDetails(scope.row)">明细</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <div class="float-right">
      <el-pagination layout="total, sizes, prev, pager, next, jumper"
                     @size-change="onPageSizeChanged"
                     @current-change="onCurrentPageChanged"
                     :current-page="page.number + 1"
                     :page-size="page.size"
                     :page-count="page.totalPages"
                     :total="page.totalElements">
      </el-pagination>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'SampleCheckoutHistSearchResultList',
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
      onDetails(row) {
        this.$emit('onDetails', row);
      },
    },
    data() {
      return {}
    },
    created() {
    }
  }
</script>
