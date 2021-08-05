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
      <el-form :model="formData" ref="form">
        <el-form-item label="公告类型">
          <el-radio v-model="formData.type" label="NORMAL">普通公告</el-radio>
          <el-radio v-model="formData.type" label="SYSTEM_ALTERNATE">预设公告</el-radio>
        </el-form-item>
        <el-form-item label="公告内容" prop="content" :rules="[{ required: true, message: '请输入公告信息', trigger: 'change' }]">
          <el-input v-model="formData.content" type="textarea" :rows="2"></el-input>
        </el-form-item>
        <el-form-item label="关联url">
          <el-input v-model="formData.url"></el-input>
        </el-form-item>
      </el-form>
      <el-row type="flex" justify="end" align="center">
        <el-button @click="visible = false">取消</el-button>
        <el-button type="primary" @click="onNew">确定</el-button>
      </el-row>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'NoticeToolbar',
  props: ['queryFormData'],
  methods: {
    onNew () {
      this.$refs.form.validate(valid => {
        if (valid) {
          this.$confirm('是否添加新的公告', '提示', {
            confirmButtonText: '是',
            cancelButtonText: '否',
            type: 'warning'
          }).then(() => {
            this._onNew()
          })
        }
      })
    },
    async _onNew () {
      const form = this.formData;

      const url = this.apis().createNotice()
      const result = await this.$http.post(url, form)

      if (result.code === 1) {
        this.$message.success('操作成功！')
        this.visible = false
        this.$emit('onAdvancedSearch');
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message)
      } else {
        this.$message.error('操作失败')
      }
    },
    onAdvancedSearch () {
      this.$emit('onAdvancedSearch');
    },
    onReset () {
      this.queryFormData.keyword = '';
    }
  },
  data () {
    return {
      visible: false,
      formData: {
        type: 'NORMAL',
        content: '',
        url: ''
      }
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