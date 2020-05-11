<template>
  <div class="animated fadeIn">
    <template v-for="(product, productIndex) in sampleList">
      <el-form>
      <el-row class="info-sales-row" type="flex" justify="space-between" align="middle" :gutter="20">
        <el-col :span="10">
          <el-row type="flex" align="middle" style="margin-left: 10px;">
              <h6 class="info-input-prepend">产品名</h6>
              <el-input placeholder="名称" v-model="product.name" size="mini" :disabled="true"></el-input>
              <el-button style="margin-left: 10px" @click="appendSample(productIndex)" size="mini">点击选择</el-button>
          </el-row>
        </el-col>
        <el-col :span="2">
          <el-row type="flex" align="middle">
            <el-button class="remove-btn" v-if="productIndex!=0" @click="removeRow(productIndex)">删除</el-button>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" v-if="product.code != null" class="info-order-row">
        <img class="purchase-product-img"
             :src="product.thumbnail!=null&&product.thumbnail.length!=0?product.thumbnail.url:'static/img/nopicture.png'">
        <table cellspacing="2" width="100%" :height="(sampleList.length+1)*50" class="order-table">
          <tr class="order-table-th_row">
            <td style="width: 40px">颜色</td>
            <template v-for="size in product.colorSizes[0].sizes">
              <th>{{size.name}}</th>
            </template>
            <th>小计</th>
          </tr>
          <template v-for="(color, rowIndex) in product.colorSizes">
            <tr>
              <td>{{color.colorName}}</td>
              <template v-for="size in product.colorSizes[0].sizes">
                <td style="width:80px">
                  <el-input class="order-table-input" type="number" @mousewheel.native.prevent :min="1"
                            v-model="getColorSize(color, size, product.colorSizes).quality">
                  </el-input>
                </td>
              </template>
              <td style="width:100px">{{countColorsAmount(color, product.colorSizes)}}</td>
            </tr>
          </template>
          <tr>
            <td :colspan="getColspanLength(product.colorSizes[0].sizes.length)">合计</td>
            <td>{{countTotalAmount(product.colorSizes)}}</td>
          </tr>
        </table>
      </el-row>
      <el-row type="flex" :gutter="20">
        <el-col :span="8">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">订单报价</h6>
            <el-input placeholder="订单报价" v-model="product.quotePrice" size="mini">
            </el-input>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">交货日期</h6>
            <el-date-picker v-model="product.deliverDate" type="date" placeholder="选择日期">
            </el-date-picker>
          </el-row>
        </el-col>
      </el-row>
      <el-row style="margin-top:20px;">
        <sample-attach-orders-form :slot-data="product"/>
      </el-row>
      <el-row class="info-order-row" style="margin-top:20px;" type="flex" align="center" :gutter="10">
        <el-col :span="4">
          <el-button class="product-form-btn" @click="onCreateAccountingSheet">创建成本核算单</el-button>
        </el-col>
        <el-col :span="2">
          <h6 style="padding-top:8px">核算单：</h6>
        </el-col>
        <el-col :span="18">
          <template v-for="(sheet,index) in slotData.costingSheets">
            <el-button :key="index" type="text" @click="onUpdateAccountingSheet(sheet,index)">
              {{sheet.id!=null?sheet.id:'成本核算单'+index+1}}
            </el-button>
          </template>
        </el-col>
      </el-row>
      <el-divider/>
      <production-task-invoice-form/>
      </el-form>
      <el-divider/>
    </template>
    <el-row type="flex" justify="center" class="info-order-row" align="middle" style="margin-top: 20px">
      <el-col :span="24">
        <div class="order-purchase-table-btn_add" @click="addRow">
          +添加另一款产品
        </div>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-button class="material-btn" @click="onSubmit">添加产品</el-button>
    </el-row>
    <el-dialog :visible.sync="materialDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <sample-products-select-dialog v-if="materialDialogVisible" @onSelectSample="onSelectSample"/>
    </el-dialog>
    <el-dialog :visible.sync="dialogVisible" width="90%" class="purchase-dialog" :close-on-click-modal="false" append-to-body>
      <sample-accounting-sheet-form v-if="dialogVisible" :slot-data="sampleAccountingSheet" @onSave="onAccountingSheetSave"
                                    :sampleSpecEntries="slotData.entries" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapMutations,
    mapActions
  } = createNamespacedHelpers('SampleProductsModule');

  import SampleProductsSelectDialog from '../../../product/sample/components/SampleProductsSelectDialog';
  import SampleAttachOrdersForm from '../../../product/sample/form/SampleAttachOrdersForm';
  import SampleAccountingSheetForm from '../../../product/sample/form/SampleAccountingSheetForm';
  import ProductionTaskInvoiceForm from '../production-task/form/ProductionTaskInvoiceForm';
  export default {
    name: 'SalesPlanAppendProduct',
    components: {
      ProductionTaskInvoiceForm,
      SampleAccountingSheetForm,
      SampleAttachOrdersForm,
      SampleProductsSelectDialog},
    computed: {
      ...mapGetters({
        slotData: 'newFormData'
      })
    },
    data () {
      return {
        materialDialogVisible: false,
        sampleList: [''],
        currentProductIndex: 0,
        dialogVisible: false,
        sampleAccountingSheet: {}
      }
    },
    methods: {
      appendSample (index) {
        this.currentProductIndex = index;
        this.materialDialogVisible = true;
      },
      onSelectSample (data) {
        this.materialDialogVisible = false;
        this.sampleList[this.currentProductIndex] = data;
        console.log(data);
      },
      removeRow (index) {
        this.sampleList.splice(index, 1);
      },
      countColorsAmount (color, colorSizes) {
        var amount = 0;
        colorSizes.forEach(val => {
          if (val.colorName == color.colorName) {
            val.sizes.forEach(item => {
              amount += parseInt(item.quality)
            });
          }
        })
        return amount;
      },
      countTotalAmount (colorSizes) {
        var amount = 0;
        colorSizes.forEach(val => {
          val.sizes.forEach(item => {
            amount += parseInt(item.quality);
          })
        })
        return amount;
      },
      getColspanLength (size) {
        return size + 1;
      },
      getColorSize (color, size, colorSizes) {
        var result = colorSizes.filter(item => {
          if (item.colorName == color.colorName) {
            const index = item.sizes.findIndex(val => val.name == size.name);
            return index > -1;
          }
        })
        if (result.length != 0) {
          for (let i = 0; i < result[0].sizes.length; i++) {
            if (result[0].sizes[i].name == size.name) {
              return result[0].sizes[i];
            }
          }
        } else {
          return null;
        }
      },
      onCreateAccountingSheet () {
        this.sampleAccountingSheet = {
          'isIncludeTax': true,
          'remarks': '',
          'totalPrice': 0,
          'materialsEntries': [],
          'specialProcessEntries': [],
          'laborCostEntries': []
        };
        this.dialogVisible = true;
      },
      onUpdateAccountingSheet (sheet, index) {
        this.sampleAccountingSheet = Object.assign({}, sheet);
        this.dialogVisible = true;
      },
      onAccountingSheetSave (sheet) {
        if (sheet.id != null) {
          var a = [];
          var entry = this.slotData.costingSheets.find(item => item.id == sheet.id);
          Object.assign(entry, sheet);
        } else if (sheet.key != null) {
          var entry = this.slotData.costingSheets.find(item => item.key == sheet.key);
          Object.assign(entry, sheet);
        } else {
          sheet['key'] = Date.now.toString;
          this.slotData.costingSheets.push(sheet);
        }
        this.dialogVisible = false;
      },
      addRow () {
        this.sampleList.push('');
      },
      onSubmit () {
        console.log('添加产品');
        this.$emit('onAppendProduct');
      }
    },
    created () {
    }
  }
