<!-- 
 * @description: 自管发货订单
 * @fileName: SelfReceiptOrderForm.vue 
 * @author: yj 
 * @date: 2020-08-27 16:58:55
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn form-container">
    <el-card>
      <el-row>
        <el-col :span="4">
          <div class="title">
            <h6>创建收货单</h6>
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
                <h6 class="baisc-lable">发货方：{{taskData.targetCooperator!=null?taskData.targetCooperator.name:''}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="baisc-lable">收货方：{{taskData.receiveParty!=null?taskData.receiveParty.name:''}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <el-col :span="8">
                <h6 class="baisc-lable">货号：{{taskData.product.skuID!=null?taskData.product.skuID:''}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="baisc-lable">
                  发货负责人：{{taskData.targetCooperator!=null?taskData.targetCooperator.contactPerson:''}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="baisc-lable">
                  联系方式：{{taskData.targetCooperator!=null?taskData.targetCooperator.contactPhone:''}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <h6 class="baisc-lable">收货地址：{{taskData.deliveryAddress!=null?taskData.deliveryAddress.details:''}}</h6>
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
    name: 'SelfReceiptOrderForm',
    props: ['taskData'],
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
      // isOnline(flag) {
      //   if (flag) {
      //     this.formData.consignment.carrierDetails = {
      //       code: '',
      //       name: ''
      //     };
      //     this.formData.consignment.trackingID = '';
      //   }
      //   //校验线上表单字段
      //   this.$nextTick(() => {
      //     this.$refs.form.validateField('consignment.carrierDetails.code');
      //     this.$refs.form.validateField('consignment.trackingID');
      //   });
      // },
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
            this.$confirm('是否确定创建收货单', '提示', {
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
        const url = this.apis().selfReceiptOrderCreate();
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
          packageSheets: [],
          receivingMode: 'BY_LIST'
        },
        carriers: ''
      }
    },
    created() {
      if (!this.taskData) {
        this.$router.go(-1);
      }
    },
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
