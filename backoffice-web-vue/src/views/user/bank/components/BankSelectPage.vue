<!--
* @Description: 银行卡选择列表页
* @Date 2021/09/22 15:35
* @Author L.G.Y
-->
<template>
  <div>
    <bank-list ref="bankList" :page="page" @onAdvancedSearch="onAdvancedSearch" :isSelect="true"/>
    <el-row type="flex" justify="center" style="margin-top: 20px">
      <el-button type="primary" @click="onSelect">确定</el-button>
    </el-row>
  </div>
</template>

<script>
import BankList from '../list/BankList'

export default {
  name: 'BankSelectPage',
  components: { BankList },
  methods: {
    async onAdvancedSearch() {
      const url = this.apis().getBanks();
      const result = await this.$http.get(url)

      if (result.code === 1) {
        this.$set(this, 'page', result.data)
      }
    },
    onSelect () {
      const row = this.$refs.bankList.currentRow
      this.$emit('onSelect', row)
    }
  },
  data () {
    return {
      page: []
    }
  },
  created () {
    this.onAdvancedSearch();
  }
}
</script>

<style scoped>

</style>