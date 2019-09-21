<template>
  <el-row type="flex" justify="space-around">
    <el-col :span="8">
      <div :class="contractType=='1'?'create-contract-type_select':'create-contract-type_not_select'"
           @click="onCreateOrderContract">
        <el-row>
          <el-col :span="24">
            <h5 :class="contractType=='1'?'create-contract-type_option_title':'create-contract-type_option_title_not'">
              订单关联合同</h5>
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
      <div :class="contractType=='2'?'create-contract-type_select':'create-contract-type_not_select'"
        @click="onCreateFrameContract">
        <el-row>
          <el-col :span="24">
            <h5 :class="contractType=='2'?'create-contract-type_option_title':'create-contract-type_option_title_not'">
              非订单关联合同</h5>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="20">
            <h6
              :class="contractType=='2'?'create-contract-type_option_content':'create-contract-type_option_content_not'">
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
</template>

<script>
  import Bus from '@/common/js/bus.js';
  import ContractForm from '../ContractForm'
  import ContractFrameForm from '../ContractFrameForm'
  import ContractSupplementForm from '../ContractSupplementForm'

  export default {
    name: "ContractType",
    methods: {
      onSelectOption(val) {
        this.contractType = val;
      },
      onCreateOrderContract(){
        this.contractType='1';
        Bus.$emit('openContractType');
        this.fn.openSlider('创建', ContractForm, '');
      },
      onCreateFrameContract(){
        this.contractType='2';
        Bus.$emit('openContractType');
        this.fn.openSlider('创建', ContractFrameForm, '');
      },
      onCreateSupplementContract(){
        this.contractType='3';
        Bus.$emit('openContractType');
        this.fn.openSlider('创建', ContractSupplementForm, '');
      },
    },
    data() {
      return {
        visible: false,
        contractType: "1",
        data: [{
            label: "使用平台电子模板",
            value: "1"
          },
          // {
          //   label: "上传纸质合同文件",
          //   value: "2"
          // }
        ]
      };
    },
    watch: {
      contractType: function (newType, oldType) {
        this.$emit('contractTypeChange',newType);
      }
    }
  };

</script>
<style>
  .create-contract-title {
    font-weight: bold;
    font-size: 18px;
    margin-bottom: 50px;
  }

  .create-contract-type_select {
    width: 350px;
    height: 110px;
    background: rgba(255, 164, 3, 1);
    opacity: 0.85;
    border-radius: 9px;
    box-shadow: 0px 8px 5px rgba(255, 164, 3, 0.2);
    /* background: radial-gradient(rgba(255, 164, 3, 1), rgba(191,123,2, 1)); */
    /* padding-bottom: 50px; */
    padding-left: 15px;
    padding-right: 15px;
    padding-top: 20px;
    cursor: pointer;
  }

  .create-contract-type_not_select {
    width: 350px;
    height: 110px;
    /* background: rgba(255, 164, 3, 1); */
    background-color: #fff;
    opacity: 0.85;
    border-radius: 9px;
    /* box-shadow: 0px 8px 5px rgba(255, 164, 3, 0.2); */
    /* background: radial-gradient(rgba(255, 164, 3, 1), rgba(191,123,2, 1)); */
    /* padding-bottom: 50px; */
    padding-left: 15px;
    padding-right: 15px;
    padding-top: 20px;
    cursor: pointer;
    border:1px gray solid;
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
    opacity: 0.45;
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