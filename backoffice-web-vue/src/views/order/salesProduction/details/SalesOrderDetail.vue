<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="6">
          <div class="sales-plan-form-title">
            <h6>销售订单详情</h6>
          </div>
        </el-col>
        <el-col :span="16">
          <div>
            <h6>销售单号：{{code}}</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" :inline="true" :model="form" hide-required-asterisk>
        <sales-order-detail-form :form="form"/>
      </el-form>
      <div style="margin-top: 10px">
        <sales-order-products-table :isCreate="false" :form="form"/>
      </div>
    </el-card>
  </div>
</template>

<script>
  import SalesOrderDetailForm from '../form/SalesOrderDetailForm';
  import SalesOrderProductsTable from '../components/SalesOrderProductsTable';
  export default {
    name: 'SalesPlanDetail',
    props: ['code'],
    components: {
      SalesOrderProductsTable,
      SalesOrderDetailForm

    },
    computed: {

    },
    methods: {

    },
    data () {
      return {
        form: {
          code: 'CO0000000001',
          foundPerson: '宁波衣加衣宁波衣加衣',
          contactPerson: '宁波衣加衣宁波衣加衣',
          contactPhone: '13888888888',
          machiningTypes: 'LABOR_AND_MATERIAL',
          invoice: true,
          quantity: 5000,
          total: 1222200202,
          budget: 12222,
          profit: 122222,
          profitMargin: 0.6,
          approvalBy: '马化腾',
          orderOwner: '周鸿伟',
          productionBy: '马云',
          procurementBy: '伟腾云',
          status: 'UNAPPROVED',
          msg: 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'
        }
      }
    },
    created () {
      console.log(this.code);
    },
    mounted () {

    }
  };
</script>

<style scoped>
  .sales-plan-form-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
