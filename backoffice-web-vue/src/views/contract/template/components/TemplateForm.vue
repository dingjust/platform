<template>
  <div class="animated fadeIn">
    <!--    <el-card>-->
    <el-row type="flex" justify="center">
      <span style="font-size: 14px; color: #9da0a8">{{ this.titleName }}(模板)</span>
    </el-row>
    <div class="pt-2"></div>
    <el-container>
      <el-aside width="150px" class="template-aside">
        <el-row justify="center" type="flex">
          <h6 class="template-aside_text">基础合同范本</h6>
        </el-row>
        <el-row :span="3" v-for="(item, index) in mockData" :key="index" :offset="0">
          <div :class="
              item.code == selectedCode
                ? 'template-file_selected'
                : 'template-file'
            " @click="onSelect(item)">
            <a href="#template">
              <div class="template-ban" v-show="item.baned">
                <i class="el-icon-remove template-ban_icon"></i>
              </div>
              <el-row type="flex" justify="center">
                <img src="static/img/word.png" class="img-word" alt="" />
              </el-row>
              <el-row type="flex" justify="center">
                <el-col :span="16" style="text-align: center">
                  <h6 class="template-name">{{ item.title }}</h6>
                </el-col>
              </el-row>
            </a>
          </div>
        </el-row>
      </el-aside>
      <el-main style="margin-left: 30px">
        <div id="template">
          <el-row type="flex" justify="space-between" align="middle">
            <el-col :span="4">
              <div class="template-form-header">
                <h6>新建合同模板</h6>
              </div>
            </el-col>
            <el-col :span="4">
              <el-button-group>
                <el-button type="warning" class="template-form-button" @click="onSave">保存</el-button>
                <!--<el-button @click="onBack">返回</el-button>-->
              </el-button-group>
            </el-col>
          </el-row>
          <el-row class="contract_custom-row">
            <el-input placeholder="请输入内容" size="mini" v-model="tempName" @blur="inputBlur"><template
                slot="prepend">合同模板名称</template>
            </el-input>
            <h6 style="color: #f56c6c; margin-left: 120px">
              {{ this.passCheck ? "" : this.validateText }}
            </h6>
          </el-row>
          <el-row class="contract_custom-row">
            <el-input placeholder="请输入内容" size="mini" v-model="remarks"><template slot="prepend">备注</template>
            </el-input>
          </el-row>
          <el-row class="contract_custom-row"><span></span></el-row>
          <el-row class="contract_custom-row text-align-left">
            <h6>固定条款</h6>
          </el-row>
          <el-row>
            <div class="contract_custom-fixed_terms">
              <Viewer :value="viewerText" class="contract_custom-viewer" />
            </div>
          </el-row>
          <template v-if="tempType != 'ZFXY'">
            <el-row class="contract_custom-row text-align-left">
              <h6>自定义条款</h6>
            </el-row>
            <el-row>
              <div class="contract_custom-custom_terms">
                <Editor v-model="editorText" :html="editorHtml" :options="editorOptions" :visible="editorVisible"
                  class="contract_custom-editor" />
              </div>
            </el-row>
          </template>
        </div>
      </el-main>
    </el-container>
    <!--    </el-card>-->
  </div>
</template>
<script>
  // import 'tui-editor/dist/tui-editor.css';
  // import 'tui-editor/dist/tui-editor-contents.css';
  // import 'highlight.js/styles/github.css';
  // import 'codemirror/lib/codemirror.css';
  import http from "@/common/js/http";

  import {
    Viewer,
    Editor
  } from "@toast-ui/vue-editor";

  import {
    createNamespacedHelpers
  } from "vuex";

  const {
    mapActions
  } = createNamespacedHelpers("ContractTemplateModule");

  export default {
    name: "TemplateForm",
    props: ["propdata", "tempFormVisible", "slotData", "templateId"],
    methods: {
      ...mapActions({
        refresh: "refresh",
        search: "search",
      }),
      onSelect(item) {
        this.selectedCode = item.code;
        this.viewerText = item.header;
        this.editorText = item.content;
        this.tempCode = item.code;
        this.tempType = item.type;
        this.titleName = item.title;
      },
      async getTemplate(code) {
        const url = this.apis().getTemplates(code);
        const result = await this.$http.get(url);
      },
      onBack() {
        this.fn.closeSlider(true);
      },
      onSave() {
        this.checkTempName().then(res => {
          if (res) {
            this._onSave();
          }
        })
      },
      async _onSave() {
        if (!this.passCheck) {
          // this.validateText = '模板名称重复，请重新输入';
          this.$message.error("请完善页面信息");
          return;
        }
        const url = this.apis().saveTemplate();
        const tempData = {
          title: this.tempName,
          content: this.viewerText,
          customizeContent: this.tempType != "ZFXY" ? this.editorText : "",
          type: this.tempType,
          available: true,
          originalTmplCode: this.tempCode,
          remark: this.remarks,
        };
        let formData = Object.assign({}, tempData);
        const result = await http.post(url, formData);
        // if (result['errors']) {
        //   this.$message.error(result['errors'][0].message);
        //   return;
        // }
        this.$message.success(result.msg);
        this.$emit("turnTempFormVisible", false);
        this.$emit("onSearch");
        this.$emit("contractTemplateSelect");
        this.fn.closeSlider(true);
      },
      inputBlur () {
        if (this.tempName == null || this.tempName.replace(/(^\s*)|(\s*$)/g, "").length === 0) {
          this.validateText = "请输入模板名称";
        } else {
          this.validateText = "";
        }
      },
      async checkTempName() {
        if (this.tempName == null || this.tempName.replace(/(^\s*)|(\s*$)/g, "").length === 0) {
          this.validateText = "请输入模板名称";
          return false;
        }

        let formData = {
          name: this.tempName,
        };
        const url = this.apis().checkTempName();
        const result = await http.post(url, formData);

        if (result.code == 1) {
          this.passCheck = true;
          return true;
        } else if (result.code == 0) {
          this.passCheck = false;
          this.validateText = "模板名称重复，请重新输入";
        }

        return false;
      },
    },
    data() {
      return {
        input1: "",
        input2: "",
        keyword: "",
        viewerText: "",
        editorText: "",
        editorHtml: "",
        editorOptions: {
          minHeight: "400px",
          language: "zh_CN",
          useCommandShortcut: true,
          useDefaultHTMLSanitizer: true,
          usageStatistics: true,
          hideModeSwitch: true,
        },
        tempContent: "",
        selectedCode: "",
        editorVisible: true,
        mockData: [],
        tempName: "",
        remarks: "",
        tempType: "",
        tempCode: "",
        titleName: "",
        passCheck: false,
        validateText: "",
      };
    },

    components: {
      Viewer,
      Editor,
    },

    computed: {
      contractName() {
        return this.propdata.contractName;
      },
    },

    watch: {
      propdata(newValue, oldValue) {},
    },
    created() {
      let i = 0;
      if (this.templateId) {
        i = this.templateId;
      }
      // this.getTemplateListPt();
      this.mockData = this.slotData;
      this.viewerText = this.slotData[i].header;
      this.editorText = this.slotData[i].content;
      this.selectedCode = this.slotData[i].code;
      this.tempCode = this.slotData[i].code;
      this.tempType = this.slotData[i].type;
      this.titleName = this.slotData[i].title;
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
    border-right: 5px solid #e6e6e6;
    // border-radius: 20px;
    padding-right: 10px;
    // position: fixed;
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
    border: 1px solid #e6e6e6;
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

  .contract_custom-editor {
    min-height: 550px;
  }

</style>
