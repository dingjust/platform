<template>
  <div class="animated fadeIn content form-container">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>创建发货单</h6>
          </div>
        </el-col>
      </el-row>
      <el-form :inline="true" ref="form" label-position="left" label-width="70px" :model="formData">
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="3">
            <img width="100px" height="100px"
              :src="taskData.product.thumbnail!=null&&taskData.product.thumbnail.length!=0?taskData.product.thumbnail.url:'static/img/nopicture.png'">
          </el-col>
          <el-col :span="21">
            <el-row type="flex" style="padding: 10px 0px">
              <el-col :span="8">
                <h6 class="baisc-lable">产品名称：{{taskData.product?taskData.product.name:''}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="baisc-lable">发货方：{{taskData.shipParty!=null?taskData.shipParty.name:''}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="baisc-lable">收货方：{{taskData.receiveParty!=null?taskData.receiveParty.name:''}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <el-col :span="8">
                <h6 class="baisc-lable">货号：{{taskData.product.skuId!=null?nulltaskData.product.skuId:''}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="baisc-lable">发货负责人：{{taskData.merchandiser!=null?taskData.merchandiser.name:''}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="baisc-lable">联系方式：{{taskData.merchandiser.mobileNumber}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <h6 class="baisc-lable">收货地址：{{taskData.deliveryAddress!=null?taskData.deliveryAddress.details:''}}</h6>
            </el-row>
            <el-row type="flex" align="middle">
              <el-col :span="8">
                <el-form-item label="发货方式" prop="consignment.carrierDetails.code" label-width="120px"
                  :rules="{required: !formData.isOfflineConsignment, message: '不能为空', trigger: 'blur'}">
                  <el-select v-model="formData.consignment.carrierDetails.code"
                    :disabled="formData.isOfflineConsignment" :placeholder="''">
                    <template v-for="item in carriers">
                      <el-option :label="item.name" :value="item.code" :key="item.code"></el-option>
                    </template>
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="发货单号" prop="consignment.trackingID" label-width="120px"
                  :rules="{required: !formData.isOfflineConsignment, message: '不能为空', trigger: 'blur'}">
                  <el-input v-model="formData.consignment.trackingID" style="width: 194px"
                    :disabled="formData.isOfflineConsignment"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-checkbox v-model="formData.isOfflineConsignment" @change="isOnline"></el-checkbox>
                <span class="basci-label">线下物流<span style="color: #F56C6C">(勾选后无需填写发货方式和单号)</span></span>
              </el-col>
            </el-row>
            <el-row type="flex" align="middle" v-if="formData.isOfflineConsignment" style="margin-top:20px">
              <el-col :span="8">
                <el-form-item label="物流方式" prop="offlineConsignorMode" label-width="120px"
                  :rules="{required: formData.isOfflineConsignment, message: '不能为空', trigger: 'blur'}">
                  <el-input style="width: 194px" v-model="formData.offlineConsignorMode"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="送货人" prop="offlineConsignorName" label-width="120px"
                  :rules="{required: formData.isOfflineConsignment, message: '不能为空', trigger: 'blur'}">
                  <el-input style="width: 194px" v-model="formData.offlineConsignorName"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="联系方式" prop="offlineConsignorPhone" label-width="120px"
                  :rules="{required: formData.isOfflineConsignment, message: '不能为空', trigger: 'blur'}">
                  <el-input style="width: 194px" v-model="formData.offlineConsignorPhone"></el-input>
                </el-form-item>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="24">
            <color-size-box-table :vdata.sync="formData.packageSheets" :colorSizeEntries="taskData.colorSizeEntries" />
          </el-col>
        </el-row>
        <el-row type="flex" justify="center" align="middle" style="margin-top: 20px">
          <el-button class="sumbit-btn" @click="onSubmit">确认创建</el-button>
        </el-row>
      </el-form>
    </el-card>
  </div>
</template>

<script>
  import {
    ColorSizeBoxTable
  } from '@/components/'
  export default {
    name: 'ShippingOrdersPage',
    components: {
      ColorSizeBoxTable
    },
    computed: {
      //是否有数据创建
      hasData: function () {
        if (this.taskData != null && this.taskData != '') {
          return true;
        } else {
          return false;
        }
      }
    },
    methods: {
      async getCarriers() {
        const url = this.apis().getCarriers();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.carriers = result;
      },
      isOnline(flag) {
        if (flag) {
          this.formData.consignment.carrierDetails = {
            code: '',
            name: ''
          };
          this.formData.consignment.trackingID = '';
        }
        //校验线上表单字段
        this.$nextTick(() => {
          this.$refs.form.validateField('consignment.carrierDetails.code');
          this.$refs.form.validateField('consignment.trackingID');
        });
      },
      valiadteForm() {
        this.$refs['form'].validate((valid) => {
          if (valid) {
            return true;
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      onSubmit() {
        //校验表单
        this.$refs['form'].validate((valid) => {
          if (valid) {
            //校验通过
            this.$confirm('是否确定创建发货单', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              this._onSubmit();
            });
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      async _onSubmit() {
        const url = this.apis().shippingOrderCreate();
        let submitForm = Object.assign({}, this.formData);
        const result = await this.$http.post(url, submitForm, {
          taskId: this.taskData.id
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == '0') {
          this.$message.error(result.msg);
        } else if (result.code == '1') {
          this.$message.success(result.msg);
          this.$router.go(-1);
        }
      },
    },
    data() {
      return {
        formData: {
          consignment: {
            trackingID: '',
            carrierDetails: {
              code: '',
              name: ''
            }
          },
          isOfflineConsignment: false,
          offlineConsignorName: '',
          offlineConsignorPhone: '',
          offlineConsignorMode: "",
          packageSheets: []
        },
        taskData: '',
        carriers: ''
      }
    },
    created() {
      if (this.$route.params.taskData) {
        this.taskData = this.$route.params.taskData;
        this.getCarriers();
      } else {
        this.$router.go(-1);
      }
    },
    destroyed() {

    }
  }

</script>

<style scoped>
  .title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }

  .basic-row {
    padding-left: 10px;
    margin-top: 20px;
  }

  .baisc-lable {
    font-size: 14px;
    color: #606266;
  }

  .form-container /deep/ .el-form-item {
    margin-bottom: 0px;
  }

  .sumbit-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 125px;
    height: 32px;
  }

</style>
