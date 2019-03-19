<template>
  <div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <proofing-basic-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>待打样产品</span>
      </div>
      <proofing-entries-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>送货地址</span>
      </div>
      <proofing-delivery-address-form :slot-data="slotData" :read-only="readOnly"/>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="12">
        <el-button class="btn-block" size="mini" type="primary" @click="onSubmit()">提交</el-button>
      </el-col>
      <el-col :span="12">
        <el-button class="btn-block" size="mini" @click="onCancel">取消</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import ProofingBasicForm from "../form/ProofingBasicForm";
  import ProofingBelongToForm from "../form/ProofingBelongToForm";
  import ProofingDeliveryAddressForm from "../form/ProofingDeliveryAddressForm";
  import ProofingEntriesForm from "../form/ProofingEntriesForm";

  export default {
    name: 'ProofingDetailForm',
    props: ['slotData', 'readOnly'],
    components: {
      ProofingBasicForm,
      ProofingBelongToForm,
      ProofingDeliveryAddressForm,
      ProofingEntriesForm,
    },
    mixins: [],
    computed: {},
    methods: {
      async onSubmit() {
        console.log("submitted data: " + JSON.stringify(this.slotData));

        const deliveryAddress = this.slotData.deliveryAddress;
        // 地址信息未填时，清除deliveryAddress节点
        if (!deliveryAddress.region || !deliveryAddress.region.isocode) {
          delete this.slotData.deliveryAddress;
        }

        const result = await this.$http.put('/b2b/orders/proofing/updateAddress/'+this.slotData.code, this.slotData);
        if (result['errors']) {
          this.$message.error('获取数据失败，原因：' + result['errors'][0].message);
          return;
        }

        this.$message.success('打样订单创建成功，订单号：' + result);
        this.fn.closeSlider();
      },
      onCancel() {
        this.fn.closeSlider();
      }
    },
    data() {
      return {}
    },
    created() {
    }
  }
</script>
