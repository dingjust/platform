<!-- 
 * @description: 复议单表单
 * @fileName: ReconsiderOrderForm.vue 
 * @author: yj 
 * @date: 2020-06-23 14:47:26
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
            :src="shippingOrder.product.thumbnail!=null&&shippingOrder.product.thumbnail.length!=0?shippingOrder.product.thumbnail.url:'static/img/nopicture.png'">
        </el-col>
        <el-col :span="21">
          <el-row type="flex" style="padding: 10px 0px">
            <el-col :span="8">
              <h6 class="basic-label">产品名称：{{shippingOrder.product.name}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">货号：{{shippingOrder.product.skuID}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="8">
              <h6 class="basic-label">发货方：{{shippingOrder.shipParty!=null?shippingOrder.shipParty.name:''}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">收货方：{{shippingOrder.receiveParty!=null?shippingOrder.receiveParty.name:''}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">发货负责人：{{shippingOrder.merchandiser.name}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="12">
              <h6 class="basic-label">收货地址：{{shippingOrder.deliveryAddress.details}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px"
            v-if="!shippingOrder.isOfflineConsignment&&shippingOrder.consignment!=null">
            <el-col :span="8">
              <h6 class="basic-label">发货方式：{{shippingOrder.consignment.carrierDetails.name}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">发货单号：{{shippingOrder.consignment.trackingID}}</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px" v-else>
            <el-col :span="8">
              <h6 class="basic-label">物流方式：{{shippingOrder.offlineConsignorMode}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">送货人：{{shippingOrder.offlineConsignorName}}</h6>
            </el-col>
            <el-col :span="8">
              <h6 class="basic-label">联系方式：{{shippingOrder.offlineConsignorPhone}}</h6>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-table :data="[shippingOrder]" stripe style="width: 100%">
        <el-table-column prop="code" label="发货单">
        </el-table-column>
        <el-table-column prop="totalQuantity" label="发货数量">
        </el-table-column>
        <el-table-column label="收货单">
          <template slot-scope="scope">
            <el-button type="text" @click="onReceiptDetail(scope.row.receiptSheets[0].id)"
              v-if="scope.row.receiptSheets!=null">
              {{scope.row.receiptSheets[0].code}}</el-button>
          </template>
        </el-table-column>
        <el-table-column label="收货数量">
          <template slot-scope="scope" v-if="scope.row.receiptSheets!=null">
            <span>{{scope.row.receiptSheets[0].totalQuantity}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="" label="退货单">
          <template slot-scope="scope">
            <el-button type="text" @click="onReturnDetail(scope.row.returnSheets[0].id)"
              v-if="scope.row.returnSheets!=null">
              {{scope.row.returnSheets[0].code}}</el-button>
          </template>
        </el-table-column>
        <el-table-column prop="" label="退货数/收退数">
          <template slot-scope="scope" v-if="scope.row.returnSheets!=null">
            <span>{{scope.row.returnSheets[0].totalQuantity}}</span>
          </template>
        </el-table-column>
        <el-table-column prop="diffQuantity" label="差异数">
        </el-table-column>
      </el-table>
      <el-form :model="form" ref="form" :inline="true">
        <el-row type="flex" justify="space-between" style="margin-top:20px">
          <el-col :span="6" :offset="2">
            <el-row type="flex">
              <h6 style="margin-right:20px">上传凭证</h6>
              <images-upload class="form-upload" :slot-data="form.medias" />
            </el-row>
          </el-col>
          <el-col :span="6">
            <!-- <h6>申请复议数量：1</h6> -->
            <el-form-item label="申请复议数量" label-width="120px"
              :rules="{required: true, message: '不能为空', trigger: 'blur'}">
              <el-input v-model="form.reconsiderQuantity" placeholder="0" v-number-input.float="{ min: 0,decimal:0}">
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50">
        <template>
          <el-col :span="4">
            <el-button class="material-btn" @click="onSubmit">提交复议</el-button>
          </el-col>
        </template>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import {
    ColorSizeBoxTable,
    ColorSizeTable
  } from '@/components/'

  import ImagesUpload from '@/components/custom/ImagesUpload';

  export default {
    name: 'ReconsiderOrderForm',
    props: {
      id: {
        type: String,
        required: true
      }
    },
    components: {
      ImagesUpload,
    },
    computed: {

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
        this.shippingOrder = Object.assign({}, result.data);
      },
      onReceiptDetail(id) {
        this.$router.push('/receipt/orders/' + id);
      },
      onReturnDetail(id) {
        this.$router.push('/returned/orders/' + id);
      },
      onSubmit() {
        //校验表单
        this.$refs['form'].validate((valid) => {
          if (valid) {
            //校验通过
            this.$confirm('是否确定申请复议？', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              this._onSubmit();
            });
          } else {
            this.$message.error('请填写复议数');
            return false;
          }
        });
      },
      async _onSubmit() {
        const url = this.apis().reconsiderOrderCreate();
        const result = await this.$http.post(url, this.form, {
          id: this.id
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        } else if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$router.go(-1);
      },
    },
    data() {
      return {
        data: [],
        shippingOrder: {
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
        form: {
          reconsiderQuantity: '',
          medias: []
        },
      }
    },
    created() {
      this.getDetail();
    },
    destroyed() {

    }
  }

</script>

<style scoped src="../../css/reconsider-order.css"></style>
