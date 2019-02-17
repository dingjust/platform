<template>
  <div class="animated fadeIn">
    <el-form ref="form"
             label-position="top"
             :model="slotData"
             :disabled="readOnly">
      <el-row :gutter="10">
        <el-col :span="24">
          <el-form-item label="生产单号" prop="code">
            <el-input v-model="slotData.code" disabled placeholder="系统自动生成"></el-input>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row :gutter="10">
        <el-col :span="24">
          <el-form-item label="订单状态" prop="status">
            <el-select v-model="slotData.status" class="w-100">
              <el-option v-for="item in consignmentStatuses"
                         :key="item.code"
                         :label="item.name"
                         :value="item.code">
              </el-option>
            </el-select>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>
  </div>
</template>

<script>
  import {ConsignmentMixin} from '../../../../mixins';

  export default {
    name: 'ConsignmentUpdateStatusForm',
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        this.$refs['form'].validate(callback);
      },
      getValue() {
        return this.slotData;
      }
    },
    computed: {},
    mixins: [ConsignmentMixin],
    data() {
      return {
        active: 0
      }
    }
  }
</script>
