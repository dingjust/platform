<template>
  <div>
    <el-row type="flex" justify="start" align="">
      <h5>选择合同签订类型</h5>
    </el-row>
    <div class="pt-2"></div>
    <!-- 步骤条 -->
    <contract-steps :step="1"/>
    <!-- 合同类型框 -->
    <el-row type="flex" justify="space-between" style="margin: 30px 60px">
      <template v-for="item in typeTitle">
        <div :key="item.name" :class="item.name === selectType ? 'contract-frame-selection' : 'contract-frame'" @click="onClick(item.name)">
          <el-row type="flex" justify="center" style="margin-top:20px">
            <h6>{{item.name}}</h6>
          </el-row>
          <el-row type="flex" justify="center" style="margin-top:40px">
            <h6>{{item.title}}</h6>
          </el-row>
        </div>
      </template>
    </el-row>
    <!-- 合同类型提示 -->
    <el-row type="flex" justify="center" align="middle">
      <i class="el-icon-question quest-icon" v-popover:popover/>
      <el-popover ref="popover" placement="top" width="600" trigger="hover">
        <template v-for="item in typeTitle">
          <div :key="item.name" style="display: flex">
            <p class="tip-title">{{item.name}}：</p>
            <p>{{item.tip}}</p>
          </div>
        </template>
      </el-popover>
      <h6 style="margin-bottom: 0px">如何选择合同类型</h6>
    </el-row>
    <el-row type="flex" justify="center" align="middle">
      <p style="color: #F56C6C">注明：只有完成实名认证才可以使用电子合同签署功能</p>
    </el-row>
    <el-row type="flex" justify="center" align="middle">
      <el-button class="sumbit-btn" @click="onSumbit">确定</el-button>
    </el-row>
    <el-dialog :visible.sync="contractFormDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <contract-form v-if="contractFormDialogVisible" @onSearch="onSearch" :slotData="slotData" :isSignedPaper="isSignedPaper"
                     @openPreviewPdf="openPreviewPdf" :templateData="mockData" :templateId="templateId"
                     @closeContractFormDialog="closeContractFormDialog"
                     @closeContractTypeDialog="closeContractTypeDialog"/>
    </el-dialog>
    <el-dialog :visible.sync="contractFormPurchaseDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <contract-purchase-form v-if="contractFormPurchaseDialogVisible" @onSearch="onSearch" :slotData="slotData" :isSignedPaper="isSignedPaper"
                              @openPreviewPdf="openPreviewPdf" :templateData="mockData" :templateId="templateId"
                              @closeContractPurchaseFormDialog="closeContractPurchaseFormDialog"
                              @closeContractTypeDialog="closeContractTypeDialog"/>
    </el-dialog>
    <el-dialog :visible.sync="contractFormFrameDialogVisible" width="80%" class="purchase-dialog" append-to-body :close-on-click-modal="false">
      <contract-frame-form v-if="contractFormFrameDialogVisible" @onSearch="onSearch" :slotData="slotData" :isSignedPaper="isSignedPaper"
                           @openPreviewPdf="openPreviewPdf" :templateData="mockData" :templateId="templateId"
                           @closeContractFrameFormDialog="closeContractFrameFormDialog"
                           @closeContractTypeDialog="closeContractTypeDialog"/>
    </el-dialog>
  </div>
</template>

<script>
  import http from '@/common/js/http';
  import Bus from '@/common/js/bus.js';
  import ContractForm from '../ContractForm'
  import ContractFrameForm from '../ContractFrameForm'
  import ContractSupplementForm from '../ContractSupplementForm'
  import ContractPurchaseForm from '../ContractPurchaseForm'
  import ContractSteps from './ContractSteps'

  export default {
    name: 'ContractType',
    props: ['slotData', 'isSignedPaper'],
    components: {ContractFrameForm, ContractPurchaseForm, ContractForm, ContractSteps},
    methods: {
      onClick (type) {
        if (this.selectType === type) {
          this.selectType = '';
          return;
        }
        this.selectType = type;
      },
      onSumbit () {
        switch (this.selectType) {
          case '委托生产合同':
            this.onCreateOrderContract();
            break;
          case '采购订单':
            this.onCreatePurchaseContract();
            break;
          case '框架协议':
            this.onCreateFrameContract();
            break;
          default:
            this.$message.warning('请选择需要签署的合同类型！');
            break;
        }
      },
      onSearch () {
        this.$emit('onSearch', 0);
      },
      onSelectOption (val) {
        this.contractType = val;
      },
      onCreateOrderContract () {
        this.contractType = '1';
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
      onCreateFrameContract () {
        this.contractType = '3';
        this.templateId = 2;
        this.contractFormFrameDialogVisible = !this.contractFormFrameDialogVisible;
      },
      onCreatePurchaseContract () {
        this.contractType = '4';
        this.templateId = 1;
        this.contractFormPurchaseDialogVisible = !this.contractFormPurchaseDialogVisible;
      },
      closeContractTypeDialog () {
        this.$emit('closeContractTypeDialog');
      },
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
        this.mockData = result.content.sort((o1, o2) => {
          return this.templateSequence[o1.type] - this.templateSequence[o2.type]; 
        });
      }
    },
    data () {
      return {
        templateSequence: {
          WTSCHT: 0,
          CGDD: 1,
          KJXY: 2,
          BCXY: 3,
          ZFXY: 4
        }, 
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
        templateId: '',
        selectType: '',
        typeTitle: [{
          name: '委托生产合同',
          title: '以某一份生产订单内容为合同标的的合同',
          tip: '指甲乙双方并没有签署框架协议的情况下，签署的对整个订单的商务条件、履约条款等进行详细约定的合同方式。。'
        }, {
          name: '采购订单',
          title: '对已签署的框架协议订单可以签署',
          tip: `指甲乙双方已经签署了框架协议，合同只需对当前订单的数量、价格、交期进行约定的合同方式。
                （采购订单签订需要提供双方已签订的框架协议）`
        }, {
          name: '框架协议',
          title: '与合作商签订长期合作合同，即框架协议',
          tip: `指甲乙双方长期合作，签署一个时间段内对双方订单进行商务条件，履约条件等内容进行约定的合同形式。
                （框架协议签署需要对方公司名称和合同有限的期限）`
        }]
      };
    },
    watch: {
      contractType: function (newType, oldType) {
        this.$emit('contractTypeChange', newType);
      }
    },
    created () {
      this.getTemplateListPt();
    }
  };
</script>
<style scoped>
  .contract-frame {
    width: 200px;
    height: 200px;
    background-color: #FBF7F7;
    padding: 8px;
  }

  .contract-frame:hover {
    background-color: #FFD60C;
    box-shadow: 0px 0px 8px #FFD60C;
  }

  .contract-frame-selection {
    width: 200px;
    height: 200px;
    background-color: #FFD60C;
    box-shadow: 0px 0px 8px #FFD60C;
    padding: 8px;
  }

  .quest-icon {
    font-size: 20px;
    margin-right: 10px;
  } 

  .tip-title {
    flex-shrink: 0;
    width: 100px;
    display: flex;
    justify-content: flex-end;
  }

  .sumbit-btn {
    width: 120px;
    height: 40px;
    background-color: #FFD60C;
    border: 1px solid #DCDFE6;
    color: #606266;
  }

</style>
