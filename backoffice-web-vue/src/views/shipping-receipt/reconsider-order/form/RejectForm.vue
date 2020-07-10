<!-- 
 * @description: 拒绝复议单表单
 * @fileName: RejectForm.vue 
 * @author: yj 
 * @date: 2020-06-23 16:55:03
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn receipt-order-container">
    <el-form :model="form">
      <el-row type="flex" justify="center" style="margin-top:20px">
        <el-col :span="20">
          <el-form-item label="审批意见">
            <el-input type="textarea" :autosize="{ minRows: 5, maxRows:10}" placeholder="请输入内容" v-model="form.remarks">
            </el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row type="flex" justify="space-between" style="margin-top:20px">
        <el-col :span="12" :offset="2">
          <el-row type="flex">
            <h6 style="margin-right:20px">上传凭证</h6>
            <images-upload class="form-upload" :slot-data="form.medias" />
          </el-row>
        </el-col>
      </el-row>
    </el-form>
    <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50">
      <template>
        <el-col :span="4">
          <el-button class="material-btn" @click="onSubmit">确定</el-button>
        </el-col>
      </template>
    </el-row>
  </div>
</template>

<script>
  import ImagesUpload from '@/components/custom/ImagesUpload';

  export default {
    name: 'RejectForm',
    props: {
      reconsiderOrder: {
        type: Object
      }
    },
    components: {
      ImagesUpload
    },
    computed: {

    },
    methods: {
      onSubmit() {
        //校验数量与订单差异
        this._onSubmit();
      },
      async _onSubmit() {
        const url = this.apis().rejectReconsider(this.reconsiderOrder.id);
        let submitForm = Object.assign({}, this.form);
        const result = await this.$http.put(url, submitForm);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        if (result.code == '0') {
          this.$message.error(result.msg);
        } else if (result.code == '1') {
          this.$message.success(result.msg);
          this.$emit('callback');
        }
      },
    },
    data() {
      return {
        form: {
          marks: '',
          medias:[]
        },
        attachments: []
      }
    },
    created() {

    },
    destroyed() {

    }
  }

</script>

<style scoped src="../../css/reconsider-order.css"></style>
