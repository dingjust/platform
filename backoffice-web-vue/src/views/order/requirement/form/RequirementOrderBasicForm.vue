<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="订单编码" prop="code">
            <el-input v-model="slotData.code" disabled placeholder="系统自动生成"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="订单备注" prop="remarks">
            <el-input v-model="slotData.remarks"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="自动关闭时间" prop="cancelledDate">
            <el-date-picker class="w-100"
                            type="date"
                            v-model="slotData.cancelledDate"
                            placeholder="选择日期"
                            value-format="timestamp">
            </el-date-picker>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="6">
            <requirement-order-labels-form :slot-data="slotData" :read-only="true"></requirement-order-labels-form>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import RequirementOrderLabelsForm from './RequirementOrderLabelsForm';

  export default {
    name: 'RequirementOrderBasicForm',
    components: {
      RequirementOrderLabelsForm
    },
    props: ['slotData', 'readOnly'],
    mixins: [],
    methods: {
      async getLabels() {
        const url = this.apis().getGroupLabels('ORDER');
        const results = await this.$http.get(url);
        if (results["errors"]) {
          this.$message.error(results["errors"][0].message);
          return;
        }
        this.labels = results;
      },
      validate(callback) {
        this.$refs['form'].validate(callback);
      }
    },
    computed: {},
    data() {
      return {
        labels: [],
      }
    },
    created() {
      this.getLabels();
    }
  }
</script>
