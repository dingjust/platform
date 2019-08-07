<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-container>
        <el-aside width="120px" class="template-aside">
          <el-row justify="center" type="flex">
            <h6 class="template-aside_text">订单基础合同范本</h6>
          </el-row>
          <el-row :span="3" v-for="(item, index) in mockData" :key="index" :offset="0">
            <div :class="item.code==selectedCode?'template-file_selected':'template-file'" @click="onSelect(item.code)">
              <div class="template-ban" v-show="item.baned">
                <i class="el-icon-remove template-ban_icon"></i>
              </div>
              <el-row type="flex" justify="center">
                <img src="static/img/word.png" class="img-word" alt="" />
              </el-row>
              <el-row type="flex" justify="center">
                <el-col :span="16">
                  <h6 class="template-name">{{item.name}}</h6>
                </el-col>
              </el-row>
            </div>
          </el-row>
        </el-aside>
        <el-main>
          <div>
            <el-row type="flex" justify="space-between" align="middle">
              <el-col :span="4">
                <div class="template-form-header">
                  <h6>新建合同模板</h6>
                </div>
              </el-col>
              <el-col :span="4">
                <el-button-group>
                  <el-button type="warning" class="template-form-button">保存</el-button>
                  <el-button >返回</el-button>
                </el-button-group>
              </el-col>
            </el-row>
            <el-row class="contract_custom-row">
              <el-input placeholder="请输入内容" size="mini" v-model="input1"><template slot="prepend">合同模板名称</template>
              </el-input>
            </el-row>
            <el-row class="contract_custom-row">
              <el-input placeholder="请输入内容" size="mini" v-model="input2"><template slot="prepend">备注</template>
              </el-input>
            </el-row>
            <el-row class="contract_custom-row"><span></span></el-row>
            <el-row class="contract_custom-row text-align-left"><span>固定条款</span></el-row>
            <el-row>
              <div class="contract_custom-fixed_terms">
                <Viewer :value="viewerText" class="contract_custom-viewer" />
              </div>
            </el-row>
            <el-row class="contract_custom-row text-align-left"><span>自定义条款</span></el-row>
            <el-row>
              <div class="contract_custom-custom_terms">
                <Editor v-model="editorText" :html="editorHtml" :options="editorOptions" :visible="editorVisible"
                  previewStyle="vertical" />
              </div>
            </el-row>
          </div>
        </el-main>
      </el-container>
    </el-card>
  </div>
</template>
<script>
  import "tui-editor/dist/tui-editor.css";
  import "tui-editor/dist/tui-editor-contents.css";
  import "highlight.js/styles/github.css";
  import "codemirror/lib/codemirror.css";

  import {
    Viewer,
    Editor
  } from "@toast-ui/vue-editor";

  export default {
    name: "TemplateForm",
    props: ["propdata"],
    methods: {
      onSelect(code) {
        this.selectedCode = code;
      },
    },
    data() {
      return {
        input1: "",
        input2: "",
        viewerText: "# 固定条款 \n xxxxxx",
        editorText: "**This is test** \n* vue \n* element \n* webpack",
        editorHtml: "",
        editorOptions: {
          minHeight: "400px",
          language: "zh_CN",
          useCommandShortcut: true,
          useDefaultHTMLSanitizer: true,
          usageStatistics: true,
          hideModeSwitch: false
        },
        selectedCode: '1',
        editorVisible: true,
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
        ]
      };
    },

    components: {
      Viewer,
      Editor
    },

    computed: {
      contractName() {
        return this.propdata.contractName;
      }
    },

    watch: {
      propdata(newValue, oldValue) {
        console.log(newValue);
      }
    }
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

</style>
