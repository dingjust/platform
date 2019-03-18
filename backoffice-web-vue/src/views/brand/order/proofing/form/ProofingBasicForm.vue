<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="交货日期" prop="expectedDeliveryDate">
            <el-date-picker
              v-model="slotData.expectedDeliveryDate"
              type="date"
              value-format="timestamp"
              placeholder="选择日期">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="加工类型" prop="machiningType">
            <el-radio-group v-model="slotData.machiningType">
              <el-radio v-for="item in machiningTypes" :label="item.code">{{item.name}}</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="是否开具发票" prop="invoiceNeeded">
            <el-radio-group v-model="slotData.invoiceNeeded">
              <el-radio :label="true">开具</el-radio>
              <el-radio :label="false">不开具</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="定金金额" prop="deposit">
            <el-input-number v-model="slotData.deposit"></el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="是否已付定金" prop="depositPaid">
            <el-radio-group v-model="slotData.depositPaid">
              <el-radio :label="true">已付</el-radio>
              <el-radio :label="false">未付</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="预计（定金）支付时间" prop="depositPaidDate">
            <el-date-picker
              v-model="slotData.depositPaidDate"
              type="date"
              value-format="timestamp"
              placeholder="选择日期">
            </el-date-picker>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="尾款金额" prop="balance">
            <el-input-number v-model="slotData.balance"></el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="是否已付尾款" prop="balancePaid">
            <el-radio-group v-model="slotData.balancePaid">
              <el-radio :label="true">已付</el-radio>
              <el-radio :label="false">未付</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="预计（尾款）支付时间" prop="balancePaidDate">
            <el-date-picker
              v-model="slotData.balancePaidDate"
              type="date"
              value-format="timestamp"
              placeholder="选择日期">
            </el-date-picker>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="12">
          <el-form-item label="备注" prop="remarks">
            <el-input type="textarea"
                      :rows="2"
                      placeholder="请输入内容"
                      v-model="slotData.remarks">
            </el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'ProofingBasicForm',
    props: ['slotData', 'readOnly'],
    mixins: [],
    computed: {},
    methods: {},
    data() {
      return {
        machiningTypes: this.$store.state.EnumsModule.machiningTypes
      }
    },
    created() {
    }
  }
</script>
