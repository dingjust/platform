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
          <el-input v-model="scope.row.unitPrice" @change="(val)=>onUnitPriceInput(val,scope.row)" >
          </el-input>
        </template>
      </el-table-column>
      <el-table-column prop="tax" label="税率">
        <template slot-scope="scope">
          <el-input  @input="(val)=>onTaxInput(val,scope.row)" :value="scope.row.tax*100"
            v-show="taxIncluded" :disabled="!taxIncluded">
            <h6 slot="suffix" style="padding-top:10px">%</h6>
          </el-input>
        </template>
      </el-table-column>
      <el-table-column prop="taxUnitPrice" label="含税单价">
        <template slot-scope="scope">
          <el-input v-model="scope.row.taxUnitPrice" @change="(val)=>onTaxUnitPriceInput(val,scope.row)"
            placeholder="输入"  v-show="taxIncluded" :disabled="!taxIncluded">
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
        <el-button icon="el-icon-plus" @click="onAdd">添加物料</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
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
      onTaxInput(val, row) {
        row.tax = val / 100;
        if (row.unitPrice != null && row.unitPrice != '') {
          row.taxUnitPrice = ((row.tax + 1) * row.unitPrice).toFixed(2);
        } else if (row.taxUnitPrice != null && row.taxUnitPrice != '') {
          row.unitPrice = (row.taxUnitPrice / (1 + row.tax)).toFixed(2);
        }
      },
      onUnitPriceInput(val, row) {
        if (row.tax != null && row.tax != '') {
          row.taxUnitPrice = ((row.tax + 1) * row.unitPrice).toFixed(2);
        }
        // else if (row.taxUnitPrice != null && row.taxUnitPrice != '') {
        //   row.tax = (row.taxUnitPrice - row.unitPrice) / row.unitPrice;
        // }
      },
      onTaxUnitPriceInput(val, row) {
        if (row.tax != null && row.tax != '') {
          row.unitPrice = (row.taxUnitPrice / (1 + row.tax)).toFixed(2);
        }
      }
    },
    data() {
      return {};
    },
    created() {}
  };

</script>
<style scoped>

</style>
