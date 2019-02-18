<template>
        <!-- 目前没有增加字段，页面会报错，暂时注释掉 -->
          <!--<media-file-list :file="slotData.contracts" @onDelete="onDelete"></media-file-list>-->
</template>

<script>
  export default {
    name: 'RequirementOrderBomForm',
    props: ['slotData'],
    methods: {
      onDelete(item) {
      },
    },
    computed: {},
    data() {
      return {
      };
    }
  };
</script>
