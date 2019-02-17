<template>
  <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
    <el-row :gutter="10">
      <el-col :span="6">
        <el-form-item label="手机号" prop="contactPhone">
          <el-input v-model="slotData.contactPhone" placeholder="手机号"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="联系人" prop="contactPerson">
          <el-input v-model="slotData.contactPerson" placeholder="联系人"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="密码" prop="password">
          <el-input type="password" v-model="slotData.password" auto-complete="off"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input type="password" v-model="slotData.confirmPassword" auto-complete="off"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: 'BrandAccountForm',
    props: ['slotData', 'isNewlyCreated', 'readOnly'],
    methods: {
      validate(callback) {
        return this.$refs['form'].validate(callback);
      },
      getValue() {
        return this.slotData;
      }
    },
    computed: {},
    data() {
      //密码校验
      const validatePass = (rule, value, callback) => {
        if (this.isNewlyCreated) {
          if (value === '') {
            callback(new Error('请输入密码'));
          } else {
            if (this.slotData.confirmPassword !== '') {
              this.$refs.form.validateField('confirmPassword');
            }
            callback();
          }
        } else {
          callback();
        }
      }; //密码校验
      const validatePass2 = (rule, value, callback) => {
        if (this.isNewlyCreated) {
          if (value === '') {
            callback(new Error('请再次输入密码'));
          } else if (value !== this.slotData.password) {
            callback(new Error('两次输入密码不一致!'));
          } else {
            callback();
          }
        } else {
          callback();
        }
      };
      return {
        rules: {
          contactPerson: [{required: true, message: '必填', trigger: 'blur'}],
          contactPhone: [
            {required: true, message: '必填', trigger: 'blur'},
            {required: true, message: '手机号码不正确', trigger: 'blur', pattern: 11 && /^((13|14|15|17|18)[0-9]{1}\d{8})$/}],
          password: [
            {required: true, message: '必填', trigger: 'blur'},
            {validator: validatePass, trigger: 'blur'},
            {
              required: true, message: '密码格式不正确，必须包含数字,字母,特殊符号两种或以上组合，且长度为6-16位',
              trigger: 'blur', pattern: '^(?![0-9]+$)(?![a-zA-Z]+$)(?!([^(0-9a-zA-Z)]|[\\(\\)])+$)([^(0-9a-zA-Z)]|[\\(\\)]|[a-zA-Z]|[0-9]){6,16}$'
            }
          ],
          confirmPassword: [
            {required: true, message: '必填', trigger: 'blur'},
            {validator: validatePass2, trigger: 'blur'}
          ]
        }
      };
    }
  };
</script>
