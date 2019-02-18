<template>
  <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
    <el-row :gutter="20">
      <el-col :span="12">
        <el-form-item label="UID" prop="uid">
          <el-input :disabled="!isNewlyCreated" v-model="slotData.uid"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="名称" prop="name">
          <el-input v-model="slotData.name"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row>
      <el-form-item label="手机号码" prop="phoneNumber">
        <el-input placeholder="请输入手机号码" v-model.number="slotData.mobileNumber">
          <template slot="prepend">+86</template>
        </el-input>
      </el-form-item>
    </el-row>
    <el-row v-if="isNewlyCreated">
      <el-form-item label="密码" prop="password">
        <el-input type="password" v-model="slotData.password" auto-complete="off"></el-input>
      </el-form-item>
    </el-row>
    <el-row v-if="isNewlyCreated">
      <el-form-item label="确认密码" prop="confirmPassword">
        <el-input type="password" v-model="slotData.confirmPassword" auto-complete="off"></el-input>
      </el-form-item>
    </el-row>
    <el-row :gutter="10">
      <el-form-item label="角色" prop="roles">
        <el-checkbox-group v-model="slotData.roles">
          <el-checkbox v-for="item in roles" :label="item.uid" :key="item.uid">
            {{item.name}}
          </el-checkbox>
        </el-checkbox-group>
      </el-form-item>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: 'EmployeeBaseForm',
    props: ['slotData', 'isNewlyCreated', 'readOnly'],
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      getValue() {
        return this.slotData;
      },
      async getRoles() {
        const result = await this.$http.get('/djfactory/role/?text=');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.roles = result.content;
      }
    },
    created() {
      this.getRoles();
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
          password: [{validator: validatePass, trigger: 'blur'},
            {
              required: true,
              message: '密码格式不正确，必须包含数字,字母,特殊符号两种或以上组合，且长度为6-16位',
              trigger: 'blur',
              pattern: '^(?![0-9]+$)(?![a-zA-Z]+$)(?!([^(0-9a-zA-Z)]|[\\(\\)])+$)([^(0-9a-zA-Z)]|[\\(\\)]|[a-zA-Z]|[0-9]){6,16}$'
            }],
          confirmPassword: [{validator: validatePass2, trigger: 'blur'}],
          name: [{required: true, message: '必填', trigger: 'blur'}],
          uid: [{required: true, message: '必填', trigger: 'blur'}],
          mobileNumber: [{required: true, message: '必填', trigger: 'blur'}]
        },
        roles: []
      };
    }
  };
</script>
