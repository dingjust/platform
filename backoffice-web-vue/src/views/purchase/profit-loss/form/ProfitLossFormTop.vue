<!--
* @Description: 盈亏分析表单，头部订单信息
* @Date 2021/03/19 09:48
* @Author L.G.Y
-->
<template>
  <div>
    <div class="form-top">
      <div>
        <el-form-item label="系统单号">
          <el-input placeholder="系统生成" v-model="formData.code" :disabled="true"></el-input>
        </el-form-item>
      </div>
      <div>
        <el-form-item label="关联外接订单" prop="salesProductionOrder.code" :rules="[{ required: true, message: '请选择关联订单', trigger: 'change' }]">
          <el-input v-model="formData.salesProductionOrder.code" :disabled="true">
          </el-input>
        </el-form-item>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'ProfitLossFormTop',
  props: ['formData'],
  methods: {
    async getDetails (id) {
      const url = this.apis().getSalesProductionOrderDetails(id);
      const result = await this.$http.get(url);

      if (result.code === 0) {
        this.$message.error(result.msg);
        return;
      }

      if (result.code === 1) {
        this.formData.salesProductionOrder = {
          id: result.data.id,
          code: result.data.code,
        }

        this.formData.tasks = result.data.taskOrderEntries;
      }
    }
  }
}
</script>

<style scoped>
  /deep/ .el-input__suffix {
    right: 0px;
  }

  .form-top {
    display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
    align-items: center;
  }
</style>