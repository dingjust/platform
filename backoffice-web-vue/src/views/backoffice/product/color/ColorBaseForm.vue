<template>
  <el-form ref="form" label-position="top" :model="slotData" :disabled="readOnly" :rules="rules">
    <el-row :gutter="10">
      <el-col :span="12">
        <el-form-item label="编码" prop="code">
          <el-input :disabled="!isNewlyCreated" v-model="slotData.code"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="名称" prop="name">
          <el-input v-model="slotData.name"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="10">
      <el-col :span="8">
        <el-form-item label="是否启用" prop="active">
          <el-radio-group v-model="slotData.active">
            <el-radio :label="true">是</el-radio>
            <el-radio :label="false">否</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="序列值" prop="sequence">
          <el-input-number class="w-100"
                           v-model="slotData.sequence"
                           :precision="0"
                           :min="0">
          </el-input-number>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="色值" prop="colorCode">
          <el-input v-model="slotData.colorCode"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: 'ColorBaseForm',
    props: ['slotData', 'readOnly', 'isNewlyCreated'],
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
    },
    data() {
      return {
        rules: {
          code: [{required: true, message: '必填', trigger: 'blur'}],
          name: [{required: true, message: '必填', trigger: 'blur'}]
        }
      };
    }
  };
</script>
