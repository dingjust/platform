<template>
  <div class="border-container">
    <el-dialog :visible.sync="salesProductAppendVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sales-plan-append-product-form v-if="salesProductAppendVisible" @onSave="onSave" :isUpdate="true"
        :updataEntry="updateEntry" :productionLeader="form.productionLeader" :readOnly="productFormReadOnly" />
    </el-dialog>
    <div class="over-tabs">
      <el-row type="flex">
        <el-button v-if="isCreate" class="material-btn" @click="appendProduct">添加商品</el-button>
      </el-row>
    </div>
    <el-tabs type="border-card">
      <el-tab-pane label="产品明细">
        <sales-production-products-table :data="form.entries" @onDelete="onProductDelete" @onModify="onProductModify"
          @onDetail="onProductDetail" />
      </el-tab-pane>
      <el-tab-pane label="生产明细">
        <sales-production-tasks-table :data="[]" @onDelete="onTaskDelete" @onModify="onTaskModify" />
      </el-tab-pane>
    </el-tabs>
    <!-- <el-dialog :visible.sync="salesProductDetailsVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sales-plan-product-detail v-if="salesProductDetailsVisible" />
    </el-dialog> -->
  </div>
</template>

<script>
  import {
    Popconfirm
  } from 'element-ui';

  // import SalesPlanProductDetail from '../details/SalesPlanProductDetail';
  import SalesPlanAppendProductForm from '../form/SalesPlanAppendProductForm';
  import SalesProductionProductsTable from './SalesProductionProductsTable';
  import SalesProductionTasksTable from './SalesProductionTasksTable';

  export default {
    name: 'SalesProductionTabs',
    components: {
      // SalesPlanProductDetail,
      SalesPlanAppendProductForm,
      SalesProductionProductsTable,
      SalesProductionTasksTable
    },
    props: {
      isCreate: {
        type: Boolean,
        default: true
      },
      form: {
        type: Object
      }
    },
    methods: {
      appendProduct() {
        this.$emit('appendProduct');
      },
      handleCommand(command) {
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
      //产品删除
      onProductDelete(index) {
        this.$confirm('确认删除？')
          .then(_ => {
            this.form.entries.splice(index, 1);
            popVisible = false;
          })
          .catch(_ => {});
      },
      onClose() {
        this.$message('------close--------');
      },
      //详情
      onProductDetail(index) {
        this.updateIndex = index;
        this.updateEntry = this.form.entries[index];
        this.productFormReadOnly = true,
          this.salesProductAppendVisible = true;
      },
      //产品修改
      onProductModify(index) {
        this.updateIndex = index;
        this.updateEntry = this.form.entries[index];
        this.productFormReadOnly = false,
        this.salesProductAppendVisible = true;
      },
      //编辑回调
      onSave(entries) {
        var newEntry = Object.assign(this.updateEntry, entries[0]);
        this.$set(this.form.entries, this.updateIndex, newEntry);
        this.salesProductAppendVisible = false;
      },
      //任务删除
      onTaskDelete(index) {
        // this.$confirm('确认删除？')
        //   .then(_ => {
        //     this.form.entries.splice(index, 1);
        //     popVisible = false;
        //   })
        //   .catch(_ => {});
      },
      //任务修改
      onTaskModify(index) {
        // this.updateIndex = index;
        // this.updateEntry = this.form.entries[index];
        // this.salesProductAppendVisible = true;
      },
    },
    data() {
      return {
        salesProductDetailsVisible: false,
        popVisible: false,
        updateEntry: null,
        updateIndex: null,
        salesProductAppendVisible: false,
        productFormReadOnly: false,
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

  .border-container {
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
