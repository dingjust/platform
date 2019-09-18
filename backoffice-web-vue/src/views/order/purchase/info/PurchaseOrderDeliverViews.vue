<template>
  <div class="info-receive-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">查看发货单</h6>
      </div>
    </el-row>
    <el-tabs v-model="activeOrder" type="card" :editable="isFactory()" @edit="handleTabsEdit">
      <template v-for="(order,index) in slotData.shippingOrders">
        <el-tab-pane :label="''+(index+1)+'('+getDeliverOrderType(order)+')'" :name="''+index">
          <deliver-view :slotData="order" />
        </el-tab-pane>
      </template>
    </el-tabs>
    <el-row type="flex" justify="end" class="info-receive-row">
      <h6 class="order-table-info">品牌跟单员： {{slotData.brandOperator!=null?slotData.brandOperator.name:'未指定'}}</h6>
      <h6 class="order-table-info">工厂跟单员： {{slotData.factoryOperator!=null?slotData.factoryOperator.name:'未指定'}}</h6>
      <h6 class="order-table-info">发货日期： {{slotData
        .creationtime | timestampToTime}}</h6>
    </el-row>
  </div>
</template>

<script>
  import OrdersInfoItem from '@/components/custom/OrdersInfoItem';
  import FormLabel from '@/components/custom/FormLabel';
  import DeliverView from '../components/DeliverView';
  import PurchaseOrderInfoDeliver from './PurchaseOrderInfoDeliver';

  export default {
    name: 'PurchaseOrderInfoDeliver',
    props: ['slotData'],
    components: {
      OrdersInfoItem,
      FormLabel,
      DeliverView,
      PurchaseOrderInfoDeliver
    },
    mixins: [],
    computed: {
      // activeOrder: function () {
      //   return this.slotData.shippingOrders[0].code;
      // }
    },
    methods: {
      async refreshData() {
        const url = this.apis().getPurchaseOrder(this.slotData.code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$set(this, 'slotData', result);
        // this.slotData=result;
      },
      handleTabsEdit(targetName, action) {
        if (action === 'add') {
          this.$emit('createNewDeliver');
        }
        if (action === 'remove') {
          this.$confirm('是否确认删除发货单?', '删除', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this.deleteDeliverOrder();
          });

        }
      },
      async deleteDeliverOrder() {
        const url = this.apis().deleteShippingOrder(this.slotData.shippingOrders[this.activeOrder].id);
        const result = await this.$http.put(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success('删除成功');
        this.refreshData();
      },
      getDeliverOrderType(order){
        if(order.isFullShipment==null||order.isFullShipment==''){
          return '部分发货'
        }else{
          return '全部发货'
        }
      }
    },
    data() {
      return {
        activeOrder: '0'
      }
    },
    created() {

    },
    watch: {
      slotData: {
        handler(val, oldVal) {
          this.activeOrder = '0';
        },
        deep: true
      },
    },
    mounted() {}
  }

</script>
<style>
  .info-receive-body {
    width: 100%;
  }

  .info-receive-row {
    margin-bottom: 20px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 80px;
    font-weight: bold;
    font-size: 12px;
  }

  .info-row_width50 {
    width: 50%;
  }

  .checkbox-text .el-checkbox__label {
    font-size: 12px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.45);
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
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
  }

  .info-receive-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
  }

</style>
