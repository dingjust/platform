<template>
  <div class="animated fadeIn form-container">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="4">
          <div class="title">
            <h6>发货单详情</h6>
          </div>
        </el-col>
        <el-col :span="6">
          <h6>单号：{{formData.code}}</h6>
        </el-col>
        <el-col :span="4">
          <h6>创建时间：{{formData.creationtime | timestampToTime}}</h6>
        </el-col>
        <el-col :span="4">
          <h6>状态：{{getEnum('ShippingSheetState', formData.state)}}</h6>
        </el-col>
      </el-row>
      <div>
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="3">
            <img width="100px" height="100px"
              :src="formData.product.thumbnail!=null&&formData.product.thumbnail.length!=0?formData.product.thumbnail.url:'static/img/nopicture.png'">
          </el-col>
          <el-col :span="21">
            <el-row type="flex" style="padding: 10px 0px">
              <el-col :span="8">
                <h6 class="basic-label">产品名称：{{formData.product.name}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">货号：{{formData.product.skuID}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <el-col :span="8">
                <h6 class="basic-label">发货方：{{formData.shipParty!=null?formData.shipParty.name:''}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">收货方：{{formData.receiveParty!=null?formData.receiveParty.name:''}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">发货负责人：{{formData.merchandiser.name}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <el-col :span="12">
                <h6 class="basic-label">收货地址：{{formData.deliveryAddress.details}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px"
              v-if="!formData.isOfflineConsignment&&formData.consignment!=null">
              <el-col :span="8">
                <h6 class="basic-label">发货方式：{{formData.consignment.carrierDetails.name}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">物流单号：{{formData.consignment.trackingID}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px" v-else>
              <el-col :span="8">
                <h6 class="basic-label">物流方式：{{formData.offlineConsignorMode}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">送货人：{{formData.offlineConsignorName}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">联系方式：{{formData.offlineConsignorPhone}}</h6>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-row" v-if="formData.packageSheets!=null">
          <el-col :span="24">
            <color-size-box-table :vdata.sync="formData.packageSheets"
              :colorSizeEntries="formData.packageSheets[0].colorSizeEntries" :readOnly="true" />
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-row" align="middle">
          <el-col :span="6">
            <el-row type="flex" align="middle">
              <span class="basic-label">收货单：</span>
              <template v-for="(sheet,sheetIndex) in formData.receiptSheets">
                <el-button type="text" @click="onReceiptDetail(formData.receiptSheets[sheetIndex].id)"
                  :key="'return'+sheetIndex">
                  {{formData.receiptSheets[sheetIndex].code}}</el-button>
              </template>
            </el-row>
          </el-col>
          <el-col :span="6">
            <el-row type="flex" align="middle">
              <span class="basic-label">退货单：</span>
              <template v-for="(sheet,sheetIndex) in formData.returnSheets">
                <el-button type="text" @click="onReturnDetail(formData.returnSheets[sheetIndex].id)"
                  :key="'return'+sheetIndex">
                  {{formData.returnSheets[sheetIndex].code}}</el-button>
              </template>
            </el-row>
          </el-col>
          <el-col :span="6">
            <el-row type="flex" align="middle">
              <span class="basic-label">复议单：</span>
              <template v-for="(sheet,sheetIndex) in formData.reconsiderSheets">
                <el-button type="text" @click="onReconsiderDetail(formData.reconsiderSheets[sheetIndex].id)"
                  :key="'return'+sheetIndex">
                  {{formData.reconsiderSheets[sheetIndex].code}}</el-button>
              </template>
            </el-row>
          </el-col>
          <el-col :span="6">
            <el-row type="flex" align="middle">
              <span class="basic-label">对账单：</span>
              <template v-for="(sheet,sheetIndex) in formData.reconsiderSheets">
                <el-button type="text" @click="onReconsiderDetail(formData.reconsiderSheets[sheetIndex].id)"
                  :key="'return'+sheetIndex">
                  {{formData.reconsiderSheets[sheetIndex].code}}</el-button>
              </template>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
          <template v-if="!hasReceiptOrder&&isReceiveOperator&&formData.state=='PENDING_RECEIVED'">
            <authorized :permission="['RECEIPT_SHEET_CREATE']">
              <el-button class="sumbit-btn" @click="onCreate">创建收货单</el-button>
            </authorized>
            <authorized :permission="['RETURN_SHEET_CREATE']">
              <el-button style="margin-left:50px" type="text" @click="onReturnAll">整单退货 >></el-button>
            </authorized>
          </template>
          <!-- 待退货 -->
          <template v-if="formData.state=='PENDING_RETURNED'&&isReceiveOperator">
            <authorized :permission="['RETURN_SHEET_CREATE']">
              <el-button class="sumbit-btn" @click="onReturn">创建退货单</el-button>
            </authorized>
            <authorized :permission="['RETURN_SHEET_CREATE']">
              <el-button class="sumbit-btn" @click="onNoReturn">无退货</el-button>
            </authorized>
          </template>
          <!-- 待复议 -->
          <template v-if="formData.state=='PENDING_RECONSIDER'&&isShipOperator">
            <authorized :permission="['RECONSIDER_SHEET_CREATE']">
              <el-button class="sumbit-btn" @click="onReconsider">提出复议</el-button>
            </authorized>
            <authorized :permission="['RECONSIDER_SHEET_CREATE']">
              <el-button class="sumbit-btn" @click="onNoReconsider">无复议</el-button>
            </authorized>
          </template>
          <!-- 待对账(收货方) -->
          <template v-if="formData.state=='PENDING_RECONCILED'&&isReceiveOperator">
            <authorized :permission="['RECONCILIATION_SHEET_CREATE_UPDATE']">
              <el-button class="sumbit-btn" @click="onReconciled">去对账</el-button>
            </authorized>
          </template>
        </el-row>
      </div>
      <el-dialog :visible.sync="receDialogVisible" width="80%" class="purchase-dialog" append-to-body
        :close-on-click-modal="false">
        <receipt-order-detail :id="receId" v-if="receDialogVisible" />
      </el-dialog>
      <el-dialog :visible.sync="returnDialogVisible" width="80%" class="purchase-dialog" append-to-body
        :close-on-click-modal="false">
        <return-order-detail :id="returnId" v-if="returnDialogVisible" />
      </el-dialog>
      <el-dialog :visible.sync="reconDialogVisible" width="80%" class="purchase-dialog" append-to-body
        :close-on-click-modal="false">
        <reconsider-order-detail :id="reconId" v-if="reconDialogVisible" />
      </el-dialog>
      <el-dialog :visible.sync="reciliDialogVisible" width="80%" class="purchase-dialog" append-to-body
        :close-on-click-modal="false">
        <reconciliation-orders-detail v-if="reciliDialogVisible" :id="reciliId" />
      </el-dialog>
    </el-card>
  </div>
</template>

<script>
  import {
    ColorSizeBoxTable
  } from '@/components/'

  import ReceiptOrderDetail from '../../receipt-order/details/ReceiptOrderDetail'
  import ReturnOrderDetail from '../../return-order/details/ReturnOrderDetail'
  import ReconsiderOrderDetail from '../../reconsider-order/details/ReconsiderOrderDetail'
  import ReconciliationOrdersDetail from '../../reconciliation-order/details/ReconciliationOrdersDetail'

  export default {
    name: 'ShippingOrdersDetail',
    props: ['id'],
    components: {
      ColorSizeBoxTable,
      ReceiptOrderDetail,
      ReturnOrderDetail,
      ReconsiderOrderDetail,
      ReconciliationOrdersDetail
    },
    computed: {
      hasReceiptOrder: function () {
        return this.formData.receiptSheets != null && this.formData.receiptSheets.length > 0;
      },
      //是否为收货方跟单员
      isReceiveOperator: function () {
        if (this.currentUser != null && this.formData.originMerchandiser != null) {
          return this.currentUser.uid == this.formData.originMerchandiser.uid;
        } else {
          return false;
        }
      },
      //是否为发货方跟单员
      isShipOperator: function () {
        if (this.currentUser != null && this.formData.merchandiser != null) {
          return this.currentUser.uid == this.formData.merchandiser.uid;
        } else {
          return false;
        }
      },
    },
    methods: {
      async getDetail() {
        // TODO 获取发货单详情
        const url = this.apis().shippingOrderDetail(this.id);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.formData = Object.assign({}, result.data);
      },
      //创建收货单
      onCreate() {
        this.$router.push({
          name: '创建收货单',
          params: {
            shippingOrder: this.formData
          }
        });
      },
      //收货详情
      onReceiptDetail(id) {
        // this.$router.push('/receipt/orders/' + id);
        this.receId = id;
        this.receDialogVisible = true;
      },
      //退货详情
      onReturnDetail(id) {
        // this.$router.push('/returned/orders/' + id);
        this.returnId = id;
        this.returnDialogVisible = true;
      },
      //复议单详情
      onReconsiderDetail(id) {
        this.reconId = id;
        this.reconDialogVisible = true;
      },
      onNoReturn() {
        this.$confirm('是否确认跳过退货?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onNoReturn();
        }).catch(() => {

        });
      },
      async _onNoReturn() {
        const url = this.apis().cancelReturn(this.id);
        const result = await this.$http.put(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        } else if (result.code == '1') {
          this.$message.success(result.msg);
          this.getDetail();
        }
      },
      //跳过复议
      onNoReconsider() {
        this.$confirm('是否确认跳过复议?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onNoReconsider();
        }).catch(() => {

        });
      },
      async _onNoReconsider() {
        const url = this.apis().cancelReconsider(this.id);
        const result = await this.$http.put(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        } else if (result.code == '1') {
          this.$message.success(result.msg);
          this.getDetail();
        }
      },
      //整单退货
      onReturnAll() {
        this.$router.push({
          name: '创建退货单',
          params: {
            shippingOrder: this.formData,
            isAllReturn: true
          }
        });
      },
      //部分退货
      onReturn() {
        this.$router.push({
          name: '创建退货单',
          params: {
            shippingOrder: this.formData,
            isAllReturn: false
          }
        });
      },
      //创建复议单
      onReconsider() {
        this.$router.push("/reconsiders/create/orders/" + this.formData.id);
      },
      //去对账
      onReconciled() {
        this.$router.push({
          name: '创建对账单',
          params: {
            productionTaskOrderId: this.formData.productionTaskOrder.id,
            selectShipOrder: [this.formData]
          }
        });
      }
    },
    data() {
      return {
        currentUser: this.$store.getters.currentUser,
        receDialogVisible: false,
        returnDialogVisible: false,
        reconDialogVisible: false,
        reciliDialogVisible: false,
        receId: null,
        returnId: null,
        reconId: null,
        reciliId: null,
        formData: {
          product: {
            name: '',
            skuID: '',
          },
          shipParty: {
            name: '',
          },
          receiveParty: {
            name: ''
          },
          merchandiser: {
            name: ''
          },
          deliveryAddress: {
            details: ''
          },
        },
        taskData: '',
        carriers: ''
      }
    },
    created() {
      this.getDetail();
    },
    destroyed() {

    }
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-row {
    padding-left: 10px;
    margin-top: 20px;
  }

  .basic-label {
    font-size: 14px;
    color: #606266;
  }

  .form-container {
    margin-bottom: 20px;
  }

  .form-container /deep/ .el-form-item {
    margin-bottom: 0px;
  }

  .sumbit-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 125px;
    height: 32px;
  }

</style>
