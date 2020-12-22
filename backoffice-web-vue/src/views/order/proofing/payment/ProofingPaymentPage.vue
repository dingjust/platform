<template>
  <div class="animated fadeIn ">
    <el-row class="info-title-row" type="flex" justify="space-between">
      <div class="info-title">
        <h6 class="info-title-text">支付</h6>
      </div>
      <!--<i class="el-icon-edit" @click="onEdit" style="cursor:pointer;font-size: 20px"></i>-->
    </el-row>
    <div style="margin: 20px 50px;border:1px solid #c8c8c8;padding: 20px 15px">
      <el-row type="flex" style="margin-bottom: 20px">
        <el-col :span="12">
          <span>打样订单号：{{slotData.code}}</span>
        </el-col>
        <el-col :span="12">
          <span>当前状态：<span :style="{color: statusColor}">{{getEnum('proofingOrderStatuses',slotData.status)}}</span></span>
        </el-col>
      </el-row>
      <el-row>
        <h6>产品图片</h6>
      </el-row>
      <el-row type="flex" >
        <el-col :span="3">
          <div class="demo-image__preview">
            <el-image
              style="width: 100px; height: 100px;border-radius: 9px"
              :src="slotData.product.images != null && slotData.product.images.length > 0 ? slotData.product.images[0].url : 'static/img/nopicture.png'"
              :preview-src-list="picUrls">
            </el-image>
          </div>
        </el-col>
        <el-col :span="21">
          <el-row type="flex">
            <el-col :span="12">
              <el-row type="flex" class="rowClass">
                <el-col :span="4">
                  <h6 style="font-weight: bold">标题</h6>
                </el-col>
                <el-col :span="20">
                  <h6 class="contentTextClass">{{slotData.product.name}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" class="rowClass">
                <el-col :span="4">
                  <h6 style="font-weight: bold">订购数量</h6>
                </el-col>
                <el-col :span="20">
                  <h6 class="contentTextClass">{{slotData.totalQuantity}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" class="rowClass">
                <el-col :span="4">
                  <h6 style="font-weight: bold">联系人</h6>
                </el-col>
                <el-col :span="20">
                  <h6 class="contentTextClass">{{slotData.belongTo.contactPerson}}</h6>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="12">
              <el-row type="flex" class="rowClass">
                <el-col :span="4">
                  <h6 style="font-weight: bold">产品品类</h6>
                </el-col>
                <el-col :span="20">
                  <h6 class="contentTextClass">{{slotData.product.category.parent.name}}-{{slotData.product.category.name}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" class="rowClass">
                <el-col :span="4">
                  <h6 style="font-weight: bold">打样费</h6>
                </el-col>
                <el-col :span="20">
                  <h6 class="contentTextClass">￥{{slotData.unitPrice ? slotData.unitPrice : '--'}}</h6>
                </el-col>
              </el-row>
              <el-row type="flex" class="rowClass">
                <el-col :span="4">
                  <h6 style="font-weight: bold">联系方式</h6>
                </el-col>
                <el-col :span="20">
                  <h6 class="contentTextClass">{{slotData.belongTo.contactPhone}}</h6>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" justify="end">
        <h6 style="font-size: 16px;color: red;margin-right: 150px">总计费用：{{slotData.totalPrice}}</h6>
      </el-row>
    </div>

    <el-divider></el-divider>

    <el-row type="flex">
      <el-col :span="12" style="padding: 20px 0px">
        <h6 style="margin-bottom: 40px">选择支付方式</h6>
        <el-row type="flex" align="middle" justify="center" style="margin-bottom: 40px">
          <el-col :span="8"></el-col>
          <el-col :span="4">
            <div class="hook" v-if="payType == 'ali'"></div>
            <div class="circular" v-else @click="handleAliClick"></div>
          </el-col>
          <el-col :sapn="10">
            <h6 style="margin-left: 20px;margin-top: 7px;">支付宝支付</h6>
          </el-col>
        </el-row>
        <el-row type="flex" align="middle" justify="center" style="margin-bottom: 40px">
          <el-col :span="8"></el-col>
          <el-col :span="4">
            <div class="hook"  v-if="payType == 'wechat'"></div>
            <div class="circular" v-else @click="handleWechatClick"></div>
          </el-col>
          <el-col :sapn="10">
            <h6 style="margin-left: 20px;margin-top: 7px;">微信支付</h6>
          </el-col>
        </el-row>
      </el-col>
      <el-divider direction="vertical"></el-divider>
      <el-col :span="12" style="padding: 20px 0px">
        <el-row type="flex" justify="center" style="width: 100%">
          <img :src="qrcodeUrl" width="200px" height="200px"/>
        </el-row>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';
  import QuoteBasicInfoPage from '../../quote/info/QuoteBasicInfoPage';
  import RequirementOrderBasicInfoPage from '../../requirement/info/RequirementOrderBasicInfoPage';
  import RequirementOrderBelongToInfoPage from '../../requirement/info/RequirementOrderBelongToInfoPage';

  const {mapGetters, mapMutations, mapActions} = createNamespacedHelpers('RequirementOrdersModule');

  export default {
    name: 'ProofingPaymentPage',
    props: {
      slotData: {
        type: Object,
        required: true
      },
      readOnly: {
        type: Boolean,
        default: true
      }
    },
    components: {
      RequirementOrderBelongToInfoPage,
      RequirementOrderBasicInfoPage,
      QuoteBasicInfoPage
    },
    computed: {
      ...mapGetters({

      }),
      picUrls: function () {
        if (this.slotData.product.images != null && this.slotData.product.images.length > 0) {
          return this.slotData.product.images.map(pic => pic.url);
        } else {
          return [];
        }
      },
      statusColor: function () {
        var color = '';
        switch (this.slotData.status) {
          case 'PENDING_PAYMENT':
            color = 'red';
            break;
          case 'PENDING_DELIVERY':
            color = 'red';
            break;
          case 'SHIPPED':
            color = 'red';
            break;
          case 'COMPLETED':
            color = 'green';
            break;
          case 'CANCELLED':
            color = 'grey';
            break;
        }
        return color;
      }
    },
    methods: {
      ...mapMutations({
      }),
      ...mapActions({
      }),
      async onPayment () {
        const url = this.apis().payProofingsImage(this.slotData.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.qrcodeUrl = result;
      },
      async onAliPayment () {
        const url = this.apis().aliPayProofingsImage(this.slotData.code);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.qrcodeUrl = result;
      },
      handleWechatClick () {
        this.payType = 'wechat';
        this.onPayment();
      },
      handleAliClick () {
        this.payType = 'ali';
        this.onAliPayment();
      }
    },
    data () {
      return {
        qrcodeUrl: '',
        payType: 'wechat'
      }
    },
    created () {
      this.onPayment();
    }
  }
</script>

<style scoped>
  .rowClass{
    margin-bottom: 20px;
  }
   .info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

   .info-title-text {
    font-size: 12px;
    font-weight: bold;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

   .info-title-row {
    margin-bottom: 20px;
  }

   /deep/ .el-divider--horizontal{
    margin: 0px 0px -1px 0px;
  }

   .buttonClass{
    padding: 8px 35px 8px 35px;
    margin-bottom: 10px;
    background-color: #ffd60c;
    color: #0b0e0f;
  }

   .box{
    width: 50px;
    position: fixed;
    right: 152px;
    top: 300px;
    z-index:1;
  }
   .boxButton{
    width: 50px;
    height: 50px;
    font-size: 10px;
    cursor: pointer;
    border: 1px solid #DCDFE6;
  }

   .buttonIconClass{
    width: 30px;
    height: 30px;
    margin-bottom: -8px;
  }

   .buttonTextClass{
    font-size: 12px;
    transform:scale(0.7);
  }

  /deep/ .v-modal{
    display: none;
  }

   .titleClass{
    padding: 10px 0px 1px 10px;
    background-color: #F0F0F0;
  }

   .titleCardClass{
    border-style: solid;
    border-width: 1px;
    border-top: white;
    border-color: #DCDCDC;
  }

   /deep/ .el-divider--vertical{
    height: auto;
    margin: 0px;
  }
</style>
