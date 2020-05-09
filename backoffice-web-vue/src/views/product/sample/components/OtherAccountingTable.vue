<template>
  <div>
    <el-table :data="slotData" style="width: 100%">
      <el-table-column prop="name" label="工艺名称">
      </el-table-column>
      <el-table-column label="">
      </el-table-column>
      <el-table-column prop="unit" label="单位">
      </el-table-column>
      <el-table-column label="不含税单价" v-if="!taxIncluded">
        <template slot-scope="scope">
          {{scope.row.unitPriceExcludingTax}}
        </template>
      </el-table-column>
      <el-table-column label="税率" v-if="taxIncluded">
        <template slot-scope="scope">
          {{showFloatPercentNum(scope.row.taxRate)+'%'}}
        </template>
      </el-table-column>
      <el-table-column label="含税单价" v-if="taxIncluded">
        <template slot-scope="scope">
          {{scope.row.unitPriceIncludingTax}}
        </template>
      </el-table-column>
      <el-table-column prop="unitPriceIncludingTax" :label="taxIncluded?'含税单件价格':'不含税单件价格'" fixed="right" width="160px">
        <template slot-scope="scope">
          {{taxIncluded?scope.row.unitPriceIncludingTax:scope.row.unitPriceExcludingTax}}
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  import {
    accMul,
  } from '@/common/js/number';

  export default {
    name: "OtherAccountingTable",
    props: ["slotData", 'taxIncluded'],
    components: {},
    computed: {},

    methods: {
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
