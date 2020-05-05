<template>
  <div class="animated fadeIn">
    <el-row class="basic-form-row_top" type="flex" align="middle">
      <h6 class="info-input-prepend_top">接单内容</h6>
    </el-row>
    <el-row type="flex" :gutter="20">
      <el-col :span="8">
        <el-form-item label="接单价格" label-width="80px">
          <el-input placeholder="请输入接单价格" size="mini"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="交货日期" label-width="80px">
          <el-date-picker type="date" placeholder="请选择日期"></el-date-picker>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row class="basic-form-row_top" type="flex" align="middle">
      <h6 class="info-input-prepend_top">生产要求</h6>
    </el-row>
    <el-row style="padding-left: 12px">
      <el-col :span="22">
        <MTAVAT :machiningTypes.sync="form.machiningTypes" :needVoice.sync="form.needVoice" :tax.sync="form.tax" />
      </el-col>
    </el-row>
    <el-row>
      <my-address-form :vAddress.sync="form.address" />
    </el-row>
  </div>
</template>

<script>
  import MTAVAT from '../../../../components/custom/order-form/MTAVAT';
  import MyAddressForm from '../../../../components/custom/order-form/MyAddressForm';
  export default {
    name: 'ProductionTaskReceivingForm',
    components: {MyAddressForm, MTAVAT},
    methods: {
    },
    data () {
      return {
        machiningTypes: this.$store.state.EnumsModule.machiningTypes,
        form: {
          machiningTypes: '',
          needVoice: '',
          tax: '',
          address: {}
        }
      }
    },
    created () {
    }
  }
</script>

<style scoped>
  .basic-form-row_top {
    padding-left: 8px;
    margin-bottom: 10px;
  }
  .basic-form-row {
    padding-left: 7px;
    /*margin-bottom: 20px;*/
  }

  .info-input-prepend_top {
    display: inline-block;
    margin: 0 5px;
    /*margin-top: 5px; */
    width: 60px;
    font-size: 14px;
    font-weight: 500;
    padding-top: 2px;
  }

  .info-input-prepend {
    display: inline-block;
    /*margin-top: 5px; */
    width: 100px;
    font-size: 12px;
    font-weight: 500;
    padding-top: 9px;
    padding-left: 10px;
  }

  .form-label_bubble {
    width: 5px;
    height: 5px;
    border-radius: 50%;
    background: rgba(255, 214, 12, 1);
    text-align: center;
  }
</style>
