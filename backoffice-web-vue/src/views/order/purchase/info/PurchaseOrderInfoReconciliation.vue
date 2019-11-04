<template>
  <div class="info-receive-body">
    <el-row class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">创建对账单({{reconciliationOrderStatus}})</h6>
      </div>
    </el-row>
    <el-form :disabled="isFactory()">
      <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">甲方</h6>
            <el-input placeholder="输入名称" v-model="form.partA" size="mini">
            </el-input>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">乙方</h6>
            <el-input placeholder="输入名称" v-model="form.partB" size="mini">
            </el-input>
          </el-row>
        </el-col>
      </el-row>
      <el-row class="info-receive-row" type="flex" justify="start" align="middle" :gutter="20">
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">品牌</h6>
            <el-input placeholder="输入品牌名" v-model="form.brand" size="mini">
            </el-input>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">款号</h6>
            <el-input placeholder="输入款号" v-model="form.skuID" size="mini">
            </el-input>
          </el-row>
        </el-col>
        <el-col :span="6">
          <el-row type="flex" align="middle">
            <h6 class="info-input-prepend">加工方式</h6>
            <el-select v-model="form.cooperationMethod" placeholder="请选择">
              <el-option v-for="item in machiningTypes" :key="item.value" :label="item.name" :value="item.code">
              </el-option>
            </el-select>
          </el-row>
        </el-col>
      </el-row>
      <table cellspacing="2" width="100%" :height="form.entries.length*50" class="order-table">
        <tr class="order-table-th_row">
          <th>颜色</th>
          <template v-for="(item,index) in sizes">
            <th :key="index" :colspan="getColspanLength3()">{{item}}</th>
          </template>
          <th>数量小计</th>
        </tr>
        <template v-for="(sizeArray,rowIndex) in form.entries">
          <tr :key="rowIndex">
            <td style="width:80px">{{sizeArray[0].color}}</td>
            <template v-for="(item,sizeIndex) in sizeArray">
              <td style="width:80px" :key="sizeIndex" :colspan="getColspanLength3()">
                <el-input class="order-table-input" v-model="item.quantity" type="number">
                </el-input>
              </td>
            </template>
            <td style="width:100px">{{countRowAmount(rowIndex)}}</td>
          </tr>
        </template>
      </table>
      <table cellspacing="2" width="100%" :height="form.entries.length*50" class="order-table"
        style="margin-bottom:20px;">
        <tr>
          <td>数量合计</td>
          <td :colspan="getColspanLength2()+1">{{totalAmout}}</td>
        </tr>
        <tr>
          <td>金额合计</td>
          <td :colspan="getColspanLength2()+1">￥{{slotData.unitPrice}} X {{totalAmout}} =
            ￥{{totalAmout*slotData.unitPrice}}</td>
        </tr>
        <tr>
          <td>延期扣款</td>
          <td class="order-table-input">
            <el-input v-model.number="form.delayDeduction" prefix-icon="el-icon-minus" type="number"></el-input>
          </td>
          <td>扣款备注</td>
          <td :colspan="getColspanLength()" class="order-table-input">
            <el-input v-model="form.delayDeductionRemarks"></el-input>
          </td>
        </tr>
        <tr>
        <tr>
          <td>质量扣款</td>
          <td class="order-table-input">
            <el-input v-model.number="form.qualityDeduction" type="number" prefix-icon="el-icon-minus"></el-input>
          </td>
          <td>扣款备注</td>
          <td :colspan="getColspanLength()" class="order-table-input">
            <el-input v-model="form.qualityDeductionRemarks"></el-input>
          </td>
        </tr>
        <tr>
        <tr>
          <td>其他扣款</td>
          <td class="order-table-input">
            <el-input v-model.number="form.otherDeduction" type="number" prefix-icon="el-icon-minus"></el-input>
          </td>
          <td>扣款备注</td>
          <td :colspan="getColspanLength()" class="order-table-input">
            <el-input v-model="form.otherDeductionRemarks"></el-input>
          </td>
        </tr>
        <tr>
        <tr>
          <td>其他增款</td>
          <td class="order-table-input">
            <el-input v-model.number="form.otherFunds" type="number" prefix-icon="el-icon-plus"></el-input>
          </td>
          <td>扣款备注</td>
          <td :colspan="getColspanLength()" class="order-table-input">
            <el-input v-model="form.otherFundsRemarks"></el-input>
          </td>
        </tr>
        <tr>
        <tr>
          <td>备注</td>
          <td :colspan="getColspanLength2()+1" class="order-table-input" style="width:120px">
            <el-input v-model="form.remarks"></el-input>
          </td>
        </tr>
        <tr>
          <td>实际应付总额</td>
          <td :colspan="getColspanLength2()+1" class="order-table-input" style="width:120px">
            {{shouldPay}}
          </td>
        </tr>
        <tr>
          <td>已付金额</td>
          <td :colspan="getColspanLength2()+1">￥{{form.paid}}</td>
        </tr>
        <tr>
          <td>剩余应付金额</td>
          <td :colspan="getColspanLength2()+1">￥{{shouldPay-form.paid}}</td>
        </tr>
      </table>
    </el-form>
    <el-row type="flex" justify="end" class="info-receive-row">
      <h6 class="order-table-info">品牌跟单员： {{slotData.brandOperator!=null?slotData.brandOperator.name:'未指定'}}</h6>
      <h6 class="order-table-info">工厂跟单员： {{slotData.factoryOperator!=null?slotData.factoryOperator.name:'未指定'}}</h6>
      <h6 class="order-table-info">发货日期： {{slotData
        .creationtime | timestampToTime}}</h6>
    </el-row>
    <el-row type="flex" justify="center" class="info-receive-row">
      <template v-if="isBrand()">
        <el-button class="info-receive-submit" v-if="showSaveBtn" @click="onSubmit">保存并退出</el-button>
        <el-button class="info-receive-submit" v-if="showCommitBtn" @click="onCommit" :disabled="form.id==''">
          确认提交</el-button>
        <el-button class="info-receive-submit"
          v-if="slotData.reconciliationOrders!=null&&slotData.reconciliationOrders.length!=0&&slotData.reconciliationOrders[0].status=='PENDING_CONFIRM'"
          @click="onWithdraw">
          撤回</el-button>
      </template>
      <template v-if="isFactory()">
        <el-button class="info-receive-refuse"
          v-if="slotData.reconciliationOrders!=null&&slotData.reconciliationOrders.length!=0&&slotData.reconciliationOrders[0].status=='PENDING_CONFIRM'"
          @click="onReject">
          拒绝</el-button>
        <el-button class="info-receive-submit"
          v-if="slotData.reconciliationOrders!=null&&slotData.reconciliationOrders.length!=0&&slotData.reconciliationOrders[0].status=='PENDING_CONFIRM'"
          @click="onAccept">
          确认</el-button>
      </template>
    </el-row>
  </div>
