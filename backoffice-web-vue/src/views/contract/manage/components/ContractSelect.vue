<template>
  <div class="animated fadeIn template-body" style="height: auto">
    <el-card>
      <el-container  style="">
        <el-main>
    <div class="main-content" style="">
      <el-row >
        <el-col v-if="mockData!=null && mockData!= []" :span="4" v-for="(item, index) in mockData" :key="index" :offset="0">
          <div v-if="item.title!=null && item.title!=''" :class="item.code==selectedItem.code?'template-file_selected':'template-file'" @click="onSelect(item)">
            <el-row  type="flex" justify="center">
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
        </el-main>
      </el-container>
    </el-card>
  </div>

</template>

<script>
  import http from '@/common/js/http';

  export default {
    name: "ContractSelect",
    props:['mockData'],
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
      // async getList(){
      //   const url = this.apis().getContractsList();
      //   const result = await http.post(url, {
      //     keyword: ''
      //   }, {
      //     page: 0,
      //     size: 100
      //   });
      //   this.mockData = result.content;
      // },


    },
    data() {
      return {
        selectedItem: {},
        selectedItemTemp: {},
        tempData:[],
        allData:[],
      };
    },
    created(){
      // this.onSearchTemp();
    }
  };

</script>
<style>
  .main-content {
    min-height: 100px;
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
    background-color: #ffd60c;
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
