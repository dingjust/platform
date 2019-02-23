<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <industrial-cluster-base-form :slot-data="slotData"
                                    :is-newly-created="false"
                                    :read-only="true">
      </industrial-cluster-base-form>
    </el-card>
  </div>
</template>

<script>
  import IndustrialClusterBaseForm from './IndustrialClusterBaseForm';

  export default {
    name: 'IndustrialClusterDetailsPage',
    props: ['slotData'],
    components: {IndustrialClusterBaseForm},
    methods: {
      async getLabels() {
        const result = await this.$http.get('/djwebservices/labels');
        if (result["errors"]) {
          this.$message.error(result["errors"][0].message);
          return;
        }
        this.labels = result;
      },
    },
    data() {
      return {
        labels: []
      };
    },
    created() {
      this.getLabels();
    }
  };
</script>

