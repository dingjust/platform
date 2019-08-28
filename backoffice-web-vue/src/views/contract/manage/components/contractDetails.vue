<template>
  <el-container>
    <el-main>
      <el-row
        class="contract_custom-row"
        type="flex"
        justify="start"
      >
        <el-col :span="4">
          <span>合同状态:待签署</span>
        </el-col>
        <el-col :span="6">
          <span>合同编号:HT0000000001</span>
        </el-col>
      </el-row>
      <el-row class="contract_custom-row contract_title text-align-center">
        <span>委托生产合同</span>
      </el-row>
      <el-row>
        <div class="contract_custom-fixed_terms">
          <Viewer
            :value="viewerText"
            class="contract_custom-viewer"
          />
        </div>
      </el-row>
    </el-main>
    <el-aside width="73px">
      <div class="dialog-aside_buttons">
        <el-button-group>
          <el-button icon="el-icon-edit">签署</el-button>
          <el-button icon="el-icon-share">下载</el-button>
          <el-button icon="el-icon-delete">作废</el-button>
        </el-button-group>
      </div>
    </el-aside>
  </el-container>
</template>

<script>
import "tui-editor/dist/tui-editor.css";
import "tui-editor/dist/tui-editor-contents.css";
import "highlight.js/styles/github.css";
import "codemirror/lib/codemirror.css";
import { Viewer, Editor } from "@toast-ui/vue-editor";
export default {
  name: "ContractDetails",
  props: ["propdata"],
  data() {
    return {
      input1: "",
      input2: "",
      viewerText:
        "### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容### 合作模板### 自定义内容 #### 我是自定义内容"
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
.contract_custom-row {
  // margin: 20px 0;
}

.contract_title {
  margin-top: 20px;
}

.text-align-center {
  text-align: center;
  color: #000;
  font-size: 20px;
  font-weight: bold;
}

.contract_custom-fixed_terms {
  padding: 20px;
  text-align: center;
  // border: 1px solid #969696;
  //   border-radius: 10px;
}

.contract_custom-viewer {
  min-height: 300px;
}
.dialog-aside_buttons {
  margin-top: 200px;
}
</style>
