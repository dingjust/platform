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
      </el-row>
    </el-form>
  </div>
</template>

<script>
  // import {OrderMixin} from '@/mixins';

  export default {
    name: 'RequirementOrderBaseForm',
    props: ['slotData', 'readOnly'],
    mixins: [],
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
