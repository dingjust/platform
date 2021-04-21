<template>
  <div>
    <el-row class="contract_custom-row">
      <el-input placeholder="请输入内容" size="mini" v-model="input1">
        <template slot="prepend">合同模板名称</template>
      </el-input>
    </el-row>
    <el-row class="contract_custom-row">
      <el-input placeholder="请输入内容" size="mini" v-model="input2">
        <template slot="prepend">备注</template>
      </el-input>
    </el-row>
    <el-row class="contract_custom-row">
      <span></span>
    </el-row>
    <el-row class="contract_custom-row text-align-left">
      <span>固定条款</span>
    </el-row>
    <el-row>
      <div class="contract_custom-fixed_terms">
        <Viewer :value="viewerText" class="contract_custom-viewer" />
      </div>
    </el-row>
    <el-row class="contract_custom-row text-align-left">
      <span>自定义条款</span>
    </el-row>
    <el-row>
      <div class="contract_custom-custom_terms">
        <Editor v-model="editorText" :html="editorHtml" :options="editorOptions" :visible="editorVisible"
          previewStyle="vertical" />
      </div>
    </el-row>
  </div>
</template>

<script>
  // import "tui-editor/dist/tui-editor.css";
  // import "tui-editor/dist/tui-editor-contents.css";
  // import "highlight.js/styles/github.css";
  // import "codemirror/lib/codemirror.css";

  import {
    Viewer,
    Editor
  } from "@toast-ui/vue-editor";
  export default {
    name: "ContractDetails",
    props: ["propdata"],
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
        editorVisible: true
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
      propdata(newValue, oldValue) {}
    }
  };

</script>

<style lang="scss" scoped>
  .contract_custom-row {
    margin: 20px 0;
  }

  .text-align-left {
    text-align: left;
  }

  .contract_custom-fixed_terms {
    padding: 5px;
    text-align: left;
    border: 1px solid #969696;
    //   border-radius: 10px;
  }

  .contract_custom-custom_terms {
    text-align: left;
  }

  .contract_custom-viewer {
    min-height: 200px;
  }

</style>
