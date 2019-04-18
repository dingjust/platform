<template>
  <div class="animated fadeIn">
    <div class="pt-2"></div>
    <el-form ref="form" label-position="top" :model="slotData">
      <el-row :gutter="10">
        <el-form-item label="标签" prop="roles">
          <el-select class="w-100" v-model="slotData.labels" multiple placeholder="请选择"
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
        <el-form-item label="产业集群" prop="industrialCluster">
          <el-select class="w-100"
                     placeholder="请选择"
                     v-model="slotData.industrialCluster"
                     value-key="code">
            <el-option-group
              v-for="label in industrialClusterLabels"
              :key="label.id"
              :label="label.name">
              <el-option
                v-for="cluster in label.clusters"
                :key="cluster.code"
                :label="cluster.name"
                :value="cluster">
              </el-option>
            </el-option-group>
          </el-select>
        </el-form-item>
      </el-row>
      <el-row :gutter="10">
        <el-form-item label="评级" prop="starLevel">
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
    name: 'FactoryLabelsForm',
    props: ['slotData', 'readOnly'],
    computed: {},
    methods: {
      async getLabels() {
        const url = this.apis().getGroupLabels('PLATFORM');
        const results = await this.$http.get(url);
        if (results["errors"]) {
          this.$message.error(results["errors"][0].message);
          return;
        }

        this.labels = results;
      },
      async getIndustrialClusterLabels() {
        const url = this.apis().getIndustrialClusterLabels();
        const result = await this.$http.get(url);
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }

        this.industrialClusterLabels = result;
      },
    },
    data() {
      return {
        labels: [],
        industrialClusterLabels: [],
        starLevel: 0,
      };
    },
    created() {
      this.getLabels();
      this.getIndustrialClusterLabels();
    }
  };
</script>
