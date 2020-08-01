<template>
  <div>
    <el-row type="flex" justify="start">
      <h6>付款内容</h6>
    </el-row>
    <el-table :data="tableData">
      <el-table-column label="付款人" prop="creator.name"/>
      <el-table-column label="付款方式">
        <template slot-scope="scope">
          <span>{{getEnum('PaymentMethod', scope.row.paymentMethod)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="付款金额">
        <template>
          <span>{{formData.requestAmount}}</span>
        </template>
      </el-table-column>
      <el-table-column label="付款时间">
        <template slot-scope="scope">
          <span>{{scope.row.payTime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="付款凭证">
        <template slot-scope="scope">
          <el-button type="text" @click="onVouchers(scope.row)">查看凭证</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog :visible.sync="dialogVisible" width="30%">
      <img width="100%" :src="dialogImageUrl" alt="">
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'PaymentRecordsList',
  props: ['tableData', 'formData'],
  computed: {
  },
  methods: {
    onVouchers (row) {
      this.dialogImageUrl = row.paymentVouchers[0].url;
      this.dialogVisible = true;
    }
  },
  data () {
    return {
      dialogVisible: false,
      dialogImageUrl: ''
    }
  }  
}
</script>

<style scoped>

</style>