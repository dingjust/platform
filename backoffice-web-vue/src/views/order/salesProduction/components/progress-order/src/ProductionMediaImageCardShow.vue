<template>
  <div class="show-body">
    <!-- <el-row type="flex"> -->
    <template v-for="(item,index) in medias">
      <el-image class="show-image" :src="item.url" :key="index" :preview-src-list="previewList" :z-index="9999">
      </el-image>
    </template>
    <!-- </el-row> -->
  </div>
</template>

<script>
  export default {
    name: 'ProductionMediaImageCardShow',
    props: {
      medias: {
        type: Array,
        default: [],
      },
      height: {
        type: Number,
        default: 200
      }
    },
    computed: {
      previewList: function () {
        return this.medias.map(media => this.getDetailUrl(media));
      }
    },
    methods: {
      getDetailUrl(media) {
        var result = media.convertedMedias.filter(item => item.mediaFormat == 'DefaultProductDetail');
        if (result.length != 0) {
          return result[0].url;
        } else {
          return media.url;
        }
      },
    },
    created() {},
    data() {
      return {

      }
    }
  }

</script>
<style scoped>
  .show-body {
    width: 100%;
    overflow: scroll;
    white-space: nowrap;
    overflow-y: hidden;
    padding: 20px;
  }

  .show-image {
    width: 160px;
    height: 120px;
    margin-right: 10px;
  }

</style>
