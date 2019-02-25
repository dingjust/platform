<template>
  <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
    <el-row :gutter="20">
      <el-col :span="12">
        <el-form-item label="名称" prop="name">
          <el-input v-model="slotData.name"></el-input>
        </el-form-item>
      </el-col>
      <el-row :gutter="10">
        <el-form-item label="标签" prop="labels">
          <el-checkbox-group v-model="slotData.labels">
            <el-checkbox v-for="item in labels" :label="item.uid" :key="item.uid">
              {{item.name}}
            </el-checkbox>
          </el-checkbox-group>
        </el-form-item>
      </el-row>
    </el-row>
  </el-form>
</template>

<script>
  export default {
    name: 'IndustrialClusterBaseForm',
    props: ['slotData', 'isNewlyCreated', 'readOnly'],
    computed: {},
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      async getLabels() {
        const results = await this.$http.get('/djwebservices/labels');
        if (results["errors"]) {
          this.$message.error(results["errors"][0].message);
          return;
        }

        this.labels = results;
      }
    },
    created() {
      this.getLabels();
    },
    data() {
      return {
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
        },
        labels: []
      };
    }
  };
</script>
