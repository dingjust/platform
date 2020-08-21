<template>
  <div>
    <div v-if="!isLoading"
      style="width: 100px; height: 100px; z-index: 100; position: fixed; margin: 50px auto auto -50px; top: 50%; left: 50%;">
      加载中....</div>
    <iframe id='previewPdf' :src="fileUrl"
      height="480" width="100%">
    </iframe>
    <a id="a"  target="_blank"></a>
  </div>
</template>


<script>
  export default {
    name: 'PdfPreview',
    props: ['fileUrl'],
    components: {
    },
    mounted () {
      this.isLoading = true;
    },
    data () {
      return {
        isLoading: false
      }
    },
    methods: {
    },
    created () {
    }
  }
</script>

<style>

</style>
