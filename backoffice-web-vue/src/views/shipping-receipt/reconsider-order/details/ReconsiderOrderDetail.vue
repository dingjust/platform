<!-- 
 * @description: 复议单详情
 * @fileName: ReconsiderOrderDetail.vue 
 * @author: yj 
 * @date: 2020-06-23 15:54:10
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn receipt-order-container">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="4">
          <div class="title">
            <h6>复议详情</h6>
          </div>
        </el-col>
        <el-col :span="4">
          <div>
            <h6>单号：{{formData.code}}</h6>
          </div>
        </el-col>
        <el-col :span="4">
          <h6>创建时间：{{formData.creationtime | timestampToTime}}</h6>
        </el-col>
        <el-col :span="4">
          <div>
            <h6>状态：{{getEnum('ShippingSheetState', formData.state)}}</h6>
          </div>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="3">
          <img width="100px" height="100px"
            :src="formData.product.thumbnail!=null&&formData.product.thumbnail.length!=0?formData.product.thumbnail.url:'static/img/nopicture.png'" />
        </el-col>
        <el-col :span="21">
          <el-row type="flex" style="padding: 10px 0px">
            <el-col :span="8">
              <h6 class="basic-label">产品名称：{{formData.product.name}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">货号：{{formData.product.skuID}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">时间：{{formData.creationtime|timestampToTime}}</h6>
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
              <h6 class="basic-label">发货单号：{{formData.consignment.trackingID}}</h6>
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
      <el-table :data="[formData]" stripe style="width: 100%">
        <el-table-column prop="logisticsSheet.code" label="发货单"></el-table-column>
        <el-table-column prop="logisticsSheet.totalQuantity" label="发货数量">
        </el-table-column>
        <el-table-column label="收货单">
          <template slot-scope="scope" v-if="scope.row.logisticsSheet.receiptSheets!=null">
            <el-button type="text" @click="onReceiptDetail(scope.row.logisticsSheet.receiptSheets[0].id)"
              v-if="scope.row.logisticsSheet.receiptSheets[0]!=null">{{scope.row.logisticsSheet.receiptSheets[0].code}}
            </el-button>
          </template>
        </el-table-column>
        <el-table-column label="收货数量">
          <template slot-scope="scope" v-if="scope.row.logisticsSheet.receiptSheets!=null">
            <span>{{scope.row.logisticsSheet.receiptSheets[0].totalQuantity}}</span>
          </template>
        </el-table-column>
        <el-table-column prop label="退货单">
          <template slot-scope="scope" v-if="scope.row.logisticsSheet.returnSheets!=null">
            <el-button type="text" @click="onReturnDetail(scope.row.logisticsSheet.returnSheets[0].id)"
              v-if="scope.row.logisticsSheet.returnSheets[0]!=null">{{scope.row.logisticsSheet.returnSheets[0].code}}
            </el-button>
          </template>
        </el-table-column>
        <el-table-column prop label="退货数/收退数">
          <template slot-scope="scope" v-if="scope.row.logisticsSheet.returnSheets!=null">
            <span>{{scope.row.logisticsSheet.returnSheets[0].totalQuantity}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="logisticsSheet.diffQuantity" label="差异数"></el-table-column>
      </el-table>
      <el-row type="flex" justify="space-between" style="margin-top:20px">
        <el-col :span="6" :offset="2">
          <template v-for="(media,index) in formData.medias">
            <el-image :key="'img'+index" class="image-item" :src="media.url" :preview-src-list="mediasUrlList">
            </el-image>
          </template>
        </el-col>
        <el-col :span="6">
          <h6>申请复议数量：{{formData.reconsiderQuantity}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="space-between" style="margin-top:20px">
        <el-col :span="12">
          <h6>审批意见：{{formData.remarks}}</h6>
        </el-col>
        <el-col :span="6">
          <h6>已补数量：{{completeNum}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50"
        v-if="formData.state=='IN_RECONSIDER'&&isReceiveParty">
        <template>
          <el-col :span="4">
            <authorized :permission="['RECONSIDER_SHEET_CONFIRM_REJECT']">
              <el-button class="material-btn" @click="onSure">同意</el-button>
            </authorized>
          </el-col>
          <el-col :span="4">
            <authorized :permission="['RECONSIDER_SHEET_CONFIRM_REJECT']">
              <el-button class="material-btn" @click="onReject">拒绝</el-button>
            </authorized>
          </el-col>
        </template>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="acceptFormVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <accept-form v-if="acceptFormVisible" :reconsiderOrder="formData" @callback="onCallback"
        :receiptOrderId="acceptReceiptOrderId" />
    </el-dialog>
    <el-dialog :visible.sync="rejectFormVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <reject-form v-if="rejectFormVisible" :reconsiderOrder="formData" @callback="onCallback" />
    </el-dialog>
    <el-dialog :visible.sync="receiptDialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <receipt-order-detail :id="receiptId" v-if="receiptDialogVisible" />
    </el-dialog>
    <el-dialog :visible.sync="returnDialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <return-order-detail :id="returnId" v-if="returnDialogVisible" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    ColorSizeBoxTable,
    ColorSizeTable
  } from "@/components/";

  import ReceiptOrderDetail from '../../receipt-order/details/ReceiptOrderDetail'
  import ReturnOrderDetail from '../../return-order/details/ReturnOrderDetail'
  import ImagesUpload from "@/components/custom/ImagesUpload";
  import AcceptForm from "../form/AcceptForm";
  import RejectForm from "../form/RejectForm";

  export default {
    name: "ReconsiderOrderDetail",
    props: {
      id: {
        type: String
      }
    },
    components: {
      ImagesUpload,
      AcceptForm,
      RejectForm,
      ReceiptOrderDetail,
      ReturnOrderDetail
    },
    computed: {
      //是收货方
      isReceiveParty: function () {
        if (this.formData.receiveParty != null && this.currentUser != null) {
          return this.currentUser.companyCode == this.formData.receiveParty.uid;
        } else {
          return false;
        }
      },
      //图片url list
      mediasUrlList: function () {
        return this.formData.medias.map(media => media.url);
      },
      //制定收货单id
      acceptReceiptOrderId: function () {
        if (this.formData.logisticsSheet.receiptSheets != null) {
          return this.formData.logisticsSheet.receiptSheets[0].id;
        } else {
          return null;
        }
      },
      //已补数量
      completeNum: function () {
        let result = 0;
        if (this.formData.receiptColorSizeEntries != null) {
          this.formData.receiptColorSizeEntries.forEach(entry => {
            let num = parseInt(entry.quantity);
            if (!Number.isNaN(num)) {
              result += num;
            }
          });
        }

        if (this.formData.returnSheet != null) {
          this.formData.returnSheet.packageSheets.forEach(sheet => {
            sheet.colorSizeEntries.forEach(entry => {
              let num = parseInt(entry.quantity);
              if (!Number.isNaN(num)) {
                result += num;
              }
            })
          });
        }

        return result;
      }
    },
    methods: {
      async getDetail() {
        // TODO 获取复议单详情
        const url = this.apis().reconsiderOrderDetail(this.id);
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
      onSure() {
        this.acceptFormVisible = true;
      },
      onReject() {
        this.rejectFormVisible = true;
      },
      onCallback() {
        this.acceptFormVisible = false;
        this.rejectFormVisible = false;
        this.getDetail();
      },
      onReturnDetail(id) {
        this.returnId = id;
        this.returnDialogVisible = true;
      },
      onReceiptDetail(id) {
        this.receiptId = id;
        this.receiptDialogVisible = true;
      }
    },
    data() {
      return {
        data: [],
        currentUser: this.$store.getters.currentUser,
        acceptFormVisible: false,
        rejectFormVisible: false,
        receiptDialogVisible: false,
        returnDialogVisible: false,
        receiptId: '',
        returnId: '',
        formData: {
          product: {
            name: "",
            skuID: ""
          },
          logisticsSheet: {
            receiptSheets: [{}],
            returnSheets: [{}]
          },
          shipParty: {
            name: ""
          },
          receiveParty: {
            name: ""
          },
          merchandiser: {
            name: ""
          },
          deliveryAddress: {
            details: ""
          }
        },
        attachments: []
      };
    },
    created() {
      this.getDetail();
    },
    destroyed() {}
  };

</script>
<style scoped src="../../css/reconsider-order.css"></style>
