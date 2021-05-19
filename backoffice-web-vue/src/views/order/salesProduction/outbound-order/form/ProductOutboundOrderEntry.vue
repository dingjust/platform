<template>
  <div class="product-out-entry">
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
            <el-button @click="onProductSelect(index)" size="mini">{{item.product.id ? '更换产品' : '添加产品'}}</el-button>
          </div>
        </el-row>
        <outbound-order-color-size-table v-if="item.colorSizeEntries.length > 0" :product="item" :isFromProduct="true"/>
        <el-row type="flex" v-if="item.code" style="margin: 0px 0px 10px 30px;">
          <el-button @click="openColorSize(item)"> + 添加颜色尺码</el-button>
        </el-row>
        <div class="outbound-basic-row price-row">
          <div style="display:flex;margin-right: 20px">
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
      <sample-products-select-dialog v-if="taskDialogVisible" @onSelectSample="onSelectSample" 
                                      :selectedRow="formData.taskOrderEntries" :isSingleSelect="isSingleSelect"/>
    </el-dialog>
    <el-dialog :visible.sync="progressPlanVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <progress-plan-select-dialog v-if="progressPlanVisible" @getProgressPlan="getProgressPlan" />
    </el-dialog>
    <el-dialog :visible.sync="editProgressPlanVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <progress-plan-edit-form v-if="editProgressPlanVisible" :progressPlan="editProgress"
        @onEditProgress="onEditProgress" />
    </el-dialog>
    <el-dialog title="添加颜色 / 尺码" :visible.sync="colorSizeVisible" width="500px" append-to-body
      :close-on-click-modal="false">
      <color-size-add-form v-if="colorSizeVisible" @closeDialog="colorSizeVisible = false" 
                            @addColorSize="addColorSize"/>
    </el-dialog>
  </div>
</template>

<script>
import OutboundOrderColorSizeTable from '../table/OutboundOrderColorSizeTable'
import ProgressPlanSelectDialog from '@/views/user/progress-plan/components/ProgressPlanSelectDialog'
import ColorSizeAddForm from '../components/ColorSizeAddForm'
import { SampleProductsSelectDialog } from '@/views/product/sample'

import {
  MyAddressForm
} from '@/components'

export default {
  name: 'ProductOutboundOrderForm',
  props: ['formData'],
  components: {
    OutboundOrderColorSizeTable,
    SampleProductsSelectDialog,
    ProgressPlanSelectDialog,
    ColorSizeAddForm,
    MyAddressForm
  },
  methods: {
    onBlur(row, attribute) {
      var reg = /\.$/;
      if (reg.test(row[attribute])) {
        row[attribute] = Number.parseInt(row[attribute]);
      }
    },
    getPrice (row) {
      let quantity = 0;
      row.colorSizeEntries.forEach(item => quantity += (item.quantity ? Number.parseInt(item.quantity) : 0));

      let price = 0;
      if (!Number.isNaN(Number.parseFloat(row.totalPrimeCost))) {
        price = Number.parseFloat(row.totalPrimeCost) / (quantity === 0 ? 1 : quantity);
      }
      return price.toFixed(2);
    },
    deleteRow(index) {
      this.formData.taskOrderEntries.splice(index, 1);
    },
    addRow() {
      this.selectIndex = '';
      this.isSingleSelect = false;
      this.taskDialogVisible = true;
    },
    onSelectSample (selectList) {
      let row;
      let entries = [];
      let colorSizeEntries;
      selectList.forEach(item => {
        colorSizeEntries = this.convertColorSize(item.colorSizes);
        row = {
          code: item.code,
          colors: item.colors,
          sizes: item.sizes,
          deliveryDate: '',
          shippingAddress: {},
          product: {
            id: item.id,
            code: item.code,
            name: item.name,
            thumbnail: item.thumbnail,
            skuID: item.skuID
          },
          progressPlan: {
            name: ''
          },
          colorSizeEntries: colorSizeEntries
        }

        entries.push(row);
        row = null;
      })
      if (this.selectIndex === '') {
        this.formData.taskOrderEntries = this.formData.taskOrderEntries.concat(entries);
        this.isSingleSelect = true;
      } else {
        entries[0].shippingAddress = this.formData.taskOrderEntries[this.selectIndex].shippingAddress;
        this.formData.taskOrderEntries.splice(this.selectIndex, 1, entries[0]);
      }
      this.taskDialogVisible = false;
    },
    convertColorSize (colorSizes) {
      let colorSizeEntries = [];
      colorSizes.forEach(item => {
        item.sizes.forEach(val => {
          colorSizeEntries.push({
            color: {
              id: item.colorId,
              code: item.colorCode,
              name: item.colorName,
              customize: item.customize
            },
            quantity: 0,
            size: {
              code: val.code,
              name: val.name
            }
          })
        })
      })
      return colorSizeEntries;
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
    },
    onEditProgress(val) {
      this.formData.taskOrderEntries[this.selectIndex].progressPlan.productionProgresses = val;
      this.editProgressPlanVisible = false;
    },
    onProductSelect(index) {
      this.taskDialogVisible = true;
      this.isSingleSelect = true;
      this.selectIndex = index;
    },
    openColorSize (item) {
      this.colorSizeItem = item;
      this.colorSizeVisible = true;
    },
    addColorSize (data, selectType) {
      let sizeSet = new Set();
      let colorSet = new Set();
      this.colorSizeItem.colorSizeEntries.forEach(item => {
        sizeSet.add(item.size);
      });
      this.colorSizeItem.colorSizeEntries.forEach(item => {
        colorSet.add(item.color);
      });
      if (selectType === 'color') {
        sizeSet.forEach(item => {
          this.colorSizeItem.colorSizeEntries.push({
            color: data,
            quantity: 0,
            size: item
          })
        })
      } else {
        colorSet.forEach(item => {
          this.colorSizeItem.colorSizeEntries.push({
            color: item,
            quantity: 0,
            size: data
          })
        })
      }

      this.colorSizeVisible = false;
    },
    editProgressPlan(index, item) {
      this.editProgressPlanVisible = true;
      this.editProgress = item.progressPlan.productionProgresses;
      this.selectIndex = index;
    },
    onProgressPlanSelect(index) {
      this.progressPlanVisible = true;
      this.selectIndex = index;
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
  },
  data () {
    return {
      taskDialogVisible: false,
      selectIndex: '',
      isSingleSelect: true,
      colorSizeItem: '',
      colorSizeVisible: false,
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

.price-row {
  display: flex;
  justify-content: start;
  flex-wrap: wrap;
}

.outbound-btn {
  background: #FFD60C;
  color: rgba(0, 0, 0, 0.85);
  width: 70px;
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