<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="!readOnly">
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="标题" prop="title">
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
          name: [{required: true, message: '必填', trigger: 'blur'}]
        },
      };
    },
    created() {
    }
  };
</script>
