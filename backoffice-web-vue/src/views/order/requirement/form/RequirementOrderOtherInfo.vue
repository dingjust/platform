<template>
  <div class="othen-info">
    <el-row type="flex" :gutter="20">
      <el-col :span="12">
        <el-form-item>
          <template slot="label">
            <h6 class="titleTextClass">订单尺码</h6>
          </template>
          <el-radio-group v-model="formData.details.sizeType">
            <el-radio v-for="item of RequirementSizeType" border :label="item.code" :key="item.code">{{item.name}}</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item>
          <template slot="label">
            <h6 class="titleTextClass">订单颜色</h6>
          </template>
          <el-radio-group v-model="formData.details.colorType">
            <el-radio v-for="item of RequirementColorType" border :label="item.code" :key="item.code">{{item.name}}</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" :gutter="20">
      <el-col :span="12">
        <el-form-item>
          <template slot="label">
            <h6 class="titleTextClass">工厂规模</h6>
          </template>
          <el-select v-model="formData.details.populationScale" placeholder="请选择" style="width: 240px">
            <el-option v-for="item in populationScales" :key="item.code" :label="item.name" :value="item.code">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item>
          <template slot="label">
            <h6 class="titleTextClass">生产模式</h6>
          </template>
          <el-select v-model="formData.details.productionMode" placeholder="请选择" style="width: 240px">
            <el-option v-for="item in ProductionModes" :key="item.code" :label="item.name" :value="item.code">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>
    <pay-plan-form :formData="formData.details.payPlan" :isUseForOrder="true" />
    <!-- <my-address-form v-if="isCreated" :vAddress.sync="shippingAddress" :showContact="false"/>
    <el-row type="flex" :gutter="20" v-if="!isCreated">
      <el-col :span="12">
        <el-form-item>
          <template slot="label">
            <h6 class="titleTextClass">所在位置</h6>
          </template>
          <el-input v-model="formData.details.address"></el-input>
        </el-form-item>
      </el-col>
    </el-row> -->
  </div>
</template>

<script>
import {
  MyAddressForm,
  PayPlanForm
} from '@/components'
export default {
  name: 'RequirementOrderOtherInfo',
  components: { PayPlanForm, MyAddressForm },
  props: ['formData', 'isCreated'],
  data () {
    return {
      shippingAddress: {},
      populationScales: this.$store.state.EnumsModule.populationScales,
      ProductionModes: this.$store.state.EnumsModule.ProductionModes,
      RequirementSizeType: this.$store.state.EnumsModule.RequirementSizeType,
      RequirementColorType: this.$store.state.EnumsModule.RequirementColorType
    }
  },
  watch: {
    shippingAddress: {
      handler(val, oldVal) {
        this.formData.details['provinceStr'] = val.region.name
        this.formData.details['cityStr'] = val.city.name
        this.formData.details['districtStr'] = val.cityDistrict.name
        this.formData.details['address'] = val.region.name + val.city.name + val.cityDistrict.name +val.line1
      },
      deep: true
    },
  }
}
</script>

<style scoped>
  .titleTextClass {
    text-align: justify;
    text-align-last: justify;
    display: inline-block;
    width: 63px;
    font-weight: bold;
  }

</style>