<template>
  <Viewer
    :value="viewerText"
    class="contract_custom-viewer"
  />
</template>

<script>
import { Viewer } from "@toast-ui/vue-editor";

export default {
  name: "ContractPreview",
  components: {
    Viewer
  },
  methods: {},
  data() {
    return {
      viewerText: "# 固定条款 \n xxxxxx"
    };
  }
};
</script>
<style>
  .contract_custom-viewer {
    min-height: 200px;
  }
</style>
