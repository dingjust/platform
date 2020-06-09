<template>
  <div>
    <el-dialog :visible.sync="dialogVisible" width="95%" class="purchase-dialog" :close-on-click-modal="false"
      :append-to-body="true">
      <sample-accounting-sheet-form :slot-data="sampleAccountingSheet" @onSave="onAccountingSheetSave"
        :unitPrice="unitPrice" :sampleSpecEntries="sampleSpecEntries" v-if="hackSet"
        :needMaterialAccounting="needMaterialAccounting" />
    </el-dialog>
    <el-form :model="slotData" ref="accountingSheetForm">
      <el-tabs value="first" type="card">
        <el-tab-pane label="成本预算单" name="first">
          <el-row type="flex" justify="space-between">
            <el-col :span="6">
              <h6>{{slotData.isIncludeTax?'含税':'不含税'}}</h6>
            </el-col>
            <el-col :span="2" v-if="!readOnly">
              <el-button @click="onUpdateAccountingSheet">编辑</el-button>
            </el-col>
          </el-row>
          <div>
            <div class="d1">
              <template v-if="needMaterialAccounting">
                <el-divider></el-divider>
                <el-row type="flex" align="center">
                  <el-col :span="1" class="form-column">
                    <h6 class="accounting-form-title">面辅料</h6>
                  </el-col>
                  <el-col :span="23">
                    <material-accounting-table :slotData="slotData.materialsEntries"
                      :taxIncluded="slotData.isIncludeTax" :sampleSpecEntries="sampleSpecEntries" />
                  </el-col>
                </el-row>
              </template>
              <el-divider></el-divider>
              <el-row type="flex" align="center">
                <el-col :span="1" class="form-column">
                  <h6 class="accounting-form-title">特殊工艺</h6>
                </el-col>
                <el-col :span="23">
                  <craft-accounting-table :slotData="slotData.specialProcessEntries"
                    :taxIncluded="slotData.isIncludeTax" />
                </el-col>
              </el-row>
              <el-divider></el-divider>
              <el-row type="flex" align="center">
                <el-col :span="1" class="form-column">
                  <h6 class="accounting-form-title">工费及其他</h6>
                </el-col>
                <el-col :span="23">
                  <other-accounting-table :slotData="slotData.laborCostEntries" :taxIncluded="slotData.isIncludeTax" />
                </el-col>
              </el-row>
              <div class="sheet-total">
                <el-row type="flex" align="center" justify="end">
                  <div class="sheet-total-title">
                    <el-row type="flex" justify="center" align="center">
                      <h6>总计价格</h6>
                    </el-row>
                  </div>
                  <div style="width:160px;text-align:center">
                    <h6>￥{{totalPrice}}</h6>
                  </div>
                </el-row>
              </div>
              <div class="sheet-total_2" style="margin-top:0px">
                <el-row type="flex" align="center" justify="end">
                  <div class="sheet-total-title">
                    <el-row type="flex">
                      <el-col :span="3" class="sheet-total-cell">销售单价</el-col>
                      <el-col :span="4" class="sheet-total-cell">
                        {{unitPrice!=null?unitPrice:''}}元</el-col>
                      <el-col :span="3" class="sheet-total-cell">预计单价成本</el-col>
                      <el-col :span="4" class="sheet-total-cell">{{totalPrice}}</el-col>
                      <el-col :span="3" class="sheet-total-cell">预计单件利润</el-col>
                      <el-col :span="4" class="sheet-total-cell">
                        {{unitPrice!=null?(unitPrice-totalPrice).toFixed(2):''}}元
                      </el-col>
                      <el-col :span="3" class="sheet-total-cell">预计单件利润率</el-col>
                    </el-row>
                  </div>
                  <div style="width: 160px;text-align: center;">
                    <h6 class="total_profit">
                      {{countProfit()}}%
                    </h6>
                  </div>
                </el-row>
              </div>
              <div class="d2">
                <div class="divider" />
              </div>
            </div>
          </div>
          <el-row type="flex" align="center" style="margin-top:10px;">
            <el-col :span="1" class="form-column">
              <h6 class="accounting-form-title">备注</h6>
            </el-col>
            <el-col :span="23">
              <div style="padding-top:10px">
                {{slotData.remarks}}
              </div>
            </el-col>
          </el-row>
        </el-tab-pane>
      </el-tabs>
    </el-form>
  </div>
</template>

