<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <el-form ref="form" disabled label-position="top" :model="slotData" :rules="rules">
        <el-row :gutter="10">
          <el-col :span="12">
            <el-form-item label="编码" prop="code">
              <el-input v-model="slotData.code"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="名称" prop="name">
              <el-input v-model="slotData.name"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="10">
          <el-col :span="12">
            <el-form-item label="父分类" prop="parent">
              <el-input v-model="slotData.parent.name"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="描述" prop="description">
              <el-input v-model="slotData.description"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col>
            <el-form-item label="图标" prop="thumbnail">
              <img :src="slotData.thumbnail"/>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" size="mini" @click="onClose">关闭</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: "ForumCategoryDetails",
    props: ["slotData"],
    methods: {
      onClose() {
        this.fn.closeSlider();
      }
    },
    computed: {},
    data() {
      return {
        readOnly: true,
        rules: {
          code: [{required: true, message: "必填", trigger: "blur"}],
          name: [{required: true, message: "必填", trigger: "blur"}]
        }
      };
    }
  };
</script>
