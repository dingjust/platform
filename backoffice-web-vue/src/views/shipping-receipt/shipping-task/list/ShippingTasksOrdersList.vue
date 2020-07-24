<template>
  <div class="task-order-container">
    <el-row type="flex" justify="end" v-if="showDeliveryBtn">
      <el-button @click="onCreate">创建发货订单</el-button>
    </el-row>
    <el-table ref="resultTable" stripe :data="formData.shippingSheets" :height="autoHeight">
      <el-table-column label="发货单号" prop="code" min-width="160px">
        <template slot-scope="scope">
          <el-row type="flex" align="middle">
            <el-button type="text" @click="onShippingSheetDetail(scope.row.id)">{{scope.row.code}}</el-button>
            <el-tag size="mini" style="margin-left:10px" type="info" effect="plain">
              {{getEnum('ShippingSheetState', scope.row.state)}}</el-tag>
            <el-tag v-if="hasAllReturnOrder(scope.row)" size="mini" style="margin-left:10px"
              type="warning" effect="plain">整单退货</el-tag>
          </el-row>
        </template>
      </el-table-column>
      <el-table-column label="发货数量" prop="totalQuantity"></el-table-column>
      <el-table-column label="发货时间">
        <template slot-scope="scope">
          <span>{{scope.row.creationtime | formatDateInday}}</span>
        </template>
      </el-table-column>
      <el-table-column label="收货单" min-width="120px">
        <template slot-scope="scope">
          <template v-for="(sheet,sheetIndex) in scope.row.receiptSheets">
            <el-row :key="'sheet'+sheetIndex" type="flex">
              <el-button type="text" @click="onReceiptDetail(scope.row.receiptSheets[sheetIndex].id)">
                {{scope.row.receiptSheets[sheetIndex].code}}</el-button>
            </el-row>
          </template>
        </template>
      </el-table-column>
      <el-table-column label="收货数">
        <template slot-scope="scope" v-if="scope.row.receiptSheets!=null">
          <span>{{countTotalSheetsNum(scope.row.receiptSheets)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="收货时间">
        <template slot-scope="scope" v-if="scope.row.receiptSheets!=null">
          <span>{{scope.row.receiptSheets[0].creationtime | formatDateInday}}</span>
        </template>
      </el-table-column>
      <el-table-column label="退货单" min-width="165px">
        <template slot-scope="scope" v-if="scope.row.returnSheets!=null">
          <template v-for="(sheet,sheetIndex) in scope.row.returnSheets">
            <el-row :key="'sheet'+sheetIndex" type="flex" align="middle">
              <el-button type="text" @click="onReturnDetail(scope.row.returnSheets[sheetIndex].id)">
                {{scope.row.returnSheets[sheetIndex].code}}</el-button>
              <el-tag size="mini" style="margin-left:10px" type="danger" effect="plain">
                {{getEnum('ShippingSheetState', scope.row.returnSheets[sheetIndex].state)}}</el-tag>
            </el-row>
          </template>
        </template>
      </el-table-column>
      <el-table-column label="退货数">
        <template slot-scope="scope" v-if="scope.row.returnSheets!=null">
          <span>{{countTotalSheetsNum(scope.row.returnSheets)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="差异数" prop="diffQuantity"></el-table-column>
      <!-- 发货方 -->
      <el-table-column align="center" fixed="right" v-if="isShipParty">
        <template slot-scope="scope">
          <el-button type="text" @click="onReconsider(scope.row.id)" v-if="scope.row.state=='PENDING_RECONSIDER'">复议
          </el-button>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" fixed="right" v-if="isReceiptParty">
        <template slot-scope="scope">
          <el-button type="text" @click="onReceive(scope.row.id)" v-if="scope.row.state=='PENDING_RECEIVED'">收货
          </el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'ShippingTasksOrdersList',
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
      }
    },
    methods: {
      onCreate() {
        this.$emit('onCreate');
      },
      onShippingSheetDetail(id) {
        this.$router.push('/shipping/orders/' + id);
      },
      onReceiptDetail(id) {
        this.$router.push('/receipt/orders/' + id);
      },
      onReturnDetail(id) {
        this.$router.push('/returned/orders/' + id);
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
      hasAllReturnOrder(row){
        if(row.returnSheets){
          let index= row.returnSheets.findIndex(sheet=>sheet.isAllReturn);
          return index>-1;      
        }else{
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
