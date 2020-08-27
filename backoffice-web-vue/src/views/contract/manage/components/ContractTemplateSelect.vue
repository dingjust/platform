<template>
  <div class="animated fadeIn template-body" style="height: auto">
    <el-card>
      <el-container  style="">
        <el-aside width="150px"  style="" class="template-aside">
          <el-row justify="center" type="flex">
            <h6 class="template-aside_text">订单基础合同范本</h6>
          </el-row>
          <el-row :span="3" v-for="(item, index) in tempData" :key="index" :offset="0">
            <div v-if="item.title!=null && item.title!=''&& item.type ==tempType && (tempType != null && tempType != 'undefined' && tempType != '')" :class="item.code==selectedItemTemp.code?'template-file_selected':'template-file'" @click="selectType(item)">
              <!--<div class="template-ban" v-show="item.baned">-->
                <!--<i class="el-icon-remove template-ban_icon"></i>-->
              <!--</div>-->
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
    <div class="main-content" style="">
      <el-row >
        <template v-if="mockData!=null && mockData!= []">
          <el-col :span="4" v-for="(item, index) in mockData" :key="index" :offset="0">
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
        </template>
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
    name: "ContractTemplateSelect",
    props:['tempType'],
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
      async getTemplateListPt(){
        const url = this.apis().getTemplatesListPt();
        const result = await http.post(url, {
          keyword: ''
        }, {
          page: 0,
          size: 10
        });
        this.tempData = result.content;
      },
      selectType(item){
        this.onSearchTemp();
        this.selectedItemTemp = item;
        var temp =[];
        if(this.allData != null && this.allData != []){
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
          this.mockData.push(temp);

        }

      },
      async onSearchTemp(keyword,page, size) {
        if(keyword == null){
          keyword = '';
        }
        const url = this.apis().getTemplatesList();
        const result = await this.$http.post(url,{
            type: this.tempType,
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
        if(this.tempType != null){
          var temp =[];
          if(this.allData != null && this.allData != []){
            for(var i=0; i<this.allData.length;i++){
              if(this.tempType == this.allData[i].type){
                temp.push(this.allData[i]);
              }
            }
            this.mockData = [];
            for(var i=0; i<temp.length;i++){
              this.mockData.push(temp[i]);
            }
            this.mockData.push(temp);

          }
        }
      },
    },
    data() {
      return {
        selectedItem: {},
        selectedItemTemp: {},
        tempData:[],
        allData:[],
        mockData:[],
      };
    },
    created(){
      this.getTemplateListPt();
      // this.onSearchTemp();
      this.mockData = [];
      this.onSearchTemp();
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
