<template>
  <div class="animated fadeIn content">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <label-base-form :slot-data="slotData"
                       :is-newly-created="false"
                       :read-only="true">
      </label-base-form>
    </el-card>
  </div>
</template>

<script>
  import LabelBaseForm from './LabelBaseForm';

  export default {
    name: 'LabelDetailsPage',
    props: ['slotData'],
    components: {LabelBaseForm},
    methods: {},
    data() {
      return {
        labels: []
      };
    },
    created() {
    }
  };
</script>

