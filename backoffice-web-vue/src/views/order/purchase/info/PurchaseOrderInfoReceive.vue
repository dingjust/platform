<template>
  <div class="info-receive-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">收货单({{receiveOrderStatus}})</h6>
      </div>
    </el-row>
    <el-row class="info-receive-row">
      <form-label label="合作对象" />
    </el-row>
    <el-form :disabled="!isBrand()">
      <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">发货人</h6>
            <el-input placeholder="输入品牌名" v-model="form.consignorName" size="mini"></el-input>
          </el-row>
        </el-col>
        <el-col :span="8">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">联系方式</h6>
            <el-input placeholder="输入手机号" v-model="form.consignorPhone" size="mini"></el-input>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">发货方式</h6>
            <el-select v-model="form.consignment.carrierDetails.code" placeholder="请选择"
              :disabled="form.isOfflineConsignment">
              <el-option v-for="item in carriers" :key="item.code" :label="item.name" :value="item.code"></el-option>
            </el-select>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">发货单号</h6>
            <el-input placeholder="货运单号" v-model="form.consignment.trackingID" size="mini"
              :disabled="form.isOfflineConsignment"></el-input>
          </el-row>
        </el-col>
        <el-col :span="8">
          <el-checkbox v-model="form.isOfflineConsignment" size="mini" class="checkbox-text">线下物流（勾选后无需填写发货方式和单号）
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
            <el-input placeholder="输入名称" v-model="form.consigneeName" size="mini"></el-input>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">联系方式</h6>
            <el-input placeholder="输入方式" v-model="form.consigneePhone" size="mini"></el-input>
          </el-row>
        </el-col>
        <el-col :span="12">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">详细地址</h6>
            <el-input placeholder="输入收货地址" v-model="form.consigneeAddress" size="mini"></el-input>
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
            <el-input placeholder="输入品牌名称" v-model="form.brand" size="mini"></el-input>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">产品款号</h6>
            <el-input placeholder="输入款号" v-model="form.skuID" size="mini"></el-input>
          </el-row>
        </el-col>
      </el-row>
      <table cellspacing="2" width="100%" :height="(form.entries.length+1)*50" class="order-table">
        <tr class="order-table-th_row">
          <td style="width:40px">颜色</td>
          <template v-for="item in sizes">
            <th>{{item.name}}</th>
          </template>
          <th>数量小计</th>
        </tr>
        <template v-for="(sizeArray,rowIndex) in form.entries">
          <tr>
            <td>{{sizeArray[0].color}}</td>
            <template v-for="(size,index) in sizeArray">
              <td style="width:80px">
                <el-input class="order-table-input" type="number" v-model="size.quantity" @mousewheel.native.prevent>
                </el-input>
              </td>
            </template>
            <td style="width:100px">{{countRowAmount(rowIndex)}}</td>
          </tr>
        </template>
        <tr>
          <td>合计</td>
          <td :colspan="getColspanLength()+1">{{totalAmout}}</td>
        </tr>
        <tr>
          <td>备注</td>
          <td :colspan="getColspanLength()+1" class="order-table-input" style="width:120px">
            <el-input v-model="form.remarks" placeholder="输入"></el-input>
          </td>
        </tr>
        <tr>
          <td>退料</td>
          <td :colspan="getColspanLength()+1" class="order-table-input" style="width:120px">
            <el-input v-model="form.withdrawalQuality" placeholder="输入"></el-input>
          </td>
        </tr>
        <tr>
          <td>残次品数</td>
          <td :colspan="getColspanLength()+1" class="order-table-input" style="width:120px">
            <el-input v-model="form.defectiveQuality" placeholder="输入"></el-input>
          </td>
        </tr>
      </table>
    </el-form>
    <el-row type="flex" justify="end" class="info-receive-row">
      <h6 class="order-table-info">品牌跟单员： {{slotData.brandOperator!=null?slotData.brandOperator.name:'未指定'}}</h6>
      <h6 class="order-table-info">工厂跟单员： {{slotData.factoryOperator!=null?slotData.factoryOperator.name:'未指定'}}</h6>
      <h6 class="order-table-info">
        发货日期： {{slotData
        .creationtime | timestampToTime}}
      </h6>
    </el-row>
    <el-row type="flex" justify="center" class="info-receive-row">
      <template v-if="isBrand()">
        <el-button class="info-receive-submit" v-if="showSaveBtn" @click="onSave">保存并退出</el-button>
        <el-button class="info-receive-submit" :disabled="!showCommitBtn" @click="onCommit">确认完成收货</el-button>
        <el-button class="info-receive-submit"
          v-if="hasDeliveryOrders&&slotData.deliveryOrders[0].status=='PENDING_CONFIRM'" @click="onWithdraw">撤回
        </el-button>
      </template>
      <template v-if="isFactory()">
        <el-button class="info-receive-refuse"
          v-if="hasDeliveryOrders&&slotData.deliveryOrders[0].status=='PENDING_CONFIRM'" @click="onReject">拒绝
        </el-button>
        <el-button class="info-receive-submit"
          v-if="hasDeliveryOrders&&slotData.deliveryOrders[0].status=='PENDING_CONFIRM'" @click="onAccept">确认
        </el-button>
      </template>
    </el-row>
  </div>
