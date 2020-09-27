<template>
  <div class="shipping-order-list-container">
    <el-table ref="resultTable" stripe :data="page.content" :height="autoHeight" 
              :highlight-current-row="isSelect"  @current-change="handleCurrentChange">
      <el-table-column label="采购单号" prop="code" min-width="120px"></el-table-column>
      <el-table-column label="关联款号" prop="workOrder.task.productionTask.product.skuID"></el-table-column>
      <el-table-column label="物料名称" prop="workOrder.materials.name"></el-table-column>
      <el-table-column label="物料类别" prop="workOrder.materials.materialsType">
        <template slot-scope="scope">
          <span>{{getEnum('MaterialsType', scope.row.workOrder.materials.materialsType)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="物料编号" prop="workOrder.materials.code"></el-table-column>
      <el-table-column label="采购总量" prop="totalQuantity"></el-table-column>
      <el-table-column label="采购员" prop="workOrder.task.merchandiser.name"></el-table-column>
      <el-table-column label="单位" prop="workOrder.materials.unit"></el-table-column>
      <el-table-column label="创建时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="回料时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{getEnum('PurchaseOrderState', scope.row.state)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button type="text" @click="onDetail(scope.row)">详情</el-button>
          <el-button v-if="scope.row.state === 'NOT_COMMITED' || scope.row.state === 'AUDIT_FAILED'" type="text" @click="onEdit(scope.row)">编辑</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="pt-2"></div>
    <el-pagination class="pagination-right" layout="total, sizes, prev, pager, next, jumper"
      @size-change="onPageSizeChanged" @current-change="onCurrentPageChanged" :current-page="page.number + 1"
      :page-size="page.size" :page-count="page.totalPages" :total="page.totalElements">
    </el-pagination>
    <el-row type="flex" justify="center">
      <el-button class="sumbit-btn" @click="onSubmit">确定</el-button>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'PurchaseOrderList',
  props: {
    page: {
      type: Object,
      required: true
    },
    isSelect: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    onDetail(row) {
      this.$router.push('/purchase/order/' + row.id);
    },
    async onEdit (row) {
      await this.getDetail(row.id);
      
      this.$router.push({
        name: '创建采购单',
        params: {
          formData: this.orderDetail.workOrder,
          order: this.order
        }
      });
    },
    onPageSizeChanged(val) {
      this.$emit('onAdvancedSearch', 0, val);

      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    onCurrentPageChanged(val) {
      this.$emit('onAdvancedSearch', val - 1);
      
      this.$nextTick(() => {
        this.$refs.resultTable.bodyWrapper.scrollTop = 0
      });
    },
    async getDetail (id) {
      const url = this.apis().searchPurchaseOrderById(id);
      const result = await this.$http.get(url);
      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 1) {
        this.orderDetail = result.data;
        this.orderDetail.entries.forEach(item => {
          if (!item.receiveQuantity) {
            this.$set(item, 'receiveQuantity', '');
          }
          if (!item.remark) {
            this.$set(item, 'remark', '');
          }
        })
        if (!this.orderDetail.attachAgreements) {
          this.$set(this.orderDetail, 'attachAgreements', []);
        }
      } else if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }
      
      this.order = {
        id: this.orderDetail.id,
        cooperator: this.orderDetail.cooperator ? this.orderDetail.cooperator : {},
        cooperatorName: this.orderDetail.cooperatorName ? this.orderDetail.cooperatorName : '',
        approvers: this.orderDetail.approvers ? this.orderDetail.approvers : [],
        auditNeed: this.orderDetail.approvers && this.orderDetail.approvers.length >= 0,
        attachAgreements: this.orderDetail.attachAgreements ? this.orderDetail.attachAgreements : [],
        workOrder: {
          id: this.orderDetail.workOrder.id
        },
        entries: this.orderDetail.entries.map(val => {
          return {
            id: val.id,
            spec: {
              id: val.spec.id
            },
            name: this.orderDetail.workOrder.materials.name,
            colorName: val.spec.colorName,
            modelName: val.spec.modelName,
            specName: val.spec.specName,
            orderQuantity: val.orderQuantity,
            price: val.price,
            totalPrice: val.totalPrice,
            estimatedRecTime: val.estimatedRecTime
          }
        })
      }
    },
    handleCurrentChange (val) {
      this.selectRow = val;
    },
    onSubmit () {
      this.$emit('setPurchaseOrder', this.selectRow);
    }
  },
  data() {
    return {
      orderDetail: '',
      order: '',
      selectRow: ''
    }
  },
  create() {

  }
}
</script>

<style scoped>
  .shipping-order-list-container>>>.el-table th>.cell .el-checkbox {
    display: none;
  }

  .sumbit-btn {
    width: 100px;
    color: #606266;
    background-color: #ffd60c;
  }

</style>
