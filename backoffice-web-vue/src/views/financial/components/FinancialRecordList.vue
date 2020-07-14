<template>
  <div>
    <el-row type="flex" justify="start" align="middle">
      <h6 style="font-size: 14px">{{title}}</h6>
    </el-row>
    <el-table ref="resultTable" stripe :data="[{}]" :height="autoHeight" highlight-current-row>
      <el-table-column label="收款次数" v-if="belongTo == 'RECEIVABLE_PAGE'"/>
      <el-table-column label="付款次数" v-if="belongTo == 'PAYABLE_PAGE'"/>
      <el-table-column label="付款申请单" v-if="belongTo == 'PAYABLE_PAGE'"/>
      <el-table-column label="付款方式" />
      <el-table-column label="付款金额" />
      <el-table-column label="付款内容" />
      <el-table-column label="付款时间" />
      <el-table-column label="付款凭证" />
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button v-if="belongTo == 'RECEIVABLE_PAGE'" type="text" @click="onConfirm(scope.row)">确认收款</el-button>
          <el-button v-if="belongTo == 'PAYABLE_PAGE'" type="text" @click="onConfirm(scope.row)">确认付款</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    name: 'FinancialRecordList',
    props: {
      belongTo: {
        type: String,
        default: 'RECEIVABLE_PAGE'
      }
    },
    components: {
    },
    computed: {
      title: function () {
        return this.belongTo == 'RECEIVABLE_PAGE' ? '收款记录' : '付款记录';
      }
    },
    methods: {
      onConfirm (row) {
        this.$emit('onConfirmReceipt', row)
      }
    },
    data () {
      return {
      }
    },
    created () {
    },
    destroyed () {
      
    }
  }
</script>

<style scoped>

</style>