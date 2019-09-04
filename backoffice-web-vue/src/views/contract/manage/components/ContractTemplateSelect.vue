<template>
  <div class="animated fadeIn template-body">
      <el-row :gutter="10">
        <el-col :span="4" v-for="(item, index) in mockData" :key="index" :offset="0">
          <div :class="item.code==selectedItem.code?'template-file_selected':'template-file'" @click="onSelect(item)">
            <el-row type="flex" justify="center">
              <img src="static/img/word.png" class="img-word" alt="" />
            </el-row>
            <el-row type="flex" justify="center">
              <el-col :span="23">
                <h6 class="template-name">{{item.title}}</h6>
              </el-col>
            </el-row>
          </div>
        </el-col>
      </el-row>
  </div>
</template>

<script>
  export default {
    name: "ContractTemplateSelect",
    props: ["mockData"],
    methods: {
      onSelect(item) {
        if (item.code == this.selectedItem.code) {
          //空选择
          this.selectedItem = {};
        } else {
          this.selectedItem = item;
        }
        console.log(this.selectedItem);
        this.$emit('fileSelectChange',this.selectedItem );
      },

    },
    data() {
      return {
        selectedItem: {},
      };
    },
  };

</script>
<style>
  /*.main-content {*/
    /*border: 0.5px solid #CCCCCC;*/
    /*padding: 10px;*/
  /*}*/

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
    height: 500px;
    overflow-y:auto;
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
