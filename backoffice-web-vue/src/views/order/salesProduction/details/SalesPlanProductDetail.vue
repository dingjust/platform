<template>
  <div class="animated fadeIn">
      <el-form>
        <el-row class="basic-form-row_top" type="flex" justify="space-between" align="middle" :gutter="20">
          <el-col :span="10">
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend">产品名:&#12288;{{product.name}}</h6>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" class="info-order-row">
          <img class="purchase-product-img"
               :src="product.thumbnail!=null&&product.thumbnail.length!=0?product.thumbnail.url:'static/img/nopicture.png'">
          <table cellspacing="2" width="100%" class="order-table">
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
                    <h6>{{getColorSize(color, size, product.colorSizes).quality}}</h6>
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
        <el-row class="basic-form-row_top" type="flex" :gutter="20">
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend">订单报价:&#12288;{{product.quotedPrice}}</h6>
            </el-row>
          </el-col>
          <el-col :span="6">
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend">交货日期:&#12288;{{product.date}}</h6>
            </el-row>
          </el-col>
        </el-row>
        <el-row style="margin-top:20px;">
          <el-tabs type="border-card">
            <el-tab-pane label="物料清单">
              <el-table ref="resultTable" stripe :data="product.content" highlight-current-row :height="autoHeight">
                <el-table-column label="品名" prop="name"/>
                <el-table-column label="规格" prop="spec"/>
                <el-table-column label="颜色" prop="color"/>
                <el-table-column label="单位" prop="unit"/>
                <el-table-column label="属性" prop="attribute"/>
                <el-table-column label="适用颜色" prop="suitColor"/>
                <el-table-column label="单位用量" prop="unitConsumption"/>
                <el-table-column label="损耗" prop="loss"/>
              </el-table>
            </el-tab-pane>
            <el-tab-pane label="生产工艺单"></el-tab-pane>
          </el-tabs>
