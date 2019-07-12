<template>
  <div class="animated fadeIn content">
    <el-card>
      <cash-out-manager-toolbar @onNew="onNew" @onSearch="onSearch"/>
      <cash-out-manager-list :page="page" @onDetails="onDetails" @onRejected="onRejected" @onCompleted="onCompleted" @onSearch="onSearch"/>
    </el-card>
  </div>
</template>

<script>
  import {createNamespacedHelpers} from 'vuex';

  const {mapGetters, mapActions} = createNamespacedHelpers('CashOutManagerModule');

  import cashOutManagerToolbar from './toolbar/cashOutManagerToolbar';
  import cashOutManagerList from './list/cashOutManagerList';
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
        keyword: 'keyword',
      })
    },
    methods: {
      ...mapActions({
        search: 'search',
      }),
      onSearch(page, size) {
        const keyword = this.keyword;
        const url = this.apis().findAmountFlowsAll();
        this.search({url, keyword, page, size});
      },
      onAdvancedSearch(page, size) {
        this.setIsAdvancedSearch(true);
        const query = this.queryFormData;
        const url = this.apis().findAmountFlowsAll();
        this.searchAdvanced({url, query, page, size});
      },
      async onDetails(item) {
        const url = this.apis().rejectedCashOut(item.id);
        const result = await this.$http.get(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }

        // this.fn.openSlider('明细：' + item.name, cashOutManagerDetailsPage, result);
      },
      async onRejected(item) {
        const url = this.apis().rejectedCashOut(item.id);
        const result = await this.$http.delete(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('拒绝提现'+item.amount+"成功");
        this.onSearch();
      },

      async onCompleted(item) {
        const url = this.apis().completedCashOut(item.id);
        const result = await this.$http.put(url);
        if (result['errors']) {
          this.$message.error(result['errors'][0].message);
          return;
        }
        this.$message.success('确认提现'+item.amount+"成功");
        this.onSearch();
      },

      onNew(formData) {
        // this.fn.openSlider('新建', cashOutManagerDetailsPage, formData);
      },
    },
    data() {
      return {};
    },
    created() {
      this.onSearch();
    }
  };
</script>
