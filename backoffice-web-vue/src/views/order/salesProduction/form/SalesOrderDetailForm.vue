<template>
  <div>
    <div class="sales-plan-box">
      <el-row type="flex">
        <el-col :span="10">
          <!-- <MTAVAT v-if="modifyType" :machiningTypes.sync="form.cooperationMode" :needVoice.sync="form.invoiceNeeded"
              :tax.sync="form.invoiceTaxPoint" :layoutScale="mtavatLayoutScale" class="basic-form-row" /> -->
          <el-row type="flex" justify="start" class="basic-form-row">
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="sales-plan-h6"><span class="info-title">单号：</span>{{form.code}}
                </h6>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="sales-plan-h6"><span
                    class="info-title">合作方式：</span>{{getEnum('cooperationModes', form.cooperationMode)}}
                </h6>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="sales-plan-h6"><span class="info-title">是否开发票：</span>{{form.invoiceNeeded ? '开发票' : '不开发票'}}
                </h6>
              </el-row>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" class="basic-form-row" v-if="!modifyType">
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="sales-plan-h6"><span class="info-title">生产总数：</span>{{totalAmount}}</h6>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="sales-plan-h6"><span class="info-title">生产总价：</span>{{totalPrice}}元</h6>
              </el-row>
            </el-col>
          </el-row>
        </el-col>
        <el-divider direction="vertical"></el-divider>
        <el-col :span="8">
          <template v-if="form.type==='SALES_ORDER'">
            <el-row type="flex" justify="start" class="basic-form-row">
              <el-col :span="24">
                <h6 class="sales-plan-h6"><span class="info-title">合作商：</span>{{cooperator.name}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" justify="start" class="basic-form-row">
              <el-col :span="12">
                <h6 class="sales-plan-h6"><span class="info-title">联系人：</span>{{cooperator.contactPerson}}</h6>
              </el-col>
              <el-col :span="12">
                <h6 class="sales-plan-h6"><span class="info-title">联系电话：</span>
                  {{cooperator.contactPhone}}</h6>
              </el-col>
            </el-row>
          </template>
          <el-row type="flex" justify="start" class="basic-form-row" style="margin-top:10px">
            <h6 class="info-title">人员设置</h6>
          </el-row>
          <el-row type="flex" justify="start" class="basic-form-row">
            <el-col :span="12">
              <h6 class="sales-plan-h6"><span class="info-title">创建人：</span>{{form.creator!=null?form.creator.name:''}}
              </h6>
            </el-col>
            <el-col :span="12">
              <h6 v-show="!modifyType" class="sales-plan-h6"><span class="info-title">审批负责人：</span>
                {{(form.approvers!=null&&form.approvers[0]!=null)?form.approvers[0].name:''}}</h6>
              <el-row type="flex" v-if="modifyType" align="middle">
                <el-col :span="10">
                  <span class="info-title">审批负责人：</span>
                </el-col>
                <el-col :span="14">
                  <el-form-item prop="approvers.0" :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                    <personnel-selection :vPerson.sync="form.approvers[0]" v-if="modifyType" />
                  </el-form-item>
                  <!-- <el-select v-model="form.approvers[0]" placeholder="请选择" v-if="modifyType" value-key="id">
                    <el-option v-for="item in options" :key="item.value.id" :label="item.label" :value="item.value">
                    </el-option>
                  </el-select> -->
                </el-col>
              </el-row>
            </el-col>
          </el-row>
          <el-row type="flex" justify="start" class="basic-form-row">
            <el-row type="flex" align="middle">
              <h6 v-show="!modifyType" class="sales-plan-h6"><span class="info-title">生产负责人：</span>
                {{form.productionLeader!=null?form.productionLeader.name:''}}</h6>
              <el-row type="flex" v-if="modifyType" align="middle">
                <el-col :span="10"><span class="info-title">生产负责人：</span></el-col>
                <el-col :span="14">
                  <!-- <el-select v-model="form.productionLeader" placeholder="请选择" v-if="modifyType" value-key="id">
                    <el-option v-for="item in options" :key="item.value.id" :label="item.label" :value="item.value">
                    </el-option>
                  </el-select> -->
                  <el-form-item prop="productionLeader" :rules="{required: true, message: '不能为空', trigger: 'blur'}">
                    <personnel-selection :vPerson.sync="form.productionLeader" v-if="modifyType" />
                  </el-form-item>
                </el-col>
              </el-row>
            </el-row>
          </el-row>
        </el-col>
        <el-divider direction="vertical"></el-divider>
        <el-col :span="6">
          <!-- <el-row type="flex" justify="space-between" class="basic-form-row">
            <h5>合同</h5>
            <el-button type="text" style="color: #ffd60c">签署合同</el-button>
          </el-row> -->
<!--          <purchase-order-info-contract :slotData="form" :contracts="[]" />-->
          <contract-com :slotData="form" :contracts="contracts" :canSign="canSign"/>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
  import {
    accMul
  } from '@/common/js/number';

  import {
    getEntryTotalAmount,
    getEntryTotalPrice,
    getEntryTotalCost,
    getEntryProfit,
    getEntryProfitPercent
  } from '../js/accounting.js';

  import MTAVAT from '@/components/custom/order-form/MTAVAT';
  import PurchaseOrderInfoContract from '@/views/order/purchase/info/PurchaseOrderInfoContract';
  import PersonnelSelection from '@/components/custom/PersonnelSelection';
  import ContractCom from '../contract/ContractCom';

  export default {
    name: 'SalesOrderDetailForm',
    computed: {
      cooperator: function () {
        if (this.form.cooperator != null) {
          if (this.form.cooperator.type == 'ONLINE') {
            return Object.assign({}, this.form.cooperator.partner);
          } else {
            return Object.assign({}, this.form.cooperator);
          }
        } else {
          return {
            name: '',
            contactPerson: '',
            contactPhone: ''
          }
        }
      },
      //总数量
      totalAmount: function () {
        let total = 0;
        if (this.form.entries != null) {
          this.form.entries.forEach(element => {
            let num = parseFloat(getEntryTotalAmount(element));
            if (num != null && (!Number.isNaN(num))) {
              total += num;
            }
          });
        }
        return total;
      },
      //销售总价
      totalPrice: function () {
        let total = 0;
        this.form.entries.forEach(element => {
          let num = parseFloat(getEntryTotalPrice(element));
          if (num != null && (!Number.isNaN(num))) {
            total += num;
          }
        });
        return total;
      },
      // 已签的合同列表
      contracts: function () {
        return this.form.agreements ? this.form.agreements : [];
      },
      // 判断是否能签署合同
      canSign: function () {

      }
    },
    components: {
      ContractCom,
      MTAVAT,
      PurchaseOrderInfoContract,
      PersonnelSelection
    },
    props: {
      form: {
        type: Object
      },
      modifyType: {
        type: Boolean,
        default: false
      }
    },
    methods: {

    },
    data () {
      return {
        machiningTypes: this.$store.state.EnumsModule.cooperationModes,
        mtavatLayoutScale: [9, 9, 6],
        options: [{
          label: this.$store.getters.currentUser.username,
          value: {
            id: this.$store.getters.currentUser.id,
            name: this.$store.getters.currentUser.username
          }
        }]
      }
    },
    created () {}
  }
</script>

<style scoped>
  .info-title {
    font-weight: bold;
    font-size: 14px;
    border: none
  }

  .sales-plan-box {
    display: table;
    margin: 0 auto;
    width: 100%;
  }

  .sales-plan-one {
    width: 100%;
    display: table-cell;
  }

  .sales-plan-three {
    width: 1%;
    display: table-cell;
  }

  .sales-plan-two {
    width: 100%;
    display: table-cell;
    z-index: 100;
  }

  .sales-plan-triangle_box {
    margin-top: 1px;
    position: absolute;
    right: 0;
    top: 0;
  }

  .sales-plan-triangle {
    width: 0;
    height: 0;
    border-right: 70px solid white;
    border-bottom: 70px solid transparent;
    z-index: 0;
  }

  .sales-plan-triangle_text {
    width: 80px;
    padding-top: 10px;
    padding-left: 30px;
    transform: rotateZ(45deg);
  }

  .sales-border-container {
    /* border: 1px solid #DCDFE6;
    border-radius: 5px; */
    width: 100%;
    padding-top: 10px;
  }

  .basic-form-row {
    width: 100%;
    padding-left: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 90px;
    height: 35px;
  }

  .sales-plan-h6 {
    padding-top: 8px;
    font-size: 12px;
  }

  /deep/ .el-input__inner {
    height: 24px;
    line-height: 24px;
    border-radius: 2px;
    padding: 0px;
  }

  .sales-radio {
    margin-top: 8px
  }

  .over-tabs {
    position: absolute;
    z-index: 100;
    right: 30px;
    margin-top: 2px;
  }

  /deep/ .el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 5px;
  }

  /deep/.el-divider--vertical {
    height: auto;
  }

</style>
