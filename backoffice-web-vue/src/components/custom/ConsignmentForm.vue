<template>
  <el-form ref="consignmentForm" :model="consignment" size="mini" label-position="left" label-width="100px" :rules="rules">
    <el-row type="flex" style="margin: 20px 0px;padding: 0px 100px" justify="center">
      <h6 style="font-size: 16px;font-weight: bold;">填写快递信息</h6>
    </el-row>
    <el-row type="flex" style="margin-left: 100px">
      <el-form-item label="选择快递方式" prop="carrierDetails.code">
        <el-select v-model="consignment.carrierDetails.code" placeholder="请选择" style="width: 270px" @change="handleChange">
          <el-option v-for="item in carriers" :key="item.code" :label="item.name" :value="item.code"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label-width="10px">
        <el-checkbox v-model="consignment.isOffline" size="mini" class="checkbox-text">线下物流
        </el-checkbox>
      </el-form-item>
    </el-row>

    <el-row type="flex" style="margin-left: 100px">
      <el-form-item label="填写快递单号" prop="trackingID">
        <el-input
          v-model="consignment.trackingID"
          placeholder="请填写"
          style="width: 270px"
          @change="handleChange">
        </el-input>
      </el-form-item>
    </el-row>

    <el-row type="flex" justify="center">
      <el-button class="btn-class" @click="onSubmit">确认</el-button>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: 'ConsignmentForm',
    props: {
    },
    methods: {
      async getCarriers () {
        const url = this.apis().getCarriers();
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.carriers = result;
      },
      onSubmit () {
        this.$refs['consignmentForm'].validate((valid) => {
          if (valid) {
            this.$emit('onSubmit', this.consignment);
          }
        });
      },
      handleChange () {
        this.consignment.isOffline = false;
      }
    },
    data () {
      var checkCarrierDetailsCode = (rule, value, callback) => {
        if (!this.consignment.isOffline && !value) {
          return callback(new Error('请选择快递方式'));
        } else {
          callback();
        }
      };
      var checkTrackingID = (rule, value, callback) => {
        if (!this.consignment.isOffline && !value) {
          return callback(new Error('请填写快递单号'));
        } else {
          callback();
        }
      };
      return {
        carriers: [],
        consignment: {
          trackingID: '',
          carrierDetails: {
            code: '',
            name: ''
          },
          isOffline: false
        },
        rules: {
          'carrierDetails.code': [
            { type: 'string', validator: checkCarrierDetailsCode, trigger: 'change' }
          ],
          'trackingID': [
            { type: 'string', validator: checkTrackingID, trigger: 'blur' }
          ]
        }
      }
    },
    created () {
      this.getCarriers();
    },
    destroyed () {
      this.consignment = {
        trackingID: '',
        carrierDetails: {
          code: '',
          name: ''
        },
        isOffline: false
      }
    }
  }
</script>

<style scoped>

</style>
