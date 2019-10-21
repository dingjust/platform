<template>
  <div class="info-receive-body">
    <el-row class="info-receive-row">
      <form-label label="合作对象" />
    </el-row>
    <el-form :disabled="true">
      <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">发货人</h6>
            <el-input placeholder="输入品牌名" v-model="slotData.consignorName" size="mini"></el-input>
          </el-row>
        </el-col>
        <el-col :span="8">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">联系方式</h6>
            <el-input placeholder="输入手机号" v-model="slotData.consignorPhone" size="mini"></el-input>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">发货方式</h6>
            <template v-if="slotData.consignment!=null">
              <el-input v-model="slotData.consignment.carrierDetails.name" size="mini"
                :disabled="slotData.isOfflineConsignment"></el-input>
            </template>
            <template v-else>
              <el-input size="mini" :disabled="slotData.isOfflineConsignment"></el-input>
            </template>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">发货单号</h6>
            <template v-if="slotData.consignment!=null">
              <el-input placeholder="货运单号" v-model="slotData.consignment.trackingID" size="mini"
                :disabled="slotData.isOfflineConsignment"></el-input>
            </template>
            <template v-else>
              <el-input  size="mini"
                :disabled="slotData.isOfflineConsignment"></el-input>
            </template>
          </el-row>
        </el-col>
        <el-col :span="8">
          <el-checkbox v-model="slotData.isOfflineConsignment" size="mini" class="checkbox-text">线下物流（勾选后无需填写发货方式和单号）
          </el-checkbox>
        </el-col>
      </el-row>
      <el-row class="info-receive-row">
        <form-label label="收货信息" />
      </el-row>
      <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">收货人</h6>
            <el-input placeholder="输入名称" v-model="slotData.consigneeName" size="mini"></el-input>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">联系方式</h6>
            <el-input placeholder="输入方式" v-model="slotData.consigneePhone" size="mini"></el-input>
          </el-row>
        </el-col>
        <el-col :span="12">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">详细地址</h6>
            <el-input placeholder="输入收货地址" v-model="slotData.consigneeAddress" size="mini"></el-input>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="info-receive-row">
        <form-label label="产品信息" />
      </el-row>
      <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">品牌</h6>
            <el-input placeholder="输入品牌名称" v-model="slotData.brand" size="mini"></el-input>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">产品款号</h6>
            <el-input placeholder="输入款号" v-model="slotData.skuID" size="mini"></el-input>
          </el-row>
        </el-col>
      </el-row>
      <table cellspacing="2" width="100%" :height="(slotData.entries.length+1)*50" class="order-table">
        <tr class="order-table-th_row">
          <td style="width:40px">颜色</td>
          <template v-for="item in sizes">
            <th>{{item}}</th>
          </template>
          <th>数量小计</th>
        </tr>
        <template v-for="color in colors">
          <tr>
            <td>{{color}}</td>
            <template v-for="size in sizes">
              <td style="width:80px">{{getVariant(color, size)}}</td>
            </template>
            <td style="width:100px">{{countRowAmount(color)}}</td>
          </tr>
        </template>
        <tr>
          <td>合计</td>
          <td :colspan="getColspanLength()+1">{{totalAmout}}</td>
        </tr>
        <tr>
          <td>备注</td>
          <td :colspan="getColspanLength()+1" class="order-table-input" style="width:120px">{{slotData.remarks}}</td>
        </tr>
        <tr>
          <td>退料</td>
          <td :colspan="getColspanLength()+1" class="order-table-input" style="width:120px">
            {{slotData.withdrawalQuality}}</td>
        </tr>
        <tr>
          <td>残次品数</td>
          <td :colspan="getColspanLength()+1" class="order-table-input" style="width:120px">
            {{slotData.defectiveQuality}}</td>
        </tr>
      </table>
    </el-form>
  </div>
</template>

