<template>
  <div class="border-container">
    <el-row>
      <el-col>
        <h6>接单内容</h6>
      </el-col>
    </el-row>
    <el-row class="progress-basic-row" type="flex">
      <el-col :span="6">
        <el-form-item label="工单号">
          <el-input :disabled="true" placeholder="系统生成" v-model="formData.code"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="交货日期" prop="expectedDeliveryDate">
          <el-date-picker style="width: 160px"
                          v-model="formData.expectedDeliveryDate"
                          type="date"
                          value-format="timestamp">
          </el-date-picker>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="创建人" prop="creationPerson">
          <el-input v-model="formData.creator.name"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="货号" prop="skuID">
          <el-input v-model="formData.product.skuID"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row class="progress-basic-row" type="flex">
      <el-col :span="12">
        <el-row>
          <el-form-item label="所属订单">
            <el-input v-model="formData.product.code"></el-input>
          </el-form-item>
          <el-button type="text" style="color: #ffd60c">选择订单</el-button>
        </el-row>
      </el-col>
      <el-col :span="6">
        <el-form-item label="优先级">
          <el-select>
            <el-option label="普通" :value="'普通'" />
            <el-option label="加急" :value="'加急'" />
            <el-option label="特级" :value="'特级'" />
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="跟单人">
          <el-input></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row type="flex">
      <el-col :span="8">
        <el-form-item label="合作方式" prop="machiningType">
          <el-radio-group v-model="formData.machiningType">
            <el-radio v-for="item in machiningTypes"
                      :label="item.code"
                      :key="item.code">
              {{item.name}}
            </el-radio>
          </el-radio-group>
        </el-form-item>
      </el-col>
    </el-row>
  </div>
</template>

<script>
  export default {
    name: 'ProgressOrderReceivingForm',
    props: ['formData'],
    data () {
      return {
        machiningTypes: this.$store.state.EnumsModule.machiningTypes
      }
    }
  }
</script>

<style scoped>
  .border-container {
    border: 1px solid #DCDFE6;
    background-color: #F4F4F4;
    padding: 10px;
    border-radius: 5px;
  }

  .progress-basic-row {
    padding-left: 20px;
  }
</style>
