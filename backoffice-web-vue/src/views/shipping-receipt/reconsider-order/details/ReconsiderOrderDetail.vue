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
          <!-- <img width="54px" height="54px"
              :src="scope.row.thumbnail!=null&&scope.row.thumbnail.length!=0?scope.row.thumbnail.url:'static/img/nopicture.png'"> -->
          <img width="100px" height="100px" :src="'static/img/nopicture.png'">
        </el-col>
        <el-col :span="21">
          <el-row type="flex" style="padding: 10px 0px">
            <el-col :span="8">
              <h6>产品名称：红烧猪蹄</h6>
            </el-col>
            <el-col :span="8">
              <h6>货号：梅菜扣肉</h6>
            </el-col>
            <el-col :span="8">
              <h6>单价：12</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="8">
              <h6>发货方：烧鸡翅</h6>
            </el-col>
            <el-col :span="8">
              <h6>收货方：xxx</h6>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-table :data="[]" stripe style="width: 100%">
        <el-table-column prop="" label="发货单">
        </el-table-column>
        <el-table-column prop="name" label="发货数量">
        </el-table-column>
        <el-table-column prop="" label="收货单">
        </el-table-column>
        <el-table-column prop="" label="收货数量">
        </el-table-column>
        <el-table-column prop="" label="退货单">
        </el-table-column>
        <el-table-column prop="" label="退货数/收退数">
        </el-table-column>
        <el-table-column prop="" label="差异数">
        </el-table-column>
      </el-table>
      <el-form :model="form" :inline="true">
        <el-row type="flex" justify="space-between" style="margin-top:20px">
          <el-col :span="6" :offset="2">
            <el-row type="flex">
              <h6 style="margin-right:20px">上传凭证</h6>
              <images-upload class="form-upload" :slot-data="attachments" />
            </el-row>
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
      <reject-form v-if="rejectFormVisible" />
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
            "quantity": 22
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
            "quantity": 2
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
            "quantity": 2
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
        form: {
          num: ''
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
