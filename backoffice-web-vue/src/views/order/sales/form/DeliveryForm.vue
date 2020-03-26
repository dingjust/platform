<template>
  <div>
    <el-row>
      <el-col :span="2">
        <div class="orders-list-title">
          <h6>发货</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-form ref="form" :model="form" label-width="80px" label-position="left" :rules="rules" hide-required-asterisk>
      <el-row type="flex">
        <h6>发货信息</h6>
      </el-row>
      <div class="sales-deliver-form-content">
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item label="发货人">
              <el-input v-model="slotData.seller.name" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="联系方式">
              <el-input v-model="slotData.seller.contactPhone" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item prop="logistics">
              <template slot="label">
                <h6 class="titleTextClass">物流公司<span :style="form.isOffline ? 'color: white' : 'color: #F56C6C'">*</span></h6>
              </template>
              <el-select v-model="form.logistics" placeholder="请选择" :disabled="form.isOffline" style="width:100%">
                <el-option v-for="item in carriers" :key="item.code" :label="item.name" :value="item.code">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item prop="logisticsCode">
              <template slot="label">
                <h6 class="titleTextClass">物流单号<span :style="form.isOffline ? 'color: white' : 'color: #F56C6C'">*</span></h6>
              </template>
              <el-input v-model="form.logisticsCode" :disabled="form.isOffline"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <div style="padding-top:5px;">
              <el-checkbox v-model="form.isOffline" @change="onOfflineChange">线下物流<span
                  style="color:rgba(255, 150, 153, 1)">（勾选后无需填写发货方式和单号）</span></el-checkbox>
            </div>
          </el-col>
        </el-row>
      </div>
      <el-row type="flex">
        <h6>收货信息</h6>
      </el-row>
      <div class="sales-deliver-form-content">
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item label="收货人">
              <el-input v-model="slotData.deliveryAddress.fullname" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="联系方式">
              <el-input v-model="slotData.deliveryAddress.cellphone" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="联系地址">
              <el-input v-model="slotData.deliveryAddress.details" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </div>
      <el-row type="flex" justify="center">
        <!-- <el-col :span="12"> -->
        <el-button class="sales-order-btn" @click="onSubmit">确定</el-button>
        <!-- </el-col> -->
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'DeliveryForm',
    props: ['code', 'slotData'],
    components: {},
    computed: {},
    methods: {
      onSubmit () {
        if (this.form.isOffline) {
          this._onSubmit();
          return;
        }
        this.$refs['form'].validate((valid) => {
          if (valid) {
            this._onSubmit();
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      _onSubmit () {
        const formData = {
          trackingID: this.form.logisticsCode,
          carrierCode: this.form.logistics,
          offlineConsignment: this.form.isOffline
        }
        this.$emit('onSubmit', formData);
      },
      async getCarriers () {
        const url = this.apis().getCarriers();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.carriers = result;
      },
      onOfflineChange (v) {
        this.$refs['form'].resetFields();
        if (this.form.isOffline) {
          this.form.logistics = '';
          this.form.logisticsCode = '';
        }
      }
    },
    data () {
      return {
        carriers: [],
        form: {
          logistics: '',
          logisticsCode: '',
          isOffline: false
        },
        rules: {
          logistics: [{required: true, message: '请选择物流公司', trigger: 'change'}],
          logisticsCode: [{required: true, message: '请填写物流单号', trigger: 'change'}]
        }
      };
    },
    created () {
      console.log('------------------------')
      console.log(this.slotData);
      this.getCarriers();
    },
    mounted () {}
  };
</script>
<style>
  .report {
    margin-bottom: 10px;
  }

  .sales-deliver-form-content {
    padding: 10px 20px 10px 20px;
  }

  .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 65px;
    font-size: 14px;
    /*font-weight: bold;*/
  }
</style>
