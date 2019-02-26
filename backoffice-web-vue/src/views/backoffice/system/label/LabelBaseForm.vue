<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="名称" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="分组" prop="group">
            <el-select v-model="slotData.group">
              <el-option v-for="item in labelGroups"
                         :label="item.name"
                         :key="item.code"
                         :value="item.code">
                {{item.name}}
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'LabelBaseForm',
    props: ['slotData', 'isNewlyCreated', 'readOnly'],
    computed: {},
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
    },
    data() {
      return {
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
          group: [{required: true, message: '必填', trigger: 'blur'}],
        },
        labelGroups: this.$store.state.EnumsModule.labelGroups,
      };
    }
  };
</script>
