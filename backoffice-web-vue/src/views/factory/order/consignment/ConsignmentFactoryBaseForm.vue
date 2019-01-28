<template>
  <el-form ref="form" label-position="top" :model="slotData" :disabled="readOnly">
    <el-row :gutter="10">
      <el-col :span="12">
        <el-form-item label="UID" prop="uid">
          <el-input v-model="slotData.uid" :disabled="true" placeholder="自动生成"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="名称" prop="name">
          <el-input v-model="slotData.name"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: "ConsignmentFactoryBaseForm",
    props: ["slotData", "isNewlyCreated", "readOnly"],
    methods: {},
    computed: {},
    data() {
      return {};
    }
  };
</script>
