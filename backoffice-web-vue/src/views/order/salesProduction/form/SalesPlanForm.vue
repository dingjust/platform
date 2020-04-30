<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="sales-plan-form-title">
            <h6>录入销售计划</h6>
          </div>
        </el-col>
      </el-row>
      <div class="pt-2"></div>
      <el-row>
        <el-col :span="4"></el-col>
      </el-row>
      <el-form ref="form" :model="form" label-width="80px">
        <el-row type="flex">
          <el-col :span="4">
            <el-form-item label="计划单号">
              <el-input v-model="form.code" placeholder="系统自动生成" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item label="计划名称">
              <el-input v-model="form.name" placeholder="请输入"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="10">
            <el-form-item label="预计销售时间" class="form-date-item" label-width="120">
              <el-date-picker v-model="form.date" type="daterange" range-separator="~" start-placeholder="开始日期"
                end-placeholder="结束日期">
              </el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="4">
            <h6>生产要求</h6>
          </el-col>
        </el-row>
        <el-row type="flex">
          <el-col :span="18">
            <MTAVAT :machiningTypes.sync="form.machiningTypes" :needVoice.sync="form.needVoice" :tax.sync="form.tax" />
          </el-col>
        </el-row>
        <my-address-form :vAddress.sync="form.address" />
        <el-row justify="start" align="middle" :gutter="20">
          <el-col :span="6">
            <el-form-item label="联系人" :rules="[
                { required: true, message: '请填写收货人', trigger: 'blur'}]" prop="address.fullname">
              <el-input placeholder="名称" v-model="form.address.fullname" size="mini">
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item class="purchase-form-item" :rules="[
                { required: true, message: '请填写联系方式', trigger: 'blur'}]" prop="address.cellphone">
              <el-row type="flex" align="middle">
                <h6 class="info-input-prepend">联系方式</h6>
                <el-input placeholder="电话" v-model="form.address.cellphone" size="mini">
                </el-input>
              </el-row>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import MTAVAT from '@/components/custom/order-form/MTAVAT';
  import MyAddressForm from '@/components/custom/order-form/MyAddressForm';

  export default {
    name: 'SalesPlanForm',
    components: {
      MTAVAT,
      MyAddressForm
    },
    computed: {

    },
    methods: {

    },
    data() {
      return {
        form: {
          code: '',
          name: '',
          date: '',
          machiningTypes: 'LABOR_AND_MATERIAL',
          needVoice: false,
          tax: 0.03,
          address: {

          }
        },

      };
    },
    created() {

    },
    mounted() {

    }
  };

</script>

<style scoped>
  .sales-plan-form-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

</style>
