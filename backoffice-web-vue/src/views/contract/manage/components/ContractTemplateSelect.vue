<template>
  <div class="animated fadeIn template-body">
    <div class="main-content">
      <el-row gutter="10">
        <el-col :span="4" v-for="(item, index) in mockData" :key="index" :offset="0">
          <div :class="item.code==selectedItem.code?'template-file_selected':'template-file'" @click="onSelect(item)">
            <el-row type="flex" justify="center">
              <img src="static/img/word.png" class="img-word" alt="" />
            </el-row>
            <el-row type="flex" justify="center">
              <el-col :span="23">
                <h6 class="template-name">{{item.name}}</h6>
              </el-col>
            </el-row>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
  export default {
    name: "ContractTemplateSelect",
    methods: {
      onSelect(item) {
        if (item.code == this.selectedItem.code) {
          //空选择
          this.selectedItem = {};
        } else {
          this.selectedItem = item;
        }
        this.$emit('fileSelectChange',this.selectedItem );
      },
    },
    data() {
      return {
        selectedItem: {},
        mockData: [{
            code: "1",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "2",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "3",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "5",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "6",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "7",
            name: "XXXXXXXXX采购合同模板",
            baned: true
          },
          {
            code: "8",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "9",
            name: "XXXXXXXXX采购合同模板"
          },
          {
            code: "10",
            name: "XXXXXXXXX采购合同模板"
          },
        ]
      };
    },
  };

</script>
<style>
  .main-content {
    border: 0.5px solid #CCCCCC;
    padding: 10px;
  }

  .template-file {
    padding-top: 10px;
    margin-bottom: 10px;
    border-radius: 10px;
    flex-direction: column;
    display: flex;
    /* border: 1px solid #ffffff; */

  }

  .template-file_selected {
    padding-top: 10px;
    margin-bottom: 10px;
    border-radius: 10px;
    flex-direction: column;
    display: flex;
    background-color: #ededed;
    /* border: 1px solid #ffd60c; */
  }

  .template-file:hover {
    background-color: #ededed;
  }

  .template-file:active {
    background-color: #ededed;
  }

  .img-word {
    width: 50px;
    height: 50px;
    margin-bottom: 5px;
  }

  .template-name {
    text-align: center;
    font-size: 12px;
  }

  .template-body {
    /* padding-top: 20px; */
  }

  .template-form-header {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    font-weight: bold;
  }

  .template-form-header h6 {
    font-weight: bold;
  }

</style>
