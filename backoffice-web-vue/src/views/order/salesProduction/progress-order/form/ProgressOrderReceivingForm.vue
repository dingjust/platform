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
          <el-date-picker style="width: 160px" :disabled="true"
                          v-model="formData.expectedDeliveryDate"
                          type="date"
                          value-format="timestamp">
          </el-date-picker>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="创建人" prop="creationPerson">
          <el-input v-model="formData.belongTo.name" :disabled="true"></el-input>
        </el-form-item>
      </el-col>
      <el-col :span="6">
        <el-form-item label="货号" prop="skuID">
          <el-input v-model="formData.product.skuID" :disabled="true"></el-input>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row class="progress-basic-row" type="flex">
      <el-col :span="8">
        <el-row>
          <el-form-item label="所属订单">
            <el-input v-model="formData.orderCode" :disabled="true"></el-input>
          </el-form-item>
<!--          <el-button type="text" style="color: #ffd60c">选择订单</el-button>-->
        </el-row>
      </el-col>
      <el-col :span="8">
        <el-form-item label="优先级">
          <el-select v-model="formData.priorityLevel" placeholder="请选择" style="width: 220px" :disabled="isRead">
            <el-option
              v-for="item in priorities"
              :key="item.code"
              :label="item.name"
              :value="item.code">
            </el-option>
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label="跟单人">
<!--          <el-input v-model="formData.personInCharge.name" :disabled="isRead"></el-input>-->
          <personnel-selection :vPerson.sync="formData.personInCharge" :read-only="isRead"/>
        </el-form-item>
      </el-col>
    </el-row>
    <el-row class="progress-basic-row" type="flex">
      <el-col :span="8">
        <el-form-item label="合作方式" prop="machiningType">
          <el-radio-group v-model="formData.machiningType" :disabled="true">
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
  import PersonnelSelection from '@/components/custom/PersonnelSelection';
  export default {
    name: 'ProgressOrderReceivingForm',
    components: {PersonnelSelection},
    props: {
      formData: {
        type: Object
      },
      isRead: {
        type: Boolean,
        default: true
      }
    },
    data () {
      return {
        value: '',
        machiningTypes: this.$store.state.EnumsModule.machiningTypes,
        priorities: this.$store.state.EnumsModule.priorities
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
