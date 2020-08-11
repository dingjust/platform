<template>
  <el-form ref="form" :model="formData" :inline="true" :rules="rules" hide-required-asterisk>
    <el-row>
      <el-col :span="4">
        <div class="organization-list-title">
          <h6>部门创建</h6>
        </div>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-col :span="16">
        <el-form-item label="部门名称" prop="name">
          <el-input ref="input" v-model="formData.name" @keyup.enter.native="onCreate" style="width: 194px"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-col :span="16">
        <el-form-item label="部门类型" prop="functionTypes">
          <dj-multiple-select :vSelectData.sync="formData.functionTypes" :options="options" 
                              keyName="code" :selectedCallBack="selectDataCallback"/>
          <!-- <el-select v-model="formData.deptType" placeholder="请选择" value-key="id">
            <el-option v-for="item in options" :label="item.name" :value="item" :key="item.id"></el-option>
          </el-select> -->
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex" justify="center" align="middle">
      <el-button @click="onCreate">确认</el-button>
    </el-row>
  </el-form>
</template>

<script>
  import { DjMultipleSelect } from '@/components' 
  export default {
    name: 'DeptForm',
    props: ['formData'],
    components: {
      DjMultipleSelect
    },
    methods: {
      onCreate () {
        this.$refs.form.validate(valid => {
          if (valid) {
            this._onCreate();
          } else {
            this.$message.error('请完善表单信息');
            return false;
          }
        });
      },
      _onCreate () {
        let functionTypes = this.formData.functionTypes.map(item => item.code)
        let data = {
          id: this.formData.id ? this.formData.id : null,
          name: this.formData.name,
          parentId: this.formData.parentId ? this.formData.parentId : null, 
          functionTypes: functionTypes
        }
        this.$emit('onConfirm', data);
      },
      selectDataCallback(){
        return this.options.filter(option=> {
          return this.formData.functionTypes.findIndex(type => option.code == type) >= 0;
        });
      }
    },
    data () {
      var validatePass = (rule, value, callback) => {
        if (value.length <= 0) {
          callback(new Error('请选择部门类型'));
        } else {
          callback();
        }
      };
      return {
        options: this.$store.state.EnumsModule.B2BDeptFunctionType,
        rules: {
          name: [
            { required: true, message: '必填', trigger: 'blur' },
          ],
          functionTypes: [
            { required: true, validator: validatePass, trigger: 'change' }
          ]
        },
      }
    },
    created () {
      // input框获取焦点
      this.$nextTick(() => {
        this.$refs.input.focus();
      })
    }
  }
</script>

<style scoped>
  .organization-list-title {
    border-left: 2px solid #ffd60c;
    padding-left: 10px;
  }
</style>