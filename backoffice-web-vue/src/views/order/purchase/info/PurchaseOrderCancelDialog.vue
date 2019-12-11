<template>
  <div class="animated fadeIn">
    <el-form :model="form" ref="form" :rules="rules">
      <el-row class="cancel-info-title-row">
        <div class="cancel-info-title">
          <h6 class="cancel-info-title_text">取消订单</h6>
        </div>
      </el-row>
      <el-form-item label="取消原因" label-position="top" prop="textarea">
          <el-input type="textarea" :rows="10" placeholder="请输入内容" v-model="form.textarea"></el-input>
      </el-form-item>
      <el-row class="cancel-button" type="flex" justify="center" align="middle" :gutter="100">
        <el-col :span="6">
          <el-button class="btn-block" size="mini" @click="onCancel">
            取消
          </el-button>
        </el-col>
        <el-col :span="6">
          <el-button class="btn-block" size="mini" type="primary" @click="onSubmit">
            提交
          </el-button>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
    export default {
      name: 'PurchaseOrderCancelDialog',
      data () {
        return {
          form: {
            textarea: ''
          },
          rules: {
            textarea: [
              { required: true, message: '请输入取消原因', trigger: 'blur' },
              { min: 10, message: '取消原因不少于 10 个字符', trigger: 'blur' }
            ]
          }
        }
      },
      methods: {
        onCancel () {
          this.$emit('closePurchaseOrderCancelVisible');
        },
        onSubmit () {
          this.$emit('_cancel', this.form.textarea);
        }
      }
    }
</script>

<style scoped>
  .cancel-info-title-row {
    margin-bottom: 20px;
  }
  .cancel-info-title {
    width: 100%;
    border-left: 2px solid #FFD60C;
    padding-left: 10px;
    height: 20px;
  }
  .cancel-info-title_text {
    font-size: 16px;
    font-weight: 500;
    color: rgba(0, 0, 0, 1);
    opacity: 0.65;
  }
  .cancel-button {
    margin-left: 20px;
    margin-top: 20px;
  }
</style>
