<template>
  <div class="info-receive-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">创建发货单</h6>
      </div>
    </el-row>
    <el-row class="info-receive-row">
      <form-label label="合作对象" />
    </el-row>
    <!-- <el-form :disabled="item.code!=null"> -->
    <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
      <el-col :span="6">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">发货人</h6>
          <el-input placeholder="输入品牌名" v-model="form.consignorName" size="mini">
          </el-input>
        </el-row>
      </el-col>
      <el-col :span="8">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">联系方式</h6>
          <el-input placeholder="输入手机号" v-model="form.consignorPhone" size="mini">
          </el-input>
        </el-row>
      </el-col>
    </el-row>
    <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
      <el-col :span="6">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">发货方式</h6>
          <el-select v-model="form.consignment.carrierDetails.code" placeholder="请选择"
            :disabled="form.isOfflineConsignment">
            <el-option v-for="item in carriers" :key="item.code" :label="item.name" :value="item.code">
            </el-option>
          </el-select>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">发货单号</h6>
          <el-input placeholder="货运单号" v-model="form.consignment.trackingID" size="mini"
            :disabled="form.isOfflineConsignment">
          </el-input>
        </el-row>
      </el-col>
      <el-col :span="8">
        <el-checkbox v-model="form.isOfflineConsignment" size='mini' class="checkbox-text">线下物流（勾选后无需填写发货方式和单号）
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
          <el-input placeholder="输入名称" v-model="form.consigneeName" size="mini">
          </el-input>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">联系方式</h6>
          <el-input placeholder="输入方式" v-model="form.consigneePhone" size="mini">
          </el-input>
        </el-row>
      </el-col>
      <el-col :span="12">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">详细地址</h6>
          <el-input placeholder="输入收货地址" v-model="form.consigneeAddress" size="mini">
          </el-input>
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
          <el-input placeholder="输入品牌名称" v-model="form.brand" size="mini">
          </el-input>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">产品款号</h6>
          <el-input placeholder="输入款号" v-model="form.skuID" size="mini">
          </el-input>
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
            <td style="width:80px" :key="index">
              <el-input class="order-table-input" type="number" v-model="size.num" placeholder="输入" :min="1"
                @mousewheel.native.prevent>
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
          <el-input v-model="form.returnNum" placeholder="输入"></el-input>
        </td>
      </tr>
      <tr>
        <td>残次品数</td>
        <td :colspan="getColspanLength()+1" class="order-table-input" style="width:120px">
          <el-input v-model="form.imperfectionsNum" placeholder="输入"></el-input>
        </td>
      </tr>
    </table>
    <el-row type="flex" justify="center" class="info-receive-row" v-if="isFactory()">
      <el-button class="info-receive-submit" @click="onSubmit(false)">部分发货</el-button>
      <el-button class="info-receive-submit" @click="onSubmit(true)"
        :disabled="slotData.status!='WAIT_FOR_OUT_OF_STORE'">全部发货</el-button>
    </el-row>
    <!-- </el-form> -->
  </div>
</template>

<script>
  import OrdersInfoItem from '@/components/custom/OrdersInfoItem';
  import FormLabel from '@/components/custom/FormLabel';

  export default {
    name: 'PurchaseOrderInfoDeliver',
    props: ['slotData'],
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
            if (item.num != '') {
              totalAmount += parseInt(item.num);
            }
          })
        });
        return totalAmount;
      }
    },
    methods: {
      countRowAmount(rowIndex) {
        var amount = 0;
        this.form.entries[rowIndex].forEach(element => {
          if (element.num != '') {
            let num = parseInt(element.num);
            amount = amount + num;
          }
        });
        return amount;
      },
      getColspanLength() {
        return this.sizes.length + 1;
      },
      async onSubmit(isAll) {
        //组合订单行参数
        var entries = [];
        this.form.entries.forEach(variants => {
          variants.forEach(variant => {
            if (variant.num != '' && variant.num > 0) {
              let item = {
                quantity: variant.num,
                color: variant.color,
                size: variant.size
              }
              entries.push(item);
            }
          })
        });
        //表单参数
        var form = {
          withdrawalQuality: this.form.returnNum,
          defectiveQuality: this.form.imperfectionsNum,
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
        var result;
        if (isAll) {
          const url = this.apis().confirmShipping(this.slotData.code);
          result = await this.$http.put(url, form);
        } else {
          const url = this.apis().createShippingOrder(this.slotData.code);
          result = await this.$http.post(url, form);
        }
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('创建成功');
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
        this.$set(this.slotData, 'shippingOrders', result.shippingOrders);
        this.$emit('afterCreate');
      },
      async getCarriers() {
        const url = this.apis().getCarriers();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.carriers = result;
      }
    },
    data() {
      return {
        receiveFormVisible: false,
        activeForm: '1',
        mockData: [],
        carriers: [],
        form: {
          consignorName: this.$store.getters.currentUser.username,
          consignorPhone: this.$store.getters.currentUser.mobileNumber,
          isOfflineConsignment: true,
          consigneeName: this.slotData.deliveryAddress.fullname,
          consigneePhone: this.slotData.deliveryAddress.cellphone,
          consigneeAddress: this.slotData.deliveryAddress.details,
          brand: this.slotData.product.brand,
          skuID: this.slotData.product.skuID,
          remarks: "",
          imperfectionsNum: '',
          returnNum: '',
          consignment: {
            trackingID: '',
            carrierDetails: {
              name: '',
              code: ''
            },
          },
          entries: []
        },
      }
    },
    created() {
      this.getCarriers();
      //初始化表格
      this.form.entries = [];
      this.colors.forEach(color => {
        var sizeArray = [];
        this.sizes.forEach(size => {
          sizeArray.push({
            'size': size.name,
            'color': color,
            'num': '',
          })
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
              sizeArray.push({
                'size': size.name,
                'color': color,
                'num': '',
              })
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
              sizeArray.push({
                'size': size.name,
                'color': color,
                'num': '',
              })
            });
            this.form.entries.push(sizeArray);
          });
        },
        deep: true
      }
    },
    mounted() {}
  }

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
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
  }

  .info-receive-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
  }

</style>