<script>
  import MaterialAccountingTable from "./MaterialAccountingTable";
  import CraftAccountingTable from "./CraftAccountingTable";
  import OtherAccountingTable from "./OtherAccountingTable";
  import SampleAccountingSheetForm from '../form/SampleAccountingSheetForm';

  export default {
    name: "SampleAccountingSheet",
    props: {
      slotData: {
        type: Object
      },
      readOnly: {
        type: Boolean,
        default: false
      },
      sampleSpecEntries: {
        type: Array,
      },
      unitPrice: {},
      needMaterialAccounting: {
        type: Boolean,
        default: true
      }
    },
    components: {
      MaterialAccountingTable,
      OtherAccountingTable,
      CraftAccountingTable,
      SampleAccountingSheetForm
    },
    computed: {
      totalPrice: function () {
        let price1 = 0;
        let price2 = 0;
        let price3 = 0;

        if (this.slotData.materialsEntries != null) {
          this.slotData.materialsEntries.forEach(element => {
            let sum = parseFloat(element.materialsSpecEntry.unitQuantity * (1 + parseFloat(element
              .materialsSpecEntry
              .lossRate)) * (this
              .slotData
              .isIncludeTax ?
              element.unitPriceIncludingTax : element.unitPriceExcludingTax));
            if (sum != null && !isNaN(sum)) {
              price1 += sum;
            }
          });
        }
        if (this.slotData.specialProcessEntries != null) {
          this.slotData.specialProcessEntries.forEach(element => {
            let sum = parseFloat(this
              .slotData
              .isIncludeTax ? element.unitPriceIncludingTax : element.unitPriceExcludingTax);
            if (sum != null && !isNaN(sum)) {
              price2 += sum;
            }
          });
        }

        if (this.slotData.laborCostEntries != null) {
          this.slotData.laborCostEntries.forEach(element => {
            let sum = parseFloat(this
              .slotData
              .isIncludeTax ? element.unitPriceIncludingTax : element.unitPriceExcludingTax);
            if (sum != null && !isNaN(sum)) {
              price3 += sum;
            }
          });
        }

        return (price1 + price2 + price3).toFixed(2);
      }
    },
    methods: {
      onUpdateAccountingSheet() {
        let sheetJson = JSON.stringify(this.slotData);
        var sheetObj = JSON.parse(sheetJson);
        this.sampleAccountingSheet = Object.assign({}, sheetObj);

        this.hackSet = false;
        this.$nextTick(() => {
          this.hackSet = true;
        });
        this.dialogVisible = true;
      },
      onAccountingSheetSave(sheet) {
        // if (sheet.id != null) {          
        // var entry = this.slotData.costingSheets.find(item => item.id == sheet.id);
        Object.assign(this.slotData, sheet);
        // } else if (sheet.key != null) {
        //   var entry = this.slotData.costingSheets.find(item => item.key == sheet.key);
        //   Object.assign(entry, sheet);
        // } else {
        //   sheet['key'] = Date.now.toString;
        //   this.slotData.costingSheets.push(sheet);
        // }
        this.dialogVisible = false;
      },
      countProfit() {
        if (this.unitPrice == null || this.unitPrice == '') {
          return '';
        }

        let result = (((parseFloat(this.unitPrice) - this
            .totalPrice) /
          parseFloat(this.unitPrice)) * 100).toFixed(2);
        if (Number.isNaN(result)) {
          return '';
        } else {
          return result;
        }
      }
    },
    data() {
      return {
        hackSet: true,
        dialogVisible: false,
        sampleAccountingSheet: {},
      };
    },
    created() {}
  };

</script>
<style scoped>
  .accounting-form-title {
    width: 20px;
    text-align: center;
    line-height: 20px;
  }

  .form-column {
    align-items: center;
    display: flex;
    display: -webkit-flex;
    justify-content: center;
  }

  .sheet-total-title {
    flex-grow: 1;
  }


  .sheet-total {
    padding-top: 8px;
    padding-bottom: 5px;
    margin-top: 24px;
    border-top: 1px solid #DCDFE6;
    border-bottom: 1px solid #DCDFE6;
  }

  .sheet-total_2 {
    margin-top: 24px;
    border-bottom: 1px solid #DCDFE6;
  }


  .d1 {
    z-index: 1;
    position: relative;
  }

  .d2 {
    z-index: 100;
  }

  .divider {
    position: absolute;
    border-left: 1px solid #DCDFE6;
    height: 100%;
    width: 1px;
    top: 0px;
    right: 160px;
    /* margin-right: 110px; */
  }

  .sheet-total-cell {
    border-right: 1px solid #DCDFE6;
    line-height: 100%;
    height: 100%;
    padding-top: 10px;
    padding-bottom: 10px;
    text-align: center;
  }

  .total_profit {
    padding-top: 10px;
    color: red;
  }

</style>
