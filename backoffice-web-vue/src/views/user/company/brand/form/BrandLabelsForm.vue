<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData">
      <el-row :gutter="10">
        <el-form-item label="标签" prop="roles">
          <<el-select class="w-100" v-model="slotData.labels" multiple placeholder="请选择"
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
      <el-row :gutter="10">
        <el-form-item label="评级" prop="roles">
          <el-rate
            v-model="slotData.starLevel"
            :colors="['#99A9BF', '#F7BA2A', '#FF9900']">
          </el-rate>
        </el-form-item>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'BrandLabelsForm',
    props: ['slotData', 'readOnly'],
    computed: {

    },
    methods: {
      async getLabels() {
        const url = this.apis().getGroupAllLabels('FACTORY');
        const results = await this.$http.get(url);
        if (results["errors"]) {
          this.$message.error(results["errors"][0].message);
          return;
        }

        this.roles = results;
      }
    },
    data() {
      return {
        labels: [],
      };
    },
    created() {
      this.getLabels();
    }
  };
</script>