</template>

<script>
  import OrdersInfoItem from '@/components/custom/OrdersInfoItem';
  import FormLabel from '@/components/custom/FormLabel';

  import Bus from '@/common/js/bus';


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
        // this.slotData.entries.forEach(element => {
        //   sizes.add(element.product.size.name);
        // });
        this.slotData.deliveryOrders[0].entries.forEach(element => {
          sizes.add(element.size);
        });
        return sizes;
      },
      colors: function () {
        var colors = new Set([]);
        this.slotData.deliveryOrders[0].entries.forEach(element => {
          colors.add(element.color);
        });
        return colors;
      },
      totalAmout: function () {
        var totalAmount = 0;
        this.form.entries.forEach(sizeArray => {
          sizeArray.forEach(item => {
            if (item.quantity != '') {
              totalAmount += parseInt(item.quantity);
            }
          })
        });
        return totalAmount;
      },
      shouldPay: function () {
        var result = this.totalAmout * this.converNum(this.slotData.unitPrice) - this
          .converNum(this.form.delayDeduction) - this.converNum(this.form.qualityDeduction) - this.converNum(this.form
            .otherDeduction) + this.converNum(this.form.otherFunds);
        return result;
      },
      showSaveBtn: function () {
        if (this.slotData.status == 'COMPLETED') {
          if (this.slotData.reconciliationOrders == null || this.slotData.reconciliationOrders.length == 0) {
            return true;
          } else {
            return this.slotData.reconciliationOrders[0].status == 'UNCOMMITTED'
          }
        } else {
          return false;
        }
      },
      showCommitBtn: function () {
        if (this.slotData.reconciliationOrders == null || this.slotData.reconciliationOrders.length == 0) {
          return this.slotData.status == 'COMPLETED';
        } else {
          return this.slotData.reconciliationOrders[0].status == 'UNCOMMITTED' || this.slotData.reconciliationOrders[
              0].status ==
            'REJECTED';
        }
      },
      reconciliationOrderStatus: function () {
        if (this.slotData.reconciliationOrders == null || this.slotData.reconciliationOrders.length == 0) {
          return '';
        } else {
          return this.getEnum('RemarksOrderStatus', this.slotData.reconciliationOrders[0].status);
        }
      }
    },
    methods: {
      converNum(str) {
        if (str == null || str == '') {
          return 0;
        } else {
          return str;
        }
      },
      countRowAmount(rowIndex) {
        var amount = 0;
        this.form.entries[rowIndex].forEach(element => {
          if (element.quantity != '') {
            let quantity = parseInt(element.quantity);
            amount = amount + quantity;
          }
        });
        return amount;
      },
      getColspanLength() {
        return this.sizes.size;
      },
      getColspanLength2() {
        return this.sizes.size > 1 ? this.sizes.size : 2;
      },
      getColspanLength3() {
        return this.sizes.size > 1 ? 1 : 2;
      },
      async onSubmit() {
        //组合订单行参数
        var entries = [];
        this.form.entries.forEach(variants => {
          variants.forEach(variant => {
            if (variant.quantity != '' && variant.quantity > 0) {
              let item = {
                quantity: variant.quantity,
                color: variant.color,
                size: variant.size
              }
              entries.push(item);
            }
          })
        });
        //表单参数
        var form = {
          partA: this.form.partA,
          partB: this.form.partB,
          brand: this.form.brand,
          skuID: this.form.skuID,
          cooperationMethod: this.form.cooperationMethod,
          remarks: this.form.remarks,
          delayDeduction: this.form.delayDeduction,
          delayDeductionRemarks: this.form.delayDeductionRemarks,
          qualityDeduction: this.form.qualityDeduction,
          qualityDeductionRemarks: this.form.qualityDeductionRemarks,
          otherDeduction: this.form.otherDeduction,
          otherDeductionRemarks: this.form.otherDeductionRemarks,
          otherFunds: this.form.otherFunds,
          otherFundsRemarks: this.form.otherDeductionRemarks,
          entries: entries,
        };

        const url = this.apis().createReconciliationOrder(this.slotData.code);
        const result = await this.$http.post(url, form);
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
        this.$set(this.slotData, 'reconciliationOrders', result.reconciliationOrders);
        this.$set(this.slotData, "status", result.status);
        this.$emit('afterCreate');
      },
      getVariant(color, size, entries) {
        var result = entries.filter(item => item.color == color && item.size == size);
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
            if (variant.quantity != '' && variant.quantity > 0) {
              let item = {
                quantity: variant.quantity,
                color: variant.color,
                size: variant.size
              }
              entries.push(item);
            }
          })
        });
        //表单参数
        var form = {
          id: this.form.id,
          code: this.form.code,
          partA: this.form.partA,
          partB: this.form.partB,
          brand: this.form.brand,
          skuID: this.form.skuID,
          cooperationMethod: this.form.cooperationMethod,
          remarks: this.form.remarks,
          delayDeduction: this.form.delayDeduction,
          delayDeductionRemarks: this.form.delayDeductionRemarks,
          qualityDeduction: this.form.qualityDeduction,
          qualityDeductionRemarks: this.form.qualityDeductionRemarks,
          otherDeduction: this.form.otherDeduction,
          otherDeductionRemarks: this.form.otherDeductionRemarks,
          otherFunds: this.form.otherFunds,
          otherFundsRemarks: this.form.otherDeductionRemarks,
          entries: entries,
        };

        const url = this.apis().commitReconciliationOrder();
        const result = await this.$http.put(url, form);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('提交成功');
        //刷新数据
        this.refreshData();
      },
      async onWithdraw() {
        const url = this.apis().withdrawReconciliationOrder();
        const result = await this.$http.put(url, {
          id: this.form.id
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('撤回成功');
        //刷新数据
        this.refreshData();
      },
      async onReject() {
        const url = this.apis().rejectReconciliation(this.form.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('拒绝成功');
        //刷新数据
        this.refreshData();
      },
      async onAccept() {
        const url = this.apis().confirmReconciliation(this.form.code);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('确认成功');
        //刷新数据
        this.refreshData();
      },
      initTable() {
        //初始化表格
        this.form.entries = [];
        this.colors.forEach(color => {
          var sizeArray = [];
          this.sizes.forEach(size => {
            if (this.slotData.reconciliationOrders == null || this.slotData.reconciliationOrders.length == 0) {
              let variant = this.getVariant(color, size, this.slotData.deliveryOrders[0].entries);
              if (variant != null) {
                sizeArray.push({
                  size: size,
                  color: color,
                  quantity: variant.quantity,
                });
              } else {
                sizeArray.push({
                  size: size,
                  color: color,
                  quantity: '',
                });
              }
            } else {
              let variant = this.getVariant(color, size, this.slotData.reconciliationOrders[0].entries);
              if (variant != null) {
                sizeArray.push(variant);
              } else {
                sizeArray.push({
                  size: size,
                  color: color,
                  quantity: '',
                });
              }
            }
          });
          this.form.entries.push(sizeArray);
        });
      },
      initUpdateForm() {
        if (this.slotData.reconciliationOrders != null && this.slotData.reconciliationOrders.length != 0) {
          this.form.id = this.slotData.reconciliationOrders[0].id;
          this.form.code = this.slotData.reconciliationOrders[0].code;
          this.form.partA = this.slotData.reconciliationOrders[0].partA;
          this.form.partB = this.slotData.reconciliationOrders[0].partB;
          this.form.brand = this.slotData.reconciliationOrders[0].brand;
          this.form.skuID = this.slotData.reconciliationOrders[0].skuID;
          this.form.cooperationMethod = this.slotData.reconciliationOrders[0].cooperationMethod;
          this.form.remarks = this.slotData.reconciliationOrders[0].remarks;
          this.form.delayDeduction = this.slotData.reconciliationOrders[0].delayDeduction;
          this.form.delayDeductionRemarks = this.slotData.reconciliationOrders[0].delayDeductionRemarks;
          this.form.qualityDeduction = this.slotData.reconciliationOrders[0].qualityDeduction;
          this.form.qualityDeductionRemarks = this.slotData.reconciliationOrders[0].qualityDeductionRemarks;
          this.form.otherDeduction = this.slotData.reconciliationOrders[0].otherDeduction;
          this.form.otherDeductionRemarks = this.slotData.reconciliationOrders[0].otherDeductionRemarks;
          this.form.otherFunds = this.slotData.reconciliationOrders[0].otherFunds;
          this.form.otherFundsRemarks = this.slotData.reconciliationOrders[0].otherFundsRemarks;
        } else {
          this.form.id = '';
          this.form.code = '';
          this.form.partA = this.slotData.purchaser.name;
          this.form.partB = this.slotData.belongTo.name;
          this.form.brand = this.slotData.deliveryOrders[0].brand;
          this.form.skuID = this.slotData.deliveryOrders[0].skuID;
          this.form.cooperationMethod = this.slotData.machiningType;
          this.form.remarks = '';
          this.form.delayDeduction = 0;
          this.form.delayDeductionRemarks = '';
          this.form.qualityDeduction = 0;
          this.form.qualityDeductionRemarks = '';
          this.form.otherDeduction = 0;
          this.form.otherDeductionRemarks = '';
          this.form.otherFunds = 0;
          this.form.otherFundsRemarks = '';
        }
      }
    },
    data() {
      return {
        machiningTypes: this.$store.state.EnumsModule.machiningTypes,
        form: {
          id: '',
          code: '',
          partA: "",
          partB: "",
          brand: "",
          skuID: "",
          cooperationMethod: "",
          remarks: "",
          paid: 0,
          delayDeduction: 0,
          delayDeductionRemarks: '',
          qualityDeduction: 0,
          qualityDeductionRemarks: '',
          otherDeduction: 0,
          otherDeductionRemarks: '',
          otherFunds: 0,
          otherFundsRemarks: '',
          entries: [],
        },
      }
    },
    created() {
      this.initTable();
    },
    watch: {
      colors: {
        handler(val, oldVal) {
          this.initTable();
        },
        deep: true
      },
      sizes: {
        handler(val, oldVal) {
          this.initTable();
        },
        deep: true
      },
      slotData: {
        handler(val, oldVal) {
          this.initUpdateForm();
        },
        deep: true,
      }
    },
    mounted() {
      this.initUpdateForm();
    }
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
    margin-bottom: 5px;
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


  .info-receive-refuse {
    background-color: red;
    border-color: red;
    color: #fff;
    width: 150px;
  }

</style>