<!--          <sample-attach-orders-form :slot-data="product"/>-->
        </el-row>
        <!-- <el-row class="info-order-row" style="margin-top:20px;" type="flex" align="center" :gutter="10">
         <el-col :span="4">
           <el-button class="product-form-btn" @click="onCreateAccountingSheet">创建成本核算单</el-button>
         </el-col>
          <el-col :span="2">
            <h6 style="padding-top:8px">核算单：</h6>
          </el-col>
          <el-col :span="22">
            <template v-for="(sheet,index) in slotData.costingSheets">
              <el-button :key="index" type="text" @click="onUpdateAccountingSheet(sheet,index)">
                {{sheet.id!=null?sheet.id:'成本核算单'+index+1}}
              </el-button>
            </template>
          </el-col>
        </el-row> -->
        <el-divider/>
        <div>
          <el-row class="basic-form-row_top" type="flex" align="middle">
            <h6 class="info-input-prepend_top">发单需求</h6>
          </el-row>
          <el-row class="basic-form-row" type="flex" :gutter="20">
            <!-- <el-col :span="5">
              <h6 class="info-input-prepend">外发目标价格:&#12288;{{product.outPrice}}</h6>
            </el-col> -->
            <el-col :span="5">
              <h6 class="info-input-prepend">外发交期:&#12288;{{product.date}}</h6>
            </el-col>
            <el-col :span="5">
              <h6 class="info-input-prepend">外发工厂规模:&#12288;{{product.scale}}</h6>
            </el-col>
            <el-col :span="9">
              <h6 class="info-input-prepend">指定生产工厂:&#12288;{{product.factory}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" class="basic-form-row" :gutter="20">
            <el-col :span="5">
              <h6 class="info-input-prepend">外发合作方式:&#12288;{{product.outPrice}}</h6>
            </el-col>
            <el-col :span="5">
              <h6 class="info-input-prepend">是否开票:&#12288;{{product.date}}</h6>
            </el-col>
            <el-col :span="5">
              <h6 class="info-input-prepend">税点:&#12288;{{product.scale}}</h6>
            </el-col>
            <el-col :span="9">
              <h6 class="info-input-prepend">是否需要打样:&#12288;{{product.factory}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" class="basic-form-row" :gutter="20">
            <el-col :span="5">
              <h6 class="info-input-prepend">联系人:&#12288;{{product.scale}}</h6>
            </el-col>
            <el-col :span="5">
              <h6 class="info-input-prepend">联系方式:&#12288;{{product.phone}}</h6>
            </el-col>
            <el-col :span="14">
              <h6 class="info-input-prepend">收货地址:&#12288;{{product.address}}</h6>
            </el-col>
          </el-row>
          <el-row class="basic-form-row_top" type="flex" align="middle">
            <h6 class="info-input-prepend_top">人员设置</h6>
          </el-row>
          <el-row type="flex" class="basic-form-row">
            <el-col :span="6">
              <h6 class="info-input-prepend">生产负责人:&#12288;{{product.charge}}</h6>
            </el-col>
          </el-row>
          <el-row class="basic-form-row_top" type="flex" align="middle">
            <h6 class="info-input-prepend_top">备注</h6>
          </el-row>
          <el-row type="flex" class="basic-form-row">
            <el-col>
              <h6 class="info-input-prepend">{{product.remarks}}</h6>
            </el-col>
          </el-row>
        </div>
      </el-form>
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
  export default {
    name: 'SalesPlanProductDetail',
    components: {
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
        sampleAccountingSheet: {},
        product: {
          outPrice: 100,
          scale: '100~200人',
          factory: '宁波衣加衣供应链有限公司',
          warehousing: '入别人仓',
          charge: '马化腾',
          machiningTypes: '',
          needVoice: '',
          tax: '',
          name: '全棉磨毛斜布',
          code: 'CO00000000001',
          date: '2019-19-19',
          quotedPrice: 1222222222,
          phone: '13888888888',
          address: '广东省广州市海珠区云顶同创汇云顶同创汇707',
          remarks: '备注备注备注备注备注备注备注备注备注备注备注备注备注',
          colorSizes: [{
            colorName: '棕色',
            colorCode: 'C35',
            sizes: [
              {
                code: 'S03',
                name: 'S',
                productCode: 'SCP100011005C35S03',
                quality: 100
              },
              {
                code: 'S02',
                name: 'XS',
                productCode: 'SCP100011005C35S02',
                quality: 200
              }
            ]
          }, {
            colorName: '驼色',
            colorCode: 'C34',
            sizes: [
              {
                code: 'S03',
                name: 'S',
                productCode: 'SCP100011005C35S03',
                quality: 100
              },
              {
                code: 'S02',
                name: 'XS',
                productCode: 'SCP100011005C35S02',
                quality: 200
              }
            ]
          }],
          content: [{
            name: '尼龙布',
            spec: '40*40cm',
            color: '白色',
            unit: '米',
            attribute: '面料',
            suitColor: '白色',
            unitConsumption: '1.6',
            loss: '5%'
          }, {
            name: '尼龙布1',
            spec: '40*40cm1',
            color: '白色1',
            unit: '米1',
            attribute: '面料1',
            suitColor: '白色1',
            unitConsumption: '1.63',
            loss: '51%'
          }]
        }
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
        this.$emit('onAppendProduct');
      }
    },
    created () {
    }
  }
</script>

<style>
  .sales-border-container{
    border: 1px solid #DCDFE6;
    border-radius: 5px;
    padding-top:10px;
    margin-left: 15px;
    margin-top: 10px;
  }

  .info-order-row {
    margin-bottom: 20px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 100%;
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

  .basic-form-row_top {
    padding-left: 8px;
    margin-bottom: 10px;
    margin-top: 10px;
  }
  .basic-form-row {
    padding-left: 25px;
    margin-top: 10px;
    /*margin-bottom: 20px;*/
  }

  .info-input-prepend_top {
    display: inline-block;
    margin: 0 5px;
    /*margin-top: 5px; */
    width: 60px;
    font-size: 14px;
    font-weight: 500;
    padding-top: 2px;
  }
</style>