<script>
  import OrdersInfoItem from "@/components/custom/OrdersInfoItem";
  import FormLabel from "@/components/custom/FormLabel";

  export default {
    name: "DeliverView",
    props: ["slotData"],
    components: {
      OrdersInfoItem,
      FormLabel
    },
    mixins: [],
    computed: {
      sizes: function () {
        var sizes = new Set([]);
        this.slotData.entries.forEach(element => {
          sizes.add(element.size);
        });
        return sizes;
      },
      colors: function () {
        var colors = new Set([]);
        this.slotData.entries.forEach(element => {
          colors.add(element.color);
        });
        return colors;
      },
      totalAmout: function () {
        var totalAmount = 0;
        this.slotData.entries.forEach(entry => {
          if (entry.quantity != "") {
            totalAmount += entry.quantity;
          }
        });
        return totalAmount;
      },
      consignment: function () {
        if (this.slotData.consignment == null) {
          return {};
        }
      }
    },
    methods: {
      countRowAmount(color) {
        var amount = 0;
        this.slotData.entries.forEach(element => {
          if (element.color == color && element.quantity != "") {
            let num = parseInt(element.quantity);
            amount = amount + num;
          }
        });
        return amount;
      },
      getColspanLength() {
        return this.colors.size + 2;
      },
      getVariant(color, size) {
        var result = this.slotData.entries.filter(
          item => item.color == color && item.size == size
        );
        if (result.length != 0) {
          return result[0].quantity;
        } else {
          return "";
        }
      }
    },
    data() {
      return {};
    },
    created() {
      //初始化表格
      // this.slotData.entries = [];
      // this.colors.forEach(color => {
      //   var sizeArray = [];
      //   this.sizes.forEach(size => {
      //     sizeArray.push({
      //       'size': size,
      //       'color': color,
      //       'num': '',
      //     })
      //   });
      //   this.slotData.entries.push(sizeArray);
      // });
    },
    watch: {
      colors: {
        //   handler(val, oldVal) {
        //     this.slotData.entries = [];
        //     this.colors.forEach(color => {
        //       var sizeArray = [];
        //       this.sizes.forEach(size => {
        //         sizeArray.push({
        //           'size': size,
        //           'color': color,
        //           'num': '',
        //         })
        //       });
        //       this.slotData.entries.push(sizeArray);
        //     });
        //   },
        //   deep: true
        // },
        // sizes: {
        //   handler(val, oldVal) {
        //     this.slotData.entries = [];
        //     this.colors.forEach(color => {
        //       var sizeArray = [];
        //       this.sizes.forEach(size => {
        //         sizeArray.push({
        //           'size': size,
        //           'color': color,
        //           'num': '',
        //         })
        //       });
        //       this.slotData.entries.push(sizeArray);
        //     });
        //   },
        //   deep: true
      }
    },
    mounted() {}
  };

</script>
<style>
  .info-receive-body {
    width: 100%;
  }

  .info-receive-row {
    margin-bottom: 20px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 80px;
    font-weight: bold;
    font-size: 12px;
  }

  .info-row_width50 {
    width: 50%;
  }

  .checkbox-text .el-checkbox__label {
    font-size: 12px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.45);
  }

  .order-table {
    /* width: 600px;
    height: 600px; */
    border-collapse: collapse;
    margin-bottom: 20px;
  }

  .order-table tr td,
  .order-table tr th {
    border: 1px solid rgba(0, 0, 0, 0.15);
    text-align: center;
    height: 30px;
    font-size: 10px;
  }

  /* .order-table-th_row {
    height: 80px;
  } */

  .order-table-input .el-input__inner {
    /* width: 60px; */
    border: 0px solid #fff;
  }

  .order-table-btn {
    padding-left: 10px;
    width: 30px;
  }

  .order-table-info {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.65);
    margin-left: 20px;
  }

  .order-table-btn_add {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
  }

  .info-receive-submit {
    background-color: #ffd60c;
    border-color: #ffd60c;
    color: #000;
    width: 150px;
  }

  .deliver-view-text {
    font-size: 12px;
    color: rgba(0, 0, 0, 0.65);
  }

</style>
