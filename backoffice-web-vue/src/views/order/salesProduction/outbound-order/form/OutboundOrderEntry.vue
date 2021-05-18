<template>
  <div class="out-order-entry">
    <template v-for="(item, index) in formData.taskOrderEntries">
      <el-form ref="itemForm" label-width="80px" :model="item" :key="'form'+index">
        <el-row type="flex" justify="end" v-if="index > 0 || (index <= 0 && formData.taskOrderEntries.length > 1)">
          <el-button class="outbound-btn" @click="deleteRow(index)">删除</el-button>
        </el-row>
        <el-row>
          <h6 style="padding-left: 10px">生产详情</h6>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start">
          <el-form-item label="产品名称" prop="product"
            :rules="[{ type: 'object', validator: validateProduct, trigger: 'change' }]">
            <el-input v-model="item.product.name" :disabled="true" placeholder="请输入"></el-input>
          </el-form-item>
          <div style="margin-left: 20px">
            <el-button @click="onProductSelect(index)">{{item.product.id ? '更换工单' : '添加工单'}}</el-button>
          </div>
        </el-row>
        <outbound-order-color-size-table v-if="item.colorSizeEntries.length > 0" :product="item" />
        <div class="outbound-basic-row price-row">
          <div style="display: flex;margin-right: 20px">
            <el-form-item label="发单总价" prop="totalPrimeCost"
              :rules="[{required: true, message: '请填写发单总价', trigger: 'blur'}]">
              <el-input v-model="item.totalPrimeCost" placeholder="请输入" @blur="onBlur(item,'totalPrimeCost')"
                v-number-input.float="{ min: 0 ,decimal:2}"></el-input>
            </el-form-item>
            <h6 style="margin:0;padding:8px 0 0 10px;width:130px">发单单价：{{(getPrice(item))}}</h6>
          </div>
          <div style="margin-right: 20px">
            <el-form-item label="交货日期" prop="deliveryDate"
              :rules="[{required: true, message: '请选择交货日期', trigger: 'change'}]">
              <el-date-picker v-model="item.deliveryDate" type="date" value-format="timestamp" placeholder="选择日期">
              </el-date-picker>
            </el-form-item>
          </div>
          <div style="margin-right: 20px">
            <el-form-item label="生产节点" prop="progressPlan"
              :rules="[{ required: true, type: 'object', validator: validateProgressPlan, trigger: 'change' }]">
              <el-input v-model="item.progressPlan.name" :disabled="true" placeholder="请输入">
                <el-button slot="suffix" v-if="item.progressPlan.isFromOrder" @click="editProgressPlan(index, item)">编辑</el-button>
                <el-button slot="suffix" v-else @click="onProgressPlanSelect(index)">选择节点</el-button>
              </el-input>
            </el-form-item>
          </div>
        </div>
        <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
          <el-col :span="24">
            <my-address-form :vAddress.sync="item.shippingAddress" ref="addressForm" />
          </el-col>
        </el-row>
      </el-form>
      <el-divider :key="'divider'+index" />
    </template>
    <el-row type="flex" justify="center" class="info-order-row" align="middle">
      <el-col :span="24">
        <div class="order-purchase-table-btn_add" @click="addRow">
          +添加另一生产任务
        </div>
      </el-col>
    </el-row>
    <el-dialog :visible.sync="taskDialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <production-task-select-dialog v-if="taskDialogVisible" :formData="formData" @onSelectTask="onSelectTask"
        :selectType="'OUTBOUND_ORDER'" :isSingleChoice="isSingleSelect"/>
    </el-dialog>
    <el-dialog :visible.sync="editProgressPlanVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <progress-plan-edit-form v-if="editProgressPlanVisible" :progressPlan="editProgress"
        @onEditProgress="onEditProgress" />
    </el-dialog>
    <el-dialog :visible.sync="progressPlanVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <progress-plan-select-dialog v-if="progressPlanVisible" @getProgressPlan="getProgressPlan" />
    </el-dialog>
  </div>
</template>

<script>
import OutboundOrderColorSizeTable from '../table/OutboundOrderColorSizeTable'
import ProgressPlanEditForm from '@/views/user/progress-plan/components/ProgressPlanEditForm'
import ProgressPlanSelectDialog from '@/views/user/progress-plan/components/ProgressPlanSelectDialog'
import ProductionTaskSelectDialog from '@/views/order/salesProduction/production-task/components/ProductionTaskSelectDialog'

import {
  MyAddressForm
} from '@/components'

