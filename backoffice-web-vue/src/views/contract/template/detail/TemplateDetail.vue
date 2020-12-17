<template>
  <div class="animated fadeIn">
<!--    <el-card>-->
      <el-container>
        <el-main>
          <div>
            <!--<el-row type="flex" justify="space-between" align="middle">-->
              <!--<el-col :span="4">-->
                <!--<div class="template-form-header">-->
                  <!--<h6>新建合同模板</h6>-->
                <!--</div>-->
              <!--</el-col>-->
              <!--<el-col :span="4">-->
<!--            <div style="float:right;margin-bottom: 10px">-->
<!--                <el-button-group>-->
<!--&lt;!&ndash;                  <el-button @click="onBack">返回</el-button>&ndash;&gt;-->
<!--                </el-button-group>-->
<!--              &lt;!&ndash;</el-col>&ndash;&gt;-->
<!--              &lt;!&ndash;</el-row>&ndash;&gt;-->
<!--            </div>-->
            <div>
              <el-button type="warning" class="template-form-button" @click="onSave">保存</el-button>
            </div>
            <el-row class="contract_custom-row">
              <el-input placeholder="请输入名称" size="mini" v-model="slotData.title" @blur="checkTempName"><template slot="prepend">合同模板名称</template>
              </el-input>
              <h6 style="color: #F56C6C;margin-left: 120px">{{this.passCheck?'': this.validateText}}</h6>
            </el-row>
            <el-row class="contract_custom-row">
              <el-input placeholder="请输入备注" size="mini" v-model="slotData.remarks"><template slot="prepend">备注</template>
              </el-input>
            </el-row>
            <el-row class="contract_custom-row"><span></span></el-row>
            <el-row class="contract_custom-row text-align-left"><span>固定条款</span></el-row>
            <el-row>
              <div class="contract_custom-fixed_terms">
                <Viewer :value="slotData.content" class="contract_custom-viewer" />
              </div>
            </el-row>
            <el-row class="contract_custom-row text-align-left"><span>自定义条款</span></el-row>
            <el-row>
              <div class="contract_custom-fixed_terms">
                <!--<Viewer :value="slotData.customizeContent" class="contract_custom-viewer" />-->
                <Editor v-model="slotData.customizeContent" :html="editorHtml" :options="editorOptions"
                        :visible="editorVisible"  class="contract_custom-editor"/>
              </div>
            </el-row>
          </div>
        </el-main>
      </el-container>
<!--    </el-card>-->
  </div>
</template>
<script>
  import 'tui-editor/dist/tui-editor.css';
  import 'tui-editor/dist/tui-editor-contents.css';
  import 'highlight.js/styles/github.css';
  import 'codemirror/lib/codemirror.css';
  import http from '@/common/js/http';

  import {
    Viewer,
    Editor
  } from '@toast-ui/vue-editor';

  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('ContractTemplateModule');

  export default {
    name: 'TemplateDetail',
    props: ['slotData'],
    methods: {
      ...mapActions({
        refresh: 'refresh',
        search: 'search'
      }),
      onSelect (item) {
        this.slotData.content = item.header;
        this.slotData.customizeContent = item.content;
        this.slotData.code = item.code;
        this.slotData.type = item.type;
      },
      async getTemplate (code) {
        const url = this.apis().getTemplates(code);
        const result = await this.$http.get(url);
      },
      onBack () {
        this.fn.closeSlider(true);
      },
      async onSave () {
        if (this.slotData.title === this.originalTitle) {
          this.passCheck = true;
        }
        if (!this.passCheck) {
          this.$message.error('请完善页面信息');
          return;
        }
        // if (this.slotData.title == null || this.slotData.title == '') {
        //   this.$message.error('请输入模板名字');
        //   return;
        // }
        const url = this.apis().saveTemplate();
        const tempData = {
          title: this.slotData.title,
          content: this.slotData.content,
          customizeContent: this.slotData.customizeContent,
          type: this.slotData.type,
          available: true,
          code: this.slotData.code,
          remark: this.slotData.remarks,
          id: this.slotData.id
        };
        let formData = Object.assign({}, tempData);
        const result = await http.post(url, formData);
        // if (result['errors']) {
        //   this.$message.error(result['errors'][0].message);
        //   return;
        // }
        this.$message.success(result.msg);
        this.$emit('closeDetails');
        // this.fn.closeSlider(true);
      },
      async checkTempName () {
        this.passCheck = false;
        if (this.slotData.title === this.originalTitle) {
          this.passCheck = true;
          return;
        }
        if (this.slotData.title == null || this.slotData.title == '' || this.slotData.title.replace(/(^\s*)|(\s*$)/g, '').length === 0) {
          this.validateText = '请输入模板名称';
          return;
        }
        let formData = {
          name: this.slotData.title
        };
        const url = this.apis().checkTempName();
        const result = await http.post(url, formData);
        if (result.code == 1) {
          this.passCheck = true;
        } else if (result.code == 0) {
          this.passCheck = false;
          this.validateText = '模板名称重复，请重新输入';
        }
        // this.passCheck = result;
        // if (!this.passCheck) {
        //   this.validateText = '模板名称重复，请重新输入';
        // }
      },
      async getTemplateListPt () {
        const url = this.apis().getTemplatesListPt();
        const result = await http.post(url, {
          keyword: ''
        }, {
          page: 0,
          size: 10
        });
        this.mockData = result.content;
      }
    },
    data () {
      return {
        editorHtml: '',
        editorOptions: {
          minHeight: '400px',
          language: 'zh_CN',
          useCommandShortcut: true,
          useDefaultHTMLSanitizer: true,
          usageStatistics: true,
          hideModeSwitch: false
        },
        tempContent: '',
        selectedCode: '3',
        editorVisible: true,
        mockData: [],
        passCheck: false,
        validateText: '',
        originalTitle: '',
        count: 0
      };
    },

    components: {
      Viewer,
      Editor
    },

    computed: {
      contractName () {
        return this.propdata.contractName;
      }
    },

    watch: {
      propdata (newValue, oldValue) {
      }
    },
    created () {
      // this.getTemplateListPt();
      this.originalTitle = this.slotData.title;
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
