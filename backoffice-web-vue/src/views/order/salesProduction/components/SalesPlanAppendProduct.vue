<template>
  <div class="animated fadeIn">
    <el-form :model="appendProductForm" ref="appendProductForm">
      <template v-for="(entry, productIndex) in appendProductForm.sampleList">
        <div :key="productIndex">
          <el-row class="info-sales-row" type="flex" justify="space-between" align="middle" :gutter="20">
            <el-col :span="10">
              <el-row type="flex" align="middle" style="margin-left: 10px;">
                <h6 class="info-input-prepend">产品名</h6>
                <el-input placeholder="名称" v-model="entry.product.name" size="mini" :disabled="true"></el-input>
                <el-button style="margin-left: 10px" @click="appendSample(productIndex)" size="mini">点击选择</el-button>
              </el-row>
            </el-col>
            <el-col :span="2">
              <el-row type="flex" align="middle">
                <el-button class="remove-btn" v-if="productIndex!=0" @click="removeRow(productIndex)">删除</el-button>
              </el-row>
            </el-col>
          </el-row>
          <el-row type="flex" v-if="entry.product.code != null" class="info-order-row">
            <img class="purchase-product-img"
              :src="entry.product.thumbnail!=null&&entry.product.thumbnail.length!=0?entry.product.thumbnail.url:'static/img/nopicture.png'">
            <table cellspacing="2" width="100%" :height="(appendProductForm.sampleList.length+1)*50"
              class="order-table">
              <tr class="order-table-th_row">
                <td style="width: 40px">颜色</td>
                <template v-for="size in entry.sizes">
                  <th :key="size.name">{{size.name}}</th>
                </template>
                <th>小计</th>
              </tr>
              <template v-for="color in entry.colors">
                <tr :key="'tr'+color.code">
                  <td>{{color.name}}</td>
                  <template v-for="size in entry.sizes">
                    <td style="width:80px" :key="'td'+size.name">
                      <el-input class="order-table-input" type="number" @mousewheel.native.prevent :min="1"
                        v-model="getEntryByColorSize(color, size, entry.colorSizeEntries).quantity">
                      </el-input>
                    </td>
                  </template>
                  <td style="width:100px">{{countColorsAmount(color, entry.colorSizeEntries)}}</td>
                </tr>
              </template>
              <tr>
                <td :colspan="getColspanLength(entry.product.colorSizes[0].sizes.length)">合计</td>
                <td>{{countTotalAmount(entry.colorSizeEntries)}}</td>
              </tr>
            </table>
          </el-row>
          <el-row type="flex" :gutter="20">
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">订单报价</h6>
                <el-input placeholder="订单报价" v-model="entry.unitPrice" v-number-input.float="{ min: 0 ,decimal:2}"
                  size="mini">
                </el-input>
              </el-row>
            </el-col>
            <el-col :span="6">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">交货日期</h6>
                <el-date-picker v-model="entry.deliverDate" type="date" placeholder="选择日期">
                </el-date-picker>
              </el-row>
            </el-col>
          </el-row>
          <el-row style="margin-top:20px;">
            <sample-attach-orders-form :entries.sync="entry.materialsSpecEntries" :medias.sync="entry.medias"
              :productionProcessContent.sync="entry.productionProcessContent"
              :productsColors="getColorsByEntries(entry.colorSizeEntries)" />
          </el-row>
          <!-- <el-row class="info-order-row" style="margin-top:20px;" type="flex" align="center" :gutter="10">
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
        </el-row> -->
          <!-- <el-divider />
        <production-task-invoice-form />
        <el-divider /> -->
        </div>
      </template>
      <el-row type="flex" justify="center" class="info-order-row" align="middle" style="margin-top: 20px">
        <el-col :span="24">
          <div class="order-purchase-table-btn_add" @click="addRow">
            +添加另一款产品
          </div>
        </el-col>
      </el-row>
    </el-form>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-button class="material-btn" @click="onSubmit">添加产品</el-button>
    </el-row>
    <el-dialog :visible.sync="materialDialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sample-products-select-dialog v-if="materialDialogVisible" @onSelectSample="onSelectSample" />
    </el-dialog>
    <!-- <el-dialog :visible.sync="dialogVisible" width="90%" class="purchase-dialog" :close-on-click-modal="false"
      append-to-body>
      <sample-accounting-sheet-form v-if="dialogVisible" :slot-data="sampleAccountingSheet"
        @onSave="onAccountingSheetSave" :sampleSpecEntries="slotData.entries" />
    </el-dialog> -->
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
      SampleProductsSelectDialog
    },
    computed: {
      ...mapGetters({
        slotData: 'newFormData'
      })
    },
    data() {
      return {
        materialDialogVisible: false,
        appendProductForm: {
          sampleList: [{
            product: {

            },
            colorSizeEntries: [],
            unitPrice: '',
            deliverDate: '',
            materialsSpecEntries: [],
            productionProcessConten: '',
            medias: [],
            sampleAccountingSheet: {}
          }],
        },
        currentProductIndex: 0,
        dialogVisible: false,
      }
    },
    methods: {
      appendSample(index) {
        this.currentProductIndex = index;
        this.materialDialogVisible = true;
      },
      onSelectSample(data) {
        //构建颜色尺码行
        var colorSizeEntries = [];
        data.colorSizes.forEach(color => {
          color.sizes.forEach(size => {
            colorSizeEntries.push({
              color: {
                code: color.colorCode,
                name: color.colorName,
                id: color.colorId
              },
              size: {
                code: size.code,
                name: size.name,
                id: size.id
              },
              quantity: ''
            })
          });
        });

        //设置对应颜色，尺码数组        
        var entry = {
          product: data,
          colorSizeEntries: colorSizeEntries,
          unitPrice: '',
          deliverDate: '',
          materialsSpecEntries: data.entries,
          productionProcessContent: '',
          medias: [],
          sampleAccountingSheet: {},
          colors: this.getColorsByEntries(colorSizeEntries),
          sizes: this.getSizesByEntries(colorSizeEntries)
        }

        //通过set 赋值刷新渲染视图
        this.$set(this.appendProductForm.sampleList, this.currentProductIndex, entry);

        this.materialDialogVisible = false;
      },
      //获取样衣颜色
      getColorsByEntries(colorSizeEntries) {
        var colors = [];
        colorSizeEntries.forEach(entry => {
          let index = colors.findIndex(element => element.code == entry.color.code);
          if (index == -1) {
            colors.push(entry.color);
          }
        });
        return colors;
      },
      //获取样衣尺码
      getSizesByEntries(colorSizeEntries) {
        var sizes = [];
        colorSizeEntries.forEach(entry => {
          let index = sizes.findIndex(element => element.code == entry.size.code);
          if (index == -1) {
            sizes.push(entry.size);
          }
        });
        return sizes;
      },
      getEntryByColorSize(color, size, colorSizeEntries) {
        let index = colorSizeEntries.findIndex(entry => entry.color.code == color.code && entry.size.code == size.code);
        if (index != -1) {
          return colorSizeEntries[index];
        } else {
          //没找到，则创建对应对象
          var newObj = {
            color: color,
            size: size,
            quantity: '',
          };
          colorSizeEntries.push(newObj);
          return newObj;
        }
      },
      removeRow(index) {
        this.appendProductForm.sampleList.splice(index, 1);
      },
      countColorsAmount(color, colorSizeEntries) {
        var amount = 0;
        colorSizeEntries.filter(entry => entry.color.code == color.code).forEach(entry => {
          let num = parseFloat(entry.quantity);
          if (!Number.isNaN(num)) {
            amount += num;
          }
        });
        return amount;
      },
      countTotalAmount(colorSizeEntries) {
        var amount = 0;
        colorSizeEntries.forEach(entry => {
          let num = parseFloat(entry.quantity);
          if (!Number.isNaN(num)) {
            amount += num;
          }
        });
        return amount;
      },
      getColspanLength(size) {
        return size + 1;
      },
      getColorSize(color, size, colorSizes) {
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
      // getClothesColors(product) {
      //   var result = [];
      //   if (product != null && product.colorSizes != null) {
      //     product.colorSizes.forEach(item => {
      //       result.push({
      //         id: item.colorId,
      //         code: item.colorCode,
      //         name: item.colorName,
      //         previewImg: ''
      //       });
      //     })
      //   }
      //   return result;
      // },
      // onCreateAccountingSheet() {
      //   this.sampleAccountingSheet = {
      //     'isIncludeTax': true,
      //     'remarks': '',
      //     'totalPrice': 0,
      //     'materialsEntries': [],
      //     'specialProcessEntries': [],
      //     'laborCostEntries': []
      //   };
      //   this.dialogVisible = true;
      // },
      // onUpdateAccountingSheet(sheet, index) {
      //   this.sampleAccountingSheet = Object.assign({}, sheet);
      //   this.dialogVisible = true;
      // },
      // onAccountingSheetSave(sheet) {
      //   if (sheet.id != null) {
      //     var a = [];
      //     var entry = this.slotData.costingSheets.find(item => item.id == sheet.id);
      //     Object.assign(entry, sheet);
      //   } else if (sheet.key != null) {
      //     var entry = this.slotData.costingSheets.find(item => item.key == sheet.key);
      //     Object.assign(entry, sheet);
      //   } else {
      //     sheet['key'] = Date.now.toString;
      //     this.slotData.costingSheets.push(sheet);
      //   }
      //   this.dialogVisible = false;
      // },
      addRow() {
        this.appendProductForm.sampleList.push({
          product: {

          },
          colorSizeEntries: [],
          unitPrice: '',
          deliverDate: '',
          materialsSpecEntrie: [],
          productionProcessContent: '',
          medias: [],
          sampleAccountingSheet: {}
        });
      },
      onSubmit() {
        this.$emit('onAppendProduct');
      }
    },
    created() {}
  }

</script>
<style src="./css/sales-plan-append-product.css"></style>
