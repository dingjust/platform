<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :disabled="!readOnly">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="账单编号">
            <el-input type="text" :value="slotData.code"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="公司名称">
            <el-input type="text" :rows="2" :value="slotData.company.name"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="流入金额">
            <el-input type="text" :rows="2" :value="slotData.amount"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="账单来源">
            <el-input type="text" :rows="2" :value="slotData.flowSource | enumTranslate('FlowSource')"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="订单编号">
            <el-input type="text" :rows="2" :value="slotData.orderCode"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="账单状态">
            <el-input type="text" :rows="2" :value="slotData.amountStatus | enumTranslate('AmountStatus')"></el-input>
          </el-form-item>
        </el-col>
        <!--<el-col :span="8">-->
          <!--<el-form-item label="提现完成时间">-->
            <!--<el-input type="text" :rows="2" :value="slotData.cashCompletionTime | formatDateWithSecond"></el-input>-->
          <!--</el-form-item>-->
        <!--</el-col>-->
      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="账单发起时间">
            <el-input type="text" :rows="2" :value="slotData.creationtime | formatDateWithSecond"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="备注">
            <el-input type="text" :rows="2" :value="slotData.remark"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="描述">
            <el-input type="text" :rows="2" :value="slotData.description"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  export default {
    name: 'billForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        if(this.$refs['form'].validate(callback)){
          return false;
        }
        return true;
      }

    },
    data() {
      return {
        creationtime:null
      };
    },
    created() {
    }
  };
</script>
