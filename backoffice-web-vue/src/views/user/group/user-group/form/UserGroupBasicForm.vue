<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :read-only="!readOnly">
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="UID" prop="uid">
            <el-input :disabled="true" v-model="slotData.uid"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="名称" prop="name" >
            <el-input v-model="slotData.name" :disabled="!readOnly"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'UserGroupBasicForm',
    props: ['slotData', 'readOnly'],
    methods: {},
    data() {
      return {
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
        }
      };
    },
    created() {
    }
  };
</script>
