<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="!readOnly">
        <el-row :gutter="24">
          <el-col :span="8">
            <el-form-item label="序号" prop="index">
              <el-input  v-model="slotData.index"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="标题" prop="name">
              <el-input  v-model="slotData.name"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="描述" prop="description">
              <el-input  v-model="slotData.description"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'OperationCourseBasicForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        if(this.$refs['form'].validate(callback)){
          return false;
        }
        return true;
      }

    },
    data() {
      return {
        rules: {
          index: [{required: true, message: '必填', trigger: 'blur'}],
          name: [{required: true, message: '必填', trigger: 'blur'}]
        },
      };
    },
    created() {
    }
  };
</script>
