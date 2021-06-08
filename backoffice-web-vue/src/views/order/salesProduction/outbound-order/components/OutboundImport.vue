<!--
* @Description: 外发订单导入
* @Date 2021/06/07 15:47
* @Author L.G.Y
-->
<template>
  <div class="outbound-import">
    <el-row type="flex">
      <el-input v-model="uniqueCode" placeholder="请输入外接订单唯一码" size="medium">
        <el-button slot="suffix" type="primary" @click="getImportDetail" size="medium">检索</el-button>
      </el-input>
    </el-row>
    <template v-if="detail">
      <el-divider style="padding: 0 10px"></el-divider>
      <el-row type="flex">
        <h6>补充信息（非必填）</h6>
      </el-row>
      <div style="margin-left: 10px">
        <el-form ref="form" :model="form" label-width="80px">
          <el-row type="flex" style="margin-left: 20px">
            <el-form-item label="标题">
              <el-input v-model="form.title"></el-input>
            </el-form-item>
          </el-row>
          <!-- <outbound-order-audit-part :formData="form" :isDisabled="false"/> -->
          <!-- <outbound-order-addition-info :formData="form" /> -->
        </el-form>
        <el-row type="flex" justify="center">
          <el-button type="primary" size="medium" @click="onImport">导入</el-button>
        </el-row>
      </div>
      <div style="padding: 0 10px">
        <el-divider></el-divider>
        <el-row type="flex">
          <h6>订单信息：</h6>
        </el-row>
        <el-row type="flex" justify="space-between">
          <div><h6>合作方式：{{getEnum('cooperationModes', detail.cooperationMode)}}</h6></div>
          <div>
            <h6 class="sales-plan-h6">是否开票：{{detail.invoiceNeeded ? '开发票' : '不开发票'}}
              <span style="margin-left:5px" v-if="detail.invoiceNeeded">{{detail.invoiceTaxPoint * 100}}%</span>
            </h6>
          </div>
          <div><h6>订单数量：{{detail.totalQuantity}}</h6></div>
          <div><h6>订单金额：{{detail.totalAmount}}元</h6></div>
          <div>
            <h6 style="display: inline-block;" v-popover:popover>
              定金：{{detail.payPlan.isHaveDeposit ? '有定金' : '无定金'}} + {{getEnum('PayPlanType', detail.payPlan.payPlanType)}}
            </h6>
            <el-popover ref="popover" placement="top-start" width="600" trigger="hover">
              <h6 v-html="getHtmlText(detail.payPlan.previewText)"></h6>
            </el-popover>
          </div>
          <div><h6>支付类型：{{detail.payOnline ? '线上支付' : '线下支付'}}</h6></div>
        </el-row>
        <el-row type="flex" style="margin-top:20px;width: 100%">
          <sales-production-tabs :canChangeProduct="false" :canUpdate="false" :form="detail"/>
        </el-row>
      </div>
    </template>
  </div>
</template>

<script>
import OutboundOrderAuditPart from '../form/OutboundOrderAuditPart'
import OutboundOrderAdditionInfo from '../form/OutboundOrderAdditionInfo'
import SalesProductionTabs from '@/views/order/salesProduction/components/SalesProductionTabs'

export default {
  name: 'OutboundImport',
  components: { OutboundOrderAuditPart, SalesProductionTabs, OutboundOrderAdditionInfo },
  methods: {
    getHtmlText(text) {
      if (text === undefined) {
        return '';
      }
      return text.replace(/\n/g, '</br></br>');
    },
    async getImportDetail () {
      const uniqueCode = this.uniqueCode;

      const url = this.apis().getOutboundByUniqueCode(uniqueCode);
      const result = await this.$http.get(url);

      if (result.code === 1) {
        result.data.state = 'TO_BE_SUBMITTED';
        result.data.auditState = 'AUDITING';
        result.data.productionLeader = {};

        this.$set(this, 'detail', result.data);
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message)
      } else {
        this.$message.error('操作失败');
      }
    },
    onImport () {
      this.$confirm('是否导入订单?', '', {
        confirmButtonText: '是',
        cancelButtonText: '否',
        type: 'warning'
      }).then(() => {
        this._onImport();
      });
    },
    async _onImport () {
      const uniqueCode = this.detail.uniqueCode;

      const data = Object.assign({}, this.form);

      // // 人员设置数据处理
      // if (!data.sendAuditNeeded) {
      //   data.sendApprovers = [];
      // } else {
      //   // 处理级联选择数据
      //   data.sendApprovers = [];
      //   this.form.sendApprovers.forEach(item => {
      //     if (item instanceof Array && item.length > 0) {
      //       data.sendApprovers.push({
      //         id: item[item.length - 1]
      //       });
      //     }
      //   })
      // }

      const url = this.apis().createOutboundByUniqueCode(uniqueCode);
      const result = await this.$http.post(url, data);

      if (result.code === 1) {
        this.$message.success('操作成功');        
        this.$emit('closeDialog');
      } else if (result.code === 0) {
        this.$message.error(result.msg);
      } else if (result['errors']) {
        this.$message.error(result['errors'][0].message)
      } else {
        this.$message.error('操作失败');
      }
    },
    validateField(name) {
      this.$refs.form.validateField(name);
    }
  },
  data () {
    return {
      uniqueCode: '',
      form: {
        title: '',
        merchandiser: this.$store.getters.currentUser,
        // sendAuditNeeded: false,
        // sendApprovers: [null],
        // remarks: '',
        // attachments: []
      },
      detail: null
    }
  },
  watch: {
    'form.sendApprovers': function (nval, oval) {
      this.formData.sendApprovers.forEach((item, index) => {
        this.validateField('sendApprovers.' + index);
      })
    }
  },
}
</script>

<style scoped>
  .outbound-import >>> .el-input__suffix {
    right: 0px;
  }
</style>