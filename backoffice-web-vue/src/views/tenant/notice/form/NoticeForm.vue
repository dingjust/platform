<!--
* @Description: 公告表单
* @Date 2021/08/10 16:49
* @Author L.G.Y
-->
<template>
  <div>
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
      <el-form-item label="序号">
        <el-input v-model="formData.sort"></el-input>
      </el-form-item>
    </el-form>
    <el-row type="flex" justify="end" align="center">
      <el-button @click="onCancel">取消</el-button>
      <el-button type="primary" @click="onNew">确定</el-button>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'NoticeForm',
  props: ['handleRow'],
  methods: {
    onNew () {
      this.$refs.form.validate(valid => {
        if (valid) {
          this.$confirm('是否' + (this.formData.id ? '修改' : '添加新的') +'公告', '提示', {
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

        this.$emit('callback', true)
      } else if (result.code === 0) {
        this.$message.error(result.msg)
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message)
      } else {
        this.$message.error('操作失败')
      }
    },
    onCancel () {
      this.$emit('callback', false)
    }
  },
  data () {
    return {
      formData: {
        type: 'NORMAL',
        content: '',
        url: '',
        sort: ''
      }
    }
  },
  created () {
    if (this.handleRow) {
      this.$set(this, 'formData', this.handleRow)
    }
  }
}
</script>

<style scoped>

</style>