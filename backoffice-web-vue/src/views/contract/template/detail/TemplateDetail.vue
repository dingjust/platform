<template>
  <div class="animated fadeIn content">
    <el-card>
      <el-container>
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
                  <!--<el-button type="warning" class="template-form-button" @click="onSave">保存</el-button>-->
                  <el-button @click="onBack">返回</el-button>
                </el-button-group>
              </el-col>
            </el-row>
            <el-row class="contract_custom-row">
              <el-input placeholder="请输入名称" size="mini" v-model="slotData.title"><template slot="prepend">合同模板名称</template>
              </el-input>
            </el-row>
            <el-row class="contract_custom-row">
              <el-input placeholder="请输入备注" size="mini" v-model="slotData.remarks"><template slot="prepend">备注</template>
              </el-input>
            </el-row>
            <el-row class="contract_custom-row"><span></span></el-row>
            <el-row class="contract_custom-row text-align-left"><span>固定条款</span></el-row>
            <el-row>
              <div class="contract_custom-fixed_terms">
                <Viewer :value="slotData.customizeContent" class="contract_custom-viewer" />
              </div>
            </el-row>
            <el-row class="contract_custom-row text-align-left"><span>自定义条款</span></el-row>
            <el-row>
              <div class="contract_custom-fixed_terms">
                <Viewer :value="slotData.customizeContent" class="contract_custom-viewer" />
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
  import http from '@/common/js/http';

  import {
    Viewer,
    Editor
  } from "@toast-ui/vue-editor";

  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('ContractTemplateModule');

  export default {
    name: "TemplateDetail",
    props: ["slotData"],
    methods: {
      ...mapActions({
        refresh: 'refresh',
        search: "search"
      }),
      onSelect(item) {
        this.slotData.content = item.header;
        this.slotData.customizeContent = item.content;
        this.slotData.code = item.code;
        this.slotData.type = item.type;
      },
      async getTemplate(code) {
        const url = this.apis().getTemplates(code);
        const result = await this.$http.get(url);
      },
      onBack(){
        this.fn.closeSlider(true);
      },
      async onSave(){
        const url = this.apis().saveTemplate();
        const tempData = {
          title: this.tempName,
          content: this.editorText,
          customizeContent: this.viewerText,
          type: this.tempType,
          available: true,
          originalTmplCode: this.tempCode,
          remark: this.remarks
        };
        let formData = Object.assign({}, tempData);
        const result = await http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('保存成功');

        this.$emit("onSearch",0);
        this.fn.closeSlider(true);
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
        this.mockData = result.content;
      },
    },
    data() {
      return {
        editorHtml: "",
        editorOptions: {
          minHeight: "400px",
          language: "zh_CN",
          useCommandShortcut: true,
          useDefaultHTMLSanitizer: true,
          usageStatistics: true,
          hideModeSwitch: false
        },
        tempContent:'',
        selectedCode: '3',
        editorVisible: true,
        mockData: [],
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
    },
    created(){
      this.getTemplateListPt();
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
