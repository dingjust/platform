<template>
  <el-row type="flex" justify="space-around">
    <el-col :span="8">
      <el-popover placement="bottom" width="320" trigger="hover" v-model="visible">
        <template v-for="item in data">
          <el-row justify="space-between" type="flex">
            <el-col :span="24">
              <div class="create-contract-type_option" @click="onSelectOption(item.value)">
                <el-row justify="space-between" type="flex" align="middle">
                  <el-col :span="2">
                  </el-col>
                  <el-col :span="22">
                    <el-radio v-model="contractType" :label="item.value">{{item.label}}</el-radio>
                  </el-col>
                </el-row>
              </div>
            </el-col>
          </el-row>
        </template>
        <div slot="reference"
          :class="contractType!='3'?'create-contract-type_select':'create-contract-type_not_select'">
          <el-row>
            <el-col :span="24">
              <h5
                :class="contractType!='3'?'create-contract-type_option_title':'create-contract-type_option_title_not'">
                新签合同（电子签章）———{{contractType!='2'?'使用平台电子模板':'上传自定义合同文件'}}</h5>
            </el-col>
          </el-row>
          <el-row>
            <el-col :span="20">
              <h6
                :class="contractType!='3'?'create-contract-type_option_content':'create-contract-type_option_content_not'">
                平台电子模板或者上传自定义合同,使用在线电子签章合同</h6>
            </el-col>
          </el-row>
          <el-row type="flex" justify="center" align="center">
            <div class="create-contract-type_icon" :class="visible?'el-icon-arrow-down':'el-icon-arrow-up'"></div>
          </el-row>
        </div>
      </el-popover>
    </el-col>
    <el-col :span="8">
      <div :class="contractType=='3'?'create-contract-type_select':'create-contract-type_not_select'"
        @click="contractType='3'">
        <el-row>
          <el-col :span="24">
            <h5 :class="contractType=='3'?'create-contract-type_option_title':'create-contract-type_option_title_not'">
              上传已签纸质合同</h5>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="20">
            <h6
              :class="contractType=='3'?'create-contract-type_option_content':'create-contract-type_option_content_not'">
              把已签署的合同文件扫描件上传到订单附件中作为备份</h6>
          </el-col>
        </el-row>
      </div>
    </el-col>
  </el-row>
</template>

<script>
  export default {
    name: "ContractTypeSelect",
    methods: {
      onSelectOption(val) {
        this.contractType = val;
      }
    },
    data() {
      return {
        visible: false,
        contractType: "1",
        data: [{
            label: "使用平台电子模板",
            value: "1"
          },
          {
            label: "上传纸质合同文件",
            value: "2"
          }
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
