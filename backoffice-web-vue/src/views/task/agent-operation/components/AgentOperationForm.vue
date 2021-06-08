<!--
* @Description: 代运营审阅通过后提交的信息表单
* @Date 2021/05/28 14:12
* @Author L.G.Y
-->
<template>
  <div class="agent-operation">
    <el-form ref="form" :model="formData" :rules="rules" label-position="left" label-width="80px">
      <el-form-item label="姓名" prop="agentName">
        <el-input v-model.trim="formData.agentName"></el-input>
      </el-form-item>
      <el-form-item label="手机号" prop="agentPhone">
        <el-input v-model="formData.agentPhone"></el-input>
      </el-form-item>
      <el-form-item label="密码" prop="agentPassword">
        <el-input v-model="formData.agentPassword" show-password auto-complete="off"></el-input>
      </el-form-item>
      <el-form-item label="合同编号">
        <el-input v-model="formData.userAgreementmentForm.userTempCode"></el-input>
      </el-form-item>
      <el-form-item label="公司编号">
        <el-input v-model="formData.userAgreementmentForm.companyCode"></el-input>
      </el-form-item>
    </el-form>
    <el-row type="flex" justify="end">
      <el-button @click="onCancel">取消</el-button>
      <el-button type="primary" @click="onSumbit">提交</el-button>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'AgentOperationForm',
  props: ['handleRow'],
  methods: {
    onCancel () {
      this.$emit('closeDialog');
    },
    onSumbit () {
      this.$refs.form.validate(valid => {
        if (valid) {
          this.$confirm('是否执行表单提交?', '', {
            confirmButtonText: '是',
            cancelButtonText: '否',
            type: 'warning'
          }).then(() => {
            this._onSumbit()
          });
        }
      })
    },
    async _onSumbit () {
      let date = new Date();
      const validityStart = new Date(date.toLocaleDateString()).getTime();
      date.setFullYear(date.getFullYear() + 1);
      const validityEnd = new Date(date.toLocaleDateString()).getTime();

      let form = Object.assign({}, this.formData);
      form.id = this.handleRow.id;
      form.userAgreementmentForm.validityStart = validityStart;
      form.userAgreementmentForm.validityEnd = validityEnd;

      const url = this.apis().AgentOperationReviewPass();
      const result = await this.$http.put(url, form);

      if (result.code === 1) {
        this.$message.success('操作成功！');
        this.$emit('callback');
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else {
        this.$message.error('操作失败！');
      }
    }
  },
  data () {
    var validatePhone = async (rule, value, callback) => {
      const reg = /^[1][3,4,5,6,7,8,9][0-9]{9}$/;
      if (value === '') {
        callback(new Error('请输入手机号码'));
      } else if (!reg.test(value)) {
        callback(new Error('请输入合法手机号码'));
      } else {
        callback();
      }
    };
    return {
      formData: {
        agentName: '',
        agentPhone: '',
        agentPassword: '',
        userAgreementmentForm: {
          userTempCode: 'd0b150f3-f3c1-4a00-810f-eafb83096428',
          companyCode: 'TPP00012002'
        }
      },
      rules: {
        agentName: [{required: true, message: '必填', tigger: 'change'}],
        agentPhone: [{required: true, validator: validatePhone, tigger: 'change'}],
        agentPassword: [{required: true, message: '必填', tigger: 'change'}]
      }
    }
  }
}
</script>

<style scoped>
.agent-operation {
  padding: 0 20px;
}
</style>
