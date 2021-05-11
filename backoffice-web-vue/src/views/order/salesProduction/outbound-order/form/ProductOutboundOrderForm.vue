<!--
 * @description: 产品外发
 * @fileName: ProductOutboundOrderForm.vue
 * @author: yj
 * @date: 2020-08-24 10:01:45
 * @version: V1.0.0
!-->
<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <supplier-select @onSelect="onSuppliersSelect" :categories="['SUPPLIER']"/>
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
      <el-form ref="form" label-width="80px" :rules="rules" :model="formData">
        <outbound-type-select :formData="formData" />
        <el-row class="outbound-basic-row">
          <el-form-item label="标题" prop="title" :rules="[{required: true, message: '请填写', trigger: 'blur'}]">
            <el-input v-model="formData.title" style="width: 200px"></el-input>
          </el-form-item>
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
            <el-form-item label="外发工厂" prop="outboundCompanyName">
              <el-input v-model="formData.outboundCompanyName" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系人" prop="outboundContactPerson">
              <el-input v-model="formData.outboundContactPerson" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="联系方式" prop="outboundContactPhone">
              <el-input v-model="formData.outboundContactPhone" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="4">
            <el-button @click="suppliersSelectVisible=!suppliersSelectVisible" size="mini">选择合作商</el-button>
          </el-col>
        </el-row>
        <template v-for="(item, index) in formData.taskOrderEntries">
          <el-form ref="itemForm" label-width="80px" :model="item" :key="'form'+index">
            <el-row type="flex" justify="end" v-if="index > 0">
              <el-col :span="2">
                <el-button class="outbound-btn" @click="deleteRow(index)">删除</el-button>
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
                <el-form-item label="产品名称" prop="product"
                  :rules="[{ type: 'object', validator: validateProduct, trigger: 'change' }]">
                  <el-input v-model="item.product.name" :disabled="true" placeholder="请输入"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="4">
                <el-button @click="onProductSelect(index)" size="mini">{{item.product.id ? '更换产品' : '添加产品'}}</el-button>
              </el-col>
            </el-row>
            <outbound-order-color-size-table v-if="item.colorSizeEntries.length > 0" :product="item" :isFromProduct="true"/>
            <el-row type="flex" v-if="item.code" style="margin: 0px 0px 10px 30px;">
              <el-button @click="openColorSize(item)"> + 添加颜色尺码</el-button>
            </el-row>
            <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
              <el-col :span="8">
                <el-form-item label="发单总价" prop="totalPrimeCost"
                  :rules="[{required: true, message: '请填写发单价格', trigger: 'blur'}]">
                  <el-input v-model="item.totalPrimeCost" placeholder="请输入" @blur="onBlur(item,'totalPrimeCost')"
                    v-number-input.float="{ min: 0 ,decimal:2}"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="7">
                <el-form-item label="交货日期" prop="deliveryDate"
                  :rules="[{required: true, message: '请选择交货日期', trigger: 'change'}]">
                  <el-date-picker v-model="item.deliveryDate" type="date" value-format="timestamp" placeholder="选择日期">
                  </el-date-picker>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item label="生产节点" prop="progressPlan"
                  :rules="[{ required: true, type: 'object', validator: validateProgressPlan, trigger: 'change' }]">
                  <el-input v-model="item.progressPlan.name" :disabled="true" placeholder="请输入"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="3">
                <el-button v-if="item.progressPlan.isFromOrder" @click="editProgressPlan(index, item)" size="mini">编辑
                </el-button>
                <el-button v-else @click="onProgressPlanSelect(index)" size="mini">选择节点</el-button>
              </el-col>
            </el-row>
            <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
              <el-col :span="24">
                <my-address-form :vAddress.sync="item.shippingAddress" ref="addressForm" />
              </el-col>
            </el-row>
          </el-form>
          <el-divider :key="'divider'+index" />
        </template>
        <el-row type="flex" justify="center" class="info-order-row" align="middle">
          <el-col :span="24">
            <div class="order-purchase-table-btn_add" @click="addRow">
              +添加另一生产任务
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
            <MTAVAT :machiningTypes.sync="formData.cooperationMode" :needVoice.sync="formData.invoiceNeeded"
              :tax.sync="formData.invoiceTaxPoint" :layoutScale="[9,10,5]" />
          </el-col>
          <el-col :span="6">
            <el-form-item label="运费承担：" label-width="120">
              <el-radio v-model="formData.freightPayer" :label="'PARTYA'">甲方</el-radio>
              <el-radio v-model="formData.freightPayer" :label="'PARTYB'">乙方</el-radio>
            </el-form-item>
          </el-col>
        </el-row>
        <!-- <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20">
          <el-col :span="6">
            <el-form-item label="生产节点" prop="progressPlan">
              <el-input v-model="formData.progressPlan.name" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="2">
            <el-button class="outbound-btn" @click="progressPlanVisible = !progressPlanVisible">选择</el-button>
          </el-col>
        </el-row> -->
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>财务设置</h6>
            </div>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start" :gutter="20" style="margin-bottom: 20px">
          <el-col :span="24">
            <pay-plan-form :formData="formData.payPlan" :isUseForOrder="true" ref="payPlanCom" />
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>人员设置</h6>
            </div>
          </el-col>
        </el-row>
        <div style="display: flex;flex-wrap: wrap;padding-left: 20px">
          <el-form-item label="跟单员" prop="merchandiser">
            <personnel-selection :vPerson.sync="formData.merchandiser" :readOnly="true" />
          </el-form-item>
          <el-form-item label="" label-width="10px">
            <el-checkbox v-model="formData.sendAuditNeeded" :disabled="isDisabled">需审核</el-checkbox>
          </el-form-item>
          <template v-for="(item,itemIndex) in formData.sendApprovers">
            <el-form-item :key="'a'+itemIndex" :label="'审批人'+(itemIndex+1)" label-width="80px" style="margin-right:10px;"
              :prop="'sendApprovers.' + itemIndex" :rules="{required: formData.sendAuditNeeded, message: '不能为空', trigger: 'change'}">
              <personnal-selection-v2 :vPerson.sync="formData.sendApprovers[itemIndex]" :disabled="!formData.sendAuditNeeded"
                                      :excludeMySelf="true" style="width: 194px" :selectedRow="formData.sendApprovers"/>
            </el-form-item>
          </template>
          <el-button-group style="padding-bottom: 26px;">
            <el-button v-if="formData.sendApprovers && formData.sendApprovers.length < 5" style="height: 32px" @click="appendApprover">+ 添加审批人</el-button>
            <el-button v-if="formData.sendApprovers && formData.sendApprovers.length > 1" style="height: 32px" @click="removeApprover">删除</el-button>
          </el-button-group>
        </div>
        <div style="padding-left: 20px">
          <h6 style="color: #F56C6C">* 审批人将按照你选择的顺序逐级审批</h6>
        </div>
        <el-row>
          <el-col :span="4">
            <div style="padding-left: 10px">
              <h6>附件及备注</h6>
            </div>
          </el-col>
        </el-row>
        <el-row style="padding-left: 20px" type="flex" justify="start" :gutter="20">
          <el-col :span="24">
            <el-form-item label="备注">
              <el-input type="textarea" :rows="2" placeholder="请输入内容" v-model="formData.remarks">
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row class="outbound-basic-row" type="flex" justify="start" >
          <el-form-item label="附件">
            <images-upload class="order-purchase-upload" :slot-data="formData.attachments" />
          </el-form-item>
        </el-row>
      </el-form>
      <el-row style="margin-top: 20px" type="flex" justify="center" align="middle" :gutter="50">
        <el-col :span="5">
          <el-button class="material-btn" @click="onCreate(false)">保存</el-button>
        </el-col>
        <el-col :span="5">
          <el-button class="material-btn" @click="onCreate(true)">创建并提交</el-button>
        </el-col>
        <el-col :span="5" v-if="canDelete">
          <el-button @click="onDelete" type="text">作废订单</el-button>
        </el-col>
      </el-row>
    </el-card>
    <el-dialog :visible.sync="taskDialogVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <sample-products-select-dialog v-if="taskDialogVisible" @onSelectSample="onSelectSample" 
                                      :selectedRow="formData.taskOrderEntries" :isSingleSelect="isSingleSelect"/>
    </el-dialog>
    <el-dialog :visible.sync="progressPlanVisible" width="60%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <progress-plan-select-dialog v-if="progressPlanVisible" @getProgressPlan="getProgressPlan" />
    </el-dialog>
    <el-dialog :visible.sync="editProgressPlanVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <progress-plan-edit-form v-if="editProgressPlanVisible" :progressPlan="editProgress"
        @onEditProgress="onEditProgress" />
    </el-dialog>
    <el-dialog title="添加颜色 / 尺码" :visible.sync="colorSizeVisible" width="500px" append-to-body
      :close-on-click-modal="false">
      <color-size-add-form v-if="colorSizeVisible" @closeDialog="colorSizeVisible = false" 
                            @addColorSize="addColorSize"/>
    </el-dialog>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapActions
  } = createNamespacedHelpers(
    'OutboundOrderModule'
  );

  import MyAddressForm from '../../../../../components/custom/order-form/MyAddressForm';
  import MTAVAT from '../../../../../components/custom/order-form/MTAVAT';
  import MyPayPlanForm from '../../../../../components/custom/order-form/MyPayPlanForm';
  import ImagesUpload from '../../../../../components/custom/ImagesUpload';
  import ProgressPlanSelectDialog from '../../../../user/progress-plan/components/ProgressPlanSelectDialog';
  import OutboundOrderColorSizeTable from '../table/OutboundOrderColorSizeTable';
  import PersonnelSelection from '@/components/custom/PersonnelSelection';
  import ProgressPlanEditForm from '@/views/user/progress-plan/components/ProgressPlanEditForm'
  import OutboundTypeSelect from '../components/OutboundTypeSelect'
  import {
    SupplierSelect,
    PersonnalSelectionV2,
    PayPlanForm
  } from '@/components'
  import { SampleProductsSelectDialog } from '@/views/product/sample'
  import { checkAuditFree } from '@/auth/auth'
  import ColorSizeAddForm from '../components/ColorSizeAddForm.vue';

  export default {
    name: 'ProductOutboundOrderForm',
    components: {
      PayPlanForm,
      PersonnelSelection,
      OutboundOrderColorSizeTable,
      ProgressPlanSelectDialog,
      ImagesUpload,
      MyPayPlanForm,
      MTAVAT,
      MyAddressForm,
      SupplierSelect,
      ProgressPlanEditForm,
      OutboundTypeSelect,
      PersonnalSelectionV2,
      SampleProductsSelectDialog,
      ColorSizeAddForm
    },
    computed: {
      canDelete: function () {
        if (this.formData.state != null && this.formData.state == 'TO_BE_SUBMITTED') {
          return true;
        } else {
          return false;
        }
      },
      isDisabled: function () {
        return !checkAuditFree('SEND_SALES_OUT_NO_AUDIT');
      }
    },
    methods: {
      ...mapActions({
        clearFormData: 'clearFormData'
      }),
      appendApprover() {
        this.formData.sendApprovers.push({});
      },
      removeApprover() {
        this.formData.sendApprovers.splice(this.formData.sendApprovers.length - 1, 1);
      },
      getProgressPlan(val) {
        if (val) {
          this.formData.taskOrderEntries[this.selectIndex].progressPlan = this.copyProgressPlan(val);
        }
        this.progressPlanVisible = false;
      },
      onEditProgress(val) {
        this.formData.taskOrderEntries[this.selectIndex].progressPlan.productionProgresses = val;
        this.editProgressPlanVisible = false;
      },
      copyProgressPlan(val) {
        let row = {
          name: val.name,
          remarks: val.remarks,
          productionProgresses: []
        }
        val.productionProgresses.forEach(item => {
          row.productionProgresses.push({
            progressPhase: item.progressPhase,
            warningDays: item.warningDays,
            medias: item.medias,
            completeAmount: item.completeAmount,
            productionProgressOrders: item.productionProgressOrders,
            quantity: item.quantity,
            sequence: item.sequence,
            isCannotRemove: true
          })
        })
        return row;
      },
      onBlur(row, attribute) {
        var reg = /\.$/;
        if (reg.test(row[attribute])) {
          this.$set(row, attribute, parseFloat(row[attribute] + '0'));
        }
      },
      onSuppliersSelect(val) {
        this.suppliersSelectVisible = false;
        this.formData.outboundCompanyName = val.name;
        this.formData.outboundContactPerson = val.person;
        this.formData.outboundContactPhone = val.phone;
        this.formData.targetCooperator.id = val.id;
        if (val.payPlan != null) {
          this.$delete(val.payPlan, 'id');
          val.payPlan.payPlanItems.forEach(element => {
            this.$delete(element, 'id');
          });
          // this.formData.payPlan = JSON.parse(JSON.stringify(val.payPlan));
          this.formData.payPlan = Object.assign({}, val.payPlan);
          this.$message.success('已关联选择合作商绑定账务方案：' + val.payPlan.name);
        }
      },
      onProductSelect(index) {
        this.taskDialogVisible = true;
        this.selectIndex = index;
      },
      onProgressPlanSelect(index) {
        this.progressPlanVisible = true;
        this.selectIndex = index;
      },
      editProgressPlan(index, item) {
        this.editProgressPlanVisible = true;
        this.editProgress = item.progressPlan.productionProgresses;
        this.selectIndex = index;
      },
      addRow() {
        this.selectIndex = '';
        this.isSingleSelect = false;
        this.taskDialogVisible = true;
      },
      deleteRow(index) {
        this.formData.taskOrderEntries.splice(index, 1);
      },
      onSelectSample (selectList) {
        let row;
        let index;
        let entries = [];
        let colorSizeEntries;
        selectList.forEach(item => {
          colorSizeEntries = this.convertColorSize(item.colorSizes);
          row = {
            code: item.code,
            colors: item.colors,
            sizes: item.sizes,
            unitPrice: '',
            deliveryDate: '',
            shippingAddress: {},
            product: {
              id: item.id,
              code: item.code,
              name: item.name,
              thumbnail: item.thumbnail,
              skuID: item.skuID
            },
            progressPlan: {
              name: ''
            },
            colorSizeEntries: colorSizeEntries
          }

          entries.push(row);
          row = null;
        })
        if (this.selectIndex === '') {
          this.formData.taskOrderEntries = this.formData.taskOrderEntries.concat(entries);
          this.isSingleSelect = true;
        } else {
          entries[0].shippingAddress = this.formData.taskOrderEntries[this.selectIndex].shippingAddress;
          this.formData.taskOrderEntries.splice(this.selectIndex, 1, entries[0]);
        }
        this.taskDialogVisible = false;
      },
      convertColorSize (colorSizes) {
        let colorSizeEntries = [];
        colorSizes.forEach(item => {
          item.sizes.forEach(val => {
            colorSizeEntries.push({
              color: {
                id: item.colorId,
                code: item.colorCode,
                name: item.colorName,
                customize: item.customize
              },
              quantity: 0,
              size: {
                code: val.code,
                name: val.name
              }
            })
          })
        })
        return colorSizeEntries;
      },
      openColorSize (item) {
        this.colorSizeItem = item;
        this.colorSizeVisible = true;
      },
      addColorSize (data, selectType) {
        let sizeSet = new Set();
        let colorSet = new Set();
        this.colorSizeItem.colorSizeEntries.forEach(item => {
          sizeSet.add(item.size);
        });
        this.colorSizeItem.colorSizeEntries.forEach(item => {
          colorSet.add(item.color);
        });
        if (selectType === 'color') {
          sizeSet.forEach(item => {
            this.colorSizeItem.colorSizeEntries.push({
              color: data,
              quantity: 0,
              size: item
            })
          })
        } else {
          colorSet.forEach(item => {
            this.colorSizeItem.colorSizeEntries.push({
              color: item,
              quantity: 0,
              size: data
            })
          })
        }

        this.colorSizeVisible = false;
      },
      onSelectTask(selectTaskList) {
        let row = {}
        let index;
        let entries = [];
        selectTaskList.forEach(item => {
          index = this.formData.taskOrderEntries.findIndex(val => val.originOrder.id == item.id);
          if (index > -1) {
            entries.push(this.formData.taskOrderEntries[index]);
          } else {
            row = {
              originOrder: {
                id: item.id
              },
              unitPrice: item.unitPrice,
              deliveryDate: item.deliveryDate,
              shippingAddress: item.shippingAddress,
              product: {
                id: item.product.id,
                name: item.product.name,
                thumbnail: item.product.thumbnail
              },
              progressPlan: {
                name: ''
              },
              colorSizeEntries: item.colorSizeEntries
            }
            if (item.progressWorkSheet) {
              row.progressPlan = this.copyProgressPlan({
                name: '节点方案1',
                remarks: '',
                productionProgresses: item.progressWorkSheet.progresses
              })
              row.progressPlan.isFromOrder = true;
            }
            entries.push(row);
            row = {};
          }
        })
        this.formData.taskOrderEntries = entries;
        // 没有选择生产工单添加默认数据
        if (selectTaskList.length <= 0) {
          this.addRow();
          this.taskDialogVisible = false;
          return;
        }
        // 回显地址
        this.formData.taskOrderEntries.forEach((val, index) => {
          if (this.$refs.addressForm[index]) {
            this.$refs.addressForm[index].getCities(val.shippingAddress.region);
            this.$refs.addressForm[index].onCityChanged(val.shippingAddress.city);
          }
        })
        this.taskDialogVisible = false;
      },
      // 封装Promise对象
      getFormPromise(form) {
        return new Promise(resolve => {
          form.validate(res => {
            resolve(res);
          })
        })
      },
      async validateForms() {
        var formArr = [];
        formArr.push(this.$refs['form']);
        this.$refs['itemForm'].forEach(item => {
          formArr.push(item);
        })
        this.$refs['addressForm'].forEach(item => {
          formArr.push(item.$refs['address']);
        })
        formArr.push(this.$refs['payPlanCom'].$refs['payPlanForm']);
        // 使用Promise.all 并行去校验结果
        let res = await Promise.all(formArr.map(this.getFormPromise));

        return res.every(item => !!item);
      },
      async onCreate(flag) {
        let validate = await this.validateForms();
        if (validate) {
          this._onCreate(flag);
        } else {
          this.$message.error('请完善表单信息');
        }
      },
      async _onCreate(flag) {
        let data = Object.assign({}, this.formData);

        // 人员设置数据处理
        if (!data.sendAuditNeeded) {
          data.sendApprovers = [];
        } else {
          // 处理级联选择数据
          data.sendApprovers = [];
          this.formData.sendApprovers.forEach(item => {
            if (item instanceof Array && item.length > 0) {
              data.sendApprovers.push({
                id: item[item.length - 1]
              });
            }
          })
        }
        if (!data.invoiceNeeded) {
          data.invoiceTaxPoint = null;
        }

        const url = this.apis().createOutboundOrderWithClothes();
        const result = await this.$http.post(url, data, {
          submitAudit: flag
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }

        this.$message.success(flag ? '创建外发订单成功！' : '保存外发订单成功！');
        await this.$router.push({
          name: '外发订单列表'
        });
      },
      validateField(name) {
        this.$refs.form.validateField(name);
      },
      validateProduct(rule, value, callback) {
        if (value.id) {
          return callback();
        } else {
          return callback(new Error('请选择产品'))
        }
      },
      validateProgressPlan(rule, value, callback) {
        if (value.name && value != '') {
          return callback();
        } else {
          return callback(new Error('请选择生产节点'))
        }
      },
      checkApprover(rule, value, callback) {
        if (value[0] && value[0].id) {
          return callback();
        } else {
          return callback(new Error('请选择审核员'))
        }
      },
      initData() {
        if (this.$route.params.formData != null) {
          this.formData = this.$route.params.formData;
          if(this.formData.sendApprovers==null){
            this.formData.sendApprovers=[{id:''}];
          }
          if (this.formData.taskOrderEntries.length <= 0) {
            this.addRow();
          }
          // if (this.$route.params.formData.targetCooperator.id != '') {
          //   this.formData.outboundCompanyName = this.$route.params.formData.targetCooperator.partner.name;
          //   this.formData.outboundContactPerson = this.$route.params.formData.targetCooperator.partner.contactPerson;
          //   this.formData.outboundContactPhone = this.$route.params.formData.targetCooperator.partner.contactPhone;
          //   this.formData.attachments = [];
          // }
        }
        //  else {

        //   this.formData = Object.assign({}, this.$store.state.OutboundOrderModule.formData);
        // }
        // //默认设置跟单员为当前账号
        this.$set(this.formData, 'merchandiser', this.currentUser);
      },
      //作废订单
      onDelete() {
        this.$confirm('此操作将永久取消订单, 是否继续?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this._onDelete();
        });
      },
      async _onDelete() {
        const url = this.apis().outboundOrderDelete(this.formData.id);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code === 0) {
          this.$message.error(result.msg);
          return;
        }
        this.$message.success('取消订单成功');
        await this.$router.go(-1);
      },
    },
    data() {
      var checkPartyAOperator = (rule, value, callback) => {
        if (value && value.id != '') {
          return callback();
        } else {
          return callback(new Error('请选择跟单员'));
        }
      };
      return {
        rules: {
          outboundCompanyName: [{
            required: true,
            message: '请选择外发工厂',
            trigger: 'change'
          }],
          outboundContactPerson: [{
            required: true,
            message: '请选择联系人',
            trigger: 'change'
          }],
          outboundContactPhone: [{
            required: true,
            message: '请选择联系方式',
            trigger: 'change'
          }],
          merchandiser: [{
            type: 'object',
            validator: checkPartyAOperator,
            trigger: 'change'
          }]
        },
        formData: Object.assign({}, this.$store.state.OutboundOrderModule.formData),
        currentUser: this.$store.getters.currentUser,
        suppliersSelectVisible: false,
        taskDialogVisible: false,
        selectIndex: '',
        progressPlanVisible: false,
        editProgressPlanVisible: false,
        editProgress: '',
        operator: {},
        count: 0,
        isSingleSelect: true,
        colorSizeVisible: false
      }
    },
    watch: {
      'formData.progressPlan': function (n, o) {
        this.validateField('progressPlan', this.currentUser);
      },
      'formData.sendApprovers': function (nval, oval) {
        this.formData.sendApprovers.forEach((item, index) => {
          this.validateField('sendApprovers.' + index);
        })
      }
    },
    created() {
      if (checkAuditFree('SEND_SALES_OUT_NO_AUDIT')) {
        this.formData.sendAuditNeeded = false;
      } else {
        this.formData.sendAuditNeeded = true;
      }
      
      this.initData();
    },
    mounted() {
      this.$nextTick(() => {
        this.$refs['form'].clearValidate();
      })
    },
    destroyed() {
      this.clearFormData();
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
    background: rgba(247, 247, 247, 1);
  }

  .order-purchase-table-btn_add:hover {
    background: #fff9c4;
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
