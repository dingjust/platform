<template>
  <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
    <el-row :gutter="20">
      <el-col :span="12">
        <el-form-item label="名称" prop="name">
          <el-input v-model="slotData.name"></el-input>
        </el-form-item>
      </el-col>
      <el-row :gutter="10">
        <el-form-item label="分组" prop="groups">
          <el-select v-model="slotData.groups">
            <el-option v-for="item in groups"
                       :label="item.code"
                       :key="item.code"
                       :value="item.code">
              {{item.name}}
            </el-option>
          </el-select>
        </el-form-item>
      </el-row>
    </el-row>
  </el-form>
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
    created() {
    },
    data() {
      return {
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
        },
        groups: this.$store.state.EnumsModule.labelGroups,
      };
    }
  };
</script>
