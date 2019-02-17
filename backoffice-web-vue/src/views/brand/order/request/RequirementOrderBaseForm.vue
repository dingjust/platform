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
          <el-form-item label="订单类型" prop="type">
            <el-select v-model="slotData.type" class="w-100" disabled>
              <el-option v-for="item in orderTypes"
                         :key="item.code"
                         :label="item.name"
                         :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="订单描述" prop="description">
            <el-input v-model="slotData.description"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="6">
          <el-form-item label="是否已付定金" prop="depositPaid">
            <el-radio-group v-model="slotData.depositPaid">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="应付定金金额" prop="depositAmount">
            <el-input-number class="w-100" v-model="slotData.depositAmount"></el-input-number>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="是否已付尾款" prop="retainagePaid">
            <el-radio-group v-model="slotData.retainagePaid">
              <el-radio :label="true">是</el-radio>
              <el-radio :label="false">否</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-col>
        <el-col :span="6">
          <el-form-item label="应付尾款金额" prop="retainageAmount">
            <el-input-number class="w-100" v-model="slotData.retainageAmount"></el-input-number>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import {OrderMixin} from '../../../../mixins';

  export default {
    name: 'RequirementOrderBaseForm',
    props: ['slotData', 'readOnly'],
    mixins: [OrderMixin],
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      }
    },
    computed: {},
    data() {
      return {}
    }
  }
</script>
