<template>
  <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
    <el-row :gutter="20">
      <el-col :span="12" v-if="slotData.id==''">
        <el-form-item label="地区" prop="zones">
          <el-select class="w-100" multiple v-model="slotData.zoneCode">
            <el-option
              v-for="item in regions"
              :key="item.isocode"
              :label="item.name"
              :value="item.isocode">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12" v-else>
        <el-form-item label="地区" prop="zones">
          <el-input class="w-100" disabled v-model="slotData.zone"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="起步价" prop="minimum">
          <el-input-number class="w-100" v-model="slotData.minimum" :min="0"></el-input-number>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="20">
      <el-col :span="12">
        <el-form-item label="首重" prop="firstWeight">
          <el-input-number class="w-100" v-model="slotData.firstWeight" :min="0"></el-input-number>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="续重价" prop="value">
          <el-input-number class="w-100" v-model="slotData.value" :min="0"></el-input-number>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  import axios from 'axios';

  export default {
    name: "ZoneDeliveryBaseForm",
    props: ["slotData", "isNewlyCreated", "readOnly"],
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      }
    },
    // computed: {},
    data() {
      return {
        rules: {
          zones: [{required: true, message: "必填", trigger: "blur"}],
          minimum: [{required: true, message: "必填", trigger: "blur"}],
          firstWeight: [{required: true, message: "必填", trigger: "blur"}],
          value: [{required: true, message: "必填", trigger: "blur"}]
        },
        regions: []
      };
    },
    created() {
      this.deliveryAddress = this.slotData.deliveryAddress;
      axios.get('/djbackoffice/address/getRegionsForDefaultCountry')
        .then(response => {
          this.regions = response.data;
          if (this.deliveryAddress.region && this.deliveryAddress.region.isocode) {
            this.onRegionChanged(this.deliveryAddress.region.isocode);
          }
        }).catch(error => {
          // this.$message.error(error.response);
        }
      );
    }
  };
</script>
