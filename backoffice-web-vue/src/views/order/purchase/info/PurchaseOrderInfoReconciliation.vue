<template>
  <div class="info-receive-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">创建对账单</h6>
      </div>
    </el-row>
    <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
      <el-col :span="6">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">甲方</h6>
          <el-input placeholder="输入名称" v-model="form.partyAName" size="mini">
          </el-input>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">乙方</h6>
          <el-input placeholder="输入名称" v-model="form.partyBName" size="mini">
          </el-input>
        </el-row>
      </el-col>
    </el-row>
    <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
      <el-col :span="6">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">品牌</h6>
          <el-input placeholder="输入品牌名" v-model="form.brandName" size="mini">
          </el-input>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">款号</h6>
          <el-input placeholder="输入款号" v-model="form.partyBName" size="mini">
          </el-input>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-row type="flex" align="middle">
          <h6 class="info-input-prepend">加工方式</h6>
          <el-input placeholder="输入方式" v-model="form.machiningType" size="mini">
          </el-input>
        </el-row>
      </el-col>
    </el-row>
    <table cellspacing="2" width="100%" :height="sizesForm.length*50" class="order-table">
      <tr class="order-table-th_row">
        <th>颜色</th>
        <template v-for="item in sizes">
          <th>{{item}}</th>
        </template>
        <th>数量小计</th>
      </tr>
      <template v-for="(row,rowIndex) in mockData">
        <tr>
          <td style="width:80px">{{row.color.name}}</td>
          <template v-for="(item,index) in sizes">
            <td style="width:80px">
              {{getSizeNum(row.size,item)}}
            </td>
          </template>
          <td style="width:100px">{{countRowAmount(rowIndex)}}</td>
        </tr>
      </template>
      <tr>
        <td>数量合计</td>
        <td :colspan="getColspanLength()-1">{{totalAmout}}</td>
      </tr>
      <tr>
        <td>金额合计</td>
        <td :colspan="getColspanLength()-1">￥1200000</td>
      </tr>
      <tr>
        <td>已付金额</td>
        <td :colspan="getColspanLength()-1">￥1200000</td>
      </tr>
      <tr>
        <td>剩余合计</td>
        <td :colspan="getColspanLength()-1">￥1200000</td>
      </tr>
      <tr>
        <td>延期扣款</td>
        <td class="order-table-input">
          <el-input v-model="form.delayDeduction" placeholder="输入"></el-input>
        </td>
        <td>扣款备注</td>
        <td :colspan="getColspanLength()-2" class="order-table-input">
          <el-input v-model="form.delayRemarks" placeholder="输入"></el-input>
        </td>
      </tr>
      <tr>
      <tr>
        <td>质量扣款</td>
        <td class="order-table-input">
          <el-input v-model="form.qualityDeduction" placeholder="输入"></el-input>
        </td>
        <td>扣款备注</td>
        <td :colspan="getColspanLength()-2" class="order-table-input">
          <el-input v-model="form.qualityRemarks" placeholder="输入"></el-input>
        </td>
      </tr>
      <tr>
      <tr>
        <td>其他扣款</td>
        <td class="order-table-input">
          <el-input v-model="form.otherDeduction" placeholder="输入"></el-input>
        </td>
        <td>扣款备注</td>
        <td :colspan="getColspanLength()-2" class="order-table-input">
          <el-input v-model="form.otherRemarks" placeholder="输入"></el-input>
        </td>
      </tr>
      <tr>
      <tr>
        <td>其他款项</td>
        <td class="order-table-input">
          <el-input v-model="form.otherPrice" placeholder="输入"></el-input>
        </td>
        <td>扣款备注</td>
        <td :colspan="getColspanLength()-2" class="order-table-input">
          <el-input v-model="form.otherPriceRemarks" placeholder="输入"></el-input>
        </td>
      </tr>
      <tr>
      <tr>
        <td>备注</td>
        <td :colspan="getColspanLength()-1" class="order-table-input" style="width:120px">
          <el-input v-model="form.remarks" placeholder="输入"></el-input>
        </td>
      </tr>
      <tr>
        <td>应付金额</td>
        <td :colspan="getColspanLength()-1" class="order-table-input" style="width:120px">
          <el-input v-model="form.realPay" placeholder="输入"></el-input>
        </td>
      </tr>
    </table>
    <el-row type="flex" justify="end" class="info-receive-row">
      <h6 class="order-table-info">品牌跟单员： 杨建</h6>
      <h6 class="order-table-info">工厂跟单员： 刘少立</h6>
      <h6 class="order-table-info">发货日期： 2019-7-19</h6>
    </el-row>
    <el-row type="flex" justify="center" class="info-receive-row">
      <el-button class="info-receive-submit" @click="onSubmit()">确认创建</el-button>
    </el-row>
  </div>
</template>

<script>
  import OrdersInfoItem from '@/components/custom/OrdersInfoItem';
  import FormLabel from '@/components/custom/FormLabel';

  export default {
    name: 'PurchaseOrderInfoReconciliation',
    props: ['slotData'],
    components: {
      OrdersInfoItem,
      FormLabel
    },
    mixins: [],
    computed: {
      sizes: function () {
        var sizes = new Set([]);
        this.mockData.forEach(color => {
          color.size.forEach(size => {
            sizes.add(size.name);
          });
        });
        return sizes;
      },
      totalAmout: function () {
        var totalAmount = 0;
        this.mockData.forEach(item => {
          item.size.forEach(size => {
            if (size.num != null && size.num != '') {
              totalAmount += parseInt(size.num);
            }
          });
        })
        return totalAmount;
      }
    },
    methods: {
      countRowAmount(rowIndex) {
        var amount = 0;
        this.mockData[rowIndex].size.forEach(element => {
          if (element != null) {
            let num = parseInt(element.num);
            amount = amount + num;
          }
        });
        return amount;
      },
      getColspanLength() {
        return this.sizes.size + 2;
      },
      onSubmit() {

      },
      getSizeNum(sizes, sizeName) {
        var result = '';
        sizes.forEach(size => {
          if (size.name == sizeName) {
            result = size.num;
          }
        });
        return result;
      }
    },
    data() {
      return {
        form: {
          partyAName: "",
          partyBName: "",
          brandName: "",
          machiningType: "",
          remarks: "",
          imperfectionsNum: '',
          realPay: '',
          delayDeduction:'',
          delayRemarks:'',
          qualityDeduction:'',
          qualityRemarks:'',
          otherDeduction:'',
          otherRemarks:'',
          otherPrice:'',
          otherPriceRemarks:''

        },
        sizesForm: [
          []
        ],
        mockData: [{
          'color': {
            'name': '蓝色',
            'code': 'C1'
          },
          'size': [{
            'name': 'X',
            'code': 'S1',
            'num': 1
          }, {
            'name': 'S',
            'code': 'S2',
            'num': 2
          }, {
            'name': 'XL',
            'code': 'S3',
            'num': 3
          }]
        }, {
          'color': {
            'name': '绿色',
            'code': 'C1'
          },
          'size': [{
            'name': 'X',
            'code': 'S1',
            'num': 1
          }, {
            'name': 'S',
            'code': 'S2',
            'num': 2
          }, {
            'name': 'XL',
            'code': 'S3',
            'num': 3
          }]
        }, {
          'color': {
            'name': '红色',
            'code': 'C1'
          },
          'size': [{
            'name': 'X',
            'code': 'S1',
            'num': 1
          }, {
            'name': 'S',
            'code': 'S2',
            'num': 2
          }, {
            'name': 'XL',
            'code': 'S3',
            'num': 3
          }]
        }],
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
    height: 50px;
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
