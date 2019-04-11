<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="!readOnly">
      <el-row :gutter="20">
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="名称" prop="name">
              <el-input  v-model="slotData.name"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="分组" prop="type">
              <el-select v-model="slotData.type">
                <el-option v-for="item in carouselTypes"
                           :label="item.name"
                           :key="item.code"
                           :value="item.code">
                  {{item.name}}
                </el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="跳转动作" prop="action">
              <el-input  v-model="slotData.action"></el-input>
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
  </div>
</template>

<script>
  export default {
    name: 'CarouselBasicForm',
    props: ['slotData', 'readOnly'],
    methods: {},
    data() {
      return {
        rules: {
          type: [{required: true, message: '必填', trigger: 'change'}],
          name: [{required: true, message: '必填', trigger: 'blur'}]
        },
        carouselTypes: this.$store.state.EnumsModule.carouselTypes,
      };
    },
    created() {
    }
  };
</script>
