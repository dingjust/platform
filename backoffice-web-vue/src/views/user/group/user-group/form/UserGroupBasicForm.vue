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
      <el-row>
        <el-form-item label="手机号码" prop="phoneNumber">
          <el-input placeholder="请输入手机号码" v-model.number="slotData.mobileNumber">
            <template slot="prepend">+86</template>
          </el-input>
        </el-form-item>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'UserGroupBasicForm',
    props: ['slotData', 'readOnly'],
    methods: {},
    data() {
      return {};
    },
    created() {
    }
  };
</script>
