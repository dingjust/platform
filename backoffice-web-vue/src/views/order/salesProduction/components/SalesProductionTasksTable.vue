<template>
  <div>
    <el-table :data="data" stripe style="width: 100%">
      <el-table-column type="selection" width="55">
      </el-table-column>
      <el-table-column label="生产工单号" prop="code" />
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
      <el-table-column label="货号" prop="product.skuID" />
      <el-table-column label="价格" prop="unitPrice" />
      <el-table-column label="数量">
        <template slot-scope="scope">
          <span>{{getEntryTotalAmount(scope.row)}}</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="关联任务单" prop="productionTask.code" min-width="120">
        <template slot-scope="scope">
          <el-button type="text" @click="onTaskDetail(scope.row.productionTask.id)">{{scope.row.productionTask.code}}
          </el-button>
        </template>
      </el-table-column> -->
      <!-- <el-table-column label="关联外发单" min-width="120">
      </el-table-column>
      <el-table-column label="关联生产单" min-width="120">
        <template slot-scope="scope">
          <el-button type="text" @click="onProductionOrderDetail(scope.row.id)">
            {{scope.row.code}}
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="关联采购任务" min-width="120">
      </el-table-column> -->
      <el-table-column label="交期">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" min-width="120">
        <template slot-scope="scope">
          <el-button type="text" @click="onProductionOrderDetail(scope.row.id)">详情</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog :visible.sync="dialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <production-order-detail :id="openId" v-if="dialogVisible" />
    </el-dialog>
  </div>
</template>

<script>
import ProductionOrderDetail from '../production-order/details/ProductionOrderDetail'

  export default {
    name: 'SalesProductionTasksTable',
    components: {
      ProductionOrderDetail
    },
    props: {
      data: {
        type: Array
      }
    },
    methods: {
      //entry detail
      onDetail(id) {
        this.$router.push('/sales/entry/' + id);
      },
      onDelete(index) {
        this.$emit('onTaskDelete', index);
      },
      onTaskDetail(id) {
        this.$router.push('/sales/production/' + id);
      },
      onProductionOrderDetail(id) {
        // this.$router.push('/sales/productionOrder/' + id);
        this.openId=id;
        this.dialogVisible=true;
      },
      onClose() {

      },
      onModify(index) {
        this.$emit('onTaskModify', index);
      },
      //数量
      getEntryTotalAmount(entry) {
        var result = 0;
        entry.colorSizeEntries.forEach(element => {
          let num = parseFloat(element.quantity);
          if (!Number.isNaN(num)) {
            result += num
          }
        });
        return result;
      },
    },
    data() {
      return {
        dialogVisible: false,
        openId: ''
      }
    }
  }

</script>

<style scoped>

</style>
