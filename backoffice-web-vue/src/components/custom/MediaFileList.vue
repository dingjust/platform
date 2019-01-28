<template>
  <ul class="el-upload-list el-upload-list--picture">
    <li tabindex="0" class="el-upload-list__item is-uploading" v-for="item in file">
      <a class="el-upload-list__item-name" :download="item.name" :href="item.url">
        <i class="el-icon-document"></i>{{item.name}}
      </a>
      <el-button @click="onDelete(item)">删除</el-button>
    </li>
  </ul>
</template>
<script>
  export default {
    name: "MediaFileList",
    props: ["file"],
    methods: {
      onDelete(item) {
        this.$emit('onDelete', item);
      }
    },
    data() {
      return {};
    }
  };
</script>
<style>
</style>
