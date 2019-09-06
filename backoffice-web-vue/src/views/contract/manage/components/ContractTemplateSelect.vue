<template>
  <div class="animated fadeIn template-body" style="height: 500px;">
    <el-card>
      <el-container  style="height: 500px;">
        <el-aside width="150px"  style="height: 500px;" class="template-aside">
          <el-row justify="center" type="flex">
            <h6 class="template-aside_text">订单基础合同范本</h6>
          </el-row>
          <el-row :span="3" v-for="(item, index) in tempData" :key="index" :offset="0">
            <div  @click="selectType(item)">
              <div class="template-ban" v-show="item.baned">
                <i class="el-icon-remove template-ban_icon"></i>
              </div>
              <el-row type="flex" justify="center">
                <img src="static/img/word.png" class="img-word" alt="" />
              </el-row>
              <el-row type="flex" justify="center">
                <el-col :span="16" style="text-align: center">
                  <h6 class="template-name">{{item.title}}</h6>
                </el-col>
              </el-row>
            </div>
          </el-row>
        </el-aside>
        <el-main>
          <el-row :gutter="10">
            <el-col :span="4" v-for="(item, index) in mockData" :key="index" :offset="0">
              <div @click="onSelect(item)">
                <el-row type="flex" justify="center">
                  <img src="static/img/word.png" class="img-word" alt=""/>
                </el-row>
                <el-row type="flex" justify="center">
                  <el-col :span="23">
                    <h6 class="template-name">{{item.title}}</h6>
                  </el-col>
                </el-row>
              </div>
            </el-col>
          </el-row>
        </el-main>
      </el-container>
    </el-card>
  </div>
</template>

<script>
  import http from '@/common/js/http';

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
        console.log(this.selectedItem);
        this.$emit('fileSelectChange',this.selectedItem );
      },
      async getTemplateListPt(){
        const url = this.apis().getTemplatesListPt();
        const result = await http.post(url, {
          keyword: ''
        }, {
          page: 0,
          size: 10
        });
        console.log(result);
        this.tempData = result.content;
      },
      selectType(item){
        var temp =[];
        for(var i=0; i<this.allData.length;i++){
          if(item.type == this.allData[i].type){
            // temp.$set(this.allData[i]);
            temp.push(this.allData[i]);
          }
        }
        this.mockData = [];
        for(var i=0; i<temp.length;i++){
          this.mockData.push(temp[i]);
        }

        console.log(this.mockData);
      },
      async onSearchTemp(keyword,page, size) {
        if(keyword == null){
          keyword = '';
        }
        const url = this.apis().getTemplatesList();
        const result = await this.$http.post(url,{
          keyword: keyword
        }, {
          page: 0,
          size: 100
        });
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.allData = result.content;
        this.mockData = result.content;
      },
    },
    created(){
      this.getTemplateListPt();
      this.onSearchTemp();
    },
    data() {
      return {
        selectedItem: {},
        tempData:[],
        mockData:[],
        allData:[],
      };
    },
  };

</script>
<style lang="scss" scoped>
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

  .template-aside {
    border-right: 5px solid #E6E6E6;
    // border-radius: 20px;
    padding-right: 10px;
  }

  .template-aside_text {
    font-size: 12px;
    margin-bottom: 20px;
  }

  .img-word {
    width: 50px;
    height: 50px;
  }

  .contract_custom-row {
    margin: 20px 0;
  }

  .text-align-left {
    text-align: left;
  }

  .contract_custom-fixed_terms {
    padding: 5px;
    text-align: left;
    border: 1px solid #E6E6E6;
    //   border-radius: 10px;
  }

  .contract_custom-custom_terms {
    text-align: left;
  }

  .contract_custom-viewer {
    min-height: 200px;
  }

  .template-form-header {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
    font-weight: bold;
  }

  .template-form-header h6 {
    font-weight: bold;
  }

  .template-form-button {
    background-color: #ffd60c;
    border-color: #ffd60c;
    margin-left: 20px;
    color: #000;
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
