<template>
  <div class="agent-operation-toolbar">
    <el-form :inline="true">
      <el-row type="flex" justify="space-between">
        <div>
          <el-form-item label="">
            <el-input v-model="queryFormData.keyword" placeholder=""></el-input>
          </el-form-item>
          <el-button-group>
            <el-button class="toolbar-search_input" @click="onAdvancedSearch">搜索</el-button>
            <el-button @click="onReset">重置</el-button>
          </el-button-group>
        </div>
        <div>
          <el-button type="primary" @click="visible = true">添加公告</el-button>
        </div>
      </el-row>
    </el-form>
    <el-dialog title="添加公告" :visible.sync="visible" :close-on-click-modal="false" append-to-body>
      <notice-form v-if="visible" @callback="callback"/>
    </el-dialog>
  </div>
</template>

<script>
import NoticeForm from '../form/NoticeForm.vue';
export default {
  components: { NoticeForm },
  name: 'NoticeToolbar',
  props: ['queryFormData'],
  methods: {
    onAdvancedSearch () {
      this.$emit('onAdvancedSearch');
    },
    onReset () {
      this.queryFormData.keyword = '';
    },
    callback (flag) {
      this.visible = false

      if (flag) {
        this.$emit('onAdvancedSearch');
      }
    }
  },
  data () {
    return {
      visible: false
    }
  }
}
</script>

<style scoped>
.agent-operation-toolbar >>> .el-form-item {
    margin-bottom: 0px;
}

.toolbar-search_input {
  background-color: #ffd60c;
  border-color: #ffd60c;
}
</style>