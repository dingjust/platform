<template>
  <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
    <el-row :gutter="20">
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="名称" prop="name">
            <el-input type="textarea" :rows="2" v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="跳转动作" prop="action">
            <el-input type="textarea" :rows="2" v-model="slotData.action"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-col :span="12">
        <el-form-item label="描述" prop="description">
          <el-input type="textarea" :rows="2" v-model="slotData.description"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="是否启用" prop="active">
          <el-radio-group v-model="slotData.active">
            <el-radio :label="true">启用</el-radio>
            <el-radio :label="false">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: "PartnersBaseForm",
    props: ["slotData", "isNewlyCreated", "readOnly"],
    methods: {
      getValue(){
        let baseData= {};
        baseData.id = this.slotData.id;
        baseData.name = this.slotData.name;
        baseData.action = this.slotData.action;
        baseData.active = this.slotData.active;
        baseData.description = this.slotData.description;
        return baseData;
      },
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
