<style>
  .el-tag + .el-tag {
    margin-left: 10px;
  }
</style>

<template>
  <div class="animated fadeIn">
    <ul class="list-group">
      <li class="list-group-item">
        <span>颜色：</span>
        <el-tag
          :key="color.code"
          v-for="color in colors"
          closable
          :disable-transitions="false"
          @close="onColorClose(color)">
          {{color.name}}
        </el-tag>
      </li>
      <li class="list-group-item">
        <span>尺码：</span>
        <el-tag
          :key="size.code"
          v-for="size in sizes"
          closable
          :disable-transitions="false"
          @close="onSizeClose(size)">
          {{size.name}}
        </el-tag>
      </li>
    </ul>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {
    name: 'ApparelProductVariantsForm',
    props: ['slotData', 'readOnly', 'isNewlyCreated'],
    methods: {
      onColorClose(color) {

      },
      onSizeClose(size) {

      }
    },
    computed: {},
    data() {
      return {
        colors: [],
        sizes: []
      };
    },
    created() {
      if (!this.isNewlyCreated) {
        this.doRefresh();
      }

      axios
        .all([
          axios
            .get('/djwebservices/colors/all')
            .then(response => {
              this.colors = response.data;
            }),

          axios
            .get('/djwebservices/sizes/all')
            .then(response => {
              this.sizes = response.data;
            })
        ]).catch(error => {
        this.$message.error(error.response.data);
      });
    }
  };
</script>
