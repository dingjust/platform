<template>
  <div class="table-body">
    <el-row type="flex" justify="end" align="middle" style="margin-bottom:20px;">
      <el-button size="mini" class="form-btn" @click="onOrder" v-if="!readonly">上报数量</el-button>
    </el-row>
    <el-row>
      <table cellspacing="2" width="100%" class="order-table">
        <tr class="order-table-th_row">
          <template v-for="item in titleRow">
            <th :key="item">{{item}}</th>
          </template>
        </tr>
        <tr v-if="tableData.length <= 0">
          <td colspan="4" style="padding: 8px;color: #909399">暂无数据</td>
        </tr>
        <template v-for="(item, index) in tableData">
          <tr :key="index">
            <td>{{item.color}}</td>
            <td>{{item.size}}</td>
            <td>{{item.status}}</td>
            <td width="500">{{item.approvalComments}}</td>
          </tr>
        </template>
      </table>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ProgressReportSample',
    props: {
      orderEntries: {
        type: Array,
        default: []
      },
      noteEntries: {
        type: Array,
        default: []
      },
      orderEntriesTotal: {
        type: Number,
        default: 0
      },
      readonly: {
        type: Boolean,
        default: false
      },
      isRead: {
        type: Boolean,
        default: true
      }
    },
    computed: {
    },
    methods: {
      onOrder () {
        this.$emit('onOrder')
      }
    },
    data () {
      return {
        tableData: [],
        titleRow: ['颜色', '尺码', '状态', '审批意见'],
        statuses: [{
          code: 'NONE',
          name: '未审核'
        },
        {
          code: 'AUDITING',
          name: '审核中'
        },
        {
          code: '"PASSED',
          name: '审核通过'
        }]
      }
    },
    created () {
      if (this.noteEntries.length > 0) {
        this.tableData = this.noteEntries[this.noteEntries.length - 1].entries;
      }
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
</style>
