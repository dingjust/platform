<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :rules="rules" :disabled="readOnly">
      <el-row :gutter="20">
        <el-col :span="8">
          <el-form-item label="名称" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="分类" prop="labels">
            <el-checkbox-group v-model="slotData.labels">
              <el-checkbox v-if="readOnly" v-for="item in slotData.labels" :label="item" :key="item.id">
                {{item.name}}
              </el-checkbox>
              <el-checkbox v-if="!readOnly" v-for="item in this.labels" :label="item" :key="item.id">
                {{item.name}}
              </el-checkbox>
            </el-checkbox-group>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'IndustrialClusterBasicForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        return this.$refs['form'].validate(callback);
      },
      async getLabels() {
        const url = this.apis().getAllLabels();
        const results = await this.$http.get(url);
        if (results["errors"]) {
          this.$message.error(results["errors"][0].message);
          return;
        }

        this.labels = results;
      }
    },
    data() {
      const validateLabels = (rule, value, callback) => {
        if (!value || !value.length) {
          callback(new Error('请选择分类'))
        } else {
          callback()
        }
      };
      return {
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
          labels: [
            {required: true, message: '必填', trigger: 'blur'},
            {required: true, trigger: 'blur', validator: validateLabels}
          ]
        },
        labels: []
      };
    },
    created() {
      this.getLabels();
    }
  };
</script>
