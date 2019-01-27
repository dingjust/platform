<template>
  <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
    <el-row :gutter="20">
      <el-col :span="12">
        <el-form-item label="颜色" prop="color">
          <el-input v-model="slotData.color.name" disabled></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="20">
      <el-col :span="12">
        <el-form-item label="修改前实际库存" prop="beforeAvailable">
          <el-input v-model="slotData.beforeAvailable" disabled></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="修改前虚拟库存" prop="beforeMaxPreOrder">
          <el-input v-model="slotData.beforeMaxPreOrder" disabled></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row :gutter="20">
      <el-col :span="12">
        <el-form-item label="需调整的实际库存" prop="available">
          <el-input-number :min="0" v-model="slotData.available"></el-input-number>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="需调整的虚拟库存" prop="maxPreOrder">
          <el-input-number :min="0" v-model="slotData.maxPreOrder"></el-input-number>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: "InventoryBaseForm",
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
          available: [{required: true, message: "必填", trigger: "blur"}],
          maxPreOrder: [{required: true, message: "必填", trigger: "blur"}]
        }
      };
    }
  };
</script>
