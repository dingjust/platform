<template>
  <div>
    <el-table :data="slotData" style="width: 100%">
      <el-table-column prop="materialsSpecEntry.title" label="使用名称">
      </el-table-column>
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
      <el-table-column prop="actualUsage" label="实际用量">
        <template slot-scope="scope">
          {{(scope.row.materialsSpecEntry.unitQuantity*(1+parseFloat(scope.row.materialsSpecEntry.lossRate))).toFixed(2)}}
        </template>
      </el-table-column>
      <el-table-column label="不含税单价">
        <template slot-scope="scope">
          <template v-if="!taxIncluded">{{scope.row.unitPriceExcludingTax}}</template>
          <template v-if="taxIncluded">{{getunitPriceExcludingTax(scope.row)}}</template>
        </template>
      </el-table-column>
      <el-table-column label="税率" min-width="90px" v-if="taxIncluded">
        <template slot-scope="scope">
          {{showFloatPercentNum(scope.row.taxRate)}}
        </template>
      </el-table-column>
      <el-table-column label="含税单价" v-if="taxIncluded">
        <template slot-scope="scope">
          {{scope.row.unitPriceIncludingTax}}
        </template>
      </el-table-column>
      <el-table-column prop="materialsSpecEntry.position" label="部位" width="50px">
      </el-table-column>
      <el-table-column prop="unitPriceIncludingTax" :label="taxIncluded?'含税单件价格':'不含税单件价格'" fixed="right" width="110px"
        align="left">
        <template slot-scope="scope">
          {{getRowTatoalPrice(scope.row)}}
        </template>
      </el-table-column>
      <el-table-column label="" fixed="right" width="50px">
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  import {
    accMul,
  } from '@/common/js/number';

  export default {
    name: "MaterialAccountingTable",
    props: ["slotData", 'taxIncluded', 'sampleSpecEntries'],
    components: {

    },
    computed: {

    },

    methods: {
      getunitPriceExcludingTax(row) {
        if (row.unitPriceIncludingTax != null && row.taxRate != null) {
          let result = parseFloat(row.unitPriceIncludingTax) / (1 + parseFloat(row.taxRate));
          if (Number.isNaN(result)) {
            return '';
          }
          return result.toFixed(2);
        } else {
          return '';
        }
      },
      getRowTatoalPrice(row) {
        if (this.taxIncluded && (row.unitPriceIncludingTax == null || row.unitPriceIncludingTax == '')) {
          return '';
        }

        if (!this.taxIncluded && (row.unitPriceExcludingTax == null || row.unitPriceExcludingTax == '')) {
          return '';
        }

        let result = (parseFloat(row.materialsSpecEntry.unitQuantity) * (1 + parseFloat(row.materialsSpecEntry
          .lossRate)) * (
          this.taxIncluded ? parseFloat(row.unitPriceIncludingTax) : parseFloat(row.unitPriceExcludingTax))).toFixed(
          2);
        return result;
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
    },
    data() {
      return {
        dialogVisible: false,
        hackSet: true,
        accountingEntries: []
      };
    },
    created() {}
  };

</script>
<style scoped>
  .form-input {
    padding-top: 15px;
  }

  .form-input .el-input--suffix .el-input__inner {
    padding: 5px !important;
  }

</style>
