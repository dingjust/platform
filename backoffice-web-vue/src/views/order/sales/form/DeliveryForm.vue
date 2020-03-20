<template>
  <div>
    <el-row>
      <el-col :span="2">
        <div class="orders-list-title">
          <h6>发货</h6>
        </div>
      </el-col>
    </el-row>
    <div class="pt-2"></div>
    <el-form ref="form" :model="form" label-width="80px" label-position="left">
      <el-row type="flex">
        <h6>发货信息</h6>
      </el-row>
      <div class="sales-deliver-form-content">
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item label="发货人">
              <el-input v-model="form.consignorName" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="联系方式">
              <el-input v-model="form.consignorPhoe" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item label="物流公司">
              <el-select v-model="form.logistics" placeholder="请选择" :disabled="form.isOffline" style="width:100%">
                <el-option v-for="item in carriers" :key="item.code" :label="item.name" :value="item.code">
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="物流单号">
              <el-input v-model="form.logisticsCode" :disabled="form.isOffline"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <div style="padding-top:5px;">
              <el-checkbox v-model="form.isOffline" @change="onOfflineChange">线下物流<span
                  style="color:rgba(255, 150, 153, 1)">（勾选后无需填写发货方式和单号）</span></el-checkbox>
            </div>
          </el-col>
        </el-row>
      </div>
      <el-row type="flex">
        <h6>收货信息</h6>
      </el-row>
      <div class="sales-deliver-form-content">
        <el-row type="flex" :gutter="20">
          <el-col :span="8">
            <el-form-item label="收货人">
              <el-input v-model="form.consigneeName" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="联系方式">
              <el-input v-model="form.consigneePhone" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="联系地址">
              <el-input v-model="form.address" :disabled="true"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </div>
      <el-row type="flex" justify="center">
        <!-- <el-col :span="12"> -->
        <el-button class="sales-order-btn"  @click="onSubmit">确定</el-button>        
        <!-- </el-col> -->
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: "DeliveryForm",
    props: ["code"],
    components: {},
    computed: {},
    methods: {
      onSubmit() {
        this.$emit('onSubmit');
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
      onOfflineChange(v) {
        if (this.form.isOffline) {
          this.form.logistics = '';
          this.form.logisticsCode = '';
        }
      }
    },
    data() {
      return {
        carriers: [],
        form: {
          consignorName: "广州贸易公司",
          consignorPhoe: '13588888888',
          logistics: '',
          logisticsCode: '',
          isOffline: false,
          consigneeName: '张三',
          consigneePhone: '18555555555',
          address: '广东省广州市天河区权威哦请问囧饿哦i去我家',
        }
      };
    },
    created() {
      this.getCarriers();
    },
    mounted() {}
  };

</script>
<style>
  .report {
    margin-bottom: 10px;
  }

  .sales-deliver-form-content {
    padding: 10px 20px 10px 20px;
  }

</style>
