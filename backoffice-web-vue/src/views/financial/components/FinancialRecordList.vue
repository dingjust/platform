<template>
  <div>
    <el-row type="flex" justify="space-between" align="middle">
      <h6 style="font-size: 14px">{{title}}</h6>
      <Authorized :permission="['PAYMENT_REQUEST_CREATE']">
        <el-button class="material-btn" @click="appendOrder" v-if="belongTo=='PAYABLE_PAGE'">创建付款申请单</el-button>
      </Authorized>
    </el-row>
    <el-table ref="resultTable" stripe :data="content">
      <el-table-column label="收款次数" v-if="belongTo == 'RECEIVABLE_PAGE'" type="index" width="80px" />
      <el-table-column label="付款次数" v-if="belongTo == 'PAYABLE_PAGE'" type="index" width="80px" />
      <el-table-column label="付款申请单" prop="code" v-if="belongTo == 'PAYABLE_PAGE'" />
      <el-table-column label="付款方式">
        <template slot-scope="scope">
          <span>{{getEnum('PaymentMethod', scope.row.paymentRecords.paymentMethod)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="付款金额" prop="requestAmount" />
      <el-table-column label="付款内容" prop="paymentFor" />
      <el-table-column label="付款时间">
        <template slot-scope="scope">
          <span>{{scope.row.paymentRecords.payTime | timestampToTime}}</span>
        </template>
      </el-table-column>
      <el-table-column label="付款凭证">
        <template slot-scope="scope">
          <el-button type="text" @click="onVouchers(scope.row)">查看凭证</el-button>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button v-if="belongTo == 'RECEIVABLE_PAGE' && scope.row.confirmState == 'PENDING'" type="text"
            @click="onConfirm(scope.row)">确认收款</el-button>
          <span v-if="belongTo == 'RECEIVABLE_PAGE' && scope.row.confirmState == 'CONFIRMED'">已确认收款</span>
          <!-- <el-button v-if="belongTo == 'PAYABLE_PAGE'" type="text" @click="onConfirm(scope.row)">确认付款</el-button> -->
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
    name: 'FinancialRecordList',
    props: {
      belongTo: {
        type: String,
        default: 'RECEIVABLE_PAGE'
      },
      content: {
        type: Array,
        default: () => []
      },
      outboundOrder: {
        type: Object
      }
    },
    components: {},
    computed: {
      title: function () {
        return this.belongTo == 'RECEIVABLE_PAGE' ? '收款记录' : '付款记录';
      }
    },
    methods: {
      onConfirm(row) {
        this.$confirm('是否确认收款?', '', {
          confirmButtonText: '是',
          cancelButtonText: '否',
          type: 'warning'
        }).then(() => {
          this.$emit('onConfirmReceipt', row)
        });
      },
      onVouchers(row) {
        this.dialogImageUrl = row.paymentRecords.paymentVouchers[0].url;
        this.dialogVisible = true;
      },
      appendOrder() {
        // this.$router.push('/financial/create/paymentRequest');
        this.$router.push({
          name: '创建付款申请单',
          params: {
            orderData: this.outboundOrder
          }
        });
      },
    },
    data() {
      return {
        dialogVisible: false,
        dialogImageUrl: ''
      }
    },
    created() {},
    destroyed() {

    }
  }

</script>

<style scoped>
  .material-btn {
    background-color: #ffd60c;
    border-color: #FFD5CE;
    color: #000;
    width: 115px;
    height: 35px;
    border-radius: 5px;
  }

</style>