</template>

<script>
  import OrdersInfoItem from "@/components/custom/OrdersInfoItem";
  import FormLabel from "@/components/custom/FormLabel";

  export default {
    name: "PurchaseOrderInfoReceive",
    props: ["slotData"],
    components: {
      OrdersInfoItem,
      FormLabel
    },
    mixins: [],
    computed: {
      sizes: function () {
        var sizes = [];
        this.slotData.entries.forEach(element => {
          sizes.push(element.product.size);
        });
        const res = new Map();
        var result = sizes.filter((size) => !res.has(size.code) && res.set(size.code, 1));
        return result.sort((o1, o2) => o1.sequence - o2.sequence);
      },
      colors: function () {
        var colors = new Set([]);
        this.slotData.entries.forEach(element => {
          colors.add(element.product.color.name);
        });
        return colors;
      },
      totalAmout: function () {
        var totalAmount = 0;
        this.form.entries.forEach(sizeArray => {
          sizeArray.forEach(item => {
            if (item.quantity != "") {
              totalAmount += parseInt(item.quantity);
            }
          });
        });
        return totalAmount;
      },
      hasDeliveryOrders: function () {
        return (
          this.slotData.deliveryOrders != null &&
          this.slotData.deliveryOrders.length != 0
        );
      },
      showSaveBtn: function () {
        if (
          this.slotData.deliveryOrders != null &&
          this.slotData.deliveryOrders.length != 0
        ) {
          return this.slotData.deliveryOrders[0].status == "UNCOMMITTED" || this.slotData.deliveryOrders[0].status ==
            'REJECTED';
        } else {
          return true;
        }
      },
      showCommitBtn: function () {
        if (
          this.slotData.deliveryOrders == null ||
          this.slotData.deliveryOrders.length == 0
        ) {
          // return this.slotData.status == 'OUT_OF_STORE';
          return false;
        } else {
          return (
            this.slotData.deliveryOrders[0].status == "UNCOMMITTED" ||
            this.slotData.deliveryOrders[0].status == "REJECTED"
          );
        }
      },
      receiveOrderStatus: function () {
        if (
          this.slotData.deliveryOrders == null ||
          this.slotData.deliveryOrders.length == 0
        ) {
          return "";
        } else {
          return this.getEnum(
            "RemarksOrderStatus",
            this.slotData.deliveryOrders[0].status
          );
        }
      }
    },
    methods: {
      countRowAmount(rowIndex) {
        var amount = 0;
        this.form.entries[rowIndex].forEach(element => {
          if (element.quantity != "") {
            let quantity = parseInt(element.quantity);
            amount = amount + quantity;
          }
        });
        return amount;
      },
      getColspanLength() {
        return this.sizes.length + 1;
      },
      async onSubmit() {
        //组合订单行参数
        var entries = [];
        this.form.entries.forEach(variants => {
          variants.forEach(variant => {
            if (variant.quantity != "" && variant.quantity > 0) {
              let item = {
                quantity: variant.quantity,
                color: variant.color,
                size: variant.size
              };
              entries.push(item);
            }
          });
        });
        //表单参数
        var form = {
          withdrawalQuality: this.form.withdrawalQuality,
          defectiveQuality: this.form.defectiveQuality,
          consignorName: this.form.consignorName,
          consignorPhone: this.form.consignorPhone,
          consigneeName: this.form.consigneeName,
          consigneePhone: this.form.consigneePhone,
          consigneeAddress: this.form.consigneeAddress,
          isOfflineConsignment: this.form.isOfflineConsignment,
          entries: entries,
          remarks: this.form.remarks,
          skuID: this.form.skuID,
          brand: this.form.brand,
          consignment: this.form.consignment
        };

        const url = this.apis().createDeliveryOrder(this.slotData.code);
        const result = await this.$http.post(url, form);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success("创建成功");
        //刷新数据
        this.refreshData();
      },
      async refreshData() {
        const url = this.apis().getPurchaseOrder(this.slotData.code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        //跟新slotData
        this.$set(this.slotData, "deliveryOrders", result.deliveryOrders);
        this.$set(this.slotData, "status", result.status);
        // this.$emit("afterCreate");
      },
      getVariant(color, size, entries) {
        var result = entries.filter(
          item => item.color == color && item.size == size
        );
        if (result.length != 0) {
          return result[0];
        } else {
          return null;
        }
      },
      async onCommit() {
        //组合订单行参数
        var entries = [];
        this.form.entries.forEach(variants => {
          variants.forEach(variant => {
            if (variant.quantity != "" && variant.quantity > 0) {
              entries.push(variant);
            }
          });
        });
        //表单参数
        var form = {
          id: this.form.id,
          code: this.form.code,
          withdrawalQuality: this.form.withdrawalQuality,
          defectiveQuality: this.form.defectiveQuality,
          consignorName: this.form.consignorName,
          consignorPhone: this.form.consignorPhone,
          consigneeName: this.form.consigneeName,
          consigneePhone: this.form.consigneePhone,
          consigneeAddress: this.form.consigneeAddress,
          isOfflineConsignment: this.form.isOfflineConsignment,
          entries: entries,
          remarks: this.form.remarks,
          skuID: this.form.skuID,
          brand: this.form.brand,
          consignment: this.form.consignment
        };
        var url = "";
        var result = "";
        if (
          this.slotData.deliveryOrders == null ||
          this.slotData.deliveryOrders.length == 0
        ) {
          url = this.apis().createAndCommitDeliveryOrder(this.slotData.code);
          result = await this.$http.post(url, form);
        } else {
          url = this.apis().commitDeliveryOrder();
          result = await this.$http.put(url, form);
        }

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success("保存成功");
        //刷新数据
        this.refreshData();
      },
      async getCarriers() {
        const url = this.apis().getCarriers();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.carriers = result;
      },
      onSave() {
        if (this.hasDeliveryOrders) {
          this.onUpdate();
        } else {
          this.onSubmit();
        }
      },
      async onUpdate() {
        //组合订单行参数
        var entries = [];
        this.form.entries.forEach(variants => {
          variants.forEach(variant => {
            if (variant.quantity != "" && variant.quantity > 0) {
              entries.push(variant);
            }
          });
        });
        //表单参数
        var form = {
          id: this.form.id,
          code: this.form.code,
          withdrawalQuality: this.form.withdrawalQuality,
          defectiveQuality: this.form.defectiveQuality,
          consignorName: this.form.consignorName,
          consignorPhone: this.form.consignorPhone,
          consigneeName: this.form.consigneeName,
          consigneePhone: this.form.consigneePhone,
          consigneeAddress: this.form.consigneeAddress,
          isOfflineConsignment: this.form.isOfflineConsignment,
          entries: entries,
          remarks: this.form.remarks,
          skuID: this.form.skuID,
          brand: this.form.brand,
          consignment: this.form.consignment
        };

        const url = this.apis().updateDeliveryOrder();
        const result = await this.$http.put(url, form);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success("保存成功");
        //刷新数据
        this.refreshData();
      },
      async onWithdraw() {
        const url = this.apis().withdrawDeliveryOrder(this.form.code);
        const result = await this.$http.put(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success("撤回成功");
        //刷新数据
        this.refreshData();
      },
      async onAccept() {
        const url = this.apis().confirmDeliveryOrder(this.form.code);
        const result = await this.$http.put(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success("确认成功");
        //刷新数据
        this.refreshData();
      },
      async onReject() {
        const url = this.apis().rejectDeliveryOrder(this.form.code);
        const result = await this.$http.put(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.$message.success("拒绝成功");
        //刷新数据
        this.refreshData();
      },
      initForm() {
        if (
          this.slotData.deliveryOrders != null &&
          this.slotData.deliveryOrders.length != 0
        ) {
          this.form.id = this.slotData.deliveryOrders[0].id;
          this.form.code = this.slotData.deliveryOrders[0].code;
          this.form.consignorName = this.slotData.deliveryOrders[0].consignorName;
          this.form.consignorPhone = this.slotData.deliveryOrders[0].consignorPhone;
          this.form.isOfflineConsignment = this.slotData.deliveryOrders[0].isOfflineConsignment;
          this.form.consigneeName = this.slotData.deliveryOrders[0].consigneeName;
          this.form.consigneePhone = this.slotData.deliveryOrders[0].consigneePhone;
          this.form.consigneeAddress = this.slotData.deliveryOrders[0].consigneeAddress;
          this.form.brand = this.slotData.deliveryOrders[0].brand;
          this.form.skuID = this.slotData.deliveryOrders[0].skuID;
          this.form.remarks = this.slotData.deliveryOrders[0].remarks;
          this.form.defectiveQuality = this.slotData.deliveryOrders[0].defectiveQuality;
          this.form.withdrawalQuality = this.slotData.deliveryOrders[0].withdrawalQuality;
          if (this.form.isOfflineConsignment) {
            this.form.consignment = {
              trackingID: "",
              carrierDetails: {
                name: "",
                code: ""
              }
            };
          } else {
            this.form.consignment = this.slotData.deliveryOrders[0].consignment;
          }
        } else {
          var lastShippingOrders = this.slotData.shippingOrders[
            this.slotData.shippingOrders.length - 1
          ];

          this.form.consignorName = lastShippingOrders.consignorName;
          this.form.consignorPhone = lastShippingOrders.consignorPhone;
          this.form.isOfflineConsignment =
            lastShippingOrders.isOfflineConsignment;
          this.form.consigneeName = lastShippingOrders.consigneeName;
          this.form.consigneePhone = lastShippingOrders.consigneePhone;
          this.form.consigneeAddress = lastShippingOrders.consigneeAddress;
          this.form.brand = lastShippingOrders.brand;
          this.form.skuID = lastShippingOrders.skuID;
          this.form.remarks = lastShippingOrders.remarks;
          this.form.defectiveQuality = lastShippingOrders.defectiveQuality;
          this.form.withdrawalQuality = lastShippingOrders.withdrawalQuality;
          if (this.form.isOfflineConsignment) {
            this.form.consignment = {
              trackingID: "",
              carrierDetails: {
                name: "",
                code: ""
              }
            };
          } else {
            this.form.consignment = lastShippingOrders.consignment;
          }
        }
      }
    },
    data() {
      return {
        receiveFormVisible: false,
        activeForm: "1",
        carriers: [],
        form: {
          code: "",
          id: "",
          consignorName: "",
          consignorPhone: "",
          isOfflineConsignment: false,
          consigneeName: "",
          consigneePhone: "",
          consigneeAddress: "",
          brand: "",
          skuID: "",
          remarks: "",
          defectiveQuality: "",
          withdrawalQuality: "",
          consignment: {
            trackingID: "",
            carrierDetails: {
              name: "",
              code: ""
            }
          },
          entries: []
        }
      };
    },
    created() {
      this.getCarriers();
      //初始化表格
      this.form.entries = [];
      this.colors.forEach(color => {
        var sizeArray = [];
        this.sizes.forEach(size => {
          if (
            this.slotData.deliveryOrders == null ||
            this.slotData.deliveryOrders.length == 0
          ) {
            sizeArray.push({
              size: size.name,
              color: color,
              quantity: ""
            });
          } else {
            let variant = this.getVariant(
              color,
              size.name,
              this.slotData.deliveryOrders[0].entries
            );
            if (variant != null) {
              sizeArray.push(variant);
            } else {
              sizeArray.push({
                size: size.name,
                color: color,
                quantity: ""
              });
            }
          }
        });
        this.form.entries.push(sizeArray);
      });
    },
    watch: {
      colors: {
        handler(val, oldVal) {
          this.form.entries = [];
          this.colors.forEach(color => {
            var sizeArray = [];
            this.sizes.forEach(size => {
              if (
                this.slotData.deliveryOrders == null ||
                this.slotData.deliveryOrders.length == 0
              ) {
                sizeArray.push({
                  size: size.name,
                  color: color,
                  quantity: ""
                });
              } else {
                let variant = this.getVariant(
                  color,
                  size.name,
                  this.slotData.deliveryOrders[0].entries
                );
                if (variant != null) {
                  sizeArray.push(variant);
                } else {
                  sizeArray.push({
                    size: size.name,
                    color: color,
                    quantity: ""
                  });
                }
              }
            });
            this.form.entries.push(sizeArray);
          });
        },
        deep: true
      },
      sizes: {
        handler(val, oldVal) {
          this.form.entries = [];
          this.colors.forEach(color => {
            var sizeArray = [];
            this.sizes.forEach(size => {
              if (
                this.slotData.deliveryOrders == null ||
                this.slotData.deliveryOrders.length == 0
              ) {
                sizeArray.push({
                  size: size.name,
                  color: color,
                  quantity: ""
                });
              } else {
                let variant = this.getVariant(
                  color,
                  size.name,
                  this.slotData.deliveryOrders[0].entries
                );
                if (variant != null) {
                  sizeArray.push(variant);
                } else {
                  sizeArray.push({
                    size: size,
                    color: color,
                    quantity: ""
                  });
                }
              }
            });
            this.form.entries.push(sizeArray);
          });
        },
        deep: true
      },
      slotData: {
        handler(val, oldVal) {
          this.initForm();
        },
        deep: true
      }
    },
    mounted() {
      this.initForm();
    }
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
    text-align: center;
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

  .info-receive-refuse {
    /* background-color: red;
    border-color: red;
    color: #fff; */
    width: 150px;
  }

</style>
