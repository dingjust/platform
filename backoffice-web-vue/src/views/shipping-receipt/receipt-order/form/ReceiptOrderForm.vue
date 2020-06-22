<!-- 
 * @description: 收货单表单
 * @fileName: ReceiptOrderForm.vue 
 * @author: yj 
 * @date: 2020-06-22 13:58:22
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn receipt-order-container">
    <el-card>
      <el-row type="flex" justify="space-between">
        <el-col :span="4">
          <div class="title">
            <h6>收货单详情</h6>
          </div>
        </el-col>
        <el-col :span="4">
          <div>
            <h6>状态：待核验</h6>
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
              <h6>发货方：红烧猪蹄</h6>
            </el-col>
            <el-col :span="8">
              <h6>收货方：梅菜扣肉</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="8">
              <h6>货号：梅菜扣肉</h6>
            </el-col>
            <el-col :span="8">
              <h6>发货负责人：烧鸡翅</h6>
            </el-col>
            <el-col :span="8">
              <h6>联系方式：123456789</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="24">
              <h6>收货地址：广州市海珠区云顶同创汇二期</h6>
            </el-col>
          </el-row>
          <el-row type="flex" style="padding-bottom: 10px">
            <el-col :span="8">
              <h6>物流方式：货拉拉</h6>
            </el-col>
            <el-col :span="8">
              <h6>发货单号：SF017532492929</h6>
            </el-col>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" style="margin-top:20px">
        <el-col :span="4" :offset="4">
          <el-radio v-model="showOnBox" :label="true">按箱号</el-radio>
          <el-radio v-model="showOnBox" :label="false">按总列表</el-radio>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row" v-if="showOnBox">
        <el-col :span="24">
          <color-size-box-table :vdata="data" :colorSizeEntries="colorSizeEntries" :readOnly="false" />
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row" v-if="!showOnBox">
        <el-col :span="24">
          <color-size-table :data="summaryData" :readOnly="false" />
        </el-col>
      </el-row>
      <el-row type="flex" style="margin-top:20px">
        <el-col :span="8" :offset="4">
          <el-row type="flex">
            <h6>有无退货：</h6>
            <el-radio v-model="returned" :label="true">有退货</el-radio>
            <el-radio v-model="returned" :label="false">无退货</el-radio>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="8" :offset="2">
          <h6>发货单：KY1000000001</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50">
        <template>
          <el-col :span="4">
            <el-button class="material-btn" @click="onSubmit">确认收货</el-button>
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

  export default {
    name: 'ReceiptOrderForm',
    props: {
      //收货单id
      id: {
        require: true
      }
    },
    components: {
      ColorSizeBoxTable,
      ColorSizeTable,
    },
    computed: {
      //箱总数
      boxAmount: function () {
        var amount = 0;
        this.data.forEach(entry => {
          if (entry != null) {
            entry.forEach(item => {
              let num = parseFloat(item.quantity);
              if (!Number.isNaN(num)) {
                amount += num;
              }
            });
          }
        });
        return amount;
      },
      //总列表总数
      summaryAmount: function () {
        var amount = 0;
        if (this.summaryData != null) {
          this.summaryData.forEach(entry => {
            let num = parseFloat(entry.quantity);
            if (!Number.isNaN(num)) {
              amount += num;
            }
          });
        }
        return amount;
      },
      //下单数
      orderAmount: function () {
        var amount = 0;
        if (this.colorSizeEntries != null) {
          this.colorSizeEntries.forEach(entry => {
            let num = parseFloat(entry.quantity);
            if (!Number.isNaN(num)) {
              amount += num;
            }
          });
        }
        return amount;
      },
    },
    methods: {
      onSubmit() {
        //校验数量与订单差异
        let num = this.showOnBox ? this.boxAmount : this.summaryAmount;
        if (num != this.orderAmount) {
          this.$confirm('收货数与发货总数不一致，是否创建收货单？创建后不允许修改', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            this._onSubmit();
          }).catch(() => {

          });
        }
      },
      async _onSubmit() {
        this.onReturnedMessage();
      },
      //提示是否创建退货单
      onReturnedMessage() {
        this.$confirm('是否马上创建退货单？', '提示', {
          confirmButtonText: '马上创建',
          cancelButtonText: '下次再说',
          type: 'info'
        }).then(() => {

        }).catch(() => {

        });
      }
    },
    data() {
      return {
        data: [],
        summaryData: [],
        colorSizeEntries: [],
        showOnBox: false,
        returned: false
      }
    },
    created() {
      if (this.$route.params.shippingOrder == null) {
        this.$router.go(-1);
      } else {
        this.$set(this, 'data', JSON.parse(JSON.stringify([this.$route.params.shippingOrder.colorSizeEntries])));
        this.$set(this, 'colorSizeEntries', JSON.parse(JSON.stringify(this.$route.params.shippingOrder
          .colorSizeEntries)));
        this.$set(this, 'summaryData', JSON.parse(JSON.stringify(this.$route.params.shippingOrder.colorSizeEntries)));
      }
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

  .receipt-order-container h6 {
    font-size: 14px;
    color: #606266;
  }

  .receipt-order-container {
    padding-bottom: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 150px;
    height: 35px;
  }

</style>
