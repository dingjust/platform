<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <suppliers-select @onSelect="onSuppliersSelect" />
    </el-dialog>
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="outbound-order-create-title">
            <h6>创建外发订单</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-form ref="form" label-width="80px">
        <template v-for="(product, index) in form.productList">
          <el-row type="flex" justify="end" v-if="index > 0">
            <el-col :span="2">
              <el-button class="outbound-btn" @click="deleteRow(index)">删除</el-button>
            </el-col>
          </el-row>
            <el-row>
              <el-col :span="4">
                <div style="padding-left: 10px">
                  <h6>合作对象</h6>
                </div>
              </el-col>
            </el-row>
            <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
              <el-col :span="8">
                <el-form-item label="外发工厂">
                  <el-input v-model="product.companyOfSeller" :disabled="true"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item label="联系人">
                  <el-input v-model="product.contactPersonOfSeller" :disabled="true"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item label="联系方式">
                  <el-input v-model="product.contactOfSeller" :disabled="true"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="4">
                <el-button @click="suppliersSelectVisible=!suppliersSelectVisible" size="mini">选择供应商</el-button>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="4">
                <div style="padding-left: 10px">
                  <h6>生产详情</h6>
                </div>
              </el-col>
            </el-row>
            <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
              <el-col :span="8">
                <el-form-item label="产品名称">
                  <el-input v-model="product.product.name" :disabled="true" placeholder="请输入"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="4">
                <el-button @click="onProductSelect" size="mini">选择产品/任务</el-button>
              </el-col>
            </el-row>
            <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
              <el-col :span="6">
                <el-form-item label="发单价格">
                  <el-input v-model="product.price" placeholder="请输入"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item label="交货日期">
                  <el-date-picker v-model="product.date" type="date" placeholder="选择日期"></el-date-picker>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
              <el-col :span="24">
                <my-address-form :vAddress.sync="product.address" />
              </el-col>
            </el-row>
          <el-divider/>
        </template>
        <el-row type="flex" justify="center" class="info-order-row" align="middle">
          <el-col :span="24">
            <div class="order-purchase-table-btn_add" @click="addRow">
              +添加另一款产品
            </div>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>生产详情</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
          <el-col :span="18">
            <MTAVAT :machiningTypes.sync="form.machiningTypes" :needVoice.sync="form.needVoice" :tax.sync="form.tax" />
          </el-col>
          <el-col :span="4">
            <el-form-item label="生产节点">
              <el-input></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="2">
            <el-button class="outbound-btn">选择</el-button>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>财务设置</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
          <el-col :span="24">
            <my-pay-plan-form :vPayPlan.sync="form.vPayPlan"/>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>人员设置</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
          <el-form-item label="跟单员">
            <el-select v-model="form.charge" placeholder="请选择" style="width:100%">
              <el-option label="张三" value="张三"></el-option>
              <el-option label="李四" value="李四"></el-option>
            </el-select>
          </el-form-item>
        </el-row>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>附件及备注</h6>
            </div>
          </el-col>
        </el-row>
        <el-row style="padding-left: 10px" type="flex" justify="start" :gutter="20">
          <el-col :span="24">
            <el-form-item label="备注">
              <el-input
                type="textarea"
                :rows="2"
                placeholder="请输入内容"
                v-model="form.textarea">
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
          <el-form-item label="附件">
            <images-upload class="order-purchase-upload" :slot-data="form.attachments"/>
          </el-form-item>
        </el-row>
      </el-form>
      <el-row style="margin-top: 20px" type="flex" justify="center" align="middle" :gutter="50">
        <el-col :span="5">
          <el-button class="material-btn">确认创建</el-button>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="sampleDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <sample-products-select-dialog v-if="sampleDialogVisible" @onSelectSample="onSelectSample"/>
    </el-dialog>
  </div>
</template>

<script>
  import SuppliersSelect from '../../../../contract/manage/components/SupplierSelect';
  import MyAddressForm from '../../../../../components/custom/order-form/MyAddressForm';
  import MTAVAT from '../../../../../components/custom/order-form/MTAVAT';
  import MyPayPlanForm from '../../../../../components/custom/order-form/MyPayPlanForm';
  import ImagesUpload from '../../../../../components/custom/ImagesUpload';
  import SampleProductsSelectDialog from '../../../../product/sample/components/SampleProductsSelectDialog';
  export default {
    name: 'OutboundOrderForm',
    components: {SampleProductsSelectDialog, ImagesUpload, MyPayPlanForm, MTAVAT, MyAddressForm, SuppliersSelect},
    methods: {
      onSuppliersSelect (val) {
        this.suppliersSelectVisible = false;
        this.form.companyOfSeller = val.name;
        this.form.contactPersonOfSeller = val.person;
        this.form.contactOfSeller = val.phone;
        this.form.cooperator.id = val.id;
        if (val.payPlan != null) {
          this.setPayPlan(val.payPlan);
          this.$message.success('已关联选择合作商绑定账务方案：' + val.payPlan.name);
        }
      },
      onProductSelect () {
        this.sampleDialogVisible = true;
      },
      addRow () {
        let item = {
          companyOfSeller: '',
          contactPersonOfSeller: '',
          contactOfSeller: '',
          product: {
            name: ''
          },
          price: '',
          date: '',
          address: {}
        };
        this.productList.push(item);
      },
      deleteRow (index) {
        this.productList.splice(index, 1);
      },
      onSelectSample (data) {
        this.sampleDialogVisible = false;
        console.log(data);
      }
    },
    data () {
      return {
        suppliersSelectVisible: false,
        sampleDialogVisible: false,
        form: {
          productList: [{
            companyOfSeller: '',
            contactPersonOfSeller: '',
            contactOfSeller: '',
            product: {
              name: ''
            },
            price: '',
            date: '',
            address: {}
          }],
          machiningTypes: 'LABOR_AND_MATERIAL',
          needVoice: false,
          tax: 0.03,
          vPayPlan: {},
          textarea: '',
          charge: '',
          medias: {},
          attachments: []
        }
      }
    }
  }
</script>

<style scoped>
  .outbound-order-create-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .outbound-basic-row {
    padding-left: 20px;
  }

  .outbound-btn {
    background: #FFD60C;
    color: rgba(0, 0, 0, 0.85);
    width: 70px;
  }

  .info-order-row {
    margin-bottom: 20px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 120px;
    height: 40px;
  }

  .order-purchase-table-btn_add {
    width: 100%;
    height: 50px;
    line-height: 50px;
    border: 0.5px dashed rgba(0, 0, 0, 0.15);
    text-align: center;
    align-content: center;
    color: rgba(0, 0, 0, 0.65);
  }

  .order-purchase-table-btn_add:hover {
    background: rgba(247, 247, 247, 1);
    cursor: pointer;
  }

  /deep/ .el-divider--horizontal {
    margin: 16px 0;
  }

  .order-purchase-upload {
    margin-left: 5px;
  }

  .order-purchase-upload>>>.el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .order-purchase-upload>>>.el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }
</style>
