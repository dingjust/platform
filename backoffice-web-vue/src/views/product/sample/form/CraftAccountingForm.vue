<template>
  <div>
    <el-table :data="slotData" style="width: 100%">
      <el-table-column prop="name" label="工艺名称">
        <template slot-scope="scope">
          <el-input v-model="scope.row.name" />
        </template>
      </el-table-column>
      <el-table-column prop="position" label="部件">
        <template slot-scope="scope">
          <el-input v-model="scope.row.position"></el-input>
        </template>
      </el-table-column>
      <el-table-column prop="unit" label="单位">
        <template slot-scope="scope">
          <el-input v-model="scope.row.unit"></el-input>
        </template>
      </el-table-column>
      <el-table-column prop="unitPriceExcludingTax" label="不含税单价">
        <template slot-scope="scope">
          <el-form-item :key="'specialProcessEntries-UPET'+scope.$index"
            :prop="'specialProcessEntries.' + scope.$index + '.unitPriceExcludingTax'"
            :rules="{required: !taxIncluded, message: '不能为空', trigger: 'change'}">
            <el-input v-model="scope.row.unitPriceExcludingTax" class="form-input"
              @change="(val)=>onUnitPriceExcludingTaxInput(val,scope.row)" v-number-input.float="{ min: 0 ,decimal:2}">
            </el-input>
          </el-form-item>
        </template>
      </el-table-column>
      <el-table-column prop="taxRate" label="税率">
        <template slot-scope="scope">
          <el-form-item :key="'specialProcessEntries-TR'+scope.$index"
            :prop="'specialProcessEntries.' + scope.$index + '.taxRate'" v-if="taxIncluded"
            :rules="{required: taxIncluded, message: '不能为空', trigger: 'change'}">
            <el-input @input="(val)=>onTaxInput(val,scope.row)" :value="showFloatPercentNum(scope.row.taxRate)"
              class="form-input" @blur="onBlur(scope.row,'taxRate')"
              v-number-input.float="{ min: 0,max:100 ,decimal:1}">
              <h6 slot="suffix" style="padding-top:25px">%</h6>
            </el-input>
          </el-form-item>
        </template>
      </el-table-column>
      <el-table-column prop="unitPriceIncludingTax" label="含税单价">
        <template slot-scope="scope">
          <el-form-item :key="'specialProcessEntries-UPIT'+scope.$index" v-if="taxIncluded"
            :prop="'specialProcessEntries.' + scope.$index + '.unitPriceIncludingTax'"
            :rules="{required: taxIncluded, message: '不能为空', trigger: 'change'}">
            <el-input v-model="scope.row.unitPriceIncludingTax" class="form-input"
              @change="(val)=>onUnitPriceIncludingTaxInput(val,scope.row)" v-number-input.float="{ min: 0 ,decimal:2}"
              placeholder="输入">
            </el-input>
          </el-form-item>
        </template>
      </el-table-column>
      <el-table-column prop="unitPriceIncludingTax" :label="taxIncluded?'含税单件价格':'不含税单件价格'" fixed="right" width="110px">
        <template slot-scope="scope">
          {{taxIncluded?scope.row.unitPriceIncludingTax:scope.row.unitPriceExcludingTax}}
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
        <el-button icon="el-icon-plus" @click="onAdd">添加工艺</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {
    accMul,
  } from '@/common/js/number';

  export default {
    name: "CraftAccountingForm",
    props: ["slotData", 'taxIncluded'],
    components: {},
    computed: {},

    methods: {
      onAdd() {
        if (this.slotData == null) {
          this.slotData = [];
        }
        this.slotData.push({
          'name': '',
          'position': '',
          'unit': '',
          'unitPriceExcludingTax': '',
          'unitPriceIncludingTax': '',
          'taxRate': ''
        })
      },
      onRemove(row) {
        this.slotData.splice(this.slotData.indexOf(row), 1);
      },

      onBlur(row, attribute) {
        var reg = /\.$/;
        if (reg.test(row[attribute])) {
          this.$set(row, attribute, parseFloat(row[attribute] + '0') / 100.0);
          if (row.unitPrice != null && row.unitPrice != '') {
            row.taxUnitPrice = ((parseFloat(row.tax) + 1) * row.unitPrice).toFixed(2);
          } else if (row.taxUnitPrice != null && row.taxUnitPrice != '') {
            row.unitPrice = (row.taxUnitPrice / (1 + row.tax)).toFixed(2);
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
    },
    data() {
      return {};
    },
    created() {}
  };

</script>
<style scoped>
  .form-input {
    padding-top: 15px;
  }

</style>
