<template>
  <div>
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
             @click="onCreateFrameContract">
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
    </el-row>
    <el-dialog :visible.sync="contractFormDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <contract-form-com v-if="contractFormDialogVisible" :slotData="slotData"
                              @onSaveContractForm="onSaveContractForm" :templateData="mockData" :templateId="templateId"
                              @onSaveContractFormPdf="onSaveContractFormPdf"
                              @closeContractFormDialog="closeContractFormDialog"/>
    </el-dialog>
    <el-dialog :visible.sync="contractFormPurchaseDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <contract-purchase-form-com v-if="contractFormPurchaseDialogVisible" :slotData="slotData"
                              @closeContractPurchaseFormDialog="closeContractPurchaseFormDialog" :templateData="mockData" :templateId="templateId"
                              @onSaveContractPurchaseForm="onSaveContractPurchaseForm"
                              @onSaveContractPurchaseFormPdf="onSaveContractPurchaseFormPdf"/>
    </el-dialog>
    <el-dialog :visible.sync="contractFormFrameDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <contract-frame-form-com v-if="contractFormFrameDialogVisible" :slotData="slotData"
                              @closeContractFrameFormDialog="closeContractFrameFormDialog" :templateData="mockData" :templateId="templateId"
                              @onSaveContractFrameForm="onSaveContractFrameForm"
                              @onSaveContractFrameFormPdf="onSaveContractFrameFormPdf"/>
    </el-dialog>
  </div>
</template>

<script>
  import http from '@/common/js/http';
  import Bus from '@/common/js/bus.js';
  import ContractFrameFormCom from './ContractFrameFormCom';
  import ContractPurchaseFormCom from './ContractPurchaseFormCom';
  import ContractFormCom from './ContractFormCom';

  export default {
    name: 'ContractTypeCom',
    props: ['slotData'],
    components: {
      ContractFormCom,
      ContractPurchaseFormCom,
      ContractFrameFormCom
    },
    methods: {
      onSaveContractForm (formData) {
        this.$emit('onSaveContractForm', formData);
        this.$emit('closeContractT');
      },
      onSaveContractFormPdf (formData) {
        this.$emit('onSaveContractFormPdf', formData);
        this.$emit('closeContractT');
      },
      onSaveContractPurchaseForm (formData) {
        this.$emit('onSaveContractPurchaseForm', formData);
        this.$emit('closeContractT');
      },
      onSaveContractPurchaseFormPdf (formData) {
        this.$emit('onSaveContractPurchaseFormPdf', formData);
        this.$emit('closeContractT');
      },
      onSaveContractFrameForm (formData) {
        this.$emit('onSaveContractFrameForm', formData);
        this.$emit('closeContractT');
      },
      onSaveContractFrameFormPdf (formData) {
        this.$emit('onSaveContractFrameFormPdf', formData);
        this.$emit('closeContractT');
      },
      onSelectOption (val) {
        this.contractType = val;
      },
      onCreateOrderContract () {
        this.contractType = '1';
        // Bus.$emit('openContractType');
        // this.fn.openSlider('创建', ContractForm, '');
        this.templateId = 0;
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
        this.templateId = 3;
        this.contractFormFrameDialogVisible = !this.contractFormFrameDialogVisible;
      },
      onCreateFrameContract () {
        this.contractType = '3';
        // Bus.$emit('openContractType');
        // this.fn.openSlider('创建', ContractSupplementForm, '');
        this.templateId = 2;
        this.contractFormFrameDialogVisible = !this.contractFormFrameDialogVisible;
      },
      onCreatePurchaseContract () {
        this.contractType = '4';
        // Bus.$emit('openContractType');
        // this.fn.openSlider('创建', ContractPurchaseForm, '');
        this.templateId = 1;
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
      openPreviewPdf (val, code) {
        this.$emit('openPreviewPdf', val, code)
      },
      async getTemplateListPt () {
        const url = this.apis().getTemplatesListPt();
        const result = await http.post(url, {
          keyword: ''
        }, {
          page: 0,
          size: 10
        });
        this.mockData = result.content;
        this.sortData();
      },
      sortData () {
        let arr = [];
        this.mockData.map(value => {
          if (value.title === '委托生产合同') {
            arr[0] = value;
          }
          if (value.title === '采购订单') {
            arr[1] = value;
          }
          if (value.title === '框架协议') {
            arr[2] = value;
          }
          if (value.title === '补充协议') {
            arr[3] = value;
          }
        });
        this.mockData = arr;
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
        ],
        mockData: [],
        templateId: ''
      };
    },
    watch: {
      contractType: function (newType, oldType) {
        console.log('============' + newType);
        this.$emit('contractTypeChange', newType);
      }
    },
    created () {
      this.getTemplateListPt();
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
