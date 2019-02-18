<template>
  <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
    <el-row :gutter="20">
      <el-col :span="8">
        <el-form-item label="UID" prop="uid">
          <el-input v-model="slotData.uid" disabled placeholder="系统自动生成"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="名称" prop="name">
          <el-input v-model="slotData.name"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="父级部门" prop="parent">
          <el-input v-model="slotData.parent" disabled></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="20">
      <el-col :span="8">
        <el-form-item label="是否启用" prop="active">
          <el-radio-group v-model="slotData.active">
            <el-radio :label="true">启用</el-radio>
            <el-radio :label="false">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-col>
      <el-col :span="16">
        <el-form-item label="描述" prop="comment">
          <el-input type="textarea" :rows="2" v-model="slotData.comment"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: 'OrgBaseForm',
    props: ['slotData', 'isNewlyCreated', 'readOnly'],
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      }
    },
    computed: {},
    data() {
      return {
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}]
        }
      };
    }
  };
</script>
