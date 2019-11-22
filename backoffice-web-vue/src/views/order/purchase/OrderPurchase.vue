<template>
  <div class="animated fadeIn content order-purchase-form">
    <el-dialog :visible.sync="productSelectVisible" width="40%" class="purchase-dialog" append-to-body>
      <product-select :page="page" @onSearch="onSearch" @onSelect="onProductSelect" />
    </el-dialog>
    <el-dialog :visible.sync="suppliersSelectVisible" width="60%" class="purchase-dialog" append-to-body>
      <supplier-select @onSelect="onSuppliersSelect" />
    </el-dialog>
    <el-dialog :visible.sync="addressSelectVisible" width="60%" class="purchase-dialog" append-to-body>
      <address-select @onSelect="onAddressSelect" />
    </el-dialog>
    <el-dialog :visible.sync="payPlanSelectDialogVisible" width="50%" class="purchase-dialog" append-to-body>
      <pay-plan-select @onSelect="onPayPlanSelect" />
    </el-dialog>
    <el-dialog title="保存账务方案" :visible.sync="dialogPayPlanFormVisible">
      <el-form :model="payPlanForm">
        <el-form-item label="方案名称">
          <el-input v-model="payPlanForm.name"></el-input>
        </el-form-item>
        <el-form-item label="备注">
          <el-input type="textarea" :rows="3" placeholder="请输入备注留言..." v-model="payPlanForm.remarks" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogPayPlanFormVisible = false">取 消</el-button>
        <el-button type="primary" @click="onPayPlanSave">确 定</el-button>
      </div>
    </el-dialog>
    <el-card class="box-card">
      <el-form :model="form" :rules="rules" ref="form">
        <div class="info-order-body">
          <el-row class="info-title-row">
            <div class="info-title">
              <h6 class="info-title_text">创建线下订单</h6>
            </div>
          </el-row>
          <el-row class="info-order-row">
            <form-label label="合作对象" />
          </el-row>
          <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="20">
            <el-col :span="8">
              <el-form-item prop="companyOfSeller" class="purchase-form-item">
                <el-row type="flex" align="middle">
                  <h6 class="info-input-prepend">合作商</h6>
                  <el-input placeholder="名称" v-model="form.companyOfSeller" :disabled="true" size="mini">
                  </el-input>
                </el-row>
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item prop="contactPersonOfSeller" class="purchase-form-item">
                <el-row type="flex" align="middle">
                  <h6 class="info-input-prepend">联系人</h6>
                  <el-input placeholder="姓名" v-model="form.contactPersonOfSeller" :disabled="true" size="mini">
                  </el-input>
                </el-row>
              </el-form-item>
            </el-col>
            <el-col :span="6">
              <el-form-item prop="contactOfSeller" class="purchase-form-item">
                <el-row type="flex" align="middle">
                  <h6 class="info-input-prepend">联系方式</h6>
                  <el-input placeholder="电话号码" :disabled="true" v-model="form.contactOfSeller" size="mini">
                  </el-input>
                </el-row>
              </el-form-item>
            </el-col>
            <el-col :span="4">
              <el-button @click="suppliersSelectVisible=!suppliersSelectVisible" size="mini">选择供应商</el-button>
            </el-col>
          </el-row>
          <el-row class="info-order-row">
            <form-label label="生产详情" />
          </el-row>
          <template v-for="(product,productIndex) in form.entries">
            <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="20">
              <el-col :span="7">
                <el-row type="flex" align="middle">
                  <h6 class="info-input-prepend">产品名</h6>
                  <el-input placeholder="名称" v-model="product.name" size="mini" :disabled="true">
                  </el-input>
                </el-row>
              </el-col>
              <el-col :span="3">
                <el-button @click="onpenSelect(productIndex)" size="mini">点击选择</el-button>
              </el-col>
              <el-col :span="2">
                <el-row type="flex" align="middle">
                  <el-button type="text" v-if="productIndex!=0" @click="removeRow(productIndex)">删除</el-button>
                </el-row>
              </el-col>
            </el-row>
            <el-row type="flex" v-if="product.code!=null" class="info-order-row">
              <img class="purchase-product-img"
                :src="product.thumbnail!=null&&product.thumbnail.length!=0?product.thumbnail.url:'static/img/nopicture.png'">
              <table cellspacing="2" width="100%" :height="(form.entries.length+1)*50" class="order-table">
                <tr class="order-table-th_row">
                  <td style="width:40px">颜色</td>
                  <template v-for="item in product.sizes">
                    <th>{{item}}</th>
                  </template>
                  <th>小计</th>
                </tr>
                <template v-for="(color,rowIndex) in product.colors">
                  <tr>
                    <td>{{color}}</td>
                    <template v-for="(size,index) in product.sizes">
                      <td style="width:80px">
                        <el-input class="order-table-input" type="number"
                          v-model="getVariant(color,size,product.variants).num">
                        </el-input>
                      </td>
                    </template>
                    <td style="width:100px">{{countColorsAmount(color,product.variants)}}</td>
                  </tr>
                </template>
                <tr>
                  <td>合计</td>
                  <td :colspan="getColspanLength(product.sizes.size)+1">{{countTotalAmount(product.variants)}}</td>
                </tr>
              </table>
            </el-row>
            <template v-if="shouldShow(product,productIndex)">
              <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="20">
                <el-col :span="8">
                  <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请输入报价', trigger: 'blur'}]" :key="product.key"
                    :prop="'entries.' + productIndex+'.unitPrice'">
                    <el-row type="flex" align="middle">
                      <h6 class="info-input-prepend">订单报价</h6>
                      <el-input placeholder="输入报价" v-model="product.unitPrice" size="mini" type="number"
                        @input="oninput(product)">
                      </el-input>
                    </el-row>
                  </el-form-item>
                </el-col>
                <el-col :span="6">
                  <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请选择日期', trigger: 'change' ,type: 'date'}]" :key="product.key"
                    :prop="'entries.' + productIndex+'.expectedDeliveryDate'">
                    <el-row type="flex" align="middle">
                      <h6 class="info-input-prepend">交货日期</h6>
                      <el-date-picker v-model="product.expectedDeliveryDate" type="date" placeholder="选择日期"
                        :picker-options="pickerOptions">
                      </el-date-picker>
                    </el-row>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="20">
                <el-col :span="7">
                  <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请选择合作方式', trigger: 'change'}]" :key="product.key"
                    :prop="'entries.' + productIndex+'.machiningTypes'">
                    <el-row type="flex" align="middle">
                      <h6 class="info-input-prepend">合作方式</h6>
                      <template v-for="(value,key) in machiningTypes">
                        <el-radio class="info-radio" v-model="product.machiningTypes" :label="key">{{value}}
                        </el-radio>
                      </template>
                    </el-row>
                  </el-form-item>
                </el-col>
                <el-col :span="7">
                  <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请选择承担运费方', trigger: 'change'}]" :key="product.key"
                    :prop="'entries.' + productIndex+'.freightPayer'">
                    <el-row type="flex" align="middle">
                      <h6 class="info-input-prepend">承担运费</h6>
                      <template v-for="(value,key) in freightPayer">
                        <el-radio class="info-radio" v-model="product.freightPayer" :label="key">{{value}}</el-radio>
                      </template>
                    </el-row>
                  </el-form-item>
                </el-col>
                <el-col :span="6">
                  <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请选择是否开发票', trigger: 'change'}]" :key="product.key"
                    :prop="'entries.' + productIndex+'.invoice'">
                    <el-row type="flex" align="middle">
                      <h6 class="info-input-prepend">是否开发票</h6>
                      <el-radio class="info-radio" v-model="product.invoice" :label="false">不开发票</el-radio>
                      <el-radio class="info-radio" v-model="product.invoice" :label="true">开发票</el-radio>
                    </el-row>
                  </el-form-item>
                </el-col>
                <el-col :span="4">
                  <el-select v-model="product.invoicePercent" :disabled="!product.invoice" placeholder="税点">
                    <el-option v-for="item in invoicePercent" :key="item.value" :label="item.label" :value="item.value">
                    </el-option>
                  </el-select>
                </el-col>
              </el-row>
              <el-row :gutter="10" class="info-order-row" type="flex" align="middle">
                <el-col :span="6">
                  <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请选择省', trigger: 'change'}]" :key="product.key"
                    :prop="'entries.' + productIndex+'.address.region'">
                    <el-row type="flex" align="middle">
                      <h6 class="info-input-prepend">送货地址</h6>
                      <el-select class="w-100" v-model="product.address.region" value-key="isocode"
                        @change="(val)=>onRegionChanged(val,productIndex)">
                        <el-option v-for="item in regions" :key="item.isocode" :label="item.name" :value="item">
                        </el-option>
                      </el-select>
                    </el-row>
                  </el-form-item>
                </el-col>
                <el-col :span="4">
                  <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请选择市', trigger: 'change'}]" :key="product.key"
                    :prop="'entries.' + productIndex+'.address.city'">
                    <el-select class="w-100" v-model="product.address.city"
                      @change="(val)=>onCityChanged(val,productIndex)" value-key="code">
                      <el-option v-for="item in product.cities" :key="item.code" :label="item.name" :value="item">
                      </el-option>
                    </el-select>
                  </el-form-item>
                </el-col>
                <el-col :span="4">
                  <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请选择区', trigger: 'change'}]" :key="product.key"
                    :prop="'entries.' + productIndex+'.address.cityDistrict'">
                    <el-select class="w-100" v-model="product.address.cityDistrict" value-key="code">
                      <el-option v-for="item in product.cityDistricts" :key="item.code" :label="item.name"
                        :value="item">
                      </el-option>
                    </el-select>
                  </el-form-item>
                </el-col>
                <el-col :span="6">
                  <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请详细地址', trigger: 'change'}]" :key="product.key"
                    :prop="'entries.' + productIndex+'.address.line1'">
                    <el-row type="flex" align="middle">
                      <el-input placeholder="详细地址" v-model="product.address.line1" size="mini">
                      </el-input>
                    </el-row>
                  </el-form-item>
                </el-col>
                <el-col :span="4">
                  <el-button size="mini" @click="addressSelect(productIndex)">选择</el-button>
                </el-col>
              </el-row>
              <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="20">
                <el-col :span="6">
                  <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请填写收货人', trigger: 'blur'}]" :key="product.key"
                    :prop="'entries.' + productIndex+'.address.fullname'">
                    <el-row type="flex" align="middle">
                      <h6 class="info-input-prepend">收货人</h6>
                      <el-input placeholder="名称" v-model="product.address.fullname" size="mini">
                      </el-input>
                    </el-row>
                  </el-form-item>
                </el-col>
                <el-col :span="6">
                  <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请填写联系方式', trigger: 'blur'}]" :key="product.key"
                    :prop="'entries.' + productIndex+'.address.cellphone'">
                    <el-row type="flex" align="middle">
                      <h6 class="info-input-prepend">联系方式</h6>
                      <el-input placeholder="电话" v-model="product.address.cellphone" size="mini">
                      </el-input>
                    </el-row>
                  </el-form-item>
                </el-col>
              </el-row>
            </template>
            <el-row>
              <el-col :span="24">
                <el-divider></el-divider>
              </el-col>
            </el-row>
          </template>
          <el-row type="flex" justify="center" class="info-order-row" align="middle">
            <el-col :span="24">
              <div class="order-purchase-table-btn_add" @click="addRow">
                +添加另一款产品
              </div>
            </el-col>
          </el-row>
          <el-row class="info-order-row">
            <form-label label="账务设置" />
          </el-row>
          <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="35">
            <el-col :span="6">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">有无定金</h6>
                <el-radio class="info-radio" v-model="form.isHaveDeposit" :label="true">有定金</el-radio>
                <el-radio class="info-radio" v-model="form.isHaveDeposit" :label="false">无定金</el-radio>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">尾款期数</h6>
                <template v-for="(value,key) in payPlanType">
                  <el-radio class="info-radio" v-model="form.payPlanType" :label="key">{{value}}</el-radio>
                </template>
              </el-row>
            </el-col>
            <el-col :span="10">
              <el-row type="flex" align="middle" justify="space-between">
                <h6 class="info-input-prepend" style="margin-right:5px;width:100px">
                  {{currentFinancialPlan!=''?'当前选中方案：'+currentFinancialPlan:'当前未选择账务方案'}}</h6>
                <el-button style="margin-right:20px" @click="payPlanSelectDialogVisible=true" type="primary" plain
                  size="mini">选用我的账务方案</el-button>
                <el-button @click="dialogPayPlanFormVisible=true" type="success" plain size="mini">保存账务方案</el-button>
              </el-row>
            </el-col>
          </el-row>
          <el-row class="info-order-row" v-if="form.isHaveDeposit" type="flex" justify="start" align="middle"
            :gutter="10">
            <el-col :span="7">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">定金</h6>
                <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
                <el-select v-model="form.deposit.event" placeholder="请选择">
                  <template v-for="(value,key) in triggerEvent">
                    <el-option :label="value" :value="key"></el-option>
                  </template>
                </el-select>
              </el-row>
            </el-col>
            <el-col :span="4">
              <el-row type="flex" align="middle" justify="space-between" :gutter="20">
                <el-col :span="6">
                  <h6 class="info-input-prepend2" style="width:50px;">后时长</h6>
                </el-col>
                <el-col :span="18">
                  <el-select v-model="form.deposit.time" placeholder="请选择">
                    <el-option label="5" :value="5"></el-option>
                    <el-option label="7" :value="7"></el-option>
                    <el-option label="15" :value="15"></el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="4">
              <el-row type="flex" align="middle" justify="space-between">
                <el-col :span="6">
                  <h6 class="info-input-prepend2">天</h6>
                </el-col>
                <el-col :span="18">
                  <el-select v-model="form.deposit.range">
                    <template v-for="(value,key) in triggerType">
                      <el-option :label="value" :value="key"></el-option>
                    </template>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="4">
              <el-row type="flex" align="middle" justify="space-between">
                <el-col :span="6">
                  <h6 class="info-input-prepend2" style="width: 40px;">付款</h6>
                </el-col>
                <el-col :span="18">
                  <el-select v-model="form.deposit.percent">
                    <el-option label="0%" :value="0"></el-option>
                    <el-option label="10%" :value="0.1"></el-option>
                    <el-option label="20%" :value="0.2"></el-option>
                    <el-option label="30%" :value="0.3"></el-option>
                    <el-option label="40%" :value="0.4"></el-option>
                    <el-option label="50%" :value="0.5"></el-option>
                    <el-option label="60%" :value="0.6"></el-option>
                    <el-option label="70%" :value="0.7"></el-option>
                    <el-option label="80%" :value="0.8"></el-option>
                    <el-option label="90%" :value="0.9"></el-option>
                    <el-option label="100%" :value="1"></el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
          <el-row class="info-order-row" v-if="form.payPlanType!='MONTHLY_SETTLEMENT'" type="flex" justify="start"
            align="middle" :gutter="10">
            <el-col :span="7">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">第1期尾款</h6>
                <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
                <el-select v-model="form.balance1.event" placeholder="请选择">
                  <template v-for="(value,key) in triggerEvent">
                    <el-option :label="value" :value="key"></el-option>
                  </template>
                </el-select>
              </el-row>
            </el-col>
            <el-col :span="4">
              <el-row type="flex" align="middle" justify="start" :gutter="20">
                <el-col :span="6">
                  <h6 class="info-input-prepend2" style="width:40px;">后时长</h6>
                </el-col>
                <el-col :span="18">
                  <el-select v-model="form.balance1.time" placeholder="请选择">
                    <el-option label="5" :value="5"></el-option>
                    <el-option label="7" :value="7"></el-option>
                    <el-option label="15" :value="15"></el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="4">
              <el-row type="flex" align="middle" justify="start">
                <el-col :span="6">
                  <h6 class="info-input-prepend2">天</h6>
                </el-col>
                <el-col :span="18">
                  <el-select v-model="form.balance1.range">
                    <template v-for="(value,key) in triggerType">
                      <el-option :label="value" :value="key"></el-option>
                    </template>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="7" v-if="form.payPlanType=='PHASEONE'">
              <el-row type="flex" align="middle" justify="start">
                <h6 class="info-input-prepend2" style="width: 200px;">支付剩余全部款项</h6>
              </el-row>
            </el-col>
            <el-col :span="4" v-if="form.payPlanType!='PHASEONE'">
              <el-row type="flex" align="middle" justify="start">
                <el-col :span="6">
                  <h6 class="info-input-prepend2" style="width: 40px;">付款</h6>
                </el-col>
                <el-col :span="18">
                  <el-select v-model="form.balance1.percent">
                    <el-option label="0%" :value="0"></el-option>
                    <el-option label="10%" :value="0.1"></el-option>
                    <el-option label="20%" :value="0.2"></el-option>
                    <el-option label="30%" :value="0.3"></el-option>
                    <el-option label="40%" :value="0.4"></el-option>
                    <el-option label="50%" :value="0.5"></el-option>
                    <el-option label="60%" :value="0.6"></el-option>
                    <el-option label="70%" :value="0.7"></el-option>
                    <el-option label="80%" :value="0.8"></el-option>
                    <el-option label="90%" :value="0.9"></el-option>
                    <el-option label="100%" :value="1"></el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
          <el-row class="info-order-row" v-if="form.payPlanType=='PHASETWO'" type="flex" justify="start" align="middle"
            :gutter="10">
            <el-col :span="7">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">第2期尾款</h6>
                <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
                <el-select v-model="form.balance2.event" placeholder="请选择">
                  <template v-for="(value,key) in triggerEvent">
                    <el-option :label="value" :value="key"></el-option>
                  </template>
                </el-select>
              </el-row>
            </el-col>
            <el-col :span="4">
              <el-row type="flex" align="middle" justify="space-between" :gutter="20">
                <el-col :span="6">
                  <h6 class="info-input-prepend2" style="width:40px;">后时长</h6>
                </el-col>
                <el-col :span="18">
                  <el-select v-model="form.balance2.time" placeholder="请选择">
                    <el-option label="5" :value="5"></el-option>
                    <el-option label="7" :value="7"></el-option>
                    <el-option label="15" :value="15"></el-option>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="4">
              <el-row type="flex" align="middle" justify="space-between">
                <el-col :span="6">
                  <h6 class="info-input-prepend2">天</h6>
                </el-col>
                <el-col :span="18">
                  <el-select v-model="form.balance2.range">
                    <template v-for="(value,key) in triggerType">
                      <el-option :label="value" :value="key"></el-option>
                    </template>
                  </el-select>
                </el-col>
              </el-row>
            </el-col>
            <el-col :span="7">
              <el-row type="flex" align="middle" justify="start">
                <h6 class="info-input-prepend2" style="width: 200px;">支付剩余全部款项</h6>
              </el-row>
            </el-col>
          </el-row>
          <el-row class="info-order-row" v-if="form.payPlanType=='MONTHLY_SETTLEMENT'" type="flex" justify="start"
            align="middle" :gutter="10">
            <el-col :span="7">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">月结</h6>
                <h6 class="info-input-prepend2" style="width:30px;">事件</h6>
                <el-select v-model="form.monthBalance.event" placeholder="请选择">
                  <template v-for="(value,key) in triggerEvent">
                    <el-option :label="value" :value="key"></el-option>
                  </template>
                </el-select>
              </el-row>
            </el-col>
            <el-col :span="4">
              <el-row type="flex" align="middle" justify="start">
                <!-- <h6 class="info-input-prepend2" style="width: 200px">后, 次月月底支付剩余全部款项</h6> -->
                <el-row type="flex" align="middle" justify="space-between" :gutter="20">
                  <el-col :span="6">
                    <h6 class="info-input-prepend2" style="width:40px;">后</h6>
                  </el-col>
                  <el-col :span="18">
                    <el-select v-model="form.monthBalance.time" placeholder="请选择">
                      <el-option label="5" :value="5"></el-option>
                      <el-option label="7" :value="7"></el-option>
                      <el-option label="15" :value="15"></el-option>
                    </el-select>
                  </el-col>
                </el-row>
              </el-row>
            </el-col>
            <el-col :span="13">
              <el-row type="flex" align="middle" justify="start">
                <el-col :span="24">
                  <h6 class="info-input-prepend2" style="width: 200px;">号支付剩余全部款项</h6>
                </el-col>
              </el-row>
            </el-col>
          </el-row>
          <el-row class="info-order-row">
            <form-label label="人员设置" />
          </el-row>
          <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="10">
            <el-col :span="24">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend" style="width:45px">跟单员</h6>
                <el-select v-model="form.QC" placeholder="请选择" :disabled="true">
                  <el-option label="采购部-刘少立" value="确认订单"></el-option>
                </el-select>
              </el-row>
            </el-col>
          </el-row>
          <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="10">
            <el-col :span="24">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend" style="width:45px">结果预览</h6>
                <el-input type="textarea" autosize v-model="resultPreview" />
                </el-input>
              </el-row>
            </el-col>
          </el-row>
          <el-row class="info-order-row">
            <form-label label="备注及附件" />
          </el-row>
          <el-row class="info-order-row" type="flex" justify="start" align="top">
            <h6 class="info-input-prepend" style="width:45px">备注</h6>
            <el-input type="textarea" :rows="3" placeholder="请输入备注留言..." v-model="form.remarks">
            </el-input>
          </el-row>
          <el-row>
            <images-upload class="order-purchase-upload" :slot-data="form.attachments" />
          </el-row>
          <el-row type="flex" justify="center" class="info-order-row">
            <el-button class="info-order-submit" @click="onSubmit()">确认创建</el-button>
          </el-row>
        </div>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import {
    createNamespacedHelpers
  } from 'vuex';

  const {
    mapGetters,
    mapMutations,
    mapActions
  } = createNamespacedHelpers('ApparelProductsModule');

  import OrdersInfoItem from '@/components/custom/OrdersInfoItem';
  import FormLabel from '@/components/custom/FormLabel';
  import ProductSelect from '@/components/custom/ProductSelect';
  import SupplierSelect from '@/components/custom/SupplierSelect';
  import AddressSelect from '@/components/custom/AddressSelect';
  import ImagesUpload from '@/components/custom/ImagesUpload';
  import PayPlanSelect from '@/components/custom/PayPlanSelect';

  export default {
    name: 'orderPurchase',
    components: {
      OrdersInfoItem,
      FormLabel,
      ProductSelect,
      ImagesUpload,
      SupplierSelect,
      AddressSelect,
      PayPlanSelect
    },
    mixins: [],
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword',
        queryFormData: 'queryFormData'
      }),
      resultPreview: function () {
        var result;
        if (this.form.isHaveDeposit && this.form.payPlanType == 'PHASETWO') {
          result = '定金+2期尾款\n        定金：在双方' + this.triggerEvent[this.form.deposit.event] + '后' + this.form.deposit
            .time +
            '天' + this.triggerType[this.form.deposit.range] + '，甲方应向乙方支付生效订单总金额的' +
            this.form.deposit
            .percent * 100 +
            '%为定金\n        支付方式：甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,在' + this.triggerEvent[this.form.balance1.event] +
            '后' + this.form.balance1
            .time +
            '天' + this.triggerType[this.form.balance1.range] + '支付合同总价的' + this.form.balance1.percent * 100 +
            '%。在产品入库并经甲方检验全部产品合格' +
            this.triggerEvent[this.form.balance2.event] + '后' +
            this.form.balance2.time + '天' + this.triggerType[this.form.balance2.range] +
            '未发现任何产品质量问题的，则甲方向乙方支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }
        if (this.form.isHaveDeposit && this.form.payPlanType == 'PHASEONE') {
          result = '定金+1期尾款\n        定金：在双方' + this.triggerEvent[this.form.deposit.event] + '后' + this.form.deposit
            .time +
            '天' + this.triggerType[this.form.deposit.range] + '，甲方应向乙方支付生效订单总金额的' +
            this.form.deposit
            .percent * 100 +
            '%为定金\n        支付方式：甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库完成在' + this.triggerEvent[this.form.balance1.event] + '后' +
            this.form.balance1
            .time +
            '天' + this.triggerType[this.form.balance1.range] +
            '未发现任何产品质量问题的则甲方向乙方支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }
        if (!this.form.isHaveDeposit && this.form.payPlanType == 'PHASEONE') {
          result = '无定金1期尾款\n        甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库完成在' + this.triggerEvent[this.form.balance1.event] +
            '后' + this.form
            .balance1.time + '天' +
            this.triggerType[this.form.balance1.range] +
            '未发现任何产品质量问题的则甲方向乙方支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。'
        }
        if (!this.form.isHaveDeposit && this.form.payPlanType == 'PHASETWO') {
          result = '无定金2期尾款\n        甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,在' + this.triggerEvent[this.form.balance1.event] +
            '后' + this.form
            .balance1.time + '天' +
            this.triggerType[this.form.balance1.range] + '支付合同总价的' + this.form.balance1.percent * 100 +
            '%。在产品入库并经甲方检验全部产品合格' + this.triggerEvent[this.form.balance2.event] + '后' + this.form.balance2.time +
            '天' + this.triggerType[this.form.balance2.range] +
            '未发现任何产品质量问题的，则甲方向乙方支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }
        if (this.form.isHaveDeposit && this.form.payPlanType == 'MONTHLY_SETTLEMENT') {
          result = '有定金+月结\n        定金：在双方' + this.triggerEvent[this.form.deposit.event] + '后' + this.form.deposit
            .time +
            '天' + this.triggerType[this.form.deposit.range] + '，甲方应向乙方支付生效订单总金额的' + this
            .form.deposit
            .percent * 100 +
            '%为定金\n        支付方式：甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,甲方在' + this.triggerEvent[this.form.monthBalance.event] +
            '完成的次月' + this.form.monthBalance.time + '号支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }
        if (!this.form.isHaveDeposit && this.form.payPlanType == 'MONTHLY_SETTLEMENT') {
          result = '无定金月结\n        甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,甲方在' + this.triggerEvent[this.form.monthBalance
              .event] +
            '完成的次月' + this.form.monthBalance.time + '号支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }

        return result;
      }
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced',
        refresh: 'refresh'
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().getApparelProducts();
        this.search({
          url,
          keyword,
          page,
          size
        });
      },
      countColorsAmount(color, variants) {
        var amount = 0;
        variants.forEach(element => {
          if (element.num != '' && element.color.name == color) {
            let num = parseInt(element.num);
            amount = amount + num;
          }
        });
        return amount;
      },
      countTotalAmount(variants) {
        var amount = 0;
        variants.forEach(element => {
          if (element.num != '') {
            let num = parseInt(element.num);
            amount = amount + num;
          }
        });
        return amount;
      },
      getColspanLength(size) {
        return size + 2;
      },
      onProductSelect(product) {
        var variants = [];
        var sizesSet = new Set([]);
        var colorsSet = new Set([]);
        product.variants.forEach(varaint => {
          var item = {
            code: varaint.code,
            baseProduct: varaint.baseProduct,
            color: varaint.color,
            size: varaint.size,
            num: ''
          };
          sizesSet.add(varaint.size.name);
          colorsSet.add(varaint.color.name);
          variants.push(item);
        });
        // var entry = {
        //   thumbnail: product.thumbnail,
        //   name: product.name,
        //   code: product.code,
        //   variants: variants,
        //   sizes: sizesSet,
        //   colors: colorsSet,
        //   unitPrice: '',
        //   expectedDeliveryDate: '',
        //   machiningTypes: '',
        //   freightPayer: '',
        //   invoice: true,
        //   invoicePercent: '',
        //   address: {
        //     city: '',
        //     cityDistrict: '',
        //     region: '',
        //     line1: '',
        //     fullname: '',
        //     cellphone: ''
        //   },
        //   cities: [],
        //   cityDistricts: [],
        // };
        this.$set(this.form.entries[this.currentProductIndex], 'thumbnail', product.thumbnail);
        this.$set(this.form.entries[this.currentProductIndex], 'name', product.name);
        this.$set(this.form.entries[this.currentProductIndex], 'code', product.code);
        this.$set(this.form.entries[this.currentProductIndex], 'variants', variants);
        this.$set(this.form.entries[this.currentProductIndex], 'sizes', sizesSet);
        this.$set(this.form.entries[this.currentProductIndex], 'colors', colorsSet);
        // this.form.entries.splice(this.currentProductIndex, 1, entry);
        this.productSelectVisible = false;
      },
      getVariant(color, size, variants) {
        var result = variants.filter(item => item.color.name == color && item.size.name == size);
        if (result.length != 0) {
          return result[0];
        } else {
          return null;
        }
      },
      onpenSelect(index) {
        this.currentProductIndex = index;
        this.productSelectVisible = !this.productSelectVisible;
      },
      addRow() {
        this.form.entries.push({
          unitPrice: '',
          expectedDeliveryDate: '',
          machiningTypes: '',
          freightPayer: '',
          invoice: true,
          invoicePercent: 0.03,
          address: {
            city: '',
            cityDistrict: '',
            region: '',
            line1: '',
            fullname: '',
            cellphone: ''
          },
          cities: [],
          cityDistricts: []
        });
      },
      removeRow(index) {
        this.form.entries.splice(index, 1);
      },
      async getRegions() {
        const url = this.apis().getRegions();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.regions = result;
      },
      onRegionChanged(current, index) {
        if (!current || current.isocode == '') {
          return;
        }

        this._onRegionChanged(current, index);
      },
      _onRegionChanged(current, index) {
        this.form.entries[index].cities = [];
        this.$set(this.form.entries[index].address, 'city', {
          code: '',
          name: ''
        });
        this.$set(this.form.entries[index].address, 'cityDistrict', {
          code: '',
          name: ''
        });
        this.getCities(current, index);
        if (this.form.entries[index].address.city && this.form.entries[index].address.city.code) {
          this.onCityChanged(this.form.entries[index].address.city.code, index);
        }
      },
      async getCities(region, index) {
        const url = this.apis().getCities(region.isocode);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.form.entries[index].cities = result;
      },
      onCityChanged(current, index) {
        if (!current) {
          return;
        }
        this._onCityChanged(current, index);
      },
      async _onCityChanged(city, index) {
        this.form.entries[index].cityDistricts.clear;
        const url = this.apis().getDistricts(city.code);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.form.entries[index].cityDistricts = result;
      },
      async onSubmit() {
        this.form.entries.forEach(entry => {
          if (entry.variants == null || entry.variants.length == 0) {
              this.$message.error('请选择产品');
              return false;
            }
        })
        this.$refs['form'].validate(async (valid) => {
          if (valid) {
            // 分单
            for (var element of this.form.entries) {
              // 组合订单行参数
              var entries = [];
              element.variants.forEach(variant => {
                if (variant.num != '' && variant.num > 0) {
                  let item = {
                    quantity: variant.num,
                    product: {
                      color: variant.color,
                      size: variant.size,
                      baseProduct: variant.baseProduct,
                      code: variant.code
                    }
                  }
                  entries.push(item);
                }
              });
              // 组合账务参数
              var payPlanItems = [];
              if (this.form.isHaveDeposit) {
                payPlanItems.push({
                  payPercent: this.form.deposit.percent,
                  triggerEvent: this.form.deposit.event,
                  triggerDays: this.form.deposit.time,
                  moneyType: 'DEPOSIT',
                  triggerType: this.form.deposit.range
                });
              }
              if (this.form.payPlanType == 'MONTHLY_SETTLEMENT') {
                payPlanItems.push({
                  triggerEvent: this.form.monthBalance.event,
                  moneyType: 'MONTHLY_SETTLEMENT',
                  triggerDays: this.form.monthBalance.time
                });
              } else {
                payPlanItems.push({
                  payPercent: this.form.balance1.percent,
                  triggerEvent: this.form.balance1.event,
                  triggerDays: this.form.balance1.time,
                  moneyType: 'PHASEONE',
                  triggerType: this.form.balance1.range
                });
                if (this.form.payPlanType == 'PHASETWO') {
                  payPlanItems.push({
                    payPercent: this.form.balance2.percent,
                    triggerEvent: this.form.balance2.event,
                    triggerDays: this.form.balance2.time,
                    moneyType: 'PHASETWO',
                    triggerType: this.form.balance2.range
                  });
                }
              }

              var totalPercent = 0;
              for (var i = 0; i++; i < payPlanItems.length - 1) {
                totalPercent += payPlanItems[i].payPercent;
              }

              payPlanItems[payPlanItems.lastIndexOf] = totalPercent;

              // 组合表单参数
              let form = {
                companyOfSeller: this.form.companyOfSeller,
                contactOfSeller: this.form.contactOfSeller,
                contactPersonOfSeller: this.form.contactPersonOfSeller,
                deliveryAddress: element.address,
                freightPayer: element.freightPayer,
                machiningType: element.machiningTypes,
                invoiceTaxPoint: element.invoicePercent,
                invoiceNeeded: element.invoice,
                unitPrice: element.unitPrice,
                entries: entries,
                expectedDeliveryDate: element.expectedDeliveryDate,
                payPlan: {
                  name: Date.now.toString,
                  payPlanType: this.form.payPlanType,
                  isHaveDeposit: this.form.isHaveDeposit,
                  payPlanItems: payPlanItems
                },
                attachments: this.form.attachments,
                remarks: this.form.remarks,
                salesApplication: 'BELOW_THE_LINE',
                cooperator: {
                  id: this.form.cooperator.id
                }
              };
              // 提交数据
              const url = this.apis().createOfflinePurchaseOrder();
              const result = await this.$http.post(url, form);
              if (result['errors']) {
                this.$message.error(result['errors'][0].message);
                return;
              }
              this.$message.success('创建成功');
            }
            this.$router.push('order/purchase');
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      async getProductAgain() {
        const url = this.apis().getApparelProduct(this.againData.entries[0].product.baseProduct);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.onProductSelect(result);
      },
      onSuppliersSelect(val) {
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
      addressSelect(index) {
        this.currentProductIndex = index;
        this.addressSelectVisible = !this.addressSelectVisible;
      },
      async onAddressSelect(val) {
        this.addressSelectVisible = false;
        this.form.entries[this.currentProductIndex].address = val;
        this.getCities(val.region, this.currentProductIndex);
        const url = this.apis().getDistricts(val.city.code);
        const result = await this.$http.get(url);

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.form.entries[this.currentProductIndex].cityDistricts = result;
      },
      shouldShow(product, index) {
        if (index == 0) {
          return true;
        } else {
          return product.code != null && product.code != '';
        }
      },
      setPayPlan(payPlan) {
        this.form.isHaveDeposit = payPlan.isHaveDeposit;
        this.form.payPlanType = payPlan.payPlanType;
        payPlan.payPlanItems.forEach((item) => {
          switch (item.moneyType) {
            case 'PHASEONE':
              this.form.balance1.percent = item.payPercent;
              this.form.balance1.event = item.triggerEvent;
              this.form.balance1.time = item.triggerDays;
              this.form.balance1.range = item.triggerType;
              break;
            case 'PHASETWO':
              this.form.balance2.percent = item.payPercent;
              this.form.balance2.event = item.triggerEvent;
              this.form.balance2.time = item.triggerDays;
              this.form.balance2.range = item.triggerType;
              break;
            case 'DEPOSIT':
              this.form.deposit.percent = item.payPercent;
              this.form.deposit.event = item.triggerEvent;
              this.form.deposit.time = item.triggerDays;
              this.form.deposit.range = item.triggerType;
              break;
            case 'MONTHLY_SETTLEMENT':
              this.form.monthBalance.event = item.triggerEvent;
              this.form.monthBalance.time = item.triggerDays;
              break;
          }
        });
      },
      onPayPlanSelect(item) {
        this.setPayPlan(item);
        this.currentFinancialPlan = item.name;
        this.payPlanSelectDialogVisible = false;
      },
      async onPayPlanSave() {
        // 组合账务参数
        var payPlanItems = [];
        if (this.form.isHaveDeposit) {
          payPlanItems.push({
            payPercent: this.form.deposit.percent,
            triggerEvent: this.form.deposit.event,
            triggerDays: this.form.deposit.time,
            moneyType: 'DEPOSIT',
            triggerType: this.form.deposit.range
          });
        }
        if (this.form.payPlanType == 'MONTHLY_SETTLEMENT') {
          payPlanItems.push({
            triggerEvent: this.form.monthBalance.event,
            moneyType: 'MONTHLY_SETTLEMENT',
            triggerDays: this.form.monthBalance.time
          });
        } else {
          payPlanItems.push({
            payPercent: this.form.balance1.percent,
            triggerEvent: this.form.balance1.event,
            triggerDays: this.form.balance1.time,
            moneyType: 'PHASEONE',
            triggerType: this.form.balance1.range
          });
          if (this.form.payPlanType == 'PHASETWO') {
            payPlanItems.push({
              payPercent: this.form.balance2.percent,
              triggerEvent: this.form.balance2.event,
              triggerDays: this.form.balance2.time,
              moneyType: 'PHASETWO',
              triggerType: this.form.balance2.range
            });
          }
        }

        var payPlanForm = {
          name: this.payPlanForm.name,
          payPlanType: this.form.payPlanType,
          isHaveDeposit: this.form.isHaveDeposit,
          payPlanItems: payPlanItems,
          remarks: this.payPlanForm.remarks
        }

        // 提交数据
        const url = this.apis().createPayPlan();
        const result = await this.$http.post(url, payPlanForm);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('创建账务方案成功');
        this.payPlanForm.name = '';
        this.payPlanForm.remarks = '';
        this.dialogPayPlanFormVisible = false;
      },
      oninput(e) {
        // // 通过正则过滤小数点后两位
        e.unitPrice = (e.unitPrice.match(/^\d*(\.?\d{0,2})/g)[0]) || null;
      },
    },
    data() {
      return {
        productSelectVisible: false,
        suppliersSelectVisible: false,
        addressSelectVisible: false,
        payPlanSelectDialogVisible: false,
        dialogPayPlanFormVisible: false,
        currentProductIndex: 0,
        currentFinancialPlan: '',
        regions: [],
        payPlanForm: {
          name: '',
          remarks: ''
        },
        freightPayer: {
          'PARTYA': '甲方',
          'PARTYB': '乙方'
        },
        machiningTypes: {
          'LABOR_AND_MATERIAL': '包工包料',
          'LIGHT_PROCESSING': '清加工'
        },
        payPlanType: {
          'PHASEONE': '一期尾款',
          'PHASETWO': '二期尾款',
          'MONTHLY_SETTLEMENT': '月结'
        },
        payMoneyType: {
          'DEPOSIT': '定金',
          'PHASEONE': '一期款',
          'PHASETWO': '二期款',
          'MONTHLY_SETTLEMENT': '月结'
        },
        triggerEvent: {
          'ORDER_CONFIRMED': '确认订单',
          'CONTRACT_SIGNED': '签署合同',
          'DELIVERY_CONFIRMED': '确认收货',
          'RECONCILIATION_CONFIRMED': '确认对账',
          'INVOICE_RECEIVED': '收到发票'
        },
        triggerType: {
          'INSIDE': '以内',
          'OUTSIDE': '以外'
        },
        invoicePercent: [{
            label: '3%税点',
            value: 0.03
          },
          {
            label: '6%税点',
            value: 0.06
          },
          {
            label: '13%税点',
            value: 0.13
          }
        ],
        form: {
          companyOfSeller: '',
          offlinereceive: false,
          productBrandName: '',
          productSKU: '',
          remarks: '',
          entries: [{
            unitPrice: '',
            expectedDeliveryDate: '',
            machiningTypes: '',
            freightPayer: '',
            invoice: false,
            invoicePercent: 0.03,
            address: {
              city: '',
              cityDistrict: '',
              region: '',
              line1: '',
              fullname: '',
              cellphone: ''
            },
            cities: [],
            cityDistricts: []
          }],
          contactPersonOfSeller: '',
          contactOfSeller: '',
          isHaveDeposit: false,
          payPlanType: 'PHASEONE',
          plan: '1',
          deposit: {
            event: 'ORDER_CONFIRMED',
            time: 5,
            range: 'INSIDE',
            percent: 0.3
          },
          balance1: {
            event: 'ORDER_CONFIRMED',
            time: 5,
            range: 'INSIDE',
            percent: 0.3
          },
          balance2: {
            event: 'ORDER_CONFIRMED',
            time: 5,
            range: 'INSIDE',
            percent: 0.3
          },
          monthBalance: {
            event: 'ORDER_CONFIRMED',
            time: 5
          },
          QC: this.$store.getters.currentUser.username,
          attachments: [],
          cooperator: {
            id: ''
          }
        },
        isAgain: this.$route.params.isAgain,
        againData: this.$route.params.data,
        rules: {
          companyOfSeller: [{
            required: true,
            message: '请填写合作商名称',
            trigger: 'blur'
          }],
          contactPersonOfSeller: [{
            required: true,
            message: '请填写联系人名称',
            trigger: 'blur'
          }],
          contactOfSeller: [{
            required: true,
            message: '请填写联系方式',
            trigger: 'blur'
          }]
        },
        pickerOptions: {
          disabledDate(time) {
            let date = new Date();
            date.setDate(date.getDate() - 1);
            return time.getTime() < date;
          }
        }
      }
    },
    created() {
      this.onSearch();
      this.getRegions();
    },
    mounted() {
      if (this.isAgain) {
        this.form = {
          companyOfSeller: this.againData.companyOfSeller,
          offlinereceive: false,
          productBrandName: '',
          productSKU: '',
          remarks: this.againData.remarks,
          entries: [{
            unitPrice: '',
            expectedDeliveryDate: '',
            machiningTypes: '',
            freightPayer: '',
            invoice: true,
            invoicePercent: 0.03,
            address: {
              city: '',
              cityDistrict: '',
              region: '',
              line1: '',
              fullname: '',
              cellphone: ''
            },
            cities: [],
            cityDistricts: []
          }],
          contactPersonOfSeller: this.againData.contactPersonOfSeller,
          contactOfSeller: this.againData.contactOfSeller,
          isHaveDeposit: false,
          payPlanType: this.againData.payPlan.payPlanType,
          plan: '1',
          deposit: {
            event: 'ORDER_CONFIRMED',
            time: 5,
            range: 'INSIDE',
            percent: 0.3
          },
          balance1: {
            event: 'ORDER_CONFIRMED',
            time: 5,
            range: 'INSIDE',
            percent: 0.3
          },
          balance2: {
            event: 'ORDER_CONFIRMED',
            time: 5,
            range: 'INSIDE',
            percent: 0.3
          },
          monthBalance: {
            event: 'ORDER_CONFIRMED',
            time: 5
          },
          QC: {},
          attachments: []
        };
        this.getProductAgain();
      }
    }
  }

</script>
<style scoped>
  .info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 14px;
  }

  .info-title_text {
    font-size: 12px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }

  .info-title-row {
    margin-bottom: 20px;
  }

  .info-order-body {
    width: 100%;
    /* padding: 10px 60px; */
  }

  .info-order-row {
    margin-bottom: 20px;
  }

  .info-input-prepend {
    display: inline-block;
    margin: 0 5px;
    width: 60px;
    font-weight: bold;
    font-size: 10px;
  }

  .info-input-prepend2 {
    display: inline-block;
    margin: 0 5px;
    width: 20px;
    font-size: 10px;
    color: rgba(0, 0, 0, 0.45);
  }

  .info-row_width50 {
    width: 50%;
  }

  .checkbox-text .el-checkbox__label {
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.45);
  }

  .order-table {
    /* width: 600px;
    height: 600px; */
    border-collapse: collapse;
    margin-bottom: 20px;

    white-space: nowrap;
    overflow: hidden;
    overflow-x: scroll;
  }

  .order-table-input>>>.el-input__inner {
    /* width: 60px; */
    border: 0px solid #fff;
    padding: 0px;
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

  /* .order-table-btn_add {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
  } */

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

  .info-order-submit {
    background-color: #FFD60C;
    border-color: #FFD60C;
    color: #000;
    width: 150px;
  }

  .purchase-product-img {
    width: 120px;
    height: 120px;
    border-radius: 10px;
    margin-right: 20px;
  }


  .order-table tr td,
  .order-table tr th {
    border: 1px solid rgba(0, 0, 0, 0.15);
    text-align: center;
    height: 30px;
    font-size: 10px;
    color: rgba(0, 0, 0, 0.65);
  }

  .info-radio .el-radio__label {
    font-size: 10px;
  }

  .order-purchase-form label {
    margin-bottom: 0px !important;
  }

  /deep/ .el-input--small .el-input__inner {
    height: 28px;
    line-height: 32px;
  }

  /deep/ .el-input.is-disabled .el-input__inner {
    cursor: pointer;
    background-color: #fff;
  }

  .order-purchase-upload {
    margin-left: 50px;
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

  .order-purchase-form>>>small.el-form-item {
    margin-bottom: 0px !important;
  }

  .order-purchase-form>>>.el-form-item--mini.el-form-item,
  .el-form-item--small.el-form-item {
    margin-bottom: 0px !important;
  }

  .order-purchase-form>>>.el-form-item__error {
    padding-left: 70px !important;
  }

  .order-purchase_select-prefix {
    /* padding-top: 10px; */
    /* background-color: grey;
    height: 28px; */
  }

</style>