</script>

<style>
  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }

  .remove-btn {
    background-color: #FFD60C;
  }

  .info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .info-title-row {
    margin-bottom: 20px;
  }

  .info-order-body {
    width: 100%;
    /* padding: 10px 60px; */
  }

  .info-order-row {
    margin-bottom: 20px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 80px;
  }

  .info-row_width50 {
    width: 50%;
  }

  .checkbox-text .el-checkbox__label {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.45);
  }

  .order-table {
    /* width: 600px;
    height: 600px; */
    border-collapse: collapse;
    margin-bottom: 20px;

    white-space: nowrap;
    overflow: hidden;
    overflow-x: scroll;
  }

  .order-table-input .el-input__inner {
    /* width: 60px; */
    border: 0px solid #fff;
    padding: 0px;
    text-align: center;
  }

  .order-table-btn {
    padding-left: 10px;
    width: 30px;
  }

  .order-table-info {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    margin-left: 20px;
  }

  /* .order-table-btn_add {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
  } */

  .order-purchase-table-btn_add {
    width: 100%;
    height: 50px;
    line-height: 50px;
    border: 0.5px dashed rgba(0, 0, 0, 0.15);
    text-align: center;
    align-content: center;
    color: rgba(0, 0, 0, 0.65);
  }

  .order-purchase-table-btn_add:hover {
    background: rgba(247, 247, 247, 1);
    cursor: pointer;
  }

  .info-sales-row {
    margin-top: 20px;
    margin-bottom: 20px;
  }

  .info-order-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
  }

  .purchase-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .purchase-dialog-header {
    padding: 0px !important;
  }

  .purchase-dialog .el-dialog__header {
    padding: 0px !important;
  }

  .purchase-product-img {
    width: 120px;
    height: 120px;
    border-radius: 10px;
    margin-right: 20px;
  }


  .order-table tr td,
  .order-table tr th {
    border: 1px solid rgba(0, 0, 0, 0.15);
    text-align: center;
    height: 30px;
    font-size: 10px;
    color: rgba(0, 0, 0, 0.65);
  }

  .info-radio .el-radio__label {
    font-size: 10px;
  }

  /* label {
    margin-bottom: 0px !important;
  } */

  .el-input--small .el-input__inner {
    height: 28px;
    line-height: 32px;
  }

  .el-input.is-disabled .el-input__inner {
    cursor: pointer;
    background-color: #fff;
  }

  .order-purchase-upload {
    margin-left: 50px;
  }

  .order-purchase-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .order-purchase-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }
</style>
