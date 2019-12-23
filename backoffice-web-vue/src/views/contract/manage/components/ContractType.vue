<template>
  <div>
    <div class="pt-2"></div>
    <el-row type="flex" justify="space-around" :gutter="50">
      <el-col :span="8">
        <div :class="contractType=='1'?'create-contract-type_select':'create-contract-type_not_select'"
             @click="onCreateOrderContract">
          <el-row>
            <el-col :span="24">
              <h5
                :class="contractType=='1'?'create-contract-type_option_title':'create-contract-type_option_title_not'">
                委托生产合同</h5>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="20">
              <h6
                :class="contractType=='1'?'create-contract-type_option_content':'create-contract-type_option_content_not'">
                以某一份生产订单内容为合同标的的合同</h6>
            </el-col>
          </el-row>
        </div>
      </el-col>
      <el-col :span="8">
        <div :class="contractType=='4'?'create-contract-type_select':'create-contract-type_not_select'"
             @click="onCreatePurchaseContract">
          <el-row>
            <el-col :span="24">
              <h5
                :class="contractType=='4'?'create-contract-type_option_title':'create-contract-type_option_title_not'">
                采购订单</h5>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="20">
              <h6
                :class="contractType=='4'?'create-contract-type_option_content':'create-contract-type_option_content_not'">
                对已签署的合同签署补充协议</h6>
            </el-col>
          </el-row>
        </div>
      </el-col>
      <el-col :span="8">
        <div :class="contractType=='3'?'create-contract-type_select':'create-contract-type_not_select'"
             @click="onCreateSupplementContract">
          <el-row>
            <el-col :span="24">
              <h5
                :class="contractType=='3'?'create-contract-type_option_title':'create-contract-type_option_title_not'">
                框架协议</h5>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="20">
              <h6
                :class="contractType=='3'?'create-contract-type_option_content':'create-contract-type_option_content_not'">
                与合作商签订长期合作合同，即框架协议</h6>
            </el-col>
          </el-row>
        </div>
      </el-col>
      <!--<el-col :span="8">-->
      <!--<div :class="contractType=='3'?'create-contract-type_select':'create-contract-type_not_select'"-->
      <!--@click="onCreateSupplementContract">-->
      <!--<el-row>-->
      <!--<el-col :span="24">-->
      <!--<h5 :class="contractType=='3'?'create-contract-type_option_title':'create-contract-type_option_title_not'">-->
      <!--补充协议</h5>-->
      <!--</el-col>-->
      <!--</el-row>-->
      <!--<el-row>-->
      <!--<el-col :span="20">-->
      <!--<h6-->
      <!--:class="contractType=='3'?'create-contract-type_option_content':'create-contract-type_option_content_not'">-->
      <!--对已签署的合同签署补充协议</h6>-->
      <!--</el-col>-->
      <!--</el-row>-->
      <!--</div>-->
      <!--</el-col>-->
    </el-row>
    <el-dialog :visible.sync="contractFormDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <contract-form v-if="contractFormDialogVisible" @onSearch="onSearch"
                     @openPreviewPdf="openPreviewPdf"
                     @closeContractFormDialog="closeContractFormDialog"
                     @closeContractTypeDialog="closeContractTypeDialog"/>
    </el-dialog>
    <el-dialog :visible.sync="contractFormPurchaseDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <contract-purchase-form v-if="contractFormPurchaseDialogVisible" @onSearch="onSearch"
                              @openPreviewPdf="openPreviewPdf"
                              @closeContractPurchaseFormDialog="closeContractPurchaseFormDialog"
                              @closeContractTypeDialog="closeContractTypeDialog"/>
    </el-dialog>
    <el-dialog :visible.sync="contractFormFrameDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <contract-frame-form v-if="contractFormFrameDialogVisible" @onSearch="onSearch"
                           @openPreviewPdf="openPreviewPdf"
                           @closeContractFrameFormDialog="closeContractFrameFormDialog"
                           @closeContractTypeDialog="closeContractTypeDialog"/>
    </el-dialog>
  </div>
</template>

