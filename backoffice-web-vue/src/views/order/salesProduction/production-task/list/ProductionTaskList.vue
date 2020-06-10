<template>
  <div class="animated fadeIn">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight"
              @selection-change="handleSelectionChange" @row-click="clickRow" :row-key="getRowKeys">
      <el-table-column type="selection" width="55" :selectable="selectable" :reserve-selection="true" v-if="isSelect"/>
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
              <img width="54px" v-if="scope.row.productionEntry.product!=null" height="54px"
                :src="scope.row.productionEntry.product.thumbnail!=null&&scope.row.productionEntry.product.thumbnail.length!=0?scope.row.productionEntry.product.thumbnail.url:'static/img/nopicture.png'" />
            </el-col>
            <el-col :span="16">
              <el-row>
                <span>{{scope.row.productionEntry.product.name}}</span>
              </el-row>
              <el-row>
                <span>货号:{{scope.row.productionEntry.product!=null?scope.row.productionEntry.product.skuID:''}}</span>
              </el-row>
            </el-col>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="品类" prop="productionEntry.product.category.name">
      </el-table-column>
      <el-table-column label="订单数量" prop="productionEntry.quantity">
      </el-table-column>
      <el-table-column label="创建人" prop="creator.name">
      </el-table-column>
      <el-table-column label="负责人" prop="productionLeader.name">
      </el-table-column>
      <el-table-column label="指定工厂" prop="appointFactory.name">
      </el-table-column>
      <el-table-column label="创建日期">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="交货时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态" prop="status">
        <template slot-scope="scope">
          <span>{{getEnum('ProductionState', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="100">
        <template slot-scope="scope">
          <el-row>
            <el-button type="text" @click="onDetails(scope.row)" class="purchase-list-button">详情</el-button>
            <!-- <el-divider direction="vertical"></el-divider>
                       <el-button type="text" @click="onDetails(scope.row)" class="purchase-list-button">删除</el-button> -->
          </el-row>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <!-- <div class="float-right"> -->
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <!-- </div> -->
  </div>
</template>

<script>
  export default {
    name: 'ProductionTaskList',
    props: ['page', 'selectTaskList', 'isSelect', 'isSingleChoice'],
    methods: {
      onDetails (row) {
        if (this.isSelect) {
          this.$emit('onDetails', row.id);
          return;
        }
        this.$router.push('/sales/production/' + row.id);
      },
      onPageSizeChanged (val) {
        this._reset();

        if (this.$store.state.SalesOrdersModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val);
          return;
        }
        this.$emit('onSearch', 0, val);
      },
      onCurrentPageChanged (val) {
        if (this.$store.state.SalesOrdersModule.isAdvancedSearch) {
          this.$emit('onAdvancedSearch', val - 1);
          return;
        }

        this.$emit('onSearch', val - 1);
        this.$nextTick(() => {
          this.$refs.resultTable.bodyWrapper.scrollTop = 0
        });
      },
      handleSelectionChange (val) {
        let data = Object.assign([], val);
        if (this.isSingleChoice) {
          if (data.length > 1) {
            this.$refs.resultTable.toggleRowSelection(data[0], false);
            data.splice(0, 1);
          }
        }
        this.$emit('getSelectTaskList', data);
      },
      getRowKeys (row) {
        return row.id;
      },
      clickRow (row) {
        if (row.state == 'DISPATCHING') {
          this.$refs.resultTable.toggleRowSelection(row);
        }
      },
      selectable (row, index) {
        if (row.state == 'DISPATCHING') {
          return true;
        }
        return false;
      }
    }
  }
</script>

<style scoped>

</style>
