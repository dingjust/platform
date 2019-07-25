<template>
  <div class="animated fadeIn">
    <el-form ref="form" label-position="top" :model="slotData" :disabled="!readOnly">
      <el-row :gutter="10">
        <el-col :span="8">
          <el-form-item label="提现账户公司">
            <el-input type="text" :rows="2" v-model="slotData.account.company.name"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="提现账户">
            <el-input type="text" :rows="2" v-model="slotData.account.cardNumber"></el-input>
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="开户行">
            <el-input type="text" :rows="2" v-model="slotData.account.bankOutlet"></el-input>
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
      validate (callback) {
        if (this.$refs['form'].validate(callback)) {
          return false;
        }
        return true;
      }
    },
    data () {
      return {

      };
    },
    created () {
    }
  };
</script>
