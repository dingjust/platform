<template>
  <div class="info-detail-staff-body">
    <el-dialog :visible.sync="dialogContractVisible" width="85%" class="purchase-dialog">
      <contract-form :slotData="slotData" ></contract-form>
    </el-dialog>
    <el-row type="flex" justify="space-between" align="middle" class="info-title-row">
      <div class="info-title">
        <h6 class="info-title_text">合同（{{contract==''?'未签署':getEnum('contractStates', contract.state)}}）</h6>
      </div>
      <el-button v-if="contract == ''" type="text" class="info-detail-logistics_info-btn2" @click="onCreate">签署合同</el-button>
      <el-button v-if="contract != ''" type="text" class="info-detail-logistics_info-btn2" @click="openContract">查看合同</el-button>
    </el-row>
    <el-row v-if="contract != ''" type="flex" justify="center">
      <img @click="openContract" src="static/img/word.png" class="info-img-word" alt="" />
    </el-row>
    <el-row v-if="contract != ''"  type="flex" justify="center">
      <el-col :span="16">
        <h6 @click="openContract" class="info-template-name">{{contract.title}}</h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import contractForm from '../../../contract/manage/ContractForm'
  // import contractPage from '../../../contract/manage/ContractPage'
  import Bus from '@/common/js/bus.js';
  import http from '@/common/js/http';
  import ContractDetails from "../../../contract/manage/components/ContractDetails";

  export default {
    name: 'PurchaseOrderInfoContract',
    props: ['slotData','contract'],
    components: {
      contractForm,
      ContractDetails
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

      },
      async openContract(){
        const url = this.apis().getContractDetail(this.contract.code);
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        console.log(result);

        if(result.data != null || result.data != ''){
          Bus.$emit('my-event');
          this.fn.openSlider("创建", ContractDetails,result.data);
        }

      },
    },
    data() {
      return {
        dialogContractVisible:false,
        dialogTableVisible:false,
        contractData:'',
      }
    },
    created() {
      // this.getContract();
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
  .purchase-dialog .el-dialog {
    border-radius: 10px !important;
  }

  .purchase-dialog-header {
    padding: 0px !important;
  }


</style>
