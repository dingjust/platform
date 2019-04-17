<template>
  <div class="animated fadeIn">
    <industrial-cluster-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
    <div class="pt-2"></div>
    <industrial-cluster-form ref="form" :slot-data="slotData" :read-only="!isNewlyCreated"/>
    <div class="pt-2"></div>
    <industrial-cluster-form-toolbar :read-only="!isNewlyCreated" @onSubmit="onSubmit" @onCancel="onCancel"/>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapActions} = createNamespacedHelpers('IndustrialClustersModule');

  import IndustrialClusterFormToolbar from '../toolbar/IndustrialClusterFormToolbar';
  import IndustrialClusterForm from '../form/IndustrialClusterForm';

  export default {
    name: 'IndustrialClusterDetailsPage',
    props: ['slotData'],
    components: {IndustrialClusterFormToolbar, IndustrialClusterForm},
    methods: {
      ...mapActions({
        refresh: 'refresh'
      }),
      onSubmit() {
        this.$refs['form'].validate((valid) => {
          if (valid) {
            this._onSubmit();
            return true;
          }

          return false;
        });
      },
      onCancel() {
        this.fn.closeSlider();
      },
      async _onSubmit() {
        let formData = this.slotData;

        const url = this.apis().createIndustrialCluster();
        const result = await this.$http.post(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('保存成功');
        this.$set(this.slotData, 'code', result);
        this.refresh(this.apis().getIndustrialClusters());
        this.fn.closeSlider(true);
      }
    },
    computed: {
      isNewlyCreated: function () {
        return this.slotData.id === null;
      }
    },
    data() {
      return {}
    }
  }
</script>
