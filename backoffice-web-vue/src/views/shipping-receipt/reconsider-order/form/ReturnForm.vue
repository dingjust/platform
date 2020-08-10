<!-- 
 * @description: 补全退货单
 * @fileName: ReturnForm.vue 
 * @author: yj 
 * @date: 2020-06-24 11:41:05
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn receipt-order-container">
    <el-row type="flex" justify="space-between">
      <el-col :span="4">
        <div class="title">
          <h6>补退货单</h6>
        </div>
      </el-col>
    </el-row>
    <el-form :model="curData" ref="form" label-position="left">
      <el-row type="flex" style="padding-bottom: 10px">
        <el-col :span="24">
          <my-address-form :vAddress.sync="curData.deliveryAddress" ref="addressForm" :readOnly="false" />
        </el-col>
      </el-row>
      <el-row type="flex" align="middle" :gutter="20">
        <el-col :span="8">
          <el-form-item label="发货方式" prop="consignment.carrierDetails.code" label-width="120px"
            :rules="{required: !curData.isOfflineConsignment, message: '不能为空', trigger: 'blur'}">
            <el-select v-model="curData.consignment.carrierDetails.code" :disabled="curData.isOfflineConsignment"
              :placeholder="''">
              <template v-for="item in carriers">
                <el-option :label="item.name" :value="item.code" :key="item.code"></el-option>
              </template>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="物流单号" prop="consignment.trackingID" label-width="120px"
            :rules="{required: !curData.isOfflineConsignment, message: '不能为空', trigger: 'blur'}">
            <el-input v-model="curData.consignment.trackingID" style="width: 194px"
              :disabled="curData.isOfflineConsignment"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-row type="flex" align="top">
            <el-checkbox v-model="curData.isOfflineConsignment" @change="isOnline"></el-checkbox>
            <span class="basci-label">线下物流<span style="color: #F56C6C">(勾选后无需填写发货方式和单号)</span></span>
          </el-row>
        </el-col>
      </el-row>
      <el-row type="flex" align="middle" v-if="curData.isOfflineConsignment" style="margin-top:20px">
        <el-col :span="8">
          <el-row type="flex" justify="start">
            <el-form-item label="物流方式" prop="offlineConsignorMode" label-width="120px"
              :rules="{required: curData.isOfflineConsignment, message: '不能为空', trigger: 'blur'}">
              <el-input style="width: 194px" v-model="curData.offlineConsignorMode"></el-input>
            </el-form-item>
          </el-row>
        </el-col>
        <el-col :span="8">
          <el-form-item label="送货人" prop="offlineConsignorName" label-width="120px"
            :rules="{required: false, message: '不能为空', trigger: 'blur'}">
            <el-input style="width: 194px" v-model="curData.offlineConsignorName"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="联系方式" prop="offlineConsignorPhone" label-width="120px"
            :rules="{required: false, message: '不能为空', trigger: 'blur'}">
            <el-input style="width: 194px" v-model="curData.offlineConsignorPhone"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <color-size-table :data="curData.packageSheets[0].colorSizeEntries" :hideEmptyColors="false" />
      <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50">
        <template>
          <el-col :span="4">
            <el-button class="material-btn" @click="onSubmit">确定</el-button>
          </el-col>
        </template>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import {
    ColorSizeTable,
    MyAddressForm,
  } from '@/components/'

  export default {
    name: 'ReturnForm',
    props: {
      colorSizeEntries: {
        type: Array,
        required: true
      },
      data: {
        type: Object
      }
    },
    components: {
      ColorSizeTable,
      MyAddressForm,
    },
    computed: {
      //总数
      totalQuantity: function () {
        let result = 0;
        this.curData.packageSheets.forEach(sheet => {
          sheet.colorSizeEntries.forEach(entry => {
            let num = parseInt(entry.quantity);
            if (!Number.isNaN(num)) {
              result += num;
            }
          })
        });
        return result;
      }
    },
    methods: {
      // 封装Promise对象
      getFormPromise(form) {
        return new Promise(resolve => {
          form.validate(res => {
            resolve(res);
          })
        })
      },
      async validateForms() {
        var formArr = [];
        formArr.push(this.$refs['form']);
        formArr.push(this.$refs.addressForm.$refs.address);
        // 使用Promise.all 并行去校验结果
        let res = await Promise.all(formArr.map(this.getFormPromise));
        return res.every(item => !!item);
      },
      async onSubmit() {
        //校验数量
        if (this.totalQuantity < 1) {
          this.$message.error('请完填写数量');
          return;
        }
        let validate = await this.validateForms();
        if (validate) {
          this.$emit('onSave', this.curData);
        } else {
          this.$message.error('请完善表单信息');
        }
      },
      isOnline(flag) {
        if (flag) {
          this.curData.consignment.carrierDetails = {
            code: '',
            name: ''
          };
          this.curData.consignment.trackingID = '';
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
    },
    data() {
      return {
        carriers: [],
        curData: {
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
          packageSheets: [{
            colorSizeEntries: []
          }],
          deliveryAddress: {
            region: '',
            city: '',
            cityDistrict: '',
            line1: ''
          },
          isAllReturn: false,
          medias: [],
          remarks: ''
        }
      }
    },
    created() {
      this.getCarriers();
      if (this.data != null) {
        this.curData = JSON.parse(JSON.stringify(this.data));
      } else {
        if (this.colorSizeEntries != null) {
          this.colorSizeEntries.forEach(entry => {
            this.curData.packageSheets[0].colorSizeEntries.push({
              color: entry.color,
              size: entry.size,
              quantity: ''
            });
          });
        }
      }
      //无数量颜色处理
      let colorKeySet = new Set([]);
      this.colorSizeEntries.filter(entry => entry.quantity > 0).forEach(element => {
        if (!colorKeySet.has(element.color.code)) {
          colorKeySet.add(element.color.code);
        }
      });
      this.curData.packageSheets[0].colorSizeEntries = this.curData.packageSheets[0].colorSizeEntries.filter(entry =>
        colorKeySet.has(entry.color.code));
    },
    destroyed() {

    }
  }

</script>

<style scoped src="../../css/reconsider-order.css"></style>
