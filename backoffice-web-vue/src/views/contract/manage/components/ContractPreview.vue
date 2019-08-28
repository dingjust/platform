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
      viewerText: "### 1. 制作一份待办事宜 [Todo 列表](https://www.zybuluo.com/mdeditor?url=https://www.zybuluo.com/static/editor/md-help.markdown#13-待办事宜-todo-列表)"
    };
  }
};
</script>
<style>
  .contract_custom-viewer {
    min-height: 200px;
  }
</style>
