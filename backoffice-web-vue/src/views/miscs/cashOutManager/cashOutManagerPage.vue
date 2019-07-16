<template>
  <div class="animated fadeIn content">
    <el-card>
      <cash-out-manager-toolbar @onNew="onNew" @onSearch="onAdvancedSearch"/>
      <cash-out-manager-list :page="page" @onDetails="onDetails" @onRejected="onRejected" @onCompleted="onCompleted" @onSearch="onAdvancedSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('CashOutManagerModule');

  import cashOutManagerToolbar from './toolbar/cashOutManagerToolbar';
  import cashOutManagerList from '../cashOutManager/list/cashOutManagerList';
  import cashOutManagerDetailsPage from './details/cashOutManagerDetailsPage';

  export default {
    name: 'cashOutManagerPage',
    components: {
      cashOutManagerToolbar,
      cashOutManagerList
    },
    computed: {
      ...mapGetters({
        page: 'page',
        keyword: 'keyword'
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
        searchAdvanced: 'searchAdvanced'
      }),
      onAdvancedSearch (page, size) {
        this.isAdvancedSearch = true;
        var query = {
          keyword: this.keyword,
          flowSource: ['CASH_OUT'],
          amountFlowType: ['OUTFLOW'],
          amountStatus: ['IN_REVIEW', 'REVIEWED', 'REJECTED']
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
        this.fn.openSlider('明细：' + item.code, cashOutManagerDetailsPage, result);
      },
      async onRejected (item) {
        const url = this.apis().rejectedCashOut(item.id);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('拒绝提现' + item.amount + '成功');
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
        this.onAdvancedSearch();
      },

      onNew (formData) {
        // this.fn.openSlider('新建', cashOutManagerDetailsPage, formData);
      }
    },
    data () {
      return {};
    },
    created () {
      this.onAdvancedSearch();
    }
  };
</script>
