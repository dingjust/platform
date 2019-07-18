<template>
  <div class="animated fadeIn">
    <cash-out-manager-form ref="form" :slot-data="slotData" :read-only="isNewlyCreated"/>
  </div>


</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions, mapMutations} = createNamespacedHelpers('CashOutManagerModule');

  import CashOutManagerForm from '../../cashOutManager/form/cashOutManagerForm';

  export default {
    name: 'BillDetailsPage',
    props: ['slotData'],
    components: {CashOutManagerForm},
    methods: {
      ...mapActions({
        searchAdvanced: 'searchAdvancedBills'
      }),
      ...mapMutations({
        setCashOutDetailData: 'cashOutDetailData'
      }),
    },
    computed: {
      ...mapGetters({
        page: 'billsPage',
        keyword: 'keyword',
        cashOutDetailData: 'cashOutDetailData'
      }),
      isNewlyCreated: function () {
        return this.slotData.id == null;
      }
    },
    data () {
      return {updateDialogVisible: false}
    },
  }
</script>
