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
        <el-form-item label="描述" prop="description">
          <el-input v-model="slotData.description"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: "RoleBaseForm",
    props: ["slotData", "isNewlyCreated", "readOnly"],
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      }
    },
    computed: {},
    data() {
      return {
        rules: {
          name: [{required: true, message: "必填", trigger: "blur"}]
        }
      };
    }
  };
</script>
