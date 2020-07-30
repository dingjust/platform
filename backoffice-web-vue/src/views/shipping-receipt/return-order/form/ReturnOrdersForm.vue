<!-- 
 * @description: 收货单表单
 * @fileName: ReceiptOrderForm.vue 
 * @author: yj 
 * @date: 2020-06-22 13:58:22
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn receipt-order-container content">
    <el-card>
      <div class="status-triangle_box" v-if="formData.isAllReturn">
        <div class="status-triangle" style="border-right: 90px solid #ff1744;">
          <h6 class="status-triangle_text" style="color:white;">整单退货</h6>
        </div>
      </div>
      <el-row type="flex" justify="space-between">
        <el-col :span="4">
          <div class="title">
            <h6>创建退货单</h6>
          </div>
        </el-col>
      </el-row>
      <el-form :inline="true" ref="form" label-position="left" label-width="70px" :model="formData">
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="3">
            <img width="100px" height="100px"
              :src="shippingOder.product!=null&&shippingOder.product.thumbnail.length!=0?shippingOder.product.thumbnail.url:'static/img/nopicture.png'">
          </el-col>
          <el-col :span="21">
            <el-row type="flex" style="padding: 10px 0px">
              <el-col :span="8">
                <h6 class="basic-label">产品名称：{{shippingOder.product.name}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">货号：{{shippingOder.product.skuID}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <el-col :span="8">
                <h6 class="basic-label">发货方：{{shippingOder.shipParty.name}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">收货方：{{shippingOder.receiveParty.name}}</h6>
              </el-col>
              <el-col :span="8">
                <h6 class="basic-label">发货负责人：{{shippingOder.merchandiser.name}}</h6>
              </el-col>
            </el-row>
            <el-row type="flex" style="padding-bottom: 10px">
              <!-- <el-col :span="2">
                <h6 class="basic-label" style="margin-top:10px">退货地址：</h6>
              </el-col> -->
              <el-col :span="24">
                <my-address-form :vAddress.sync="formData.deliveryAddress" ref="addressComp" :readOnly="false"
                  :hideContact="true" />
              </el-col>
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
                <el-form-item label="物流单号" prop="consignment.trackingID" label-width="120px"
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
                  :rules="{required: false, message: '不能为空', trigger: 'blur'}">
                  <el-input style="width: 194px" v-model="formData.offlineConsignorName"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="联系方式" prop="offlineConsignorPhone" label-width="120px"
                  :rules="{required: false, message: '不能为空', trigger: 'blur'}">
                  <el-input style="width: 194px" v-model="formData.offlineConsignorPhone"></el-input>
                </el-form-item>
              </el-col>
            </el-row>
          </el-col>
        </el-row>
        <el-row type="flex" justify="start" class="basic-row">
          <el-col :span="24">
            <color-size-table :data="formData.packageSheets[0].colorSizeEntries" :readOnly="formData.isAllReturn" />
          </el-col>
        </el-row>
        <el-row type="flex" style="margin-top:20px;">
          <el-input type="textarea" placeholder="输入退货原因" v-model="formData.remarks" :rows="5">
          </el-input>
        </el-row>
        <el-row type="flex" align="top" style="margin-top:20px">
          <el-col :span="2">
            <h6 class="info-input-prepend" style="margin-top: 41px;">凭证</h6>
          </el-col>
          <el-col :span="20">
            <el-form-item prop="medias" :rules="[{ required: false, message: '请上传凭证', trigger: 'change'}]">
              <images-upload class="return-images-form-upload" :slot-data="formData.medias" :limit="5">
                <template slot="picBtn">
                  <h6>大小不超过5M/张，且最多5张主图</h6>
                </template>
              </images-upload>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <el-row type="flex" justify="start" class="basic-row">
        <el-col :span="8" :offset="2">
          <h6>发货单：{{shippingOder.code}}</h6>
        </el-col>
      </el-row>
      <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50">
        <template>
          <el-col :span="4">
            <el-button class="material-btn" @click="onSubmit">确认退货</el-button>
          </el-col>
        </template>
      </el-row>
    </el-card>
  </div>
</template>

<script>
  import {
    ColorSizeBoxTable,
    ColorSizeTable,
    MyAddressForm,
    ImagesUpload
  } from '@/components/index'

  export default {
    name: 'ReturnOrdersForm',
    props: {
      componentsType: {
        type: String,
        default: 'page'
      }
    },
    components: {
      ColorSizeBoxTable,
      ColorSizeTable,
      MyAddressForm,
      ImagesUpload
    },
    computed: {

    },
    methods: {
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
      async getCarriers() {
        const url = this.apis().getCarriers();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.carriers = result;
      },
      //封装Promise对象
      getFormPromise(form) {
        return new Promise(resolve => {
          form.validate(res => {
            resolve(res);
          })
        })
      },
      onSubmit() {
        //获取各层级form
        var forms = [];
        forms.push(this.$refs.form);
        forms.push(this.$refs.addressComp.$refs.address);
        // 使用Promise.all 并行去校验结果
        Promise.all(forms.map(this.getFormPromise)).then(res => {
          const validateResult = res.every(item => !!item);
          if (validateResult) {
            this.$confirm('确定退货?', '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning'
            }).then(() => {
              this._onSubmit();
            }).catch(() => {

            });
          } else {
            this.$message.error('请完善信息');
          }
        });
      },
      async _onSubmit() {
        //页面直接提交数据
        if (this.componentsType == 'page') {
          const url = this.apis().returnOrderCreate();
          let submitForm = Object.assign({}, this.formData);
          const result = await this.$http.post(url, submitForm, {
            id: this.shippingOder.id
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
        }
        //组件回调
        else if (this.componentsType == 'component') {
          this.$emit('callback', this.formData);
        }
      },
      //提示是否创建退货单
      onReturnedMessage() {
        this.$confirm('是否马上创建退货单？', '提示', {
          confirmButtonText: '马上创建',
          cancelButtonText: '下次再说',
          type: 'info'
        }).then(() => {

        }).catch(() => {

        });
      }
    },
    data() {
      return {
        shippingOder: '',
        carriers: [],
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
          packageSheets: [],
          deliveryAddress: {
            region: '',
            city: '',
            cityDistrict: '',
            line1: ''
          },
          isAllReturn: false,
          medias: [],
          remarks: ''
        },
      }
    },
    created() {
      this.getCarriers();
      if (this.$route.params.isAllReturn != null) {
        this.$set(this.formData, 'isAllReturn', this.$route.params.isAllReturn);
      }

      if (this.$route.params.shippingOrder == null) {
        this.$router.go(-1);
      } else {
        //设置colorSizeEntries
        this.$set(this, 'shippingOder', JSON.parse(JSON.stringify(this.$route.params.shippingOrder)));
        //整理按总汇表单数据
        let summaryData = [];
        this.$route.params.shippingOrder.packageSheets.forEach(sheet => {
          if (summaryData.length == 0) {
            summaryData.push(JSON.parse(JSON.stringify(sheet)));
          } else {
            //整合数据
            for (let i = 0; i < sheet.colorSizeEntries.length; i++) {
              let num = parseInt(sheet.colorSizeEntries[i].quantity);
              if (!Number.isNaN(num)) {
                summaryData[0].colorSizeEntries[i].quantity += num;
              }
            }
          }
        });
        //非整单
        if (!this.formData.isAllReturn) {
          //清空数量
          summaryData.forEach(sheet => {
            sheet.colorSizeEntries.forEach(entry => {
              entry.quantity = '';
            })
          });
        }
        this.$set(this.formData, 'packageSheets', summaryData);
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

  .receipt-order-container h6 {
    font-size: 14px;
    color: #606266;
  }

  .receipt-order-container {
    padding-bottom: 10px;
  }

  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 150px;
    height: 35px;
  }


  .status-triangle_box {
    /* margin-top: 1px; */
    position: absolute;
    right: 0;
    top: 0;
  }

  .status-triangle {
    width: 0;
    height: 0;
    border-right: 90px solid white;
    border-bottom: 90px solid transparent;
    z-index: 0;
  }

  .status-triangle_text {
    width: 100px;
    padding-top: 10px;
    padding-left: 40px;
    transform: rotateZ(45deg);
    color: white;
    font-size: 10px;
  }

  .return-images-form-upload {
    margin-left: 10px;
  }

  .return-images-form-upload>>>.el-upload--picture-card {
    width: 100px;
    height: 100px;
    line-height: 100px;
  }

  .return-images-form-upload>>>.el-upload-list--picture-card .el-upload-list__item {
    width: 100px;
    height: 100px;
  }

</style>
