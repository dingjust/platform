<template>
  <div class="temp-detail">
    <el-row type="flex" justify="start" align="middle">
      <h6>固定条款</h6>
    </el-row>
    <el-row type="flex" class="clause-detail">
      <Viewer :value="detail.header" style="width: 100%"/>
    </el-row>
    <el-row type="flex" justify="start" align="middle" style="margin-top: 30px">
      <h6>自定义条款</h6>
    </el-row>
    <el-row type="flex" class="clause-detail">
      <Viewer v-if="detail.content" :value="detail.content" style="width: 100%"/>
      <el-row v-else type="flex" justify="center" align="middle" style="padding: 20px;width: 100%">
        <h6 style="color: #909399">暂无数据</h6>
      </el-row>
    </el-row>
  </div>
</template>

<script>
import {
  Viewer,
  Editor
} from '@toast-ui/vue-editor';

export default {
  name: 'ContractBackTempDetail',
  props: ['detail'],
  components: {
    Viewer,
    Editor
  }
}
</script>

<style scoped>
  .clause-detail {
    padding: 5px;
    border: 1px solid #e6e6e6;
  }
</style>