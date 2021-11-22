<template>
  <div>
    <el-table :data="data" stripe style="width: 100%" row-key="id">
      <el-table-column type="selection" :reserve-selection="true" width="55">
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
      <el-table-column label="金额" prop="totalPrimeCost" />
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
          <el-button v-if="canModifyPrice(scope.row)" type="text" @click="onModifyPrice(scope.row)">修改价格</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog :visible.sync="dialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <production-order-detail :id="openId" v-if="dialogVisible" />
    </el-dialog>
    <el-dialog :visible.sync="updatePriceVisible" title="修改产品价格" width="400px" append-to-body :close-on-click-modal="false">
      <el-form ref="form" :model="updateForm" :inline="true">
        <el-form-item label="单价" prop="unitPrice" :rules="[{ required: true, message: '请输入', tigger: 'change' }]">
          <el-input v-model="updateForm.unitPrice" ></el-input>
        </el-form-item>
      </el-form>
      <el-row type="flex" justify="end" align="middle">
        <el-button @click="updatePriceVisible = false">取消</el-button>
        <el-button type="primary" @click="_onModifyPrice">确定</el-button>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
// import ProductionOrderDetail from '../production-order/details/ProductionOrderDetail'

  export default {
    name: 'SalesProductionTasksTable',
    components: {
      ProductionOrderDetail:()=>import('../production-order/details/ProductionOrderDetail')
    },
    props: {
      data: {
        type: Array
      },
      isSelfCreated: {
        type: Boolean
      },
      readOnly: {
        type: Boolean
      }
    },
    methods: {
      canModifyPrice (row) {
        return true
        // return this.isSelfCreated && row.state === 'TO_BE_PRODUCED' && !this.readOnly;
      },
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
      onModifyPrice (row) {
        this.updateForm = {
          id: row.id,
          unitPrice: row.unitPrice
        }
        this.updatePriceVisible = true;
      },
      _onModifyPrice () {
        this.$refs.form.validate(valid => {
          if (valid) {
            this.__onModifyPrice();
          }
        });
      },
      async __onModifyPrice () {
        const url = this.apis().updateSalesProductionItemPrice();
        const result = await this.$http.post(url, {}, {
          id: this.updateForm.id,
          price: this.updateForm.unitPrice
        });
        
        if (result.code == 1) {
          this.$message.success('修改成功');
          this.$emit('callback');
          this.updatePriceVisible = false;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
        } else if (result['errors']) {
          this.$message.error(result['errors'][0].message);
        } else {
          this.$message.error('操作失败！');
        }

      }
    },
    data() {
      return {
        dialogVisible: false,
        openId: '',
        updatePriceVisible: false,
        updateForm: {
          unitPrice: ''
        }
      }
    }
  }

</script>

<style scoped>

</style>
