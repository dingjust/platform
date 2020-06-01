<template>
  <div class="table-body">
    <table cellspacing="2" width="100%" class="order-table">
      <tr class="order-table-th_row">
        <template v-for="item in titleRow">
          <th :key="item">{{item}}</th>
        </template>
      </tr>
      <template v-for="(item, materialindex) in order.materialPreparationEntries">
        <tr :key="materialindex">
          <td :rowspan="item.colorEntries.length + 1">{{item.materialsName}}</td>
          <td :rowspan="item.colorEntries.length + 1">{{item.spec}}</td>
          <td :rowspan="item.colorEntries.length + 1">{{getEnum('MaterialsUnit', item.materialsUnit)}}</td>
          <td :rowspan="item.colorEntries.length + 1">{{getEnum('MaterialsType', item.materialsType)}}</td>
        </tr>
        <template v-for="(val, index) in item.colorEntries">
          <tr :key="val.id">
            <td>{{val.materialsColor}}</td>
            <!-- 实际需求数量 -->
            <td>{{val.actualDemandQuantity}}</td>
            <!-- 实际收货数量 -->
            <td>{{val.actualReceivedQuantity}}</td>
            <td v-if="index === 0" :rowspan="item.colorEntries.length + 1" style="width:120px">
              <!-- 物料状态 -->
              {{item.status!=null?getEnum('ProgressReportMaterialStatus', item.status):''}}
            </td>
          </tr>
        </template>
      </template>
      <tr v-if="productionProgressOrders.length <= 0">
        <td colspan="8" style="padding: 8px;color: #909399">暂无数据</td>
      </tr>
    </table>
  </div>
</template>

<script>
  export default {
    name: 'ProgressReportMaterial',
    props: {
      productionProgressOrders: {
        type: Array,
        default: () => {
          return [];
        }
      },
      // materialsSpecEntries: {
      //   type: Array,
      //   default: () => {
      //     return [];
      //   }
      // }
    },
    computed: {
      order: function () {
        // var arry = this.productionProgressOrders.sort((o1, o2) => {
        //   console.log(o1.reportTime+'-'+o2.reportTime);
        //   console.log(o1.reportTime - o2.reportTime);
        //   return o1.reportTime - o2.reportTime;
        // });
        return this.productionProgressOrders[this.productionProgressOrders.length - 1];
      }
    },
    methods: {
      //获取总需求量
      // getTotalDemandQuantity
    },
    data() {
      return {
        titleRow: ['物料名称', '物料规格', '物料单位', '物料属性', '物料颜色', '实际需求数量', '实际收货数量', '状态'],
      }
    },
    created() {

    }
  }

</script>

<style scoped>
  .table-body {
    width: 100%;
  }

  .form-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
  }

  .table-body {
    width: 100%;
  }

  .order-table {
    /* width: 600px;
    height: 600px; */
    border-collapse: collapse;
    margin-bottom: 20px;
  }

  .order-table tr td,
  .order-table tr th {
    border: 1px solid rgba(0, 0, 0, 0.15);
    text-align: center;
    height: 30px;
    font-size: 10px;
  }

  /* .order-table-th_row {
    height: 80px;
  } */

  .order-table-input .el-input__inner {
    /* width: 60px; */
    border: 0px solid #fff;
  }

  .order-table-btn {
    padding-left: 10px;
    width: 30px;
  }

  .order-table-info {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    margin-left: 20px;
  }

  .order-table-btn_add {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
  }

  .form-btn {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
  }

</style>
