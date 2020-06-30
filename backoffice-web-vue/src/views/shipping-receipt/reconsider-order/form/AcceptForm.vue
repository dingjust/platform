<!-- 
 * @description: 同意复议单表单
 * @fileName: AcceptForm.vue 
 * @author: yj 
 * @date: 2020-06-23 16:54:56
 * @version: V1.0.0 
!-->
<template>
  <div class="animated fadeIn receipt-order-container">
    <el-row type="flex" justify="space-between">
      <el-col :span="4">
        <div class="title">
          <h6>修改对应单据内容</h6>
        </div>
      </el-col>
    </el-row>
    <el-row type="flex" style="padding: 10px 0px" justify="space-around">
      <el-col :span="8">
        <h6>复议数量：1</h6>
      </el-col>
      <el-col :span="8">
        <h6>已补数量：2</h6>
      </el-col>
    </el-row>
    <el-row type="flex" style="padding-bottom: 10px" justify="space-around">
      <el-col :span="8">
        <el-row type="flex">
          <el-button @click="receiptFormVisible=true" :disabled="form.receiptOrder!=null">补收货单</el-button>
          <el-button type="text" v-if="form.receiptOrder!=null" @click="receiptFormVisible=true">收货单</el-button>
        </el-row>
      </el-col>
      <el-col :span="8">
        <el-row type="flex">
          <el-button @click="returnFormVisible=true" :disabled="form.returnOrder!=null">补退货单</el-button>
          <el-button type="text" v-if="form.returnOrder!=null" @click="returnFormVisible=true">退货单</el-button>
        </el-row>
      </el-col>
    </el-row>
    <el-form :model="form">
      <el-row type="flex" justify="center" style="margin-top:20px">
        <el-col :span="20">
          <el-form-item label="审批意见">
            <el-input type="textarea" :autosize="{ minRows: 5, maxRows:10}" placeholder="请输入内容" v-model="form.message">
            </el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row type="flex" justify="space-between" style="margin-top:20px">
        <el-col :span="12" :offset="2">
          <el-row type="flex">
            <h6 style="margin-right:20px">上传凭证</h6>
            <images-upload class="form-upload" :slot-data="form.attachments" />
          </el-row>
        </el-col>
      </el-row>
    </el-form>
    <el-row type="flex" justify="center" style="margin-top: 20px" :gutter="50">
      <template>
        <el-col :span="4">
          <el-button class="material-btn" @click="onSubmit">确定</el-button>
        </el-col>
      </template>
    </el-row>
    <el-dialog :visible.sync="receiptFormVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <receipt-form :receiptOrder="{colorSizeEntries:reconsiderOrder.colorSizeEntries}" :data="form.receiptOrder"
        v-if="receiptFormVisible" @onSave="onReceiptSave" />
    </el-dialog>
    <el-dialog :visible.sync="returnFormVisible" width="80%" class="purchase-dialog" append-to-body
      :close-on-click-modal="false">
      <return-form :data="form.returnOrder" :colorSizeEntries="reconsiderOrder.colorSizeEntries"
        v-if="returnFormVisible" @onSave="onReturnSave" />
    </el-dialog>
  </div>
</template>

<script>
  import ImagesUpload from '@/components/custom/ImagesUpload';
  import ReceiptForm from './ReceiptForm';
  import ReturnForm from './ReturnForm';

  export default {
    name: 'AcceptForm',
    props: {
      reconsiderOrder: {
        type: Object
      }
    },
    components: {
      ImagesUpload,
      ReceiptForm,
      ReturnForm
    },
    computed: {

    },
    methods: {
      onSubmit() {
        //校验数量与订单差异
        this.receiptFormVisible = true;
      },
      async _onSubmit() {
        // this.onReturnedMessage();
      },
      onReceiptSave(val) {
        this.$set(this.form, 'receiptOrder', val);
        this.receiptFormVisible = false;
      },
      onReturnSave(val) {
        this.$set(this.form, 'returnOrder', val);
        this.returnFormVisible = false;
      }
    },
    data() {
      return {
        receiptFormVisible: false,
        returnFormVisible: false,
        data: [],
        form: {
          num: '',
          message: '',
          attachments: [],
          data: [],
          receiptOrder: null,
          returnOrder: null
        },
      }
    },
    created() {

    },
    destroyed() {

    }
  }

</script>

<style scoped src="../../css/reconsider-order.css"></style>