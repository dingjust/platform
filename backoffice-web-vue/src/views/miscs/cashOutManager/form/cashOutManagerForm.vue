<template>
  <div class="animated fadeIn">
    <el-card class="box-card" v-if="slotData.flowSource == 'CASH_OUT'">
      <div slot="header" class="clearfix">
      <span>基本信息</span>
    </div>
      <cash-out-manager-basic-form ref="basicForm"
                           :slot-data="slotData"
                           :read-only="readOnly">
      </cash-out-manager-basic-form>
    </el-card>
    <el-card class="box-card" v-else>
      <div slot="header" class="clearfix">
      <span>基本信息</span>
    </div>
      <bill-form ref="basicForm"
                           :slot-data="slotData"
                           :read-only="readOnly">
      </bill-form>
    </el-card>

    <div class="pt-2"></div>
    <el-card class="box-card" v-show="slotData.account != null">
    <div slot="header" class="clearfix">
      <span>提现账户信息</span>
    </div>

        <cash-out-bank-card-form
                             :slot-data="slotData"
                             :read-only="readOnly">
        </cash-out-bank-card-form>

    </el-card>
  </div>
</template>

<script>
  import CashOutManagerBasicForm from './cashOutManagerBasicForm';
  import cashOutBankCardForm from './cashOutBankCardForm';
  import billForm from '../../bill/form/billForm';

  export default {
    name: 'cashOutManagerFrom',
    components: {
      billForm,
      CashOutManagerBasicForm,
      cashOutBankCardForm
    },
    props: ['slotData', 'readOnly'],
    methods: {
      validate (callback) {
        return this.$refs['basicForm'].validate(callback);
      }
    },
    computed: {},
    data () {
      return {}
    }
  }
</script>
