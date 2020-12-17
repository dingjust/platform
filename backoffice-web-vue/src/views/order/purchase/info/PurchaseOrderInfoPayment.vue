<template>
  <el-table :data="paymentOrders" style="width: 100%" class="finance-form-table">
    <el-table-column label="账期" >
      <template slot-scope="scope">
        <span>{{getEnum('PayMoneyType',scope.row.moneyType)}}</span>
      </template>
    </el-table-column>
    <el-table-column label="付款金额">
      <template slot-scope="scope">
        <span>￥{{scope.row.amount}}</span>
      </template>
    </el-table-column>
    <el-table-column label="类型">
      <template slot-scope="scope">
        <span>{{getEnum('PaymentType',scope.row.paymentType)}}</span>
      </template>
    </el-table-column>
    <el-table-column label="时间">
      <template slot-scope="scope">
        <span>{{scope.row.creationtime | timestampToTime}}</span>
      </template>
    </el-table-column>
    <el-table-column label="凭证" min-width="100px">
      <template slot-scope="scope">
        <el-row type="flex" align="top" >
          <el-link class="finance-form-link" v-if="scope.row.payCertificate != null" :href="scope.row.payCertificate.url" target="_blank">
            {{scope.row.payCertificate.name}}</el-link>
          <el-upload name="file" :action="mediaUploadUrl" :data="uploadFormData" :show-file-list="false"
                     :before-upload="onBeforeUpload" :on-success="onSuccess" :headers="headers">
            <el-button type="text" size="mini" @click="paymentId = scope.row.id">点击上传</el-button>
          </el-upload>
        </el-row>
      </template>
    </el-table-column>
    <el-table-column label="备注">
      <template slot-scope="scope">
        <span>{{scope.row.remarks}}</span>
      </template>
    </el-table-column>
    <el-table-column label="操作">
      <template slot-scope="scope">
        <el-button size="mini" type="text" @click="onDelete(scope.row.id)" style="color: #C0C0C0"
                   v-if="scope.row.deletable === true">删除</el-button>
      </template>
    </el-table-column>
  </el-table>
</template>

<script>
  import PurchaseOrderFinanceForm from './PurchaseOrderFinanceReceiptForm';

  export default {
    name: 'PurchaseOrderInfoPayment',
    props: ['slotData', 'paymentOrders'],
    components: {
      PurchaseOrderFinanceForm
    },
    mixins: [],
    computed: {
      headers: function () {
        return {
          Authorization: this.$store.getters.token
        }
      }
    },
    methods: {
      onBeforeUpload (file) {
        if (file.size > 1024 * 1024 * 10) {
          this.$message.error('上传的文件不允许超过10M');
          return false;
        }

        return true;
      },
      onSuccess (response) {
        const result = this.$http.put(this.apis().updatePaymentOrder(), {
          id: this.paymentId,
          payCertificate: response
        });
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
        } else {
          this.$emit('refreshData');
        }
      },
      handlePreview (file) {
        this.dialogImageUrl = file.url;
        this.dialogVisible = true;
      },
      onDelete (id) {
        const result = this.$http.put(this.apis().deletePaymentOrder(id));

        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
        } else {
          this.$emit('refreshItem');
        }
      }
    },
    data () {
      return {
        uploadFormData: {
          fileFormat: 'DefaultFileFormat',
          conversionGroup: 'DefaultProductConversionGroup'
        },
        paymentId: null
      }
    },
    created () {
    }
  }
</script>
<style>
  .info-finance-body {
    width: 100%;
    margin-top: 20px;
  }

  .finance-log-content {
    font-weight: 500;
    color: rgba(0, 0, 0, 0.45);
    font-size: 10px;
    margin-top: 10px;
  }

  .info-finance-btn {
    width: 50px;
    height: 25px;
    text-align: center;
    white-space: nowrap;
    cursor: pointer;
    background: #FFF;
    border: 1px solid #DCDFE6;
    color: #606266;
    -webkit-appearance: none;
    box-sizing: border-box;
    outline: 0;
    margin: 0;
    -webkit-transition: .1s;
    transition: .1s;
    font-weight: 500;
    border-radius: 4px;
    font-size: 10px;
  }

  .info-title_text2 {
    margin-top: 5px;
    margin-left: 10px;
    font-size: 10px;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
  }

  .info-finance-body-title-row2 {
    background-color: rgba(0, 0, 0, 0.02);
    text-align: center;
  }

  .info-finance-btn:focus,
  .info-finance-btn:hover {
    color: #409EFF;
    border-color: #c6e2ff;
    background-color: #ecf5ff;
  }

  .info-finance-logistics_info-btn1 {
    /* width: 50px; */
    height: 20px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    text-align: center;
    border: 0px solid #FFD60C;
    padding-bottom: 15px;
  }

  .info-finance-logistics_info-btn3 {
    /* width: 60px; */
    height: 20px;
    background: #FFD60C;
    font-weight: 400;
    color: rgba(0, 0, 0, 0.85);
    font-size: 10px;
    border-radius: 0px;
    text-align: center;
    border: 0px solid #FFD60C;
    padding-bottom: 15px;
  }

</style>
