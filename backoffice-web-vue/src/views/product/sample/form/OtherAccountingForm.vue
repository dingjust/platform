<template>
  <div>
    <el-table :data="slotData" style="width: 100%">
      <el-table-column prop="name" label="工艺名称">
        <template slot-scope="scope">
          <el-input v-model="scope.row.name" />
        </template>
      </el-table-column>
      <el-table-column label="">
      </el-table-column>
      <el-table-column prop="unit" label="单位">
        <template slot-scope="scope">
          <el-input v-model="scope.row.unit"></el-input>
        </template>
      </el-table-column>
      <el-table-column prop="unitPrice" label="不含税单价">
        <template slot-scope="scope">
          <el-input v-model="scope.row.unitPrice" @change="(val)=>onUnitPriceInput(val,scope.row)"
            v-number-input.float="{ min: 0 ,decimal:2}">
          </el-input>
        </template>
      </el-table-column>
      <el-table-column prop="tax" label="税率">
        <template slot-scope="scope">
          <el-input @input="(val)=>onTaxInput(val,scope.row)" :value="showFloatPercentNum(scope.row.tax)"
            @blur="onBlur(scope.row,'tax')" v-number-input.float="{ min: 0,max:100 ,decimal:1}" v-show="taxIncluded"
            :disabled="!taxIncluded">
            <h6 slot="suffix" style="padding-top:10px">%</h6>
          </el-input>
        </template>
      </el-table-column>
      <el-table-column prop="taxUnitPrice" label="含税单价">
        <template slot-scope="scope">
          <el-input v-model="scope.row.taxUnitPrice" @change="(val)=>onTaxUnitPriceInput(val,scope.row)"
            v-number-input.float="{ min: 0 ,decimal:2}" placeholder="输入" v-show="taxIncluded" :disabled="!taxIncluded">
          </el-input>
        </template>
      </el-table-column>
      <el-table-column prop="taxUnitPrice" :label="taxIncluded?'含税单件价格':'不含税单件价格'" fixed="right" width="110px">
        <template slot-scope="scope">
          {{taxIncluded?scope.row.taxUnitPrice:scope.row.unitPrice}}
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
        <el-button icon="el-icon-plus" @click="onAdd">添加加工类型</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {
    accMul,
  } from '@/common/js/number';

  export default {
    name: "OtherAccountingForm",
    props: ["slotData", 'taxIncluded'],
    components: {},
    computed: {},

    methods: {
      onAdd() {
        this.slotData.push({
          'name': '物料1',
          'size': '',
          'color': '',
          'unit': '米',
          'attribute': '面料',
          'suitColor': '',
          'usage': '',
          'waste': '',
          'colors': ['红色', '白色'],
          'sizes': ['S', 'X', 'M'],
          'actualUsage': '',
          'unitPrice': '',
          'tax': ''
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
          row.tax = (val / 100.0).toFixed(3);
        } else {
          row.tax = val;
        }
        if (row.unitPrice != null && row.unitPrice != '') {
          row.taxUnitPrice = ((parseFloat(row.tax) + 1) * row.unitPrice).toFixed(2);
        } else if (row.taxUnitPrice != null && row.taxUnitPrice != '') {
          row.unitPrice = (row.taxUnitPrice / (1 + row.tax)).toFixed(2);
        }
      },
      onUnitPriceInput(val, row) {
        if (row.tax != null && row.tax != '') {
          row.taxUnitPrice = ((parseFloat(row.tax) + 1) * row.unitPrice).toFixed(2);
        }
        // else if (row.taxUnitPrice != null && row.taxUnitPrice != '') {
        //   row.tax = (row.taxUnitPrice - row.unitPrice) / row.unitPrice;
        // }
      },
      onTaxUnitPriceInput(val, row) {
        if (row.tax != null && row.tax != '') {
          row.unitPrice = (row.taxUnitPrice / (1 + parseFloat(row.tax))).toFixed(2);
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

</style>
