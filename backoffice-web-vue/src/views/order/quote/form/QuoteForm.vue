<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>需求信息</span>
      </div>
      <requirement-order-request-form :read-only="true" :slot-data="slotData.requirementOrder.details"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <el-button type="primary" v-if="isFactory()&&readOnly" @click="onUpdate">修改</el-button>
      <el-button type="primary" v-if="isBrand()" @click="onApprove">通过</el-button>
      <el-button type="danger" v-if="isBrand()" @click="onRefuse">拒绝</el-button>
      <div slot="header" class="clearfix">
        <span>报价明细</span>
      </div>
      <quote-request-form ref="requestForm" :read-only="readOnly" :slot-data="slotData"/>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span>附件</span>
      </div>
      <quote-attachments-form :read-only="readOnly" :slot-data="slotData"/>
    </el-card>

    <el-dialog title="修改报价" width="450px" :visible.sync="this.updateVisible" :before-close="handleClose">
      <quote-request-form ref="requestForm" :read-only="false" :slot-data="slotData"/>
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="update()">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import RequirementOrderRequestForm from '@/views/order/requirement/form/RequirementOrderRequestForm';

  import QuoteRequestForm from './QuoteRequestForm';
  import QuoteAttachmentsForm from './QuoteAttachmentsForm';

  export default {
    name: 'QuoteOrderFrom',
    components: {
      RequirementOrderRequestForm,
      QuoteRequestForm,
      QuoteAttachmentsForm,
    },
    props: ['slotData', 'readOnly'],
    methods: {
      handleClose(done) {
        this.updateVisible = false;
      },
      onUpdate(){
        this.updateVisible = true;
      },
      async update(){
        if (this.compareDate(new Date(), new Date(this.slotData.expectedDeliveryDate))) {
          this.$message.error('确认交货时间不能小于当前时间');
          return false;
        }
        let formData = this.slotData;

        const url = this.apis().updateQuote(formData.code);
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('更新成功，订单编号： ' + result);
        this.updateVisible = false;
      },
      async onApprove(){
        let formData = this.slotData;
        const url = this.apis().updateApprove(formData.code);
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('通过成功，订单编号： ' + formData.code);
      },
      async onRefuse(){
        let formData = this.slotData;
        const url = this.apis().updateReject(formData.code);
        const result = await this.$http.put(url, formData);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        this.$message.success('解决成功，订单编号： ' + formData.code);
      },
    },
    computed: {},
    data() {
      return {
        updateVisible:false,
      }
    }
  }
</script>
