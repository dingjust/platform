<template>
  <div class="recommend-code-form">
    <el-form ref="form" :model="formData" label-width="80px">
      <el-form-item label="标题" prop="title" :rules="[{ required: true, message: '必填', tigger: 'change' }]">
        <el-input v-model="formData.title"></el-input>
      </el-form-item>
      <el-form-item label="备注">
        <el-input v-model="formData.remark"></el-input>
      </el-form-item>
      <el-form-item label="url">
        <el-input v-model="formData.url"></el-input>
      </el-form-item>
    </el-form>
    <el-row type="flex" justify="end">
      <el-button @click="onCancel">取消</el-button>
      <el-button type="primary" @click="onConfirm">提交</el-button>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'RecommendCodeForm',
  props: ['id'],
  methods: {
    onCancel () {
      this.$emit('closeDialog');
    },
    onConfirm () {
      this.$refs.form.validate(valid => {
        if (valid) {
          this.$confirm('是否' + (this.id ? '修改' : '新增') + '渠道码?', '', {
            confirmButtonText: '是',
            cancelButtonText: '否',
            type: 'warning'
          }).then(() => {
            this._onConfirm();
          });
        } else {
          this.$message.error('请完善表单信息');
        }
      })
    },
    async _onConfirm () {
      const form = {
        id: this.formData.id ? this.formData.id : null,
        title: this.formData.title,
        remark: this.formData.remark,
        url: this.formData.url
      };

      const url = this.apis().saveRecommendCode();
      const result = await this.$http.post(url, form);
      
      if (result.code === 1) {
        this.$message.success('操作成功！');
        this.$emit('callback');
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败！');
      }
    },
    async getDetail () {
      const id = this.id;

      const url = this.apis().getRecommendCodeById(id);
      const result = await this.$http.get(url);

      if (result.code === 1) {
        this.formData = {
          id: result.data.id,
          title: result.data.title,
          remark: result.data.remark,
          url: result.data.url
        };
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败！');
      }
    }
  },
  data () {
    return {
      formData: {
        title: '',
        remark: '',
        url: ''
      }
    }
  },
  created () {
    if (this.id) {
      this.getDetail();
    }
  }
}
</script>

<style scoped>

</style>