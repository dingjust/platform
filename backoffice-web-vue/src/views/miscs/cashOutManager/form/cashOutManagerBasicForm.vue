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
          <el-form-item label="提现金额">
            <el-input type="text" :rows="2" :value="slotData.amount"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="账单状态">
            <el-input type="text" :rows="2" :value="slotData.amountStatus | enumTranslate('AmountStatus')"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="提现发起时间">
            <el-input type="text" :rows="2" :value="slotData.creationtime | formatDate"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="提现完成时间">
            <el-input type="text" :rows="2" :value="slotData.cashCompletionTime | formatDate"></el-input>
          </el-form-item>
        </el-col>
        <!--<el-col :span="8">-->
          <!--<el-form-item label="提现发起时间">-->
            <!--<el-date-picker-->
              <!--:value="slotData.creationtime"-->
              <!--type="date"-->
              <!--value-format="timestamp"-->
              <!--placeholder="选择日期">-->
            <!--</el-date-picker>-->
          <!--</el-form-item>-->
        <!--</el-col>-->
        <!--<el-col :span="8">-->
          <!--<el-form-item label="提现完成时间">-->
            <!--<el-date-picker-->
              <!--:value="slotData.cashCompletionTime"-->
              <!--type="date"-->
              <!--value-format="timestamp"-->
              <!--placeholder="选择日期">-->
            <!--</el-date-picker>-->
          <!--</el-form-item>-->
        <!--</el-col>-->
        <!--<el-col :span="8">-->
          <!--<el-form-item label="提现完成时间">-->
            <!--<el-input type="text" :value="slotData.creationtime" prop="creationtime">-->
              <!--<template slot-scope="scope">-->
                <!--{{scope.row.creationtime | formatDate}}-->
              <!--</template>-->
            <!--</el-input>-->
          <!--</el-form-item>-->
        <!--</el-col>-->
      </el-row>
      <el-row :gutter="10">
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
    name: 'cashOutManagerBasicForm',
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
