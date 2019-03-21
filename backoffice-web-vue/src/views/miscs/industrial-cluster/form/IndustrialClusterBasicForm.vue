<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData"  :disabled="readOnly">
      <el-row :gutter="20">
        <el-col :span="12">
          <el-form-item label="名称" prop="name">
            <el-input v-model="slotData.name"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
        <el-row :gutter="10">
          <el-col :span="12">
          <el-form-item label="标签" prop="labels">
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
      async getLabels() {
        const results = await this.$http.get('/djwebservices/labels/all');
        if (results["errors"]) {
          this.$message.error(results["errors"][0].message);
          return;
        }

        this.labels = results;
      }
    },
    data() {
      return {
        rules: {
          name: [{required: true, message: '必填', trigger: 'blur'}],
        },
        labels: []
      };
    },
    created() {
      this.getLabels();
    }
  };
</script>
