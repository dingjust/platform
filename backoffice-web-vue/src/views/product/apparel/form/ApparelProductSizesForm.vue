<template>
  <div>
    <el-row class="info-title-row" type="flex" align="center">
      <h6 class="info-title_text">选择尺码：</h6>
    </el-row>
    <el-checkbox-group v-model="slotData.sizes" :disabled="isRead">
      <template v-for="size in sizes">
        <!-- <div class="size-tag"> -->
          <el-checkbox class="size-tag" :label="size.code" border>{{size.name}}</el-checkbox>
        <!-- </div> -->
      </template>
    </el-checkbox-group>
  </div>
</template>

<script>
  export default {
    name: 'ApparelProductSizesForm',
    props: ['slotData', 'readOnly', 'isRead'],
    components: {},
    computed: {},
    methods: {
      async getAllSizes () {
        const url = this.apis().getAllSizes();
        this.sizes = await this.$http.get(url);
      }
    },
    data () {
      return {
        sizes: []
      };
    },
    created () {
      this.getAllSizes();
    }
  };
</script>
<style>
  .size-tag {
    width: 80px;
        margin-left: 0px;
  }

.el-checkbox.is-bordered+.el-checkbox.is-bordered {
    margin-left: 0px;
}
</style>
