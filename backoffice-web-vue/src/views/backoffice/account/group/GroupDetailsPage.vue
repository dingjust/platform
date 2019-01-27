<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
        <span class="float-right">
         <el-button type="primary" size="mini">编辑</el-button>
        </span>
      </div>
      <group-base-form :slot-data="slotData"
                       :read-only="true"
                       :is-newly-created="isNewlyCreated">
      </group-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10">
      <el-col :span="24">
        <el-button class="btn-block" size="mini" @click="onClose()">关闭</el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import GroupBaseForm from "./GroupBaseForm";

  export default {
    name: 'GroupDetailsPage',
    components: {GroupBaseForm},
    props: ['slotData', 'isNewlyCreated', 'preview'],
    methods: {
      onClose() {
        this.fn.closeSlider();
      }
    },
    computed: {},
    data() {
      return {}
    }
  }
</script>
