<template>
  <div>
    <el-table :data="slotData" style="width: 100%" border>
      <el-table-column prop="title" fixed="left">
        <template slot="header">
          使用名称 <el-popover placement="top-start" title="使用名称" width="200" trigger="hover"
            content="使用名称即面料在成衣上的实际用途如：主面料，口袋链，里布等。">
            <i slot="reference" class="el-icon-question" style="font-size:14px;"></i>
          </el-popover>
        </template>
      </el-table-column>
      <el-table-column prop="materialsName" label="物料名称" fixed="left">
      </el-table-column>
      <el-table-column prop="materialsCode" label="物料编号" min-width="120px">
      </el-table-column>
      <el-table-column prop="spec" label="物料规格">
        <template slot-scope="scope">
          {{scope.row.spec.name}}
        </template>
      </el-table-column>
      <el-table-column prop="materialsUnit" label="物料单位">
        <template slot-scope="scope">
          {{getEnum('MaterialsUnit', scope.row.materialsUnit)}}
        </template>
      </el-table-column>
      <el-table-column prop="materialsType" label="物料属性">
        <template slot-scope="scope">
          {{getEnum('MaterialsType', scope.row.materialsType)}}
        </template>
      </el-table-column>
      <el-table-column prop="unitQuantity" label="单位用量">
      </el-table-column>
      <el-table-column prop="lossRate" label="损耗">
        <template slot-scope="scope">
          {{showFloatPercentNum(scope.row.lossRate)}}%
        </template>
      </el-table-column>
      <el-table-column label="实际用量">
        <template slot-scope="scope">
          {{(scope.row.unitQuantity*(1+parseFloat(scope.row.lossRate))).toFixed(2)}}
        </template>
      </el-table-column>
      <el-table-column align="center">
        <template slot="header">
          款式颜色<el-popover placement="top-start" title="款式颜色" width="200" trigger="hover" ref="popover"
            content="此处显示对于款式的全部颜色，下方填写对应款式颜色所需物料的对应颜色，如不需要选择“无”即可">
            <i slot="reference" class="el-icon-question" v-popover:popover style="font-size:14px;"></i>
          </el-popover>
        </template>
        <template v-for="(color,index) in colors">
          <el-table-column :key="index" :label="color.name">
            <template slot-scope="scope">
              {{getMaterialColor(scope.row,color)}}
            </template>
          </el-table-column>
        </template>
      </el-table-column>
      <el-table-column prop="position" label="使用部位">
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  import {
    accMul,
  } from '@/common/js/number';

  export default {
    name: "MaterialSpecEntriesTable",
    props: {
      slotData: {
        type: Array,
        default: []
      },
      colors: {
        type: Array,
        default: []
      }
    },
    components: {

    },
    computed: {

    },
    methods: {
      getMaterialColor(row, color) {
        if (row.materialsColorEntries == null) {
          return '';
        }
        let item = row.materialsColorEntries.find(val => val.sampleColor.code == color.code || val.sampleColor.name ==
          color.name);
        return (item != null && item.materialsColor) ? item.materialsColor.name : '';
      },
      showFloatPercentNum(val) {
        if (val == null) {
          return 0;
        }
        return accMul(parseFloat(val), 100);
      },
    },
    data() {
      return {

      };
    },
    created() {

    }
  };

</script>
<style scoped>
</style>
