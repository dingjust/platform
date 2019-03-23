<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="UID" prop="uid">
            <el-input :disabled="!isNewlyCreated" v-model="slotData.uid"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="名称" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'RoleBasicForm',
    props: ['slotData', 'readOnly'],
    methods: {},
    data() {
      return {};
    },
    created() {
    }
  };
</script>
