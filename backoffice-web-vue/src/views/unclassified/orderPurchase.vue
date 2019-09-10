<template>
  <div class="animated fadeIn content">
    <el-dialog :visible.sync="productSelectVisible" width="40%" class="purchase-dialog" append-to-body>
      <product-select :page="page" @onSearch="onSearch" @onSelect="onProductSelect" />
    </el-dialog>
    <el-card class="box-card">
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
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend">合作商</h6>
              <el-input placeholder="名称" v-model="form.supplierName" size="mini">
                <el-select v-model="form.supplierName" slot="append" placeholder="请选择">
                  <el-option label="123" value="123"></el-option>
                  <el-option label="1234" value="1234"></el-option>
                  <el-option label="1324" value="1324"></el-option>
                </el-select>
              </el-input>
            </el-row>
          </el-col>
          <el-col :span="6">
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend">联系人</h6>
              <el-input placeholder="姓名" v-model="form.contactName" size="mini">
              </el-input>
            </el-row>
          </el-col>
          <el-col :span="6">
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend">联系方式</h6>
              <el-input placeholder="电话号码" v-model="form.contactPhone" size="mini">
              </el-input>
            </el-row>
          </el-col>
        </el-row>
        <el-row class="info-order-row">
          <form-label label="生产详情" />
        </el-row>
        <template v-for="(product,productIndex) in form.entries">
          <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="20">
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">产品名</h6>
                <el-input placeholder="名称" v-model="product.name" size="mini" :disabled="true">
                  <el-button slot="append" @click="onpenSelect(productIndex)">点击选择</el-button>
                </el-input>
              </el-row>
            </el-col>
            <el-col :span="8">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">订单报价</h6>
                <el-input placeholder="输入方式" v-model="product.quotePrice" size="mini">
                </el-input>
              </el-row>
            </el-col>
            <el-col :span="6">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">交货日期</h6>
                <el-date-picker v-model="product.deliverDate" type="date" placeholder="选择日期">
                </el-date-picker>
              </el-row>
            </el-col>
            <el-col :span="2">
              <el-button type="text" v-if="productIndex!=0" @click="removeRow(productIndex)">删除</el-button>
            </el-col>
          </el-row>
          <el-row type="flex" v-if="product!=''">
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
          <el-row class="info-order-row" v-if="product!=''" type="flex" justify="start" align="middle" :gutter="20">
            <el-col :span="7">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">合作方式</h6>
                <el-radio class="info-radio" v-model="product.cooperationMode" label="1">清加工</el-radio>
                <el-radio class="info-radio" v-model="product.cooperationMode" label="2">包工包料</el-radio>
              </el-row>
            </el-col>
            <el-col :span="7">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">承担运费</h6>
                <el-radio class="info-radio" v-model="product.fare" label="1">甲方</el-radio>
                <el-radio class="info-radio" v-model="product.fare" label="2">乙方</el-radio>
              </el-row>
            </el-col>
            <el-col :span="6">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">是否开发票</h6>
                <el-radio class="info-radio" v-model="product.invoice" label="1">不开发票</el-radio>
                <el-radio class="info-radio" v-model="product.invoice" label="2">开发票</el-radio>
              </el-row>
            </el-col>
            <el-col :span="4">
              <el-select v-model="product.invoicePercent" placeholder="税点">
                <el-option v-for="item in invoicePercent" :key="item.value" :label="item.label" :value="item.value">
                </el-option>
              </el-select>
            </el-col>
          </el-row>
          <el-row :gutter="10" class="info-order-row" v-if="product!=''" type="flex" align="middle">
            <el-col :span="6">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">送货地址</h6>
                <el-select class="w-100" v-model="product.address.region" value-key="isocode"
                  @change="(val)=>onRegionChanged(val,productIndex)">
                  <el-option v-for="item in regions" :key="item.isocode" :label="item.name" :value="item">
                  </el-option>
                </el-select>
              </el-row>
            </el-col>
            <el-col :span="4">
              <el-select class="w-100" v-model="product.address.city" @change="(val)=>onCityChanged(val,productIndex)"
                value-key="code">
                <el-option v-for="item in product.cities" :key="item.code" :label="item.name" :value="item">
                </el-option>
              </el-select>
            </el-col>
            <el-col :span="4">
              <el-select class="w-100" v-model="product.address.cityDistrict" value-key="code">
                <el-option v-for="item in product.cityDistricts" :key="item.code" :label="item.name" :value="item">
                </el-option>
              </el-select>
            </el-col>
            <el-col :span="6">
              <el-row type="flex" align="middle">
                <el-input placeholder="详细地址" v-model="product.address.line1" size="mini">
                </el-input>
              </el-row>
            </el-col>
            <el-col :span="4">
              <el-button size="mini">选择</el-button>
            </el-col>
          </el-row>
          <el-row class="info-order-row" v-if="product!=''" type="flex" justify="start" align="middle" :gutter="20">
            <el-col :span="6">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">收货人</h6>
                <el-input placeholder="名称" v-model="product.receiveName" size="mini">
                </el-input>
              </el-row>
            </el-col>
            <el-col :span="6">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">联系方式</h6>
                <el-input placeholder="电话" v-model="product.contactPhone" size="mini">
                </el-input>
              </el-row>
            </el-col>
          </el-row>
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
        <el-row class="info-order-row" type="flex" justify="start" align="middle" :gutter="40">
          <el-col :span="6">
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend">有无定金</h6>
              <el-radio class="info-radio" v-model="form.hasDeposit" :label="true">有定金</el-radio>
              <el-radio class="info-radio" v-model="form.hasDeposit" :label="false">无定金</el-radio>
            </el-row>
          </el-col>
          <el-col :span="8">
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend">尾款期数</h6>
              <el-radio class="info-radio" v-model="form.periods" :label="1">1期尾款</el-radio>
              <el-radio class="info-radio" v-model="form.periods" :label="2">2期尾款</el-radio>
              <el-radio class="info-radio" v-model="form.periods" :label="3">月结</el-radio>
            </el-row>
          </el-col>
          <el-col :span="10">
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend" style="margin-right:20px;width:80px">选用我的账务方案</h6>
              <el-radio class="info-radio" v-model="form.plan" label="1">方案1</el-radio>
              <el-radio class="info-radio" v-model="form.plan" label="2">方案2</el-radio>
              <el-radio class="info-radio" v-model="form.plan" label="3">方案3</el-radio>
            </el-row>
          </el-col>
        </el-row>
        <el-row class="info-order-row" v-if="form.hasDeposit" type="flex" justify="start" align="middle" :gutter="10">
          <el-col :span="7">
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend">定金</h6>
              <el-input placeholder="选择事件" class="purchase-order-input_select" v-model="form.deposit.event"
                :disabled="true" size="mini">
                <template slot="prepend">事件</template>
                <el-select slot="append" v-model="form.deposit.event" placeholder="请选择">
                  <el-option label="确认订单" value="确认订单"></el-option>
                  <el-option label="签署合同" value="签署合同"></el-option>
                  <el-option label="确认收货" value="确认收货"></el-option>
                  <el-option label="确认对账" value="确认对账"></el-option>
                  <el-option label="收到发票 " value="收到发票 "></el-option>
                </el-select>
              </el-input>
            </el-row>
          </el-col>
          <el-col :span="6">
            <el-row type="flex" align="middle" justify="start">
              <h6 class="info-input-prepend2">后</h6>
              <el-input placeholder="选择天数" class="purchase-order-input_select" v-model="form.deposit.time"
                :disabled="true" size="mini">
                <template slot="prepend">时长</template>
                <el-select slot="append" v-model="form.deposit.time" placeholder="请选择">
                  <el-option label="5" value="5"></el-option>
                  <el-option label="7" value="7"></el-option>
                  <el-option label="15" value="15"></el-option>
                </el-select>
              </el-input>
            </el-row>
          </el-col>
          <el-col :span="4">
            <el-row type="flex" align="middle" justify="start">
              <h6 class="info-input-prepend2">天</h6>
              <el-input class="purchase-order-input_select" v-model="form.deposit.range" :disabled="true" size="mini">
                <el-select slot="append" v-model="form.deposit.range">
                  <el-option label="以内" value="以内"></el-option>
                  <el-option label="以外" value="以外"></el-option>
                </el-select>
              </el-input>
            </el-row>
          </el-col>
          <el-col :span="7">
            <el-row type="flex" align="middle" justify="start">
              <h6 class="info-input-prepend2" style="width: 40px;">付款</h6>
              <el-input class="purchase-order-input_select" v-model="form.deposit.percent*100+'%'" :disabled="true"
                size="mini">
                <template slot="prepend">金额比例</template>
                <el-select slot="append" v-model="form.deposit.percent">
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
              </el-input>
            </el-row>
          </el-col>
        </el-row>
        <el-row class="info-order-row" v-if="form.periods!=3" type="flex" justify="start" align="middle" :gutter="10">
          <el-col :span="7">
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend">第1期尾款</h6>
              <el-input placeholder="选择事件" class="purchase-order-input_select" v-model="form.balance1.event"
                :disabled="true" size="mini">
                <template slot="prepend">事件</template>
                <el-select slot="append" v-model="form.balance1.event" placeholder="请选择">
                  <el-option label="确认订单" value="确认订单"></el-option>
                  <el-option label="签署合同" value="签署合同"></el-option>
                  <el-option label="确认收货" value="确认收货"></el-option>
                  <el-option label="确认对账" value="确认对账"></el-option>
                  <el-option label="收到发票 " value="收到发票 "></el-option>
                </el-select>
              </el-input>
            </el-row>
          </el-col>
          <el-col :span="6">
            <el-row type="flex" align="middle" justify="start">
              <h6 class="info-input-prepend2">后</h6>
              <el-input placeholder="选择天数" class="purchase-order-input_select" v-model="form.balance1.time"
                :disabled="true" size="mini">
                <template slot="prepend">时长</template>
                <el-select slot="append" v-model="form.balance1.time" placeholder="请选择">
                  <el-option label="5" value="5"></el-option>
                  <el-option label="7" value="7"></el-option>
                  <el-option label="15" value="15"></el-option>
                </el-select>
              </el-input>
            </el-row>
          </el-col>
          <el-col :span="4">
            <el-row type="flex" align="middle" justify="start">
              <h6 class="info-input-prepend2">天</h6>
              <el-input class="purchase-order-input_select" v-model="form.balance1.range" :disabled="true" size="mini">
                <el-select slot="append" v-model="form.balance1.range">
                  <el-option label="以内" value="以内"></el-option>
                  <el-option label="以外" value="以外"></el-option>
                </el-select>
              </el-input>
            </el-row>
          </el-col>
          <el-col :span="7">
            <el-row type="flex" align="middle" justify="start">
              <h6 class="info-input-prepend2" style="width: 40px;">付款</h6>
              <el-input class="purchase-order-input_select" v-model="form.balance1.percent*100+'%'" :disabled="true"
                size="mini">
                <template slot="prepend">金额比例</template>
                <el-select slot="append" v-model="form.balance1.percent">
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
              </el-input>
            </el-row>
          </el-col>
        </el-row>
        <el-row class="info-order-row" v-if="form.periods==2" type="flex" justify="start" align="middle" :gutter="10">
          <el-col :span="7">
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend">第2期尾款</h6>
              <el-input placeholder="选择事件" class="purchase-order-input_select" v-model="form.balance2.event"
                :disabled="true" size="mini">
                <template slot="prepend">事件</template>
                <el-select slot="append" v-model="form.balance2.event" placeholder="请选择">
                  <el-option label="确认订单" value="确认订单"></el-option>
                  <el-option label="签署合同" value="签署合同"></el-option>
                  <el-option label="确认收货" value="确认收货"></el-option>
                  <el-option label="确认对账" value="确认对账"></el-option>
                  <el-option label="收到发票 " value="收到发票 "></el-option>
                </el-select>
              </el-input>
            </el-row>
          </el-col>
          <el-col :span="6">
            <el-row type="flex" align="middle" justify="start">
              <h6 class="info-input-prepend2">后</h6>
              <el-input placeholder="选择天数" class="purchase-order-input_select" v-model="form.balance2.time"
                :disabled="true" size="mini">
                <template slot="prepend">时长</template>
                <el-select slot="append" v-model="form.balance2.time" placeholder="请选择">
                  <el-option label="5" value="5"></el-option>
                  <el-option label="7" value="7"></el-option>
                  <el-option label="15" value="15"></el-option>
                </el-select>
              </el-input>
            </el-row>
          </el-col>
          <el-col :span="4">
            <el-row type="flex" align="middle" justify="start">
              <h6 class="info-input-prepend2">天</h6>
              <el-input class="purchase-order-input_select" v-model="form.balance2.range" :disabled="true" size="mini">
                <el-select slot="append" v-model="form.balance2.range">
                  <el-option label="以内" value="以内"></el-option>
                  <el-option label="以外" value="以外"></el-option>
                </el-select>
              </el-input>
            </el-row>
          </el-col>
          <el-col :span="7">
            <el-row type="flex" align="middle" justify="start">
              <h6 class="info-input-prepend2" style="width: 200px;">支付剩余全部款项</h6>
            </el-row>
          </el-col>
        </el-row>
        <el-row class="info-order-row" v-if="form.periods==3" type="flex" justify="start" align="middle" :gutter="10">
          <el-col :span="7">
            <el-row type="flex" align="middle">
              <h6 class="info-input-prepend">月结</h6>
              <el-input placeholder="选择事件" class="purchase-order-input_select" v-model="form.balance2.event"
                :disabled="true" size="mini">
                <template slot="prepend">事件</template>
                <el-select slot="append" v-model="form.monthBalance.event" placeholder="请选择">
                  <el-option label="确认订单" value="确认订单"></el-option>
                  <el-option label="签署合同" value="签署合同"></el-option>
                  <el-option label="确认收货" value="确认收货"></el-option>
                  <el-option label="确认对账" value="确认对账"></el-option>
                  <el-option label="收到发票 " value="收到发票 "></el-option>
                </el-select>
              </el-input>
            </el-row>
          </el-col>
          <el-col :span="12">
            <el-row type="flex" align="middle" justify="start">
              <h6 class="info-input-prepend2" style="width: 200px">后, 次月月底支付剩余全部款项</h6>
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
              <el-select v-model="form.QC" placeholder="请选择">
                <el-option label="采购部-刘少立" value="确认订单"></el-option>
                <el-option label="采购部-刘少立" value="签署合同"></el-option>
                <el-option label="采购部-刘少立" value="确认收货"></el-option>
                <el-option label="采购部-刘少立" value="确认对账"></el-option>
                <el-option label="采购部-刘少立 " value="收到发票 "></el-option>
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
  import ImagesUpload from '@/components/custom/ImagesUpload';

  export default {
    name: 'orderPurchase',
    components: {
      OrdersInfoItem,
      FormLabel,
      ProductSelect,
      ImagesUpload
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
        if (this.form.hasDeposit && this.form.periods == 2) {
          result = '定金+2期尾款\n        定金：在双方' + this.form.deposit.event + '后，甲方应向乙方支付生效订单总金额的' + this.form.deposit.percent * 100 +
            '%为定金\n        支付方式：甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,在' + this.form.balance1.event + '后' + this.form.balance1.time +
            '日' + this.form.balance1.range + '支付合同总价的' + this.form.balance1.percent * 100 + '%。在产品入库并经甲方检验全部产品合格' +
            this.form.balance2.event + '后' +
            this.form.balance2.time + '日' + this.form.balance2.range +
            '未发现任何产品质量问题的，则甲方向乙方支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }
        if (this.form.hasDeposit && this.form.periods == 1) {
          result = '定金+1期尾款\n        定金：在双方' + this.form.deposit.event + '后，甲方应向乙方支付生效订单总金额的' + this.form.deposit.percent * 100 +
            '%为定金\n        支付方式：甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库完成在' + this.form.balance1.event + '后' + this.form.balance1.time +
            '日' + this.form.balance1.range + '未发现任何产品质量问题的则甲方向乙方支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }
        if (!this.form.hasDeposit && this.form.periods == 1) {
          result = '无定金1期尾款\n        甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库完成在' + this.form.balance1.event + '后' + this.form.balance1.time + '日' +
            this.form.balance1.range + '未发现任何产品质量问题的则甲方向乙方支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。'
        }
        if (!this.form.hasDeposit && this.form.periods == 2) {
          result = '无定金2期尾款\n        甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,在' + this.form.balance1.event + '后' + this.form.balance1.time + '日' +
            this.form.balance1.range + '支付合同总价的' + this.form.balance1.percent * 100 + '%。在产品入库并经甲方检验全部产品合格' + this
            .form.balance2.event + '后' + this.form.balance2.time + '日' + this.form.balance2.range +
            '未发现任何产品质量问题的，则甲方向乙方支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }
        if (this.form.hasDeposit && this.form.periods == 3) {
          result = '有定金+月结\n        定金：在双方' + this.form.deposit.event + '后，甲方应向乙方支付生效订单总金额的' + this.form.deposit.percent * 100 +
            '%为定金\n        支付方式：甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,甲方在' + this.form.monthBalance +
            '完成的次月月底支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }
        if (!this.form.hasDeposit && this.form.periods == 3) {
          result = '无定金月结\n        甲方收到乙方交付的全部产品并经甲方检验全部产品合格入库,甲方在'+this.form.monthBalance.event+'完成的次月月底支付剩余全部款项（以双方确认的对账单金额为准）。若发现质量问题的，则按甲乙双方对质量的相关条款处理。';
        }

        return result;
      },
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
        var entry = {
          thumbnail: product.thumbnail,
          name: product.name,
          code: product.code,
          variants: variants,
          sizes: sizesSet,
          colors: colorsSet,
          quotePrice: '',
          deliverDate: '',
          cooperationMode: '',
          fare: '',
          invoice: '',
          invoicePercent: '',
          address: {
            city: '',
            cityDistrict: '',
            region: '',
            line1: ''
          },
          cities: [],
          cityDistricts: [],
          receiveName: '',
          contactPhone: ''
        };
        this.form.entries.pop();
        this.form.entries.push(entry);
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
        this.form.entries.push('');
      },
      removeRow(index) {
        this.form.entries.splice(index, 1);
      },
      async getRegions() {
        const url = this.apis().getRegions();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
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

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
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

        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.form.entries[index].cityDistricts = result;
      },
      onSubmit() {

      }
    },
    data() {
      return {
        productSelectVisible: false,
        currentProductIndex: 0,
        regions: [],
        invoicePercent: [{
            label: '6%税点',
            value: '1'
          },
          {
            label: '8%税点',
            value: '2'
          },
          {
            label: '11%税点',
            value: '3'
          }

        ],
        form: {
          supplierName: "",
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
          entries: [''],
          contactName: '',
          contactPhone: '',
          hasDeposit: false,
          periods: 1,
          plan: '1',
          deposit: {
            event: '',
            time: '5',
            range: '以内',
            percent: 0.3
          },
          balance1: {
            event: '',
            time: '5',
            range: '以内',
            percent: 0.3
          },
          balance2: {
            event: '',
            time: '5',
            range: '以内',
            percent: 0.3
          },
          monthBalance: {
            event: '',
          },
          QC: {},
          remarks: '',
          attachments: []
        },
      }
    },
    created() {
      this.onSearch();
      this.getRegions();
    },
    mounted() {}
  }

</script>
<style>
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
    padding: 10px 60px;
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

  .order-table-input .el-input__inner {
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

  .purchase-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .purchase-dialog-header {
    padding: 0px !important;
  }

  .purchase-dialog .el-dialog__header {
    padding: 0px !important;
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

  label {
    margin-bottom: 0px !important;
  }

  .el-input--small .el-input__inner {
    height: 28px;
    line-height: 32px;
  }

  .el-input.is-disabled .el-input__inner {
    cursor: pointer;
    background-color: #fff;
  }

  .order-purchase-upload {
    margin-left: 50px;
  }

  .order-purchase-upload .el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .order-purchase-upload .el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

</style>
