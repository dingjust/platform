<template>
  <div class="animated fadeIn">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
      <span>基本信息</span>
    </div>
      <cash-out-manager-basic-form ref="basicForm"
                           :slot-data="slotData"
                           :read-only="readOnly">
      </cash-out-manager-basic-form>
    </el-card>
    <div class="pt-2"></div>
    <el-card class="box-card">
    <div slot="header" class="clearfix">
      <span>提现账户信息</span>
    </div>

        <cash-out-bank-card-form ref="imageForm"
                             :slot-data="slotData"
                             :read-only="readOnly">
        </cash-out-bank-card-form>

    </el-card>
  </div>
</template>

<script>
  import CashOutManagerBasicForm from './cashOutManagerBasicForm';
  import cashOutBankCardForm from './cashOutBankCardForm';

  export default {
    name: 'cashOutManagerFrom',
    components: {
      CashOutManagerBasicForm,
      cashOutBankCardForm
    },
    props: ['slotData', 'readOnly'],
    methods: {
      validate(callback) {
        return this.$refs['basicForm'].validate(callback);
      }
    },
    computed: {},
    data() {
      return {}
    }
  }
</script>
