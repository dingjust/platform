<template>
  <div>
    <el-table :data="slotData" style="width: 100%" border @selection-change="handleSelectionChange">
      <el-table-column type="selection" :reserve-selection="true">
      </el-table-column>
      <el-table-column prop="materialsName" label="物料名称">
      </el-table-column>
      <el-table-column prop="materialsCode" label="物料编号" sortable>
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
      <el-table-column prop="materialsType" label="属性">
        <template slot-scope="scope">
          {{getEnum('MaterialsType', scope.row.materialsType)}}
        </template>
      </el-table-column>
      <el-table-column prop="unitQuantity" label="单位用量">
      </el-table-column>
      <el-table-column prop="lossRate" label="损耗">
        <template slot-scope="scope">
          {{showFloatPercentNum(scope.row.lossRate)+'%'}}
        </template>
      </el-table-column>
    </el-table>
    <el-row type="flex" justify="center" align="middle" style="margin-top: 10px">
      <el-button size="medium" class="sure-button" @click="onAdd">确认添加</el-button>
    </el-row>
  </div>
</template>

<script>
  import {
    accMul,
  } from '@/common/js/number';

  export default {
    name: "SampleSpecEntriesTable",
    props: ["slotData"],
    components: {

    },
    computed: {

    },
    methods: {
      showFloatPercentNum(val) {
        var reg = /\.$/;
        val = val, toString;
        if (!reg.test(val)) {
          return accMul(val, 100);
        } else {
          return val;
        }
      },
      handleSelectionChange(val) {
        this.multipleSelection = val;
      },
      onAdd() {
        this.$emit('onAdd', this.multipleSelection);
      }
    },
    data() {
      return {
        multipleSelection: []
      };
    },
    created() {

    }
  };

</script>
<style scoped>
</style>
