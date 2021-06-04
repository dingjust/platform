<template>
  <div class="temp-form">
    <el-tabs v-model="activeName">
      <el-tab-pane label="编辑" name="EDIT">
        <div>
          <el-row type="flex" justify="start" align="middle">
            <h6>模板名称</h6>
          </el-row>
          <el-row type="flex">
            <el-input v-model="detail.title" placeholder=""></el-input>
          </el-row>
          <template v-if="isCreate">
            <el-row type="flex" justify="start" align="middle" style="margin-top: 20px">
              <h6>模板类型</h6>
            </el-row>
            <el-row type="flex">
              <el-input v-model="detail.type" placeholder=""></el-input>
            </el-row>
          </template>
          <el-row type="flex" justify="start" align="middle" style="margin-top: 20px">
            <h6>固定条款</h6>
          </el-row>
          <el-row type="flex">
            <Editor style="width: 100%" v-model="detail.header" :options="editorOptions"/>
          </el-row>
          <el-row type="flex" justify="start" align="middle" style="margin-top: 30px">
            <h6>自定义条款</h6>
          </el-row>
          <el-row type="flex">
            <Editor style="width: 100%" v-model="detail.content" :options="editorOptions"/>
          </el-row>
        </div>
      </el-tab-pane>
      <el-tab-pane label="预览" name="READ">
        <!-- <el-row type="flex" justify="start">
          <h6>{{detail.title}}</h6>
        </el-row> -->
        <div class="read-box">
          <el-row type="flex" style="padding: 0 10px;">
            <Viewer :value="detail.header" style="width: 100%"/>
          </el-row>
          <el-divider></el-divider>
          <el-row type="flex" style="padding: 0 10px;">
            <Viewer :value="detail.content" style="width: 100%"/>
          </el-row>
        </div>
      </el-tab-pane>
    </el-tabs>
    <el-row type="flex" justify="center" align="middle">
      <el-button type="primary" class="save-btn" @click="onSave">{{isCreate ? '创建' : '修改'}}</el-button>
    </el-row>
  </div>
</template>

<script>
import {
  Viewer,
  Editor
} from "@toast-ui/vue-editor";

export default {
  name: 'ContractBackTempForm',
  props: ['detail', 'isCreate'],
  components: { Editor, Viewer },
  methods: {
    onSave () {
      this.$confirm('是否执行' + (this.isCreate ? '创建 ' : '修改 ') + this.detail.title +' 模板操作?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this._onSave();
      });
    },
    async _onSave () {
      const form = {
        id: this.detail.id ? this.detail.id : '',
        title: this.detail.title,
        code: this.detail.code,
        header: this.detail.header,
        content: this.detail.content,
        type: this.detail.type,
        available: true
      };

      const url = this.apis().updateContractTempOnPlatform();
      const result = await this.$http.post(url, form);

      if (result['errors']) {
        this.$message.error(result['errors'][0].message);
        return;
      }
      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }

      this.$emit('callback', this.detail);
    }
  },
  data () {
    return {
      activeName: 'EDIT',
      editorHtml: '',
      editorOptions: {
        minHeight: '400px',
        language: "zh_CN",
        useCommandShortcut: true,
        useDefaultHTMLSanitizer: true,
        usageStatistics: true,
        hideModeSwitch: true
      }
    }
  }
}
</script>

<style scoped>
  .clause-detail {
    padding: 5px;
    border: 1px solid #e6e6e6;
  }

  .save-btn {
    margin-top: 20px;
    width: 120px;
    height: 40px;
  }

  .temp-form >>> .te-md-splitter {
    width: 100%
  }

  .read-box {
    border: 1px solid #dbdbdb;
  }
</style>