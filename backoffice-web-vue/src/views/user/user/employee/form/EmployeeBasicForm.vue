<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="!readOnly">
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="UID" prop="uid">
            <el-input :disabled="!readOnly" v-model="slotData.uid"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="名称" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
            <template slot="prepend">+86
            </template>
        <el-form-item label="手机号码" prop="phoneNumber">
          <el-input placeholder="请输入手机号码" clearable v-model.number="slotData.mobileNumber">
          </el-input>
        </el-form-item>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'EmployeeBasicForm',
    props: ['slotData', 'readOnly'],
    methods: {},
    data() {
      return {
        rules: {
          uid: [{required: true, message: '必填', trigger: 'blur'}],
          name: [{required: true, message: '必填', trigger: 'blur'}],
        }
      };
    },
    created() {

    }
  };
</script>
