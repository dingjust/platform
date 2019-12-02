<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules">
      <el-row type="flex" align="middle" :gutter="20">
        <el-col :span="8">
          <el-form-item label="编码" prop="code" :disabled="readOnly">
            <el-input :disabled="readOnly" v-model="slotData.code"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="名称" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row type="flex" align="middle" :gutter="20">
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
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'SizeBasicForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate () {
        var bool = false;
        this.$refs['form'].validate((valid) => {
          if (valid) {
            bool = true;
          } else {
            this.$message.error('请完善需求信息');
            return false;
          }
        });

        return bool;
      }
    },
    data () {
      return {
        rules: {
          code: [{required: true, message: '必填', trigger: 'blur'}],
          name: [{required: true, message: '必填', trigger: 'blur'}]
        }
      };
    },
    created () {
    }
  };
</script>
