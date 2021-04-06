<!--
* @Description: 成本单关联报价单列表
* @Date 2021/03/31 15:33
* @Author L.G.Y
-->
<template>
  <el-table :data="quoteList">
    <el-table-column label="单号" prop="code"></el-table-column>
    <el-table-column label="操作">
      <template slot-scope="scope">
        <el-button type="text" @click="onDetail(scope.row.id)">详情</el-button>
      </template>
    </el-table-column>
  </el-table>
</template>

<script>
export default {
  name: 'CostQuoteInfo',
  props: ['formData'],
  data () {
    return {
      quoteList: []
    }
  },
  methods: {
    async getQuoteList () {
      const url = this.apis().searchQuoteByCostId(this.formData.id);
      const result = await this.$http.post(url, {});

      if (result.code === 1) {
        this.quoteList = result.data;
      }
    },
    onDetail (id) {
      this.$router.push('/purchase/quote/' + id);
    }
  },
  created () {
    this.getQuoteList();
  }
}
</script>

<style scoped>

</style>