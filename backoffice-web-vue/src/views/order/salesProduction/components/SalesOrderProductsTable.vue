<template>
  <div class="border-container">
    <div class="over-tabs">
      <el-row type="flex">
          <el-button class="material-btn" @click="appendProduct" v-if="isCreate">添加商品</el-button>
      </el-row>
    </div>
    <el-tabs type="border-card">
      <el-tab-pane label="产品明细">
        <el-table :data="tableData.content" stripe style="width: 100%">
          <el-table-column type="selection" width="55">
          </el-table-column>
          <el-table-column prop="date" label="产品名称" ></el-table-column>
          <el-table-column prop="name" label="数量"></el-table-column>
          <el-table-column prop="price" label="预计销售单价/元" min-width="100"></el-table-column>
          <el-table-column prop="total" label="预计销售总价/元" min-width="100"></el-table-column>
          <el-table-column prop="budget" label="预计总成本"></el-table-column>
          <el-table-column prop="profit" label="预计利润"></el-table-column>
          <el-table-column prop="profitMargin" label="预计利润率">
            <template slot-scope="scope">
              <span>{{scope.row.profitMargin * 100}}</span>
            </template>
          </el-table-column>
          <el-table-column prop="address" label="交货时间">
            <template slot-scope="scope">
              <span>{{scope.row.time | timestampToTime}}</span>
            </template>
          </el-table-column>
          <el-table-column prop="address" label="审核状态">
            <template slot-scope="scope">
              <span>{{getEnum('cooperationModes', scope.row.type)}}</span>
            </template>
          </el-table-column>
          <el-table-column prop="address" label="操作" min-width="120">
            <template slot-scope="scope">
              <el-button type="text" @click="onProductDetail(scope.row)">详情</el-button>
              <el-button type="text" @click="onModify(scope.row)">编辑</el-button>
              <el-button type="text" @click="onDelete(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
      <el-tab-pane label="生产明细" v-if="!isCreate">

      </el-tab-pane>
    </el-tabs>
    <el-dialog :visible.sync="salesProductDetailsVisible" width="80%" class="purchase-dialog" append-to-body
               :close-on-click-modal="false">
      <sales-plan-product-detail v-if="salesProductDetailsVisible"/>
    </el-dialog>
  </div>
</template>

<script>
  import SalesPlanProductDetail from '../details/SalesPlanProductDetail';
  export default {
    name: 'SalesOrderProductsTable',
    components: {SalesPlanProductDetail},
    props: {
      isCreate: {
        type: Boolean,
        default: true
      }
    },
    methods: {
      appendProduct () {
        this.$emit('appendProduct');
      },
      handleCommand (command) {
        switch (command) {
          case 'delete':
            this.onDelete();
            break;
          case 'close':
            this.onClose();
            break;
          case 'modify':
            this.onModify();
            break;
        }
      },
      onProductDetail (row) {
        this.salesProductDetailsVisible = true;
      },
      onDelete () {
        this.$confirm('请问是否删除该商品', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$message('------delete--------');
        });
      },
      onClose () {
        this.$message('------close--------');
      },
      onModify () {
        this.$message('------modify--------');
      }
    },
    data () {
      return {
        salesProductDetailsVisible: false,
        tableData: {
          type: 'complete',
          content: [{
            date: '2016-05-02',
            name: '王小虎',
            code: 'CO0000000001',
            foundPerson: '宁波衣加衣宁波衣加衣',
            contactPerson: '宁波衣加衣宁波衣加衣',
            contactPhone: '13888888888',
            type: 'LABOR_AND_MATERIAL',
            time: 1586770813000,
            fapiao: '不开发票',
            quantity: 5000,
            price: 11111,
            total: 1222200202,
            budget: 12222,
            profit: 122222,
            profitMargin: 0.6,
            approvalBy: '周鸿伟',
            orderOwner: '马化腾',
            productionBy: '马云',
            procurementBy: '伟腾云'
          }, {
            date: '2016-05-02',
            name: '王小虎',
            code: 'CO0000000001',
            foundPerson: '宁波衣加衣宁波衣加衣',
            contactPerson: '宁波衣加衣宁波衣加衣',
            contactPhone: '13888888888',
            type: 'LABOR_AND_MATERIAL',
            time: 1586770813000,
            fapiao: '不开发票',
            quantity: 5000,
            price: 11111,
            total: 1222200202,
            budget: 12222,
            profit: 122222,
            profitMargin: 0.6,
            approvalBy: '周鸿伟',
            orderOwner: '马化腾',
            productionBy: '马云',
            procurementBy: '伟腾云'
          }, {
            date: '2016-05-02',
            name: '王小虎',
            code: 'CO0000000001',
            foundPerson: '宁波衣加衣宁波衣加衣',
            contactPerson: '宁波衣加衣宁波衣加衣',
            contactPhone: '13888888888',
            type: 'LABOR_AND_MATERIAL',
            time: 1586770813000,
            fapiao: '不开发票',
            quantity: 5000,
            price: 11111,
            total: 1222200202,
            budget: 12222,
            profit: 122222,
            profitMargin: 0.6,
            approvalBy: '周鸿伟',
            orderOwner: '马化腾',
            productionBy: '马云',
            procurementBy: '伟腾云'
          }, {
            date: '2016-05-02',
            name: '王小虎',
            code: 'CO0000000001',
            foundPerson: '宁波衣加衣宁波衣加衣',
            contactPerson: '宁波衣加衣宁波衣加衣',
            contactPhone: '13888888888',
            type: 'LABOR_AND_MATERIAL',
            time: 1586770813000,
            fapiao: '不开发票',
            quantity: 5000,
            price: 11111,
            total: 1222200202,
            budget: 12222,
            profit: 122222,
            profitMargin: 0.6,
            approvalBy: '周鸿伟',
            orderOwner: '马化腾',
            productionBy: '马云',
            procurementBy: '伟腾云'
          }, {
            date: '2016-05-02',
            name: '王小虎',
            code: 'CO0000000001',
            foundPerson: '宁波衣加衣宁波衣加衣',
            contactPerson: '宁波衣加衣宁波衣加衣',
            contactPhone: '13888888888',
            type: 'LABOR_AND_MATERIAL',
            time: 1586770813000,
            fapiao: '不开发票',
            quantity: 5000,
            price: 11111,
            total: 1222200202,
            budget: 12222,
            profit: 122222,
            profitMargin: 0.6,
            approvalBy: '周鸿伟',
            orderOwner: '马化腾',
            productionBy: '马云',
            procurementBy: '伟腾云'
          }]
        }
      }
    }
  }
</script>

<style scoped>
  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 100px;
    height: 40px;
    border-radius: 5px;
  }

  .border-container{
    border: 1px solid #DCDFE6;
    border-radius: 5px;
    background-color: #F5F5F5;
  }

  .sales-container-box {
    background-color: #D5D5DE;
    padding: 18px;
    border-radius: 3px;
  }

  .el-dropdown-link {
    cursor: pointer;
    color: #409EFF;
    font-size: 12px;
  }
  .el-icon-arrow-down {
    font-size: 12px;
  }
  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 30px;
    margin-top: 2px;
  }
  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }
</style>