export default {
  name: 'OutboundOrderEntry',
  props: ['formData'],
  components: {
    OutboundOrderColorSizeTable,
    MyAddressForm,
    ProgressPlanEditForm,
    ProgressPlanSelectDialog,
    ProductionTaskSelectDialog
  },
  methods: {
    getPrice (row) {
      let quantity = 0;
      row.colorSizeEntries.forEach(item => quantity += (item.quantity ? item.quantity : 0));

      let price = 0;
      if (!Number.isNaN(Number.parseFloat(row.totalPrimeCost))) {
        price = Number.parseFloat(row.totalPrimeCost) / (quantity === 0 ? 1 : quantity);
      }
      return price.toFixed(2);
    },
    onProductSelect(index) {
      this.taskDialogVisible = true;
      this.isSingleSelect = true;
      this.selectIndex = index;
    },
    onBlur(row, attribute) {
      var reg = /\.$/;
      if (reg.test(row[attribute])) {
        row[attribute] = Number.parseInt(row[attribute]);
      }
    },
    validateProduct(rule, value, callback) {
      if (value.id) {
        return callback();
      } else {
        return callback(new Error('请选择产品'))
      }
    },
    validateProgressPlan(rule, value, callback) {
      if (value.name && value != '') {
        return callback();
      } else {
        return callback(new Error('请选择生产节点'))
      }
    },
    addRow() {
      this.selectIndex = '';
      this.isSingleSelect = false;
      this.taskDialogVisible = true;
    },
    deleteRow(index) {
      this.formData.taskOrderEntries.splice(index, 1);
    },
    onSelectTask(selectTaskList) {
      if (!selectTaskList || selectTaskList.length <= 0) {
        this.taskDialogVisible = false;
        return;
      }
      let row = {}
      let entries = [];
      selectTaskList.forEach(item => {
        row = {
          originOrder: {
            id: item.id
          },
          deliveryDate: item.deliveryDate,
          shippingAddress: item.shippingAddress,
          product: {
            id: item.product.id,
            name: item.product.name,
            thumbnail: item.product.thumbnail,
            skuID:item.product.skuID
          },
          progressPlan: {
            name: ''
          },
          colorSizeEntries: item.colorSizeEntries
        }
        if (item.progressWorkSheet) {
          row.progressPlan = this.copyProgressPlan({
            name: '节点方案1',
            remarks: '',
            productionProgresses: item.progressWorkSheet.progresses
          })
          row.progressPlan.isFromOrder = true;
        }
        entries.push(row);
        row = {};
      })
      if (this.selectIndex === '') {
        this.formData.taskOrderEntries = this.formData.taskOrderEntries.concat(entries);
        this.isSingleSelect = true;
      } else {
        this.formData.taskOrderEntries.splice(this.selectIndex, 1, entries[0]);
      }
      // 回显地址
      this.formData.taskOrderEntries.forEach((val, index) => {
        if (this.$refs.addressForm[index]) {
          this.$refs.addressForm[index].getCities(val.shippingAddress.region);
          this.$refs.addressForm[index].onCityChanged(val.shippingAddress.city);
        }
      })
      this.taskDialogVisible = false;
    },
    editProgressPlan(index, item) {
      this.editProgressPlanVisible = true;
      this.editProgress = item.progressPlan.productionProgresses;
      this.$set(this, 'selectIndex', index);
    },
    onEditProgress(val) {
      this.formData.taskOrderEntries[this.selectIndex].progressPlan.productionProgresses = val;
      this.editProgressPlanVisible = false;
    },
    onProgressPlanSelect(index) {
      this.progressPlanVisible = true;
      this.selectIndex = index;
    },
    getProgressPlan(val) {
      if (val) {
        this.formData.taskOrderEntries[this.selectIndex].progressPlan = this.copyProgressPlan(val);
      }
      this.progressPlanVisible = false;
    },
    copyProgressPlan(val) {
      let row = {
        name: val.name,
        remarks: val.remarks,
        productionProgresses: []
      }
      val.productionProgresses.forEach(item => {
        row.productionProgresses.push({
          progressPhase: item.progressPhase,
          warningDays: item.warningDays,
          medias: item.medias,
          completeAmount: item.completeAmount,
          productionProgressOrders: item.productionProgressOrders,
          quantity: item.quantity,
          sequence: item.sequence,
          isCannotRemove: true
        })
      })
      return row;
    }
  },
  data () {
    return {
      taskDialogVisible: false,
      selectIndex: '',
      isSingleSelect: false,
      editProgressPlanVisible: false,
      editProgress: '',
      progressPlanVisible: false
    }
  }
}
</script>

<style scoped>
.outbound-basic-row {
  padding-left: 20px;
}

.outbound-btn {
  background: #FFD60C;
  color: rgba(0, 0, 0, 0.85);
  width: 70px;
}

.price-row {
  display: flex;
  justify-content: start;
  flex-wrap: wrap;
}

.info-order-row {
  margin-bottom: 20px;
}

.order-purchase-table-btn_add {
  width: 100%;
  height: 50px;
  line-height: 50px;
  border: 0.5px dashed rgba(0, 0, 0, 0.15);
  text-align: center;
  align-content: center;
  color: rgba(0, 0, 0, 0.65);
  background: rgba(247, 247, 247, 1);
}

.order-purchase-table-btn_add:hover {
  background: #fff9c4;
  cursor: pointer;
}
</style>