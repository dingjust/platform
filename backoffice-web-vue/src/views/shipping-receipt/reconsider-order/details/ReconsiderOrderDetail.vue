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
            <h6>申请复议</h6>
          </div>
        </el-col>
        <el-col :span="4">
          <div>
            <h6>时间：{{Date.now()|timestampToTime}}</h6>
          </div>
        </el-col>
      </el-row>
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
        <el-table-column prop="code" label="发货单">
        </el-table-column>
        <el-table-column prop="totalQuantity" label="发货数量">
        </el-table-column>
        <el-table-column label="收货单">
          <template slot-scope="scope">
            <el-button type="text" @click="onReceiptDetail(scope.row.receiptSheets[0].id)"
              v-if="scope.row.receiptSheets[0]!=null">
              {{scope.row.receiptSheets[0].code}}</el-button>
          </template>
        </el-table-column>
        <el-table-column label="收货数量">
          <template slot-scope="scope" v-if="scope.row.receiptSheets[0]!=null">
            <span>{{scope.row.receiptSheets[0].totalQuantity}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="" label="退货单">
          <template slot-scope="scope">
            <el-button type="text" @click="onReturnDetail(scope.row.returnSheets[0].id)"
              v-if="scope.row.returnSheets[0]!=null">
              {{scope.row.returnSheets[0].code}}</el-button>
          </template>
        </el-table-column>
        <el-table-column prop="" label="退货数/收退数">
          <template slot-scope="scope" v-if="scope.row.returnSheets[0]!=null">
            <span>{{scope.row.returnSheets[0].totalQuantity}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="diffQuantity" label="差异数">
        </el-table-column>
      </el-table>
      <el-form :model="form" :inline="true">
        <el-row type="flex" justify="space-between" style="margin-top:20px">
          <el-col :span="6" :offset="2">
            <template v-for="(media,index) in formData.medias">
              <el-image :key="'img'+index" class="image-item" :src="media.url" :preview-src-list="mediasUrlList">
              </el-image>
            </template>
          </el-col>
          <el-col :span="6">
            <h6>申请复议数量：1</h6>
          </el-col>
        </el-row>
      </el-form>
      <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50">
        <template>
          <el-col :span="4">
            <el-button class="material-btn" @click="onSure">同意</el-button>
          </el-col>
          <el-col :span="4">
            <el-button class="material-btn" @click="onReject">拒绝</el-button>
          </el-col>
        </template>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="acceptFormVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <accept-form v-if="acceptFormVisible" :reconsiderOrder="{colorSizeEntries:colorSizeMockData}" />
    </el-dialog>
    <el-dialog :visible.sync="rejectFormVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <reject-form v-if="rejectFormVisible" :reconsiderOrder="{colorSizeEntries:colorSizeMockData}" />
    </el-dialog>
  </div>
</template>

<script>
  import {
    ColorSizeBoxTable,
    ColorSizeTable
  } from '@/components/'

  import ImagesUpload from '@/components/custom/ImagesUpload';
  import AcceptForm from '../form/AcceptForm';
  import RejectForm from '../form/RejectForm';

  export default {
    name: 'ReconsiderOrderForm',
    props: {
      id: {
        type: String
      }
    },
    components: {
      ImagesUpload,
      AcceptForm,
      RejectForm
    },
    computed: {

    },
    methods: {
      async getDetail() {
        // TODO 获取复议单详情
        const url = this.apis().formDataDetail(this.id);
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

    },
    data() {
      return {
        data: [],
        acceptFormVisible: false,
        rejectFormVisible: false,
        colorSizeMockData: [{
            "id": 8798845730133,
            "color": {
              "id": 8796094592307,
              "code": "C49",
              "name": "灰蓝",
              "colorCode": "#336666",
              "customize": false
            },
            "size": {
              "code": "S24",
              "name": "40"
            },
            "quantity": 22342
          },
          {
            "id": 8798845762901,
            "color": {
              "id": 8796094592307,
              "code": "C49",
              "name": "灰蓝",
              "colorCode": "#336666",
              "customize": false
            },
            "size": {
              "code": "S17",
              "name": "30"
            },
            "quantity": 22323
          },
          {
            "id": 8798845795669,
            "color": {
              "id": 8796094428467,
              "code": "C42",
              "name": "墨绿色",
              "colorCode": "#33300",
              "customize": false
            },
            "size": {
              "code": "S17",
              "name": "30"
            },
            "quantity": 2111
          },
          {
            "id": 8798845828437,
            "color": {
              "id": 8796094428467,
              "code": "C42",
              "name": "墨绿色",
              "colorCode": "#33300",
              "customize": false
            },
            "size": {
              "code": "S24",
              "name": "40"
            },
            "quantity": 2
          }
        ],
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
        attachments: []
      }
    },
    created() {

    },
    destroyed() {

    }
  }

</script>
<style scoped src="../../css/reconsider-order.css"></style>