<script>
  import Bus from '@/common/js/bus.js';
  import ContractForm from '../ContractForm'
  import ContractFrameForm from '../ContractFrameForm'
  import ContractSupplementForm from '../ContractSupplementForm'
  import ContractPurchaseForm from '../ContractPurchaseForm'

  export default {
    name: 'ContractType',
    components: {ContractFrameForm, ContractPurchaseForm, ContractForm},
    methods: {
      onSearch () {
        this.$emit('onSearch', 0);
      },
      onSelectOption (val) {
        this.contractType = val;
      },
      onCreateOrderContract () {
        this.contractType = '1';
        // Bus.$emit('openContractType');
        // this.fn.openSlider('创建', ContractForm, '');
        this.contractFormDialogVisible = !this.contractFormDialogVisible;
      },
      closeContractFormDialog () {
        this.contractFormDialogVisible = false;
      },
      closeContractPurchaseFormDialog () {
        this.contractFormPurchaseDialogVisible = false;
      },
      closeContractFrameFormDialog () {
        this.contractFormFrameDialogVisible = false;
      },
      onCreateSupplementContract () {
        this.contractType = '2';
        // Bus.$emit('openContractType');
        // this.fn.openSlider('创建', ContractFrameForm, '');
        this.contractFormFrameDialogVisible = !this.contractFormFrameDialogVisible;
      },
      onCreateFrameContract () {
        this.contractType = '3';
        Bus.$emit('openContractType');
        this.fn.openSlider('创建', ContractSupplementForm, '');
      },
      onCreatePurchaseContract () {
        this.contractType = '4';
        // Bus.$emit('openContractType');
        // this.fn.openSlider('创建', ContractPurchaseForm, '');
        this.contractFormPurchaseDialogVisible = !this.contractFormPurchaseDialogVisible;
      },
      closeContractTypeDialog () {
        this.$emit('closeContractTypeDialog');
      },
      // onCreateSupplementContract(){
      //   this.contractType='3';
      //   Bus.$emit('openContractType');
      //   this.fn.openSlider('创建', ContractSupplementForm, '');
      // },
      openPreviewPdf(val, code) {
        this.$emit('openPreviewPdf', val, code)
      }
    },
    data () {
      return {
        contractFormDialogVisible: false,
        contractFormPurchaseDialogVisible: false,
        contractFormFrameDialogVisible: false,
        visible: false,
        contractType: '',
        data: [{
          label: '使用平台电子模板',
          value: '1'
        }
          // {
          //   label: "上传纸质合同文件",
          //   value: "2"
          // }
        ]
      };
    },
    watch: {
      contractType: function (newType, oldType) {
        console.log('============' + newType);
        this.$emit('contractTypeChange', newType);
      }
    }
  };
</script>
<style scoped>
  .create-contract-title {
    font-weight: bold;
    font-size: 18px;
    margin-bottom: 50px;
  }

  .create-contract-type_select {
    width: 280px;
    height: 110px;
    background: rgba(255, 164, 3, 1);
    opacity: 0.85;
    border-radius: 9px;
    box-shadow: 0px 8px 5px rgba(255, 164, 3, 0.2);
    padding-left: 15px;
    padding-right: 15px;
    padding-top: 20px;
    cursor: pointer;
  }

  .create-contract-type_not_select {
    width: 280px;
    height: 110px;
    /* background: rgba(255, 164, 3, 1); */
    background-color: #fff;
    opacity: 0.85;
    border-radius: 9px;
    padding-left: 15px;
    padding-right: 15px;
    padding-top: 20px;
    cursor: pointer;
    border: 1px solid black;
  }

  .create-contract-type_not_select:hover {
    background: rgba(255, 164, 3, 1);
    box-shadow: 0px 8px 5px rgba(255, 164, 3, 0.2);
    border: none
  }

  .create-contract-type_not_select:hover .create-contract-type_option_title_not {
    color: rgba(255, 255, 255, 1);;
  }

  .create-contract-type_not_select:hover .create-contract-type_option_content_not {
    color: rgba(255, 255, 255, 1);
  }

  .create-contract-type_option {
    padding-top: 10px;
    padding-bottom: 10px;
  }

  .create-contract-type_option:hover {
    background-color: #f4f4f4;
    cursor: pointer;
    color: #ffa403;
  }

  .create-contract-type_option:hover .create-contract-type_option_prefix {
    background: #ffa403;
  }

  .create-contract-type_option_prefix {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    background: #f4f4f4;
  }

  .create-contract-type_option_title {
    color: rgba(255, 255, 255, 1);
    opacity: 0.85;
    font-size: 15px;
    font-weight: bold;
  }

  .create-contract-type_option_content {
    font-size: 14px;
    color: rgba(255, 255, 255, 1);
    opacity: 0.65;
    /* margin-top: 5px; */
  }

  .create-contract-type_option_title_not {
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
    font-size: 15px;
    font-weight: bold;
  }

  .create-contract-type_option_content_not {
    font-size: 14px;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
    /* margin-top: 5px; */
  }

  .dropdown-menu {
    width: 320px;
    height: 100px;
  }

  .create-contract-type_icon {
    color: #fff;
    /* font-size: 20px; */
  }

</style>
