<template>
  <div class="table-body">
    <el-table :data="orders" border style="width: 100%">
      <el-table-column prop="id" label="单号">
      </el-table-column>
      <el-table-column label="上报时间">
        <template slot-scope="scope">
          <span>{{scope.row.reportTime|timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="上报人员">
        <template slot-scope="scope">
          <span>{{scope.row.operator.name}}</span>
        </template>
      </el-table-column>
      <el-table-column prop="amount" label="上报数量">
      </el-table-column>
      <el-table-column label="状态">
        <template slot-scope="scope">
          <span>{{getEnum('ProgressOrderStatus', scope.row.status)}}</span>
        </template>
      </el-table-column>
      <el-table-column fixed="right" label="操作">
        <template slot-scope="scope">
          <el-button type="text" size="small" @click="onDetail(scope.row)">查看</el-button>
          <authorized :permission="['PROGRESS_WORK_ORDER_UPDATE']">
            <el-button type="text" size="small" @click="onUpdate(scope.row)" v-if="!readonly && isMySelf">修改</el-button>
          </authorized>
          <authorized :permission="['PROGRESS_WORK_ORDER_UPDATE']">
            <el-button v-if="(scope.row.status != 'CANCEL')&&!readonly&&isMySelf" type="text" size="small"
              @click="onCencel(scope.row.id)">作废</el-button>
          </authorized>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'ProductionProgressOrdersTable',
    props: {
      orders: {
        type: Array,
        default: []
      },
      readonly: {
        type: Boolean,
        default: false
      },
      isMySelf: {
        type: Boolean,
        default: true
      }
    },
    computed: {

    },
    methods: {
      onDetail(data) {
        this.$emit('onDetail', data);
      },
      onCencel(id) {
        this.$emit('onCencel', id);
      },
      onUpdate(data) {
        this.$emit('onUpdate', data);
      }
    },
    data() {
      return {

      }
    },
    created() {
      console.log(this.orders);
    }
  }

</script>
<style scoped>
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
