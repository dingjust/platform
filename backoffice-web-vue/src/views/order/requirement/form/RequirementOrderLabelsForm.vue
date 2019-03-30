<template>
  <div class="animated fadeIn">
    <div class="pt-2"></div>
    <el-form ref="form" label-position="top" :model="slotData">
      <el-row :gutter="10">
        <el-form-item label="标签" prop="roles">
          <el-select class="w-100" v-model="slotData.labels" :disabled="readOnly"  multiple placeholder="请选择"
                     value-key="id">
            <el-option
              v-for="item in labels"
              :key="item.id"
              :label="item.name"
              :value="item">
            </el-option>
          </el-select>
        </el-form-item>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'FactoryLabelsForm',
    props: ['slotData', 'readOnly'],
    computed: {

    },
    methods: {
      async getLabels() {
        const url = this.apis().getGroupLabels('ORDER');
        const results = await this.$http.get(url);
        if (results["errors"]) {
          this.$message.error(results["errors"][0].message);
          return;
        }
        this.labels = results;
      }
    },
    data() {
      return {
        labels: [],
        starLevel:0,
      };
    },
    created() {
      this.getLabels();
    }
  };
</script>
