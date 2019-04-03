<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :rules="rules"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="24">
          <el-form-item label="物流单号" prop="trackingID">
            <el-input placeholder="请输入物流单号" v-model="slotData.trackingID"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="24">
          <el-form-item label="物流企业" prop="carrierDetails">
            <el-select v-model="slotData.carrierDetails" class="w-100" value-key="code">
              <el-option v-for="item in carriers" :key="item.code"
                         :label="item.name" :value="item">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'ConsignmentForm',
    props: ['slotData', 'readOnly'],
    mixins: [],
    computed: {},
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      async getCarriers() {
        const url = this.apis().getCarriers();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.carriers = result;
      }
    },
    data() {
      return {
        carriers: [],
        rules: {
          trackingID: [{required: true, message: '必填', trigger: 'blur'}],
          carrierDetails: [{required: true, message: '必填', trigger: 'blur'}],
        },
      }
    },
    created() {
      this.getCarriers();
    }
  }
</script>
