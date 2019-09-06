<template>
  <div class="info-detail-staff-body">
      <el-dialog :visible.sync="dialogContractVisible" width="85%" class="purchase-dialog">
      <contract-form :slotData="slotData" ></contract-form>
    </el-dialog>
    <el-row type="flex" justify="space-between" align="middle" class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">合同</h6>
      </div>
      <el-button type="text" class="info-detail-logistics_info-btn2" @click="onCreate">签署合同</el-button>
    </el-row>
    <el-row type="flex" justify="center">
      <img src="static/img/word.png" class="info-img-word" alt="" />
    </el-row>
    <el-row type="flex" justify="center">
      <el-col :span="16">
        <h6 class="info-template-name">衣加衣电子合同</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import contractForm from '../../../contract/manage/ContractForm'
  import Bus from '@/common/js/bus.js';
  import http from '@/common/js/http';

  export default {
    name: 'PurchaseOrderInfoContract',
    props: ['slotData'],
    components: {
      contractForm
    },
    mixins: [],
    computed: {

    },
    methods: {
      async onCreate(){
        const url = this.apis().getAuthenticationState();
        const result = await http.get(url);
        console.log(result);
        Bus.$emit('my-event');
        if(result.data.personalState == 'SUCCESS' || result.data.companyState == 'SUCCESS'){
          this.fn.openSlider("创建", contractForm,this.slotData);
          // this.dialogContractVisible = true;

        }else{
          this.$message.error('当前账号未通过认证');
        }

      }
    },
    data() {
      return {
        dialogContractVisible:false
      }
    },
    created() {
      console.log(this.slotData);
    }
  }

</script>
<style>
  .info-detail-staff-body {
    width: 100%;
    margin-top: 20px;
  }

  .info-row {
    margin-top: 5px;
  }

  .info-template-name {
    text-align: center;
    font-size: 12px;
  }

  .info-img-word {
    width: 50px;
    height: 50px;
    margin-bottom: 5px;
  }

  .purchase-dialog .el-dialog__header {
    padding: 0px !important;
  }

</style>
