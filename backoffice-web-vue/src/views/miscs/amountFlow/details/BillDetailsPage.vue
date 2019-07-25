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
      onAdvancedSearch (page, size) {
        this.isAdvancedSearch = true;
        var query = {
          keyword: this.keyword,
          // flowSource: ['CASH_OUT'],
          // amountFlowType: ['OUTFLOW'],
          // amountStatus: ['IN_REVIEW', 'REVIEWED', 'REJECTED']
          company: this.slotData.company.uid
        };
        const url = this.apis().findBills();
        this.searchAdvanced({url, query, page, size});
      },
      async onDetails (item) {
        const url = this.apis().getBill(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
        }
        this.setCashOutDetailData(result);
        // this.fn.openSlider('明细：' + item.code, cashOutManagerDetailsPage, result);
      },
      async onRejected (item) {
        const url = this.apis().rejectedCashOut(item.id);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('拒绝提现' + item.amount + '成功');
        this.onDetails(item);
        this.onAdvancedSearch();
      },

      async onCompleted (item) {
        const url = this.apis().completedCashOut(item.id);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('确认提现' + item.amount + '成功');
        this.onDetails(item);
        this.onAdvancedSearch();
      },
      onCancel () {
        this.fn.closeSlider();
      }
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
    created () {
      this.onAdvancedSearch();
    },
  }
</script>
