<template>
  <div class="animated fadeIn">
    <el-card>
      <el-row class="table-row">
        <template v-for="(item, index) in topData">
          <el-col :span="4" :title="item.title" :key="item.title">
            <div class="table-cell" :class="(topData.length - 1 === index) ? 'table-cell_last' : ''">
              <h6 class="table-cell_title">{{item.title}}</h6>
              <h6 class="table-cell_value">{{item.value}}</h6>
            </div>
          </el-col>
        </template>
      </el-row>
      <div class="pt-3"></div>
      <h6 style="margin: 0px">生产流程预警</h6>
      <div class="pt-3"></div>
      <el-row class="table-row">
        <template v-for="(item, index) in centerData">
          <el-col :span="4" :title="item.title" :key="item.title">
            <div class="table-cell-center" :class="index > 5 ? 'table-cell_last' : ''">
              <h6 class="table-cell_value">{{item.value}}</h6>
              <h6 class="table-cell_title">{{item.title}}</h6>
            </div>
          </el-col>
        </template>
      </el-row>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'TenantDashboardPage',
  data () {
    return {
      topData: [
        {
          title: '今日成交额',
          value: 23800
        }, {
          title: '今日注册用户',
          value: 29
        }, {
          title: '今日需求数',
          value: 19
        }, {
          title: '今日报价数',
          value: 19
        }, {
          title: '今日订单额',
          value: 10
        }, {
          title: '今日签约额',
          value: 11
        }
      ],
      centerData: [
        {
          title: '需求未报价',
          value: 18
        }, {
          title: '报价未确认',
          value: 18
        }, {
          title: '报价确认未做单',
          value: 18
        }, {
          title: '做单未签约',
          value: 18
        }, {
          title: '签约未首付',
          value: 18
        }, {
          title: '首付未结算',
          value: 18
        }, {
          title: '首付后未生产',
          value: 18
        }, {
          title: '工序2天未更新',
          value: 18
        }, {
          title: '生产完成未对账',
          value: 18
        }, {
          title: '对账未付尾款',
          value: 18
        }, {
          title: '尾款未结算',
          value: 18
        }
      ]
    }
  }
}
</script>

<style scoped>
  .table-row {
    border: 1px solid #DCDFE6;
    padding: 4px;
  }

  .table-cell {
    min-height: 90px;
    max-height: 90px;
    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
    align-items: center;
    border-right: 1px solid #DCDFE6;
  }
  .table-cell_last {
    border: none !important;;
  }

  .table-cell_title {
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
    width: 100%;
    text-align: center;
    margin: 0;
  }

  .table-cell_value {
    color: #409EFF;
    margin: 0;
  }

  .table-cell-center {
    min-height: 90px;
    max-height: 90px;
    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
    align-items: center;
    border-bottom: 1px solid #DCDFE6;
  }

</style>
