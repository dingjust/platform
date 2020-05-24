<template>
  <div>
    <el-table :data="data" stripe style="width: 100%">
      <el-table-column type="selection" width="55">
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
      <el-table-column label="数量">
        <template slot-scope="scope">
          <span>{{getEntryTotalAmount(scope.row)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="关联任务单"></el-table-column>
      <el-table-column label="关联外发单">
      </el-table-column>
      <el-table-column label="关联生产单">
      </el-table-column>
      <el-table-column label="关联采购任务">
      </el-table-column>
      <el-table-column label="交货时间">
        <template slot-scope="scope">
          <span>{{scope.row.deliveryDate | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="订单状态">
        <!-- <template slot-scope="scope">
          <span>{{scope.row.status!=null? getEnum('SalesProductionAuditStatus', scope.row.auditState):''}}</span>
        </template> -->
      </el-table-column>
      <el-table-column label="操作" min-width="120">
        <template slot-scope="scope">
          <!-- <el-button type="text" @click="onProductDetail(scope.row)">详情</el-button> -->
          <el-button type="text" @click="onModify(scope.$index)">编辑</el-button>
          <el-button slot="reference" type="text" @click="onDelete(scope.$index)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'SalesProductionTasksTable',
    components: {},
    props: {
      data: {
        type: Array
      }
    },
    methods: {
      onProductDetail(row) {
        // this.salesProductDetailsVisible = true;
      },
      onDelete(index) {
        this.$emit('onTaskDelete', index);
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

      }
    }
  }

</script>

<style scoped>

</style>
