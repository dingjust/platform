<template>
  <div class="recommend-code-detail">
    <el-row>
      <h6>标题：{{detail.title}}</h6>
    </el-row>
    <el-row>
      <h6>备注：{{detail.remark}}</h6>
    </el-row>
    <el-row>
      <h6>url：{{detail.url}}</h6>
    </el-row>
    <el-row>
      <h6>编码：{{detail.code}}</h6>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'RecommendCodeDetail',
  props: ['id'],
  methods: {
    async getDetail () {
      const id = this.id;

      const url = this.apis().getRecommendCodeById(id);
      const result = await this.$http.get(url);

      if (result.code === 1) {
        this.detail = result.data;
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else {
        this.$message.error('操作失败！');
      }
    }
  },
  data () {
    return {
      detail: {}
    }
  },
  created () {
    this.getDetail();
  }
}
</script>

<style>

</style>