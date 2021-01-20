<template>
  <div>
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" 
      @selection-change="handleSelectionChange" row-key="id" @row-click="rowClick">
      <el-table-column type="selection" width="55" v-if="isSelection"
        :reserve-selection="true" :selectable="selectable" />
      <el-table-column label="出货单号" prop="code"></el-table-column>
      <el-table-column label="标题" prop="title"></el-table-column>
      <el-table-column label="单据">
        <template slot-scope="scope">
          <template v-if="scope.row.medias && scope.row.medias.length > 0">
            <el-image 
              title="点击查看大图及更多"
              class="media-image"
              :src="scope.row.medias[0].url"
              :preview-src-list="scope.row.medias.map(item => item.url)" />
          </template>
        </template>
      </el-table-column>
      <el-table-column label="合作商" min-width="200px">
        <template slot-scope="scope">
          <span>{{scope.row.cooperator.type === 'ONLINE' ? scope.row.cooperator.partner.name : scope.row.cooperator.name}}</span>
        </template>
      </el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{getEnum('DeliveryType', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" v-if="!isSelection">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
  </div>
</template>

<script>
export default {
  name: 'DeliveryOrdersList',
  props: ['page', 'isSelection'],
  // ReconciliationOrdersFormV2Header 传入
  inject: {
    formData: {
      default: () => {}
    }
  },
  data () {
    return {
      currentUserUid: this.$store.getters.currentUser.uid,
      currentRow: [],
      listName: 'fastShippingSheets'
    }
  },
  methods: {
    onPageSizeChanged(val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0;
      });
    },
    onCurrentPageChanged(val) {
      this.$emit('onAdvancedSearch', val - 1, 10);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0;
      });
    },
    onDetail (row) {
      this.$router.push('/order/delivery/' + row.id);
    },
    // 判断行是否能选择
    selectable (row, index) {
      if (this.judge(row)) {
        return true;
      } 
      return false;
    },
    handleSelectionChange (selection) {
      this.currentRow = selection;
    },
    rowClick (row) {
      if (this.judge(row)) {
        this.$refs.resultTable.toggleRowSelection(row);
      }
    },
    judge (row) {
      if (!this.formData) {
        return;
      }
      if (!this.formData.cooperator) {
        // 未确定合作商时
        return this.currentRow <= 0 || row.cooperator.name === this.currentRow[0].cooperator.name;
      } else {
        // 已确定合作商时
        return this.formData.cooperator.name === row.cooperator.name;
      }
    }
  },
  watch: {
    'page': function (nval, oval) {
      if (this.formData && this.formData[this.listName] && nval) {
        this.page.content.forEach(item => {
          if (this.formData[this.listName].some(val => val.id === item.id)) {
            this.$refs.resultTable.toggleRowSelection(item);
          }
        })
      }
    }
  }
}
</script>

<style scoped>
  .media-image {
    width: 60px; 
    height: 60px;    
    border-radius: 5px;
  }
</style>