<template>
  <div>
    <el-dialog :visible.sync="viewDialogVisible" width="90%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <sample-accounting-sheet :slot-data="slotData" :readOnly="true" :unitPrice="unitPrice"/>
    </el-dialog>
    <el-row style="margin-top:20px;" type="flex" align="center" :gutter="10" v-if="!isOutboundRead">
      <el-col :span="2">
        <h6 style="padding-top:8px">核算单：</h6>
      </el-col>
      <el-col :span="18">
        <h6 class="account_sheet-btn" @click="viewDialogVisible=true" v-if="slotData.isIncludeTax!=null">
          {{slotData.id}}
        </h6>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import SampleAccountingSheet from '../components/SampleAccountingSheet';

  export default {
    name: "AccountingSheetBtn",
    props: ["slotData","unitPrice", 'isOutboundRead'],
    components: {
      SampleAccountingSheet
    },
    computed: {},

    methods: {

    },
    data() {
      return {
        viewDialogVisible: false,
      };
    },
    created() {}
  };

</script>
<style scoped>
  .form-input {
    padding-top: 15px;
  }

  .account_sheet-btn {
    color: #409EFF;
    padding-top: 8px;
    cursor: pointer;
  }

</style>
