<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
      <span>基本信息</span>
    </div>
      <carousel-basic-form ref="basicForm"
                           :slot-data="slotData"
                           :read-only="readOnly">
      </carousel-basic-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
    <div slot="header" class="clearfix">
      <span>图片信息</span>
    </div>
    <carousel-image-form ref="imageForm"
                         :slot-data="slotData"
                         :read-only="readOnly">
    </carousel-image-form>
    </el-card>
    <div class="pt-2"></div>
  </div>
</template>

<script>
  import CarouselBasicForm from './CarouselBasicForm';
  import CarouselImageForm from './CarouselImageForm';

  export default {
    name: 'CarouselFrom',
    components: {
      CarouselBasicForm,
      CarouselImageForm,
    },
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        // TODO: validation
        return true;
        // return this.$refs['basicForm'].validate(callback);
      }
    },
    computed: {},
    data() {
      return {}
    }
  }
</script>
