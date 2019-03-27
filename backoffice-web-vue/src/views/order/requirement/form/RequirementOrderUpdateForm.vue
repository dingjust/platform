<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly"
             :rules="rules">
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="预计交货时间" prop="expectedDeliveryDate">
            <el-date-picker class="w-100"
                            type="date"
                            v-model="slotData.details.expectedDeliveryDate"
                            placeholder="选择日期"
                            value-format="timestamp">
            </el-date-picker>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="期望价格" prop="maxExpectedPrice">
            <el-input-number class="w-100"
                             v-model="slotData.details.maxExpectedPrice">
            </el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="加工类型" prop="machiningType">
            <el-select class="w-100" v-model="slotData.details.machiningType">
              <el-option v-for="item in machiningTypes"
                         :key="item.code"
                         :label="item.name"
                         :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="生产区域" prop="productiveOrientations">
            <el-select class="w-100" v-model="slotData.details.productiveOrientations"
                       value-key="isocode" multiple>
              <el-option
                v-for="item in regions"
                :key="item.isocode"
                :label="item.name"
                :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="是否提供样衣" prop="samplesNeeded">
            <el-radio-group v-model="slotData.details.samplesNeeded">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="是否需要发票" prop="invoiceNeeded">
            <el-radio-group v-model="slotData.details.invoiceNeeded">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="是否需要打样" prop="proofingNeeded">
            <el-radio-group v-model="slotData.details.proofingNeeded">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="18">
          <el-form-item label="订单备注" prop="remarks">
            <el-input v-model="slotData.remarks"></el-input>
          </el-form-item>
        </el-col>
      </el-row>

    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'RequirementOrderUpdateForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        return this.$refs['form'].validate(callback);
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

    },
    computed: {
      uploadFormData: function () {
        return {
          fileFormat: 'DefaultFileFormat',
        };
      },
      headers: function () {
        return {
          Authorization: this.$store.getters.token
        }
      }
    },
    data() {
      return {
        regions: [],
        machiningTypes: this.$store.state.EnumsModule.machiningTypes,
        rules: {
          expectedDeliveryDate: [{required: true, message: '必填', trigger: 'blur'}],
        },
      }
    },
    created() {
      this.getRegions();
    }
  }
</script>
