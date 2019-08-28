<template>
  <div class="animated fadeIn">
    <el-row :gutter="20">
      <el-col :span="14">
        <el-row>
          <business-card />
        </el-row>
        <el-row>
          <toolbar-card />
        </el-row>
        <el-row>
          <chart-card />
        </el-row>
        <el-row :gutter="10">
          <el-col :span="12">
            <month-income-card :slot-data="lastMonthIncome"/>
          </el-col>
          <el-col :span="12">
            <month-income-card :slot-data="thisMonthIncome"/>
          </el-col>
        </el-row>
      </el-col>
      <el-col :span="10">
        <account-entry-card />
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import BusinessCard from '../shared/BusinessCard';
  import ToolbarCard from '../shared/ToolbarCard';
  import ChartCard from '../shared/ChartCard';
  import MonthIncomeCard from '../shared/MonthIncomeCard';
  import AccountEntryCard from '../shared/AccountEntryCard';

  export default {
    name: 'FactoryDashboardPage',
    components: {
      BusinessCard,
      ToolbarCard,
      ChartCard,
      MonthIncomeCard,
      AccountEntryCard
    },
    computed: {

    },
    methods: {},
    data() {
      return {
        thisMonthIncome:{
          title:'本月营收',
          income:1231.12,
          proofingOrders:8,
          purchaseOrders:10,
          incomed:123,
          comparison:0.264
        },
        lastMonthIncome:{
          title:'上月营收',
          income:3134.12,
          proofingOrders:23,
          purchaseOrders:13,
          incomed:1232,
          comparison:0.3114
        }
      };
    },
    created() {}
  };

</script>
<style>
  .dashboard-card {
    background-color: #ffffff;
    border-radius: 5px;
    width: 100%;
    padding-top: 10px;
    padding-left: 20px;
    padding-right: 20px;
    padding-bottom: 10px;
    margin-bottom: 10px;
  }

</style>
