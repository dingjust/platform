<template>
  <div class="info-detail-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">生产订单详情({{getEnum('purchaseOrderStatuses', slotData.status)}})</h6>
      </div>
    </el-row>
    <el-row type="flex" justify="space-between" align="center">
      <el-col :span="3">
        <img
          :src="slotData.product.thumbnail!=null&&slotData.product.thumbnail.length!=0?slotData.product.thumbnail.url:'static/img/nopicture.png'"
          class="info-detail-thumnail" />
      </el-col>
      <el-col :span="21">
        <div>
          <el-row type="flex" align="center" class="info-detail-item_row">
            <orders-info-item :slotData="'产品名称'">{{slotData.product.name}}</orders-info-item>
          </el-row>
          <el-row type="flex" align="center" class="info-detail-item_row">
            <el-col :span="6">
              <orders-info-item :slotData="'产品货号'">{{slotData.product.skuID}}</orders-info-item>
            </el-col>
            <el-col :span="6">
              <orders-info-item :slotData="'生产数量'">{{totalQuantity}}(件)</orders-info-item>
            </el-col>
            <el-col :span="6">
              <orders-info-item :slotData="'订单报价'">￥{{this.slotData.unitPrice}}</orders-info-item>
            </el-col>
            <el-col :span="6">
              <orders-info-item :slotData="'生产总额'">￥{{this.slotData.totalPrice | numFilter}}</orders-info-item>
            </el-col>
          </el-row>
          <el-row type="flex" align="center" class="info-detail-item_row">
            <el-col :span="6">
              <orders-info-item :slotData="'合作方式'">{{getEnum('machiningTypes', slotData.machiningType)}}
              </orders-info-item>
            </el-col>
            <el-col :span="6">
              <orders-info-item :slotData="'运费承担'">{{slotData.freightPayer=='PARTYA'?'甲方':'乙方'}}
              </orders-info-item>
            </el-col>
            <el-col :span="6">
              <orders-info-item :slotData="'交货日期'">{{slotData.expectedDeliveryDate | timestampToTime}}
              </orders-info-item>
            </el-col>
            <el-col :span="6">
              <orders-info-item :slotData="'是否开票'">
                {{slotData.invoiceNeeded?('开发票'+slotData.invoiceTaxPoint*100+'%税点'):'不开发票'}}</orders-info-item>
            </el-col>
          </el-row>
          <el-row type="flex" justify="space-between" align="center" class="info-detail-item_row" v-if="slotData.deliveryAddress!=null">
            <el-col :span="20">
              <orders-info-item :slotData="'送货地址'">{{this.slotData.deliveryAddress.details}}
                {{this.slotData.deliveryAddress.fullname}} {{this.slotData.deliveryAddress.cellphone}}</orders-info-item>
            </el-col>
            <el-col :span="4">
              <el-button style="padding-top: 0px" v-if="isMyself" size="mini" type="text" @click="onAddressModifyFormVisible">修改地址</el-button>
            </el-col>
          </el-row>
          <!-- <el-row type="flex" justify="space-between" align="middle">
            <el-row type="flex" justify="start" align="middle">
              <div class="info-detail-logistics_info">
                <el-row>
                  <h6 class="info-detail-logistics_info-text">
                    物流信息&nbsp;&nbsp;&nbsp;&nbsp;2832847739043057939428434
                  </h6>
                </el-row>
              </div>
              <el-button class="info-detail-logistics_info-btn1">查看物流</el-button>
            </el-row>
          </el-row> -->
          <el-row class="info-detail-item_row2">
            <orders-info-table :slotData="slotData.entries" class="info-detail-table" />
          </el-row>
        </div>
      </el-col>
    </el-row>
    <el-row type="flex" justify="space-between" align="center">

    </el-row>
  </div>
</template>

<script>
  import OrdersInfoItem from '@/components/custom/OrdersInfoItem';
  import OrdersInfoTable from '@/components/custom/OrdersInfoTable';

  export default {
    name: 'PurchaseOrderInfoDetail',
    props: ['slotData'],
    components: {
      OrdersInfoItem,
      OrdersInfoTable
    },
    mixins: [],
    computed: {
      totalQuantity: function () {
        var result = 0;
        this.slotData.entries.forEach(element => {
          result += element.quantity;
        });
        return result;
      },
      isMyself: function () {
        if (this.slotData.creator != null) {
          return this.slotData.creator.uid == this.$store.getters.currentUser.companyCode;
        } else {
          return false;
        }
        // if (this.slotData.creator.uid === this.$store.getters.currentUser.companyCode) {
        //   return true;
        // } else {
        //   return false;
        // }
      }
    },
    methods: {
      onAddressModifyFormVisible () {
        this.$emit('onAddressModifyFormVisible');
      }
    },
    data () {
      return {
      }
    },
    created () {
    }
  }
</script>
<style>
  .info-detail-body {
    width: 100%;
  }

  .info-detail-thumnail {
    width: 70px;
    height: 70px;
    border-radius: 10px;
  }

  .info-detail-item_row {
    margin-bottom: 5px;
  }

  .info-detail-item_row2 {
    margin-top: 20px;
  }

  .info-detail-logistics_info {
    border: 0.5px solid rgba(0, 0, 0, 0.15);
    padding-left: 10px;
    padding-top: 5px;
    padding-bottom: 5px;
    padding-right: 5px;
    height: 25px;
    width: 250px;
  }

  .info-detail-logistics_info-text {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
  }

  .info-detail-logistics_info-btn1 {
    width: 70px;
    height: 25px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    border: 0px solid #FFD60C;
  }

  .info-detail-logistics_info-btn2 {
    width: 70px;
    font-weight: 400;
    color: rgba(252, 157, 29, 1);
    font-size: 10px;
    border: 0px solid #fff;
  }

</style>
