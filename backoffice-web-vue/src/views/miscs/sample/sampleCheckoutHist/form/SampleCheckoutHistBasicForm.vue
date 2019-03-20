<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData">
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="样衣编码" prop="code">
            <el-input placeholder="请输入样衣编码"
                      v-model="slotData.code" :disabled="readOnly">
            </el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="样衣名称" prop="name">
            <el-input placeholder="请输入样衣名称"
                      v-model="slotData.name" :disabled="readOnly">
            </el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="数量" prop="quantity">
            <el-input-number class="w-100"
                             v-model="slotData.quantity"
                             :min="1"
                             :disabled="readOnly">
            </el-input-number>
          </el-form-item>
        </el-col>

      </el-row>

      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="预计归还时间" prop="expectedReturningDate">
            <el-date-picker class="w-100"
                            type="date"
                            v-model="slotData.expectedReturningDate"
                            placeholder="选择日期"
                            value-format="timestamp"
                            :disabled="readOnly">
            </el-date-picker>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="关联方" prop="relatedParty">
            <el-input placeholder="请输入关联方"
                      v-model="slotData.relatedParty"
                      :disabled="readOnly">
            </el-input>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="联系方式" prop="contact">
            <el-input placeholder="请输入联系方式"
                      v-model="slotData.contact"
                      :disabled="readOnly">
            </el-input>
          </el-form-item>
        </el-col>
      </el-row>

      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="接还类型" prop="type">
            <el-select class="w-100"
                       placeholder="请选择"
                       v-model="slotData.type"
                       :disabled="readOnly">
              <el-option
                v-for="item in sampleCheckoutTypes"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="借还状态" prop="state">
            <el-select class="w-100"
                       placeholder="请选择"
                       v-model="slotData.state">
              <el-option
                v-for="item in returnStates"
                :key="item.code"
                :label="item.name"
                :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>

        <el-col :span="6">
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
    name: 'SampleCheckoutHistBasicForm',
    props: ['slotData', 'readOnly'],
    mixins: [],
    computed: {},
    methods: {},
    data() {
      return {
        sampleCheckoutTypes: this.$store.state.EnumsModule.sampleCheckoutTypes,
        returnStates:this.$store.state.EnumsModule.returnStates,
      }
    },
    created() {
    }
  }
</script>
