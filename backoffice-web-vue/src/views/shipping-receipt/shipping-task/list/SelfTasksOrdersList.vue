<template>
  <div class="task-order-container">
    <el-row type="flex" justify="end" v-if="showDeliveryBtn">
      <el-button @click="onReceiptCreate" v-if="isAutogestion">创建收货订单</el-button>
      <authorized :permission="['SHIPPING_SHEET_CREATE']" v-else>
        <el-button @click="onCreate">创建发货订单</el-button>
      </authorized>
    </el-row>
    <el-table ref="resultTable" stripe :data="formData.receiptSheets" :height="autoHeight">
      <el-table-column label="收货单号" prop="code" min-width="230px">
        <template slot-scope="scope">
          <el-row type="flex" align="middle">
            <el-button type="text" @click="onReceiptDetail(scope.row.id)">{{scope.row.code}}</el-button>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="收货数量" prop="totalQuantity"></el-table-column>
      <el-table-column label="收货时间" min-width="85px">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDateInday}}</span>
        </template>
      </el-table-column>
      <!-- 发货方 -->
      <!-- <el-table-column align="center" fixed="right" v-if="isShipParty">
        <template slot-scope="scope">
          <authorized :permission="['RECONSIDER_SHEET_CREATE']">
            <el-button type="text" @click="onReconsider(scope.row.id)" v-if="scope.row.state=='PENDING_RECONSIDER'">复议
            </el-button>
          </authorized>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" fixed="right" v-if="isReceiptParty">
        <template slot-scope="scope">
          <authorized :permission="['RECEIPT_SHEET_CREATE']">
            <el-button type="text" @click="onReceive(scope.row.id)" v-if="scope.row.state=='PENDING_RECEIVED'">收货
            </el-button>
          </authorized>
        </template>
      </el-table-column> -->
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'SelfTasksOrdersList',
    props: ['formData', 'readOnly'],
    components: {

    },
    computed: {
      //是否为发货方
      isShipParty: function () {
        if (this.currentUser != null && this.formData.shipParty != null) {
          return this.currentUser.companyCode == this.formData.shipParty.uid;
        } else {
          return false;
        }
      },
      //是否为收货方
      isReceiptParty: function () {
        if (this.currentUser != null && this.formData.receiveParty != null) {
          return this.currentUser.companyCode == this.formData.receiveParty.uid;
        } else {
          return false;
        }
      },
      showDeliveryBtn: function () {
        return this.isShipParty && (this.formData.state == 'IN_DELIVERY' || this.formData.state ==
          'PENDING_DELIVERY');
      },
      //是否自管类型
      isAutogestion: function () {
        if (this.formData.productionTaskOrder && this.formData.productionTaskOrder.managementMode) {
          return this.formData.productionTaskOrder.managementMode == 'AUTOGESTION';
        }
        return false;
      }
    },
    methods: {
      onCreate() {
        this.$emit('onCreate');
      },
      onReceiptCreate() {
        this.$emit('onReceiptCreate');
      },
      onReceiptDetail(id) {
        this.$router.push('/receipt/orders/' + id);
      },
      //收货
      onReceive(id) {
        this.$router.push({
          name: '创建收货单',
          params: {
            shippingOrderId: id
          }
        });
      },
      //复议
      onReconsider(id) {
        this.$router.push('/reconsiders/create/orders/' + id);
      },
      //统计单数
      countTotalSheetsNum(sheets) {
        let result = 0;
        sheets.forEach(element => {
          let num = parseInt(element.totalQuantity);
          if (!Number.isNaN(num)) {
            result += num;
          }
        });
        return result;
      },
      //是否有整单退货
      hasAllReturnOrder(row) {
        if (row.returnSheets) {
          let index = row.returnSheets.findIndex(sheet => sheet.isAllReturn);
          return index > -1;
        } else {
          return false;
        }
      }
    },
    watch: {
      'formData.shippingSheets': function (n, o) {
        this.$nextTick(() => {
          this.$refs.resultTable.doLayout()
        })
      },
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
      }
    },
    create() {

    }
  }

</script>

<style scope>
</style>
