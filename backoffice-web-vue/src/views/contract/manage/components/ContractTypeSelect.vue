<template>
  <el-row type="flex" justify="space-around">
    <el-col :span="8">
      <div  @click="handleClick('1')"
        :class="electronicsSelect">
        <el-row>
          <el-col :span="24">
            <h5
              :class="electronicsTitle">
              新建合同（电子签章）——— 纸质合同</h5>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="20">
            <h6
              :class="electronicsContent">
              新创建电子合同或上传未签署的纸质合同文件使用在线电子签章签署合同</h6>
          </el-col>
        </el-row>
      </div>
    </el-col>
    <el-col :span="8">
      <div :class="paperSelect"
        @click="handleClick('3')">
        <el-row>
          <el-col :span="24">
            <h5 :class="paperTitle">
              已签纸质合同</h5>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="20">
            <h6
              :class="paperContent">
              把已签署的合同文件扫描件上传到订单附件中作为备份</h6>
          </el-col>
        </el-row>
      </div>
    </el-col>
  </el-row>
</template>

<script>
  export default {
    name: 'ContractTypeSelect',
    props: ['isSignedPaper', 'isCancel'],
    computed: {
      electronicsSelect: function () {
        if (this.isSignedPaper) {
          return 'isSignedPaper-select';
        }
        return this.contractType === '1' ? 'create-contract-type_select' : 'create-contract-type_not_select';
      },
      electronicsTitle: function () {
        if (this.isSignedPaper) {
          return 'isSignedPaper-title';
        }
        return this.contractType === '1' ? 'create-contract-type_option_title' : 'create-contract-type_option_title_not';
      },
      electronicsContent: function () {
        if (this.isSignedPaper) {
          return 'isSignedPaper-content';
        }
        return this.contractType ==='1'?'create-contract-type_option_content':'create-contract-type_option_content_not';
      },
      paperSelect: function () {
        if (this.isCancel) {
          return 'isSignedPaper-select';
        }
        return this.contractType === '3' ? 'create-contract-type_select' : 'create-contract-type_not_select';
      },
      paperTitle: function () {
        if (this.isCancel) {
          return 'isSignedPaper-title';
        }
        return this.contractType === '3' ? 'create-contract-type_option_title' : 'create-contract-type_option_title_not';
      },
      paperContent: function () {
        if (this.isCancel) {
          return 'isSignedPaper-content';
        }
        return this.contractType ==='3'?'create-contract-type_option_content':'create-contract-type_option_content_not';
      },
    },
    methods: {
      handleClick (type) {
        if (this.isCancel && type === '3') {
          return;
        }
        if (!this.isSignedPaper) {
          this.contractType = type;
          this.$emit('contractTypeChange', type);
        }
      },
      onSelectOption (val) {
        this.contractType = val;
      }
    },
    data () {
      return {
        visible: false,
        contractType: '',
        data: [{
          label: '使用平台电子模板',
          value: '1'
        },
        {
          label: '上传纸质合同文件',
          value: '2'
        }
        ]
      };
    },
    created () {
      if (this.isSignedPaper) {
        this.contractType = '3';
      } else {
        this.contractType = '1';
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
    border: 1px solid black;
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
  }

  .create-contract-type_not_select:hover{
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
    border: none;
  }

  .create-contract-type_not_select:hover .create-contract-type_option_title_not{
    color:white;
  }
  .create-contract-type_not_select:hover .create-contract-type_option_content_not{
    color:white;
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
    /*border: 1px solid black;*/
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

  .isSignedPaper-select {
    /* border: 1px solid black; */
    border-color: #E4E7ED;
    width: 350px;
    height: 110px;
    background-color: #F5F7FA;
    opacity: 0.85;
    border-radius: 9px;
    padding-left: 15px;
    padding-right: 15px;
    padding-top: 20px;
    cursor: pointer;
  }
  .isSignedPaper-select:hover {
    cursor:not-allowed
  }

  .isSignedPaper-title {
    /* color: rgba(0, 0, 0, 1); */
    color: #C0C4CC;
    opacity: 0.65;
    font-size: 15px;
    font-weight: bold;
  }

  .isSignedPaper-content {
    font-size: 14px;
    /* color: rgba(0, 0, 0, 1); */
    color: #C0C4CC;
    opacity: 0.65;
  }
</style>
