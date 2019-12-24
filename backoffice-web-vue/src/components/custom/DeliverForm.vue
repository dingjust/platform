<template>
  <div class="info-receive-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">创建发货单</h6>
      </div>
    </el-row>
    <el-tabs v-model="activeForm" type="card">
      <template v-for="(item,index) in mockData">
        <el-tab-pane :label="item.code" :name="item.code">
          <el-row class="info-receive-row">
            <form-label label="合作对象" />
          </el-row>
          <!-- <el-form :disabled="item.code!=null"> -->
          <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
            <el-col :span="6">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">发货人</h6>
                <el-input placeholder="输入品牌名" v-model="form.brandName" size="mini">
                </el-input>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">联系方式</h6>
                <el-input placeholder="输入手机号" v-model="form.phone" size="mini">
                  <el-select v-model="form.phone" slot="append" placeholder="请选择">
                    <el-option label="123" value="123"></el-option>
                    <el-option label="1234" value="1234"></el-option>
                    <el-option label="1324" value="1324"></el-option>
                  </el-select>
                </el-input>
              </el-row>
            </el-col>
          </el-row>
          <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
            <el-col :span="6">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">发货方式</h6>
                <el-input placeholder="输入方式" v-model="form.deliverWay" size="mini" :disabled="form.offlinereceive">
                </el-input>
              </el-row>
            </el-col>
            <el-col :span="6">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">发货单号</h6>
                <el-input placeholder="货运单号" v-model="form.receiveCode" size="mini" :disabled="form.offlinereceive">
                </el-input>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-checkbox v-model="form.offlinereceive" size='mini' class="checkbox-text">线下物流（勾选后无需填写发货方式和单号）
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
                <el-input placeholder="输入名称" v-model="form.receiveName" size="mini">
                </el-input>
              </el-row>
            </el-col>
            <el-col :span="6">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">联系方式</h6>
                <el-input placeholder="输入方式" v-model="form.receivePhone" size="mini">
                </el-input>
              </el-row>
            </el-col>
            <el-col :span="12">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">详细地址</h6>
                <el-input placeholder="输入收货地址" v-model="form.receiveAddress" size="mini">
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
                <el-input placeholder="输入品牌名称" v-model="form.productBrandName" size="mini">
                </el-input>
              </el-row>
            </el-col>
            <el-col :span="6">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">产品款号</h6>
                <el-input placeholder="输入款号" v-model="form.productSKU" size="mini">
                </el-input>
              </el-row>
            </el-col>
          </el-row>
          <table cellspacing="2" width="100%" :height="(form.entries.length+1)*50" class="order-table">
            <tr class="order-table-th_row">
              <td style="width:40px">颜色</td>
              <template v-for="item in sizes">
                <th>{{item}}</th>
              </template>
              <th>数量小计</th>
            </tr>
            <template v-for="(sizeArray,rowIndex) in form.entries">
              <tr>
                <td>{{sizeArray[0].color}}</td>
                <template v-for="(size,index) in sizeArray">
                  <td style="width:80px">
                    <el-input class="order-table-input" type="number" @mousewheel.native.prevent v-model="size.num" :min="1"
                      placeholder="输入">
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
          <el-row type="flex" justify="end" class="info-receive-row">
            <h6 class="order-table-info">品牌跟单员： ***</h6>
            <h6 class="order-table-info">工厂跟单员： ***</h6>
            <h6 class="order-table-info">发货日期： 2019-7-19</h6>
          </el-row>
          <el-row type="flex" justify="center" class="info-receive-row">
            <el-button class="info-receive-submit" @click="onSubmit">确认创建</el-button>
          </el-row>
          <!-- </el-form> -->
        </el-tab-pane>
      </template>
    </el-tabs>
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
        var sizes = new Set([]);
        this.slotData.entries.forEach(element => {
          sizes.add(element.product.size.name);
        });
        return sizes;
      },
      colors: function () {
        var colors = new Set([]);
        this.slotData.entries.forEach(element => {
          colors.add(element.product.color.name);
        });
        return colors;
      },
      // SizesNum: {
      //   get() {
      //     return this.sizesForm;
      //   },
      //   set(val) {
      //     console.log(val);
      //     this.sizesForm = val;
      //   }
      // }
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
        return this.colors.size + 2;
      },
      onSubmit() {
        console.log(this.form);
      }
    },
    data() {
      return {
        receiveFormVisible: false,
        activeForm: '1',
        mockData: [{
          code: '1',
          brandName: "啊是大",
          phone: "13268002017",
          receiveName: "撒旦解决了",
          receiveCode: "0100203002",
          offlinereceive: false,
          receiveName: "三空间",
          receivePhone: "19299992",
          receiveAddress: "我去饿",
          productBrandName: "请问",
          productSKU: "K010000",
          remarks: "乐扣乐扣",
          imperfectionsNum: '12',
          returnNum: '12',
          entries: []
        }, {
          code: '2',
          brandName: "啊是大",
          phone: "13268002017",
          receiveName: "撒旦解决了",
          receiveCode: "0100203002",
          offlinereceive: false,
          receiveName: "三空间",
          receivePhone: "19299992",
          receiveAddress: "我去饿",
          productBrandName: "请问",
          productSKU: "K010000",
          remarks: "乐扣乐扣",
          imperfectionsNum: '12',
          returnNum: '12',
          entries: []
        }, {
          code: '3',
          brandName: "啊是大",
          phone: "13268002017",
          receiveName: "撒旦解决了",
          receiveCode: "0100203002",
          offlinereceive: false,
          receiveName: "三空间",
          receivePhone: "19299992",
          receiveAddress: "我去饿",
          productBrandName: "请问",
          productSKU: "K010000",
          remarks: "乐扣乐扣",
          imperfectionsNum: '12',
          returnNum: '12',
          entries: []
        }],
        form: {
          brandName: "",
          phone: "",
          receiveName: "",
          receiveCode: "",
          offlinereceive: false,
          receiveName: "",
          receivePhone: "",
          receiveAddress: "",
          productBrandName: "",
          productSKU: "",
          remarks: "",
          imperfectionsNum: '',
          returnNum: '',
          deliverWay: '',
          entries: []
        },
      }
    },
    created() {
      //初始化表格
      this.form.entries = [];
      this.colors.forEach(color => {
        var sizeArray = [];
        this.sizes.forEach(size => {
          sizeArray.push({
            'size': size,
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
                'size': size,
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
                'size': size,
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
