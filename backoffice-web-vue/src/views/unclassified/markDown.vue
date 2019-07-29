<template>
  <div class="custom-markdown">
    <mark-down
      class="custom-markdown-class"
      @on-paste-image="handlePasteImage"
      @on-save="save"
      :theme="theme"
      :initialValue="initialValue"
    ></mark-down>
  </div>
</template>

<script>
import MarkDown from "vue-meditor";
export default {
  name: "Markdown",
  data() {
    return {
      initialValue: "",
      theme: "OneDark"
    };
  },
  components: {
    MarkDown
  },
  methods: {
    save(res) {
      console.log(res);
    },
    handlePasteImage(res) {
      console.log(res);
    }
  }
};
</script>

<style lang="scss" scoped>
.custom-markdown {
  border: 1px solid #ccc;
  text-align: left;
}
.custom-markdown-class {
  //   height: 400px !important;
  //   min-height: 400px !important;
}
</style>