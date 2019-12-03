<template>
  <div class="info-deliver-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">创建发货单</h6>
      </div>
    </el-row>
    <el-row class="info-deliver-row">
      <form-label label="合作对象" />
    </el-row>
    <el-row class="info-deliver-row" type="flex" justify="start" align="middle" :gutter="20">
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
    <el-row class="info-deliver-row" type="flex" justify="start" align="middle" :gutter="20">
      <el-col :span="6">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">发货方式</h6>
          <el-input placeholder="输入方式" v-model="form.deliverName" size="mini" :disabled="form.offlineDeliver">
          </el-input>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">发货单号</h6>
          <el-input placeholder="货运单号" v-model="form.deliverCode" size="mini" :disabled="form.offlineDeliver">
          </el-input>
        </el-row>
      </el-col>
      <el-col :span="8">
        <el-checkbox v-model="form.offlineDeliver" size='mini' class="checkbox-text">线下物流（勾选后无需填写发货方式和单号）</el-checkbox>
      </el-col>
    </el-row>
    <el-row class="info-deliver-row">
      <form-label label="收货信息" />
    </el-row>
    <el-row class="info-deliver-row" type="flex" justify="start" align="middle" :gutter="20">
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
    <el-row class="info-deliver-row">
      <form-label label="产品信息" />
    </el-row>
    <el-row class="info-deliver-row" type="flex" justify="start" align="middle" :gutter="20">
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
    <table cellspacing="2" width="100%" :height="sizesForm.length*50" class="order-table">
      <tr class="order-table-th_row">
        <template v-for="item in sizes">
          <th>{{item}}</th>
        </template>
        <th>数量小计</th>
        <th>颜色</th>
      </tr>
      <template v-for="(row,rowIndex) in sizesForm">
        <tr>
          <template v-for="(item,index) in sizes">
            <td style="width:80px">
              <el-input class="order-table-input" type="number" v-model="sizesForm[rowIndex][index]" placeholder="输入"
                @mousewheel.native.prevent>
              </el-input>
            </td>
          </template>
          <td style="width:100px">{{countRowAmount(rowIndex)}}</td>
          <td>
            <el-checkbox-group v-model="colorSelect[rowIndex]">
              <template v-for="color in colors">
                <el-checkbox :label="color"></el-checkbox>
              </template>
            </el-checkbox-group>
          </td>
          <td class="order-table-btn" style="border: 0px solid #ffffff;">
            <el-button type="text" @click="removeRow(rowIndex)" size="mini">删除</el-button>
          </td>
        </tr>
      </template>
      <tr>
        <td :colspan="getColspanLength()">
          <el-button type="info" icon="el-icon-plus" class="order-table-btn_add" size="mini" circle @click="addRow">
          </el-button>
        </td>
      </tr>
      <tr>
        <td>合计</td>
        <td :colspan="getColspanLength()-1">{{totalAmout}}</td>
      </tr>
      <tr>
        <td>备注</td>
        <td :colspan="getColspanLength()-1" class="order-table-input" style="width:120px">
          <el-input v-model="form.remarks" placeholder="输入"></el-input>
        </td>
      </tr>
      <tr>
        <td>退料</td>
        <td :colspan="getColspanLength()-1" class="order-table-input" style="width:120px">
          <el-input v-model="form.returnNum" placeholder="输入"></el-input>
        </td>
      </tr>
      <tr>
        <td>残次品数</td>
        <td :colspan="getColspanLength()-1" class="order-table-input" style="width:120px">
          <el-input v-model="form.imperfectionsNum" placeholder="输入"></el-input>
        </td>
      </tr>
    </table>
    <el-row type="flex" justify="end" class="info-deliver-row">
      <h6 class="order-table-info">品牌跟单员： 杨建</h6>
      <h6 class="order-table-info">工厂跟单员： 刘少立</h6>
      <h6 class="order-table-info">发货日期： 2019-7-19</h6>
    </el-row>
    <el-row type="flex" justify="center" class="info-deliver-row">
      <el-button class="info-deliver-submit" @click="onSubmit()">确认创建</el-button>
    </el-row>
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
        this.sizesForm.forEach(size => {
          size.forEach(num => {
            if (num != '') {
              totalAmount += parseInt(num);
            }
          })
        });
        return totalAmount;
      }
    },
    methods: {
      countRowAmount(rowIndex) {
        var amount = 0;
        this.sizesForm[rowIndex].forEach(element => {
          if (element != '') {
            let num = parseInt(element);
            amount = amount + num;
          }
        });
        return amount;
      },
      getColspanLength() {
        return this.colors.size + 2;
      },
      addRow() {
        var sizesNum = [];
        this.sizes.forEach(element => {
          sizesNum.push('');
        });
        this.sizesForm.push(sizesNum);
        //添加颜色选择行
        this.colorSelect.push([]);
      },
      removeRow(rowIndex) {
        this.sizesForm.splice(rowIndex, 1);
        //添加颜色选择行
        this.colorSelect.splice(rowIndex, 1);
      },
      onSubmit() {

      }
    },
    data() {
      return {
        deliverFormVisible: false,
        form: {
          brandName: "",
          phone: "",
          deliverName: "",
          deliverCode: "",
          offlineDeliver: false,
          receiveName: "",
          receivePhone: "",
          receiveAddress: "",
          productBrandName: "",
          productSKU: "",
          remarks: "",
          imperfectionsNum: '',
          returnNum: ''
        },
        sizesForm: [
          []
        ],
        mockContact: [{
          'name': '张三',
          'phone': '13268002017'
        }, {
          'name': '张三',
          'phone': '13268002017'
        }, {
          'name': '张三',
          'phone': '13268002017'
        }],
        colorSelect: [
          []
        ]
      }
    },
    created() {

    },
    watch: {
      sizes: {
        handler(val, oldVal) {
          this.sizesForm = [];
          var sizesNum = [];
          this.sizes.forEach(element => {
            sizesNum.push('');
          });
          this.sizesForm.push(sizesNum);
        },
        deep: true
      }
    },
    mounted() {}
  }

</script>
<style>
  .info-deliver-body {
    width: 100%;
  }

  .info-deliver-row {
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

  .info-deliver-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
  }

</style>
