<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight"
              @selection-change="handleSelectionChange" @row-click="clickRow" :row-key="getRowKeys">
      <el-table-column type="selection" width="55" :selectable="canSelect" :reserve-selection="true" v-if="isSelect"/>
      <el-table-column label="生产单号" min-width="130">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle">
            <span>{{scope.row.code}}</span>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="产品名称" min-width="150">
        <template slot-scope="scope">
          <el-row type="flex" justify="space-between" align="middle" :gutter="50">
            <el-col :span="6">
              <img width="54px" v-if="scope.row.product!=null" height="54px"
                :src="scope.row.product.thumbnail!=null&&scope.row.product.thumbnail.length!=0?scope.row.product.thumbnail.url:'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>{{scope.row.product.name}}</span>
              </el-row>
              <el-row>
                <span>货号:{{scope.row.product!=null?scope.row.product.skuID:''}}</span>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="品类" prop="product.category.name">
      </el-table-column>
      <el-table-column label="订单数量" prop="quantity">
      </el-table-column>
      <!-- <el-table-column label="创建人" prop="creator.name">
      </el-table-column>
      <el-table-column label="负责人" prop="productionLeader.name">
      </el-table-column> -->
      <!-- <el-table-column label="指定工厂" prop="appointFactory.name">
      </el-table-column> -->
      <el-table-column label="创建日期">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="交货时间">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
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
  export default {
    name: 'ProductionTaskSelectList',
    props: {
      page: {
        required: true
      },
      selectedRow: {
        type: Array,
        default: () => []
      },
      isSelect: Boolean,
      isSingleChoice: {
        type: Boolean,
        default: false
      }
    },
    data () {
      return {
        selectTaskList: []
      }
    },
    methods: {
      // onDetails (row) {
      //   if (this.isSelect) {
      //     this.$emit('onDetails', row.id);
      //     return;
      //   }
      //   this.$router.push('/sales/production/' + row.id);
      // },
      canSelect (row) {
        let index;
        if (this.selectedRow && this.selectedRow.length > 0) {
          index = this.selectedRow.findIndex(item => item.originOrder.id === row.id);
          if (index > -1) {
            return false
          }
        }
        return true;
      },
      onPageSizeChanged (val) {
        this.$emit('onSearch', 0, val);

        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      onCurrentPageChanged (val) {
        this.$emit('onSearch', val - 1, 10);

        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      handleSelectionChange (val) {
        if (this.isSingleChoice) {
          if (val.length > 1) {
            this.$refs.resultTable.toggleRowSelection(val[0], false);
            this.selectTaskList = [val[val.length - 1]];
          } else if (val.length <= 1) {
            this.selectTaskList = val;
          }
        } else {
          this.selectTaskList = val;
        }
      },
      getRowKeys (row) {
        return row.id;
      },
      clickRow (row) {
        if (!this.canSelect(row)) {
          return;
        }
        if (this.isSingleChoice && this.selectTaskList.length >= 1) {
          console.log(row);
          console.log(this.selectTaskList);
          if (row.id === this.selectTaskList[0].id) {
            this.$refs.resultTable.toggleRowSelection(this.selectTaskList[0], false);
            return;
          }
          this.$refs.resultTable.toggleRowSelection(this.selectTaskList[0], false);
        }
        this.$refs.resultTable.toggleRowSelection(row);
      }
    }
  }
</script>

<style scoped>

</style>
