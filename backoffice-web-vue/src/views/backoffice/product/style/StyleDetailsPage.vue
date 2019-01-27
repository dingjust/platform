<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>基本信息</span>
      </div>
      <style-base-form :slot-data="slotData"
                       :read-only="true"
                       :is-newly-created="isNewlyCreated">
      </style-base-form>
    </el-card>
    <div class="pt-2"></div>
    <el-row :gutter="10" v-show="!preview">
      <el-col :span="24">
        <el-button class="btn-block" size="mini" @click="onClose">
          关闭
        </el-button>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  import StyleBaseForm from "./StyleBaseForm";

  export default {
    name: "StyleDetailsPage",
    components: {StyleBaseForm},
    props: ["slotData", "isNewlyCreated", "preview"],
    methods: {
      onChangeState() {
        // TODO: 启用/禁用
      },
      onClose() {
        this.fn.closeSlider();
      }
    },
    computed: {},
    data() {
      return {};
    }
  };
</script>
