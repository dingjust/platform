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
      <el-table-column prop="unitPriceExcludingTax" label="不含税单价">
        <template slot-scope="scope">
          <el-form-item :key="'laborCostEntries-UPET'+scope.$index"
            :prop="'laborCostEntries.' + scope.$index + '.unitPriceExcludingTax'"
            :rules="{required: !taxIncluded, message: '不能为空', trigger: 'change'}">
            <el-input v-model="scope.row.unitPriceExcludingTax" class="form-input" v-if="!taxIncluded"
              v-number-input.float="{ min: 0 ,decimal:2}">
            </el-input>
          </el-form-item>
        </template>
      </el-table-column>
      <el-table-column prop="taxRate" label="税率">
        <template slot-scope="scope">
          <el-form-item :key="'laborCostEntries-TR'+scope.$index"
            :prop="'laborCostEntries.' + scope.$index + '.taxRate'"
            :rules="{required: taxIncluded, message: '不能为空', trigger: 'change'}" v-if="taxIncluded">
            <el-input v-model="scope.row.taxRatePercent" @change="onRateChange(scope.row)" class="form-input"
              v-number-input.float="{ min: 0,max:100 ,decimal:1}">
              <h6 slot="suffix" style="padding-top:25px">%</h6>
            </el-input>
          </el-form-item>
        </template>
      </el-table-column>
      <el-table-column prop="unitPriceIncludingTax" label="含税单价">
        <template slot-scope="scope">
          <el-form-item :key="'laborCostEntries-UPIT'+scope.$index"
            :prop="'laborCostEntries.' + scope.$index + '.unitPriceIncludingTax'"
            :rules="{required: taxIncluded, message: '不能为空', trigger: 'change'}" v-if="taxIncluded">
            <el-input v-model="scope.row.unitPriceIncludingTax" class="form-input"
              v-number-input.float="{ min: 0 ,decimal:2}" placeholder="输入" :disabled="!taxIncluded">
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
        if (this.slotData == null) {
          this.slotData = [];
        }
        this.slotData.push({
          'name': '',
          'unit': '',
          'unitPriceExcludingTax': '',
          'unitPriceIncludingTax': '',
          'taxRate': '',
          'taxRatePercent': '',

        })
      },
      onRemove(row) {
        this.slotData.splice(this.slotData.indexOf(row), 1);
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
      onRateChange(row) {
        row.taxRate = (row.taxRatePercent / 100).toFixed(3);
      },
    },
    data() {
      return {};
    },
    created() {
      this.slotData.forEach(element => {
        this.$set(element, 'taxRatePercent', (element.taxRate * 100).toFixed(1))
      });
    }
  };

</script>
<style scoped>
  .form-input {
    padding-top: 15px;
  }

</style>
