<template>
  <div>
    <el-dialog :visible.sync="dialogVisible" width="65%" class="purchase-dialog" :close-on-click-modal="false"
      append-to-body>
      <sample-spec-entries-table :slot-data="sampleSpecEntries" @onAdd="onEntriesAdd" v-if="hackSet" />
    </el-dialog>
    <el-table :data="slotData" style="width: 100%">
      <el-table-column prop="materialsSpecEntry.materialsName" label="物料名称">
      </el-table-column>
      <el-table-column prop="materialsSpecEntry.spec" label="物料规格">
        <template slot-scope="scope">
          {{scope.row.materialsSpecEntry.spec.name}}
        </template>
      </el-table-column>
      <el-table-column prop="materialsSpecEntry.unitQuantity" label="物料单位">
        <template slot-scope="scope">
          {{getEnum('MaterialsUnit', scope.row.materialsSpecEntry.materialsUnit)}}
        </template>
      </el-table-column>
      <el-table-column prop="materialsSpecEntry.materialsType" label="物料属性">
        <template slot-scope="scope">
          {{getEnum('MaterialsType', scope.row.materialsSpecEntry.materialsType)}}
        </template>
      </el-table-column>
      <el-table-column prop="materialsSpecEntry.unitQuantity" label="单位用量">
      </el-table-column>
      <el-table-column prop="materialsSpecEntry.lossRate" label="损耗">
        <template slot-scope="scope">
          {{showFloatPercentNum(scope.row.materialsSpecEntry.lossRate)+'%'}}
        </template>
      </el-table-column>
      <el-table-column prop="actualUsage" label="单位实际用量">
        <template slot-scope="scope">
          {{(scope.row.materialsSpecEntry.unitQuantity*(1+parseFloat(scope.row.materialsSpecEntry.lossRate))).toFixed(2)}}
        </template>
      </el-table-column>
      <el-table-column prop="unitPriceExcludingTax" label="不含税单价">
        <template slot-scope="scope">
          <el-form-item :key="'materialsEntries-UPET'+scope.$index"
            :prop="'materialsEntries.' + scope.$index + '.unitPriceExcludingTax'"
            :rules="{required: !taxIncluded, message: '不能为空', trigger: 'change'}">
            <el-input v-model="scope.row.unitPriceExcludingTax" class="form-input"
              @change="(val)=>onUnitPriceExcludingTaxInput(val,scope.row)" v-number-input.float="{ min: 0 ,decimal:2}">
            </el-input>
          </el-form-item>
        </template>
      </el-table-column>
      <el-table-column prop="taxRate" label="税率">
        <template slot-scope="scope">
          <el-form-item :key="'TR'+scope.$index" :prop="'materialsEntries.' + scope.$index + '.taxRate'"
            :rules="{required: taxIncluded, message: '不能为空', trigger: 'change'}" v-if="taxIncluded">
            <el-input @input="(val)=>onTaxInput(val,scope.row)" :value="showFloatPercentNum(scope.row.taxRate)"
              @blur="onBlur(scope.row,'taxRate')" v-number-input.float="{ min: 0,max:100 ,decimal:1}" class="form-input"
              :disabled="!taxIncluded">
              <h6 slot="suffix" style="padding-top:25px">%</h6>
            </el-input>
          </el-form-item>
        </template>
      </el-table-column>
      <el-table-column prop="unitPriceIncludingTax" label="含税单价">
        <template slot-scope="scope">
          <el-form-item :key="'UPIT'+scope.$index" :prop="'materialsEntries.' + scope.$index + '.unitPriceIncludingTax'"
            :rules="{required: taxIncluded, message: '不能为空', trigger: 'change'}" v-if="taxIncluded">
            <el-input v-model="scope.row.unitPriceIncludingTax" class="form-input"
              @change="(val)=>onUnitPriceIncludingTaxInput(val,scope.row)" v-number-input.float="{ min: 0 ,decimal:2}"
              placeholder="输入" :disabled="!taxIncluded">
            </el-input>
          </el-form-item>
        </template>
      </el-table-column>
      <el-table-column prop="unitPriceIncludingTax" :label="taxIncluded?'含税单件价格':'不含税单件价格'" fixed="right" width="110px">
        <template slot-scope="scope">
          {{(scope.row.materialsSpecEntry.unitQuantity*(1+scope.row.materialsSpecEntry.lossRate)*(taxIncluded?scope.row.unitPriceIncludingTax:scope.row.unitPriceExcludingTax)).toFixed(2)}}
        </template>
      </el-table-column>
      <el-table-column label="操作" fixed="right" width="50px">
        <template slot-scope="scope">
          <el-button @click="onRemove(scope.row)" type="text" size="small">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-row type="flex" style="margin-top:10px;">
      <el-col :span="4">
        <el-button icon="el-icon-plus" @click="onAdd">添加物料</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {
    accMul,
  } from '@/common/js/number';

  import SampleSpecEntriesTable from "../components/SampleSpecEntriesTable";

  export default {
    name: "MaterialAccountingForm",
    props: ["slotData", 'taxIncluded', 'sampleSpecEntries'],
    components: {
      SampleSpecEntriesTable
    },
    computed: {},

    methods: {
      onRemove(row) {
        this.slotData.splice(this.slotData.indexOf(row), 1);
      },
      onBlur(row, attribute) {
        var reg = /\.$/;
        if (reg.test(row[attribute])) {
          this.$set(row, attribute, parseFloat(row[attribute] + '0') / 100.0);
          if (row.unitPriceExcludingTax != null && row.unitPriceExcludingTax != '') {
            row.unitPriceIncludingTax = ((parseFloat(row.taxRate) + 1) * row.unitPriceExcludingTax).toFixed(2);
          } else if (row.unitPriceIncludingTax != null && row.unitPriceIncludingTax != '') {
            row.unitPriceExcludingTax = (row.unitPriceIncludingTax / (1 + row.taxRate)).toFixed(2);
          }
        }
      },
      showFloatPercentNum(val) {
        if (val == null) {
          return '';
        }
        var reg = /\.$/;
        if (!reg.test(val)) {
          return accMul(val, 100);
        } else {
          return val;
        }
      },
      onTaxInput(val, row) {
        var reg = /\.$/;
        if (!reg.test(val)) {
          row.taxRate = (val / 100.0).toFixed(3);
        } else {
          row.taxRate = val;
        }
        if (row.unitPriceExcludingTax != null && row.unitPriceExcludingTax != '') {
          row.unitPriceIncludingTax = ((parseFloat(row.taxRate) + 1) * row.unitPriceExcludingTax).toFixed(2);
        } else if (row.unitPriceIncludingTax != null && row.unitPriceIncludingTax != '') {
          row.unitPriceExcludingTax = (row.unitPriceIncludingTax / (1 + row.taxRate)).toFixed(2);
        }
      },
      onUnitPriceExcludingTaxInput(val, row) {
        if (row.taxRate != null && row.taxRate != '') {
          row.unitPriceIncludingTax = ((parseFloat(row.taxRate) + 1) * row.unitPriceExcludingTax).toFixed(2);
        }
        // else if (row.unitPriceIncludingTax != null && row.unitPriceIncludingTax != '') {
        //   row.taxRate = (row.unitPriceIncludingTax - row.unitPriceExcludingTax) / row.unitPriceExcludingTax;
        // }
      },
      onUnitPriceIncludingTaxInput(val, row) {
        if (row.taxRate != null && row.taxRate != '') {
          row.unitPriceExcludingTax = (row.unitPriceIncludingTax / (1 + parseFloat(row.taxRate))).toFixed(2);
        }
      },
      onAdd() {
        this.hackSet = false;
        this.$nextTick(() => {
          this.hackSet = true;
        });
        this.dialogVisible = true;
      },
      onEntriesAdd(specEntries) {
        this.dialogVisible = false;
        specEntries.filter(item => this.slotData.findIndex(element => element.materialsSpecEntry.materialsCode == item
          .materialsCode && element.materialsSpecEntry.spec.code == item.spec
          .code) == -1).forEach(element => {
          let obj = Object.assign({}, element);
          this.slotData.push({
            'materialsSpecEntry': obj,
            'unitPriceIncludingTax': '',
            'unitPriceExcludingTax': '',
            'taxRate': '',
            'unitTotalPrice': '',
            'unitActualQuantity': ''
          });
        });
      }
    },
    data() {
      return {
        dialogVisible: false,
        hackSet: true
      };
    },
    created() {}
  };

</script>
<style scoped>
  .form-input {
    padding-top: 15px;
  }

</style>
